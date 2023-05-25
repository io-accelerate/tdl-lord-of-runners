package content.workflow;

import java.util.Map;

class SupportedLanguage {
    static final SupportedLanguage JAVA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "./gradlew run",
            "./gradlew test -i",
            "./src/main/java/befaster/solutions",
            "throw new SolutionNotImplementedException()");
    static final SupportedLanguage SCALA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "sbt run",
            "sbt test",
            "./src/main/scala/befaster/solutions",
            "throw new SolutionNotImplementedException()");

    static final SupportedLanguage KOTLIN = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "./gradlew run",
            "./gradlew test -i",
            "./src/main/kotlin/solutions",
            "TODO(\"Solution not implemented\")");

    static final SupportedLanguage RUBY = new SupportedLanguage(
            CommentBlock.HASHES,
            "Run this file from the IDE. Set the working directory to the root of the repo.",
            "rake run",
            "rake test",
            "./lib/solutions",
            "raise 'Not implemented'");
    static final SupportedLanguage PYTHON = new SupportedLanguage(
            CommentBlock.DOCSTRING,
            "Run this file from the IDE.",
            "PYTHONPATH=lib python lib/send_command_to_server.py",
            "PYTHONPATH=lib python -m unittest discover -s test",
            "./lib/solutions",
            "raise NotImplementedError()");
    static final SupportedLanguage NODEJS = new SupportedLanguage(
            CommentBlock.JAVADOC,
            "Run this file from the IDE.",
            "npm start",
            "npm test",
            "./lib/solutions",
            "throw new Error(\"method not implemented\")");
    static final SupportedLanguage CSHARP = new SupportedLanguage(
            CommentBlock.TRIPLE_SLASH,
            "Configure the \"BeFaster.App\" solution to Run on External Console then run.",
            "msbuild befaster.sln; src\\BeFaster.App\\bin\\Debug\\BeFaster.App.exe",
            "Run the \"BeFaster.App.Tests - Unit Tests\" configuration.",
            ".\\src\\BeFaster.App\\Solutions",
            "throw new SolutionNotImplementedException()");
    static final SupportedLanguage FSHARP = new SupportedLanguage(
            CommentBlock.TRIPLE_SLASH,
            "Configure the \"BeFaster.App\" solution to Run on External Console then run.",
            "msbuild befaster.sln; src\\BeFaster.App\\bin\\Debug\\BeFaster.App.exe",
            "Run the \"BeFaster.App.Tests - Unit Tests\" configuration.",
            ".\\src\\BeFaster.App\\Solutions",
            "raise (NotImplementedException())");
    static final SupportedLanguage VBNET = new SupportedLanguage(
            CommentBlock.APOSTROPHE,
            "Configure the \"BeFaster.App\" solution to Run on External Console then run.",
            "msbuild befaster.sln; src\\BeFaster.App\\bin\\Debug\\BeFaster.App.exe",
            "Run the \"BeFaster.App.Tests - Unit Tests\" configuration.",
            ".\\src\\BeFaster.App\\Solutions",
            "Throw New NotImplementedException()");

    private final CommentBlock commentBlock;
    private final String ideRunInstruction;
    private final String consoleRunInstruction;
    private final String unitTestInstruction;
    private final String solutionsLocation;
    private final String exceptionLine;

    private SupportedLanguage(CommentBlock commentBlock,
                              String ideRunInstruction, String consoleRunInstruction,
                              String unitTestInstruction,
                              String solutionsLocation, String exceptionLine) {
        this.commentBlock = commentBlock;
        this.ideRunInstruction = ideRunInstruction;
        this.consoleRunInstruction = consoleRunInstruction;
        this.unitTestInstruction = unitTestInstruction;
        this.solutionsLocation = solutionsLocation;
        this.exceptionLine = exceptionLine;
    }

    Map<String, Object> populateModel(Map<String, Object> root) {
        root.put("block", commentBlock);
        root.put("ideRunInstruction", ideRunInstruction);
        root.put("consoleRunInstruction", consoleRunInstruction);
        root.put("unitTestInstruction", unitTestInstruction);
        root.put("solutionsLocation", solutionsLocation);
        root.put("exceptionLine", exceptionLine);
        return root;
    }
}
