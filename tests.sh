#!/usr/bin/env bash
set -e
export JIRA_CLI="./target/debug/jira_cli"
export JIRA_PROJECT_KEY="CITS"
export JIRA_VERSION_NAME="v0.0.0"

# version
$JIRA_CLI -V

# help
$JIRA_CLI help

# generate
$JIRA_CLI generate bash > /tmp/jira_cli.bash
$JIRA_CLI generate elvish > /tmp/jira_cli.elvish
$JIRA_CLI generate fish > /tmp/jira_cli.fish
$JIRA_CLI generate powershell > /tmp/jira_cli.ps1
$JIRA_CLI generate zsh > /tmp/jira_cli.zsh

# user
## get_id
JIRA_USER_ACCOUNT_ID=$($JIRA_CLI user get_account_id "$JIRA_USER")
export JIRA_USER_ACCOUNT_ID
echo "$JIRA_USER_ACCOUNT_ID"

# project
## create
echo "project create"
$JIRA_CLI project create citest CITS "$JIRA_USER_ACCOUNT_ID"
## get_id
echo "project get_id"
$JIRA_CLI project get_id $JIRA_PROJECT_KEY
JIRA_PROJECT_ID=$($JIRA_CLI project get_id $JIRA_PROJECT_KEY)
export JIRA_PROJECT_ID
## list_features
echo "project list_features"
$JIRA_CLI project list_features $JIRA_PROJECT_KEY
## set_feature_state
echo "project set_feature_state"
$JIRA_CLI project set_feature_state $JIRA_PROJECT_KEY jsw.agility.releases ENABLED
## new_version
echo "project new_version"
$JIRA_CLI project new_version
$JIRA_CLI project new_version test
## list_versions
echo "project list_versions"
$JIRA_CLI project list_versions

# issue
## list_types
echo "issue list_types"
$JIRA_CLI issue list_types $JIRA_PROJECT_KEY
## create
echo "issue create"
$JIRA_CLI issue create Task "little test" "little test using jira_cli" "$JIRA_USER_ACCOUNT_ID" $JIRA_PROJECT_KEY
## add_version
echo "issue add_version"
$JIRA_CLI issue add_version "$JIRA_PROJECT_KEY"-1 $JIRA_VERSION_NAME
$JIRA_CLI issue add_version "$JIRA_PROJECT_KEY"-1 test
## add_label
echo "issue add_label"
$JIRA_CLI issue add_label "$JIRA_PROJECT_KEY"-1 "CI"
$JIRA_CLI issue add_label "$JIRA_PROJECT_KEY"-1 "CI2"
## remove_version
echo "issue remove_version"
$JIRA_CLI issue remove_version "$JIRA_PROJECT_KEY"-1 test
## remove_label
echo "issue remove_label"
$JIRA_CLI issue remove_label "$JIRA_PROJECT_KEY"-1 "CI2"
## show_fixversions
echo "issue show_fixversions"
$JIRA_CLI issue show_fixversions "$JIRA_PROJECT_KEY"-1

# labels
echo "labels"
$JIRA_CLI labels

# project - delete_project
echo "delete_project"
./test_project_destroy.exp