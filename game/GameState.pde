// GameState: mesin status permainan + penyimpanan progres.
// Tidak menggambar apa pun; UI yang membaca state ini.

class GameState {
  static final int W = 320;
  static final int H = 180;
  static final int SCALE = 4;

  static final int MENU = 0;
  static final int SELECT = 1;
  static final int PLAY = 2;
  static final int TUTORIAL = 3;

  static final int TUTORIAL_PAGES = 11;

  PApplet app;

  int screen = MENU;
  Level[] levels = new Level[10];
  int levelCount = 0;
  int currentLevel = 0;
  int unlocked = 1;
  int[] stars = new int[11];
  String[] savedPrograms = new String[11];
  boolean tutorialDone = false;
  int tutorialPage = 0;

  Program program;
  Interpreter vm;
  boolean running = false;
  boolean fastRun = false;
  int lastStepAt = 0;

  boolean resultShown = false;
  boolean helpShown = false;
  int hintStage = 0;
  boolean resultPass = false;
  String resultTitle = "";
  String resultMessage = "";
  int earnedStars = 0;
  int lastSteps = 0;

  GameState(PApplet app) {
    this.app = app;
    for (int i = 0; i < savedPrograms.length; i++) {
      savedPrograms[i] = "";
    }
  }

  void boot() {
    loadLevels();
    loadProgress();
    if (!tutorialDone) {
      openTutorial();
    } else {
      openMenu();
    }
  }

  // ---------- level & progres ----------

  void loadLevels() {
    levelCount = 0;
    for (int i = 1; i <= 10; i++) {
      String path = "data/levels/level" + String.format("%02d", i) + ".json";
      try {
        JSONObject o = app.loadJSONObject(path);
        if (o != null) {
          levels[levelCount] = new Level(o);
          levelCount++;
        }
      } catch (Exception e) {
        System.out.println("Gagal memuat " + path + ": " + e.getMessage());
      }
    }
    if (levelCount == 0) {
      System.out.println("Tidak ada data level. Periksa game/data/levels/.");
    }
  }

  void loadProgress() {
    try {
      String path = app.sketchPath("progress.json");
      File f = new File(path);
      if (!f.exists()) return;
      JSONObject p = app.loadJSONObject(path);
      if (p == null) return;
      unlocked = Math.max(1, p.getInt("unlocked", 1));
      if (p.hasKey("stars")) {
        JSONObject s = p.getJSONObject("stars");
        for (int i = 1; i <= 10; i++) {
          stars[i] = s.getInt(Integer.toString(i), 0);
        }
      }
      for (int i = 1; i <= 10; i++) {
        savedPrograms[i] = p.getString("program" + i, "");
      }
      tutorialDone = p.getBoolean("tutorialDone", false);
    } catch (Exception e) {
      System.out.println("Progres tidak terbaca: " + e.getMessage());
    }
  }

  void saveProgress() {
    JSONObject p = new JSONObject();
    p.setInt("unlocked", unlocked);
    p.setBoolean("tutorialDone", tutorialDone);
    JSONObject s = new JSONObject();
    for (int i = 1; i <= 10; i++) {
      s.setInt(Integer.toString(i), stars[i]);
    }
    p.setJSONObject("stars", s);
    for (int i = 1; i <= 10; i++) {
      if (savedPrograms[i] != null && savedPrograms[i].length() > 0) {
        p.setString("program" + i, savedPrograms[i]);
      }
    }
    app.saveJSONObject(p, app.sketchPath("progress.json"));
  }

  void persistProgram() {
    if (program != null && currentLevel >= 0 && currentLevel < levelCount) {
      savedPrograms[levels[currentLevel].id] = program.encode();
    }
    saveProgress();
  }

  // ---------- navigasi ----------

  void openMenu() {
    if (screen == PLAY) persistProgram();
    running = false;
    resultShown = false;
    helpShown = false;
    hintStage = 0;
    screen = MENU;
  }

  void openSelect() {
    if (screen == PLAY) persistProgram();
    running = false;
    resultShown = false;
    helpShown = false;
    hintStage = 0;
    screen = SELECT;
  }

  void openTutorial() {
    if (screen == PLAY) persistProgram();
    running = false;
    resultShown = false;
    helpShown = false;
    hintStage = 0;
    tutorialPage = 0;
    screen = TUTORIAL;
  }

  void tutorialNext() {
    if (tutorialPage < TUTORIAL_PAGES - 1) {
      tutorialPage++;
    } else {
      finishTutorial();
    }
  }

  void tutorialPrev() {
    if (tutorialPage > 0) tutorialPage--;
  }

  void skipTutorial() {
    tutorialDone = true;
    saveProgress();
    openMenu();
  }

  void finishTutorial() {
    tutorialDone = true;
    saveProgress();
    if (levelCount > 0) {
      startLevel(0);
    } else {
      openMenu();
    }
  }

  void startContinue() {
    if (levelCount == 0) return;
    int idx = Math.min(unlocked, levelCount) - 1;
    startLevel(idx);
  }

