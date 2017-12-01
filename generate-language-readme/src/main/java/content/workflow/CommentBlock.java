package content.workflow;

public class CommentBlock {
    static final CommentBlock JAVADOC = new CommentBlock(
            "    /**",
            "     *",
            "     **/");
    static final CommentBlock HASHES = new CommentBlock(
            "#",
            "#",
            "#");
    static final CommentBlock DOCSTRING = new CommentBlock(
            "\"\"\"",
            " ",
            "\"\"\"");
    static final CommentBlock TRIPLE_SLASH = new CommentBlock(
            "/// <summary>",
            "///",
            "/// </summary>");
    static final CommentBlock APOSTROPHE = new CommentBlock(
            "'",
            "'",
            "'");

    private String start;
    private String l;
    private String end;

    private CommentBlock(String start, String l, String end) {
        this.start = start;
        this.l = l;
        this.end = end;
    }

    public String getStart() {
        return this.start;
    }

    public String getL() {
        return this.l;
    }

    public String getEnd() {
        return this.end;
    }
}
