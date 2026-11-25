// Interpreter: menjalankan program satu blok per langkah.
// Hanya mengubah state (tangan, memori, inbox, outbox, ip). UI yang menggambar.

class Interpreter {
  Level level;
  Program program;

  ArrayList<Integer> inbox = new ArrayList<Integer>();
  ArrayList<Integer> outbox = new ArrayList<Integer>();
  int[] memory;
  Integer hand = null;

  int ip = 0;
  int steps = 0;
  int activeIndex = -1;
  boolean done = false;
  boolean failed = false;
  String message = "";

  Interpreter(Level level, Program program) {
    this.level = level;
    this.program = program;
  }

  void reset(int[] input, int[] initialMemory) {
    inbox.clear();
    outbox.clear();
    for (int i = 0; i < input.length; i++) {
      inbox.add(Integer.valueOf(input[i]));
    }
    memory = new int[Math.max(0, level.memorySize)];
    if (initialMemory != null) {
      for (int i = 0; i < initialMemory.length && i < memory.length; i++) {
        memory[i] = initialMemory[i];
      }
    }
    hand = null;
    ip = 0;
    steps = 0;
    activeIndex = -1;
    done = false;
    failed = false;
    message = "";
  }

  void step() {
    if (done || failed) return;
    if (steps >= level.runLimit) {
      fail("Batas langkah tercapai");
      return;
    }
    if (program.blocks.size() == 0) {
      done = true;
      activeIndex = -1;
      message = "Program kosong";
      return;
    }
    if (ip < 0 || ip >= program.blocks.size()) {
      done = true;
      activeIndex = -1;
      return;
    }

    activeIndex = ip;
    Block b = program.blocks.get(ip);
    steps++;
    int next = ip + 1;

    if (b.op.equals(Block.AMBIL)) {
      if (inbox.isEmpty()) {
        done = true;
        activeIndex = -1;
        message = "Inbox habis";
        return;
      }
      // Nilai lama di tangan ditimpa (dibuang) agar penyaringan nol/negatif
      // bisa kembali ke AMBIL tanpa blok buang tambahan.
      hand = inbox.remove(0);

    } else if (b.op.equals(Block.TARUH)) {
      if (hand == null) {
        fail("TARUH: tangan kosong");
        return;
      }
      outbox.add(hand);
      hand = null;

    } else if (b.op.equals(Block.SIMPAN)) {
      if (!validMemory(b.arg)) {
        fail("SIMPAN: kotak memori " + b.arg + " tidak ada");
        return;
      }
      if (hand == null) {
        fail("SIMPAN: tangan kosong");
        return;
      }
      memory[b.arg] = hand.intValue();

    } else if (b.op.equals(Block.MUAT)) {
      if (!validMemory(b.arg)) {
        fail("MUAT: kotak memori " + b.arg + " tidak ada");
        return;
      }
      hand = Integer.valueOf(memory[b.arg]);

    } else if (b.op.equals(Block.TAMBAH) || b.op.equals(Block.KURANG)) {
      if (!validMemory(b.arg)) {
        fail(b.op + ": kotak memori " + b.arg + " tidak ada");
        return;
      }
      if (hand == null) {
        fail(b.op + ": tangan kosong");
        return;
      }
      int v = memory[b.arg];
      hand = Integer.valueOf(b.op.equals(Block.TAMBAH) ? hand.intValue() + v : hand.intValue() - v);

    } else if (b.op.equals(Block.LABEL)) {
      // penanda, tidak melakukan apa pun

    } else if (b.op.equals(Block.LONCAT)) {
      int target = labelIndex(b.arg);
      if (target < 0) {
        fail("LONCAT: label " + b.arg + " tidak ditemukan");
        return;
      }
      next = target;

    } else if (b.op.equals(Block.LONCAT_NOL)) {
      if (hand == null) {
        fail("LONCAT JIKA NOL: tangan kosong");
        return;
      }
      if (hand.intValue() == 0) {
        int target = labelIndex(b.arg);
        if (target < 0) {
          fail("LONCAT JIKA NOL: label " + b.arg + " tidak ditemukan");
          return;
        }
        next = target;
      }

    } else if (b.op.equals(Block.LONCAT_NEG)) {
      if (hand == null) {
        fail("LONCAT JIKA NEGATIF: tangan kosong");
        return;
      }
      if (hand.intValue() < 0) {
        int target = labelIndex(b.arg);
        if (target < 0) {
          fail("LONCAT JIKA NEGATIF: label " + b.arg + " tidak ditemukan");
          return;
        }
        next = target;
      }

    } else {
      fail("Blok tidak dikenal: " + b.op);
      return;
    }

    ip = next;
    if (ip >= program.blocks.size()) {
      done = true;
      activeIndex = -1;
      if (message.length() == 0) message = "Program selesai";
    }
  }

  boolean validMemory(int index) {
    return index >= 0 && index < memory.length;
  }

  int labelIndex(int label) {
    for (int i = 0; i < program.blocks.size(); i++) {
      Block b = program.blocks.get(i);
      if (b.op.equals(Block.LABEL) && b.arg == label) return i;
    }
    return -1;
  }

  void fail(String msg) {
    failed = true;
    message = msg;
  }
}