  void startLevel(int idx) {
    if (idx < 0 || idx >= levelCount) return;
    if (idx + 1 > unlocked) return;
    if (idx == 0 && !tutorialDone) {
      tutorialDone = true;
      saveProgress();
    }
    currentLevel = idx;
    helpShown = false;
    hintStage = 0;
    program = new Program();
    String saved = savedPrograms[levels[idx].id];
    if (saved != null && saved.length() > 0) {
      program.decode(saved);
    }
    screen = PLAY;
    resetRun();
  }

  void quit() {
    app.exit();
  }

  // ---------- aksi program ----------

  void addBlock(String op) {
    if (program == null || currentLevel >= levelCount) return;
    Level lv = levels[currentLevel];
    if (!lv.blocks.contains(op)) return;
    if (program.add(op)) resetRun();
  }

  void selectBlock(int idx) {
    if (program == null || idx < 0 || idx >= program.blocks.size()) return;
    if (program.selected == idx) {
      program.cycleArg(levels[currentLevel].memorySize);
      resetRun();
    } else {
      program.selected = idx;
      program.ensureVisible(idx);
    }
  }

  void removeBlock(int idx) {
    if (program == null) return;
    program.removeAt(idx);
    resetRun();
  }

  void removeSelected() {
    if (program == null || program.selected < 0) return;
    program.removeAt(program.selected);
    resetRun();
  }

  void moveSelected(int dir) {
    if (program == null || program.selected < 0) return;
    program.move(program.selected, dir);
    resetRun();
  }

  // ---------- eksekusi ----------

  void resetRun() {
    running = false;
    resultShown = false;
    if (program == null || currentLevel >= levelCount) return;
    Level lv = levels[currentLevel];
    if (lv.tests.size() == 0) {
      vm = null;
      return;
    }
    vm = new Interpreter(lv, program);
    vm.reset(lv.tests.get(0).inbox, lv.initialMemory);
    lastStepAt = app.millis();
  }

  void run() {
    if (vm == null) return;
    if (vm.done || vm.failed) resetRun();
    running = true;
    resultShown = false;
    lastStepAt = app.millis();
  }

  void pause() {
    running = false;
  }

  void stepOnce() {
    if (vm == null) return;
    if (vm.done || vm.failed) resetRun();
    running = false;
    resultShown = false;
    vm.step();
    if (vm.done || vm.failed) finishRun();
  }

  void toggleSpeed() {
    fastRun = !fastRun;
  }

  void update() {
    if (screen != PLAY || resultShown || vm == null) return;
    if (!running || vm.done || vm.failed) return;
    int delay = fastRun ? 35 : 220;
    if (app.millis() - lastStepAt >= delay) {
      lastStepAt = app.millis();
      vm.step();
      if (vm.done || vm.failed) finishRun();
    }
  }

  void finishRun() {
    running = false;
    if (currentLevel >= levelCount) return;
    evaluate();
    resultShown = true;
    persistProgram();
  }

  void evaluate() {
    Level lv = levels[currentLevel];
    resultPass = true;
    lastSteps = 0;
    earnedStars = 0;
    resultMessage = "";

    for (int t = 0; t < lv.tests.size(); t++) {
      TestCase tc = lv.tests.get(t);
      Interpreter run = new Interpreter(lv, program);
      run.reset(tc.inbox, lv.initialMemory);
      int guard = 0;
      while (!run.done && !run.failed && guard++ < lv.runLimit + 5) {
        run.step();
      }
      lastSteps = Math.max(lastSteps, run.steps);

      if (run.failed) {
        resultPass = false;
        resultMessage = "Tes " + (t + 1) + " (" + joinInts(tc.inbox) + "): " + run.message;
        break;
      }

      int diff = firstDiff(run.outbox, tc.expected);
      if (diff >= 0) {
        resultPass = false;
        resultMessage = "Tes " + (t + 1) + " (" + joinInts(tc.inbox) + "): output ke-" + (diff + 1) + " tidak sesuai.";
        break;
      }
    }

    if (resultPass) {
      earnedStars = 1;
      if (program.blockCount() <= lv.sizeTarget) earnedStars++;
      if (lastSteps <= lv.speedTarget) earnedStars++;
      stars[lv.id] = Math.max(stars[lv.id], earnedStars);
      unlocked = Math.max(unlocked, Math.min(levelCount, lv.id + 1));
      resultTitle = "LULUS!";
      resultMessage = "Size " + program.blockCount() + "/" + lv.sizeTarget
        + "   Langkah " + lastSteps + "/" + lv.speedTarget;
    } else {
      resultTitle = "BELUM TEPAT";
    }
  }

  void continueNext() {
    if (resultPass && currentLevel + 1 < levelCount) {
      startLevel(currentLevel + 1);
    } else {
      openSelect();
    }
  }

  int firstDiff(ArrayList<Integer> got, int[] want) {
    int n = Math.min(got.size(), want.length);
    for (int i = 0; i < n; i++) {
      if (got.get(i).intValue() != want[i]) return i;
    }
    if (got.size() != want.length) return n;
    return -1;
  }

  String joinInts(int[] a) {
    String s = "";
    for (int i = 0; i < a.length; i++) {
      if (i > 0) s += ",";
      s += a[i];
    }
    return s;
  }
}
