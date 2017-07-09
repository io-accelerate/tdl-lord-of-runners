package content.workflow;

import java.util.Map;

class SupportedLanguage {
    static final SupportedLanguage JAVA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            ActionNames.CAMEL_CASE,
            "./gradlew run -Daction=$ACTION",
            "./gradlew test -i",
            "./src/main/java/befaster/solutions");
    static final SupportedLanguage SCALA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            ActionNames.CAMEL_CASE,
            "sbt \"run $ACTION\"",
            "sbt \"test\"",
            "./src/main/scala/befaster/solutions");
    static final SupportedLanguage RUBY = new SupportedLanguage(
            CommentBlock.HASHES,
            ActionNames.UNDERSCORE,
            "rake run action=$ACTION",
            "rake test",
            "./lib/solutions");
    static final SupportedLanguage PYTHON = new SupportedLanguage(
            CommentBlock.DOCSTRING,
            ActionNames.UNDERSCORE,
            "PYTHONPATH=lib python lib/befaster_app.py $ACTION",
            "PYTHONPATH=lib python -m unittest discover -s test",
            "./lib/solutions");
    static final SupportedLanguage NODEJS = new SupportedLanguage(
            CommentBlock.JAVADOC,
            ActionNames.CAMEL_CASE,
            "npm start $ACTION",
            "npm test",
            "./lib/solutions");

    private CommentBlock commentBlock;
    private String runCommand;
    private String unitTestCommand;
    private String solutionsLocation;
    private ActionNames actionNames;

    private SupportedLanguage(CommentBlock commentBlock,
                              ActionNames actionNames, String runCommand,
                              String unitTestCommand, String solutionsLocation) {
        this.commentBlock = commentBlock;
        this.runCommand = runCommand;
        this.unitTestCommand = unitTestCommand;
        this.solutionsLocation = solutionsLocation;
        this.actionNames = actionNames;
    }

    Map<String, Object> populateModel(Map<String, Object> root) {
        root.put("block", commentBlock);
        root.put("runCommand", runCommand);
        root.put("unitTestCommand", unitTestCommand);
        root.put("solutionsLocation", solutionsLocation);
        root.put("act", actionNames);
        return root;
    }
}
