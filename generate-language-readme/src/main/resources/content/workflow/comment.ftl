<#-- @ftlvariable name="block" type="content.workflow.CommentBlock" -->
<#-- @ftlvariable name="act" type="content.workflow.ActionNames" -->
<#-- @ftlvariable name="runCommand" type="java.lang.String" -->
<#-- @ftlvariable name="solutionsLocation" type="java.lang.String" -->
${block.start}
${block.l} ~~~~~~~~~~ The workflow ~~~~~~~~~~~~~
${block.l}
<#assign colW = 40>
${block.l}   +------+-${("----------------------------------")?right_pad(colW, "-")}+-----------------------------------------------+
${block.l}   | Step | ${("         IDE                           ")?right_pad(colW)}|         Web console                           |
${block.l}   +------+-${("----------------------------------")?right_pad(colW, "-")}+-----------------------------------------------+
${block.l}   |  1.  | ${(""                                       )?right_pad(colW)}| Open your browser and go to:                  |
${block.l}   |      | ${(""                                       )?right_pad(colW)}|    http://run.befaster.io:8111                |
${block.l}   |  2.  | ${(""                                       )?right_pad(colW)}| Configure your email                          |
${block.l}   |  3.  | ${(""                                       )?right_pad(colW)}| Start a challenge, should display "Started"   |
${block.l}   |  4.  | ${("Set the email variable"                 )?right_pad(colW)}|                                               |
${block.l}   |  5.  | ${("Run \""+act.newRound+"\""               )?right_pad(colW)}|                                               |
${block.l}   |  6.  | ${("Read description from ./challenges"     )?right_pad(colW)}|                                               |
${block.l}   |  7.  | ${("Implement the required method in"       )?right_pad(colW)}|                                               |
${block.l}   |      | ${("  "+solutionsLocation+""                )?right_pad(colW)}|                                               |
${block.l}   |  8.  | ${("Run \""+act.connect+"\", observe output")?right_pad(colW)}|                                               |
${block.l}   |  9.  | ${("If ready, run \""+act.deploy+"\""       )?right_pad(colW)}|                                               |
${block.l}   | 10.  | ${(""                                       )?right_pad(colW)}| Type "done"                                   |
${block.l}   | 11.  | ${(""                                       )?right_pad(colW)}| Check failed requests                         |
${block.l}   | 12.  | ${(""                                       )?right_pad(colW)}| Go to step 5.                                 |
${block.l}   +------+-${("----------------------------------")?right_pad(colW, "-")}+-----------------------------------------------+
${block.l}
${block.l} ~~~~~~~~~~ Running the system: ~~~~~~~~~~~~~
${block.l}
${block.l}   From command line:
${block.l}      ${runCommand}
${block.l}
${block.l}   From IDE:
${block.l}      Set the value of the `${act.noArgs}`
${block.l}      Run this file from the IDE.
${block.l}
<#assign actW = 25>
${block.l}   Available actions:
${block.l}        * ${(act.newRound+"")?right_pad(actW)} - Get the round description (call once per round).
${block.l}        * ${(act.connect+" ")?right_pad(actW)} - Test you can connect to the server (call any number of time)
${block.l}        * ${(act.deploy+"  ")?right_pad(actW)} - Release your code. Real requests will be used to test your solution.
${block.l}          ${"               "?right_pad(actW)}   If your solution is wrong you get a penalty of 10 minutes.
${block.l}          ${"               "?right_pad(actW)}   After you fix the problem, you should deploy a new version into production.
${block.l}
${block.end}
