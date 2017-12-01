package content.workflow;

import freemarker.core.PlainTextOutputFormat;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

public class GenerateComment {

    public static void main(String[] args) throws IOException, TemplateException {
        generateWorkflowCommentFor(SupportedLanguage.VBNET);
    }

    private static void generateWorkflowCommentFor(SupportedLanguage supportedLanguage) throws IOException, TemplateException {
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_25);
        cfg.setClassForTemplateLoading(GenerateComment.class, "/content/workflow");
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.DEBUG_HANDLER);
        cfg.setLogTemplateExceptions(false);
        cfg.setOutputFormat(PlainTextOutputFormat.INSTANCE);

        Map<String, Object> root = new HashMap<>();
        root = supportedLanguage.populateModel(root);

        Template temp = cfg.getTemplate("comment.ftl");
        Writer out = new OutputStreamWriter(System.out);
        temp.process(root, out);
    }
}