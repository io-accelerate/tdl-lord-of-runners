<#-- @ftlvariable name="block" type="content.workflow.CommentBlock" -->
<#-- @ftlvariable name="ideRunInstruction" type="java.lang.String" -->
<#-- @ftlvariable name="consoleRunInstruction" type="java.lang.String" -->
<#-- @ftlvariable name="unitTestInstruction" type="java.lang.String" -->
<#-- @ftlvariable name="solutionsLocation" type="java.lang.String" -->
<#-- @ftlvariable name="exceptionLine" type="java.lang.String" -->
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
<#assign colW = 70>
${block.l}   +------+-${("------------------"                                               )?right_pad(colW, "-")}+
${block.l}   | Step | ${("The usual workflow"                                               )?right_pad(colW)}|
${block.l}   +------+-${("------------------"                                               )?right_pad(colW, "-")}+
${block.l}   |  1.  | ${("Run this file."                                                   )?right_pad(colW)}|
${block.l}   |  2.  | ${("Start a challenge by typing \"start\"."                           )?right_pad(colW)}|
${block.l}   |  3.  | ${("Read the description from the \"challenges\" folder."             )?right_pad(colW)}|
${block.l}   |  4.  | ${("Locate the file corresponding to your current challenge in:"      )?right_pad(colW)}|
${block.l}   |      | ${("  "+solutionsLocation+""                                          )?right_pad(colW)}|
${block.l}   |  5.  | ${("Replace the following placeholder exception with your solution:"  )?right_pad(colW)}|
${block.l}   |      | ${("  "+exceptionLine+""                                              )?right_pad(colW)}|
${block.l}   |  6.  | ${("Deploy to production by typing \"deploy\"."                       )?right_pad(colW)}|
${block.l}   |  7.  | ${("Observe the output, check for failed requests."                   )?right_pad(colW)}|
${block.l}   |  8.  | ${("If passed, go to step 1."                                         )?right_pad(colW)}|
${block.l}   +------+-${("----"                                                             )?right_pad(colW, "-")}+
${block.l}
${block.l}   You are encouraged to change this project as you please:
${block.l}        * You can use your preferred libraries.
${block.l}        * You can use your own test framework.
${block.l}        * You can change the file structure.
${block.l}        * Anything really, provided that this file stays runnable.
${block.l}
${block.end}
