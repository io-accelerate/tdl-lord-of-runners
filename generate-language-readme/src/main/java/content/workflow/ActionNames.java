package content.workflow;

public class ActionNames {
    static final ActionNames CAMEL_CASE =
            new ActionNames(
                    "getNewRoundDescription",
                    "testConnectivity",
                    "deployToProduction",
                    "actionIfNoArgs");
    static final ActionNames UNDERSCORE =
            new ActionNames(
                    "get_new_round_description",
                    "test_connectivity",
                    "deploy_to_production",
                    "action_if_no_args");

    private String newRound;
    private String connect;
    private String deploy;
    private String noArgs;

    private ActionNames(String newRound,
                        String connect,
                        String deploy, String noArgs) {
        this.newRound = newRound;
        this.connect = connect;
        this.deploy = deploy;
        this.noArgs = noArgs;
    }

    public String getNewRound() {
        return this.newRound;
    }

    public String getConnect() {
        return this.connect;
    }

    public String getDeploy() {
        return this.deploy;
    }

    public String getNoArgs() {
        return noArgs;
    }
}
