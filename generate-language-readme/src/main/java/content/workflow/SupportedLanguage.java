package content.workflow;

import java.util.Map;

class SupportedLanguage {
    static final SupportedLanguage JAVA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            ActionNames.CAMEL_CASE,
            "./gradlew run -Daction=$ACTION",
            "./src/main/java/befaster/solutions");
    static final SupportedLanguage SCALA = new SupportedLanguage(
            CommentBlock.JAVADOC,
            ActionNames.CAMEL_CASE,
            "sbt \"run $ACTION\"",
            "./src/main/scala/befaster/solutions");
    static final SupportedLanguage RUBY = new SupportedLanguage(
            CommentBlock.HASHES,
            ActionNames.UNDERSCORE,
            "rake run action=$ACTION",
            "./lib/solutions");
    static final SupportedLanguage PYTHON = new SupportedLanguage(
            CommentBlock.DOCSTRING,
            ActionNames.UNDERSCORE,
            "PYTHONPATH=lib python lib/befaster_app.py $ACTION",
            "./lib/solutions");
    static final SupportedLanguage NODEJS = new SupportedLanguage(
            CommentBlock.JAVADOC,
            ActionNames.CAMEL_CASE,
            "npm start $ACTION",
            "./lib/solutions");

    private CommentBlock commentBlock;
    private String runCommand;
    private String solutionsLocation;
    private ActionNames actionNames;

    private SupportedLanguage(CommentBlock commentBlock,
                              ActionNames actionNames, String runCommand,
                              String solutionsLocation) {
        this.commentBlock = commentBlock;
        this.runCommand = runCommand;
        this.solutionsLocation = solutionsLocation;
        this.actionNames = actionNames;
    }

    Map<String, Object> populateModel(Map<String, Object> root) {
        root.put("block", commentBlock);
        root.put("runCommand", runCommand);
        root.put("solutionsLocation", solutionsLocation);
        root.put("act", actionNames);
        return root;
    }
}
