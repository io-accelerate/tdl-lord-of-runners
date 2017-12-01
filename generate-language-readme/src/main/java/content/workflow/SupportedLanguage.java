package content.workflow;

import java.util.Map;

class SupportedLanguage {
    static final SupportedLanguage JAVA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "./gradlew run",
            "./gradlew test -i",
            "./src/main/java/befaster/solutions");
    static final SupportedLanguage SCALA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "sbt run",
            "sbt test",
            "./src/main/scala/befaster/solutions");
    static final SupportedLanguage RUBY = new SupportedLanguage(
            CommentBlock.HASHES,
            "Run this file from the IDE. Set the working directory to the root of the repo.",
            "rake run",
            "rake test",
            "./lib/solutions");
    static final SupportedLanguage PYTHON = new SupportedLanguage(
            CommentBlock.DOCSTRING,
            "Run this file from the IDE.",
            "PYTHONPATH=lib python lib/send_command_to_server.py",
            "PYTHONPATH=lib python -m unittest discover -s test",
            "./lib/solutions");
    static final SupportedLanguage NODEJS = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "npm start",
            "npm test",
            "./lib/solutions");
    static final SupportedLanguage CSHARP = new SupportedLanguage(
            CommentBlock.TRIPLE_SLASH,
            "Configure the \"BeFaster.App\" solution to Run on External Console then run.",
            "msbuild befaster.sln; src\\BeFaster.App\\bin\\Debug\\BeFaster.App.exe",
            "Run the \"BeFaster.App.Tests - Unit Tests\" configuration.",
            ".\\src\\BeFaster.App\\Solutions");
    static final SupportedLanguage FSHARP = CSHARP;
    static final SupportedLanguage VBNET = new SupportedLanguage(
            CommentBlock.APOSTROPHE,
            "Configure the \"BeFaster.App\" solution to Run on External Console then run.",
            "msbuild befaster.sln; src\\BeFaster.App\\bin\\Debug\\BeFaster.App.exe",
            "Run the \"BeFaster.App.Tests - Unit Tests\" configuration.",
            ".\\src\\BeFaster.App\\Solutions");

    private CommentBlock commentBlock;
    private String ideRunInstruction;
    private String consoleRunInstruction;
    private String unitTestInstruction;
    private String solutionsLocation;

    private SupportedLanguage(CommentBlock commentBlock,
                              String ideRunInstruction, String consoleRunInstruction,
                              String unitTestInstruction,
                              String solutionsLocation) {
        this.commentBlock = commentBlock;
        this.ideRunInstruction = ideRunInstruction;
        this.consoleRunInstruction = consoleRunInstruction;
        this.unitTestInstruction = unitTestInstruction;
        this.solutionsLocation = solutionsLocation;
    }

    Map<String, Object> populateModel(Map<String, Object> root) {
        root.put("block", commentBlock);
        root.put("ideRunInstruction", ideRunInstruction);
        root.put("consoleRunInstruction", consoleRunInstruction);
        root.put("unitTestInstruction", unitTestInstruction);
        root.put("solutionsLocation", solutionsLocation);
        return root;
    }
}
