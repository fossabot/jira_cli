use clap::{crate_authors, crate_name, crate_version, Arg, Command};
use clap_complete::Shell;

use crate::{check_version, issue, labels, project, user};

fn generate() -> Command<'static> {
    return Command::new("generate")
        .about("Generate autocompletion script for your shell")
        .visible_aliases(&["g", "gen"])
        .arg_required_else_help(true)
        .arg(
            Arg::new("shell")
                .possible_values(Shell::possible_values())
                .required(true),
        );
}

pub fn build_cli() -> Command<'static> {
    return Command::new(crate_name!())
        .version(crate_version!())
        .author(crate_authors!())
        .subcommand_required(true)
        .arg_required_else_help(true)
        .arg(
            Arg::new("domain")
                .short('d')
                .long("domain")
                .help("Domain")
                .env("JIRA_DOMAIN")
                .takes_value(true)
                .required(true),
        )
        .arg(
            Arg::new("user")
                .short('u')
                .long("user")
                .help("User")
                .env("JIRA_USER")
                .takes_value(true)
                .required(true),
        )
        .arg(
            Arg::new("token")
                .short('t')
                .long("token")
                .help("TOKEN - API KEY")
                .env("JIRA_TOKEN")
                .takes_value(true)
                .required(true),
        )
        .subcommand(generate())
        .subcommand(check_version::cli_commands())
        .subcommand(issue::cli_commands())
        .subcommand(labels::cli_commands())
        .subcommand(project::cli_commands())
        .subcommand(user::cli_commands());
}
