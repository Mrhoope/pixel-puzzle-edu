// Level: data level dibaca dari JSON (data/levels/levelNN.json).

class TestCase {
  int[] inbox;
  int[] expected;

  TestCase(JSONArray inboxJson, JSONArray expectedJson) {
    inbox = new int[inboxJson.size()];
    for (int i = 0; i < inbox.length; i++) {
      inbox[i] = inboxJson.getInt(i);
    }
    expected = new int[expectedJson.size()];
    for (int i = 0; i < expected.length; i++) {
      expected[i] = expectedJson.getInt(i);
    }
  }
}

class Level {
  int id = 0;
  String title = "";
  String concept = "";
  String brief = "";
  int memorySize = 0;
  int[] initialMemory = new int[0];
  ArrayList<String> blocks = new ArrayList<String>();
  int runLimit = 500;
  int sizeTarget = 99;
  int speedTarget = 999;
  ArrayList<TestCase> tests = new ArrayList<TestCase>();

  Level(JSONObject o) {
    id = o.getInt("id", 0);
    title = o.getString("title", "Level");
    concept = o.getString("concept", "");
    brief = o.getString("brief", "");
    memorySize = o.getInt("memorySize", 0);
    runLimit = o.getInt("runLimit", 500);
    sizeTarget = o.getInt("sizeTarget", 99);
    speedTarget = o.getInt("speedTarget", 999);

    if (o.hasKey("initialMemory")) {
      JSONArray m = o.getJSONArray("initialMemory");
      initialMemory = new int[m.size()];
      for (int i = 0; i < initialMemory.length; i++) {
        initialMemory[i] = m.getInt(i);
      }
    }

    if (o.hasKey("availableBlocks")) {
      JSONArray a = o.getJSONArray("availableBlocks");
      for (int i = 0; i < a.size(); i++) {
        blocks.add(a.getString(i));
      }
    }

    if (o.hasKey("tests")) {
      JSONArray t = o.getJSONArray("tests");
      for (int i = 0; i < t.size(); i++) {
        JSONObject tc = t.getJSONObject(i);
        tests.add(new TestCase(tc.getJSONArray("inbox"), tc.getJSONArray("expected")));
      }
    }
  }
}
