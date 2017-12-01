<#-- @ftlvariable name="block" type="content.workflow.CommentBlock" -->
<#-- @ftlvariable name="ideRunInstruction" type="java.lang.String" -->
<#-- @ftlvariable name="consoleRunInstruction" type="java.lang.String" -->
<#-- @ftlvariable name="unitTestInstruction" type="java.lang.String" -->
<#-- @ftlvariable name="solutionsLocation" type="java.lang.String" -->
${block.start}
${block.l} ~~~~~~~~~~ Running the system: ~~~~~~~~~~~~~
${block.l}
${block.l}   From IDE:
${block.l}      ${ideRunInstruction}
${block.l}
${block.l}   From command line:
${block.l}      ${consoleRunInstruction}
${block.l}
${block.l}   To run your unit tests locally:
${block.l}      ${unitTestInstruction}
${block.l}
${block.l} ~~~~~~~~~~ The workflow ~~~~~~~~~~~~~
${block.l}
<#assign actW = 25>
${block.l}   By running this file you interact with a challenge server.
${block.l}   The interaction follows a request-response pattern:
${block.l}        * You are presented with your current progress and a list of actions.
${block.l}        * You trigger one of the actions by typing it on the console.
${block.l}        * After the action feedback is presented, the execution will stop.
${block.l}
<#assign colW = 60>
${block.l}   +------+-${("-----------------------------------------------")?right_pad(colW, "-")}+
${block.l}   | Step | ${("The usual workflow                             ")?right_pad(colW)}|
${block.l}   +------+-${("-----------------------------------------------")?right_pad(colW, "-")}+
${block.l}   |  1.  | ${("Run this file."                                 )?right_pad(colW)}|
${block.l}   |  2.  | ${("Start a challenge by typing \"start\"."         )?right_pad(colW)}|
${block.l}   |  3.  | ${("Read description from the \"challenges\" folder")?right_pad(colW)}|
${block.l}   |  4.  | ${("Implement the required method in"               )?right_pad(colW)}|
${block.l}   |      | ${("  "+solutionsLocation+""                        )?right_pad(colW)}|
${block.l}   |  5.  | ${("Deploy to production by typing \"deploy\"."     )?right_pad(colW)}|
${block.l}   |  6.  | ${("Observe output, check for failed requests."     )?right_pad(colW)}|
${block.l}   |  7.  | ${("If passed, go to step 3."                       )?right_pad(colW)}|
${block.l}   +------+-${("-----------------------------------------------")?right_pad(colW, "-")}+
${block.l}
${block.end}
