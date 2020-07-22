#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="DockerHub build helper.")
    parser.add_argument("-v", "--version", choices=("2.9.2.1", "2.10"),
                        dest="version", help="Version to build.", required=True)
    parser.add_argument("-s", "--stack", choices=("alpine", "ubuntu", "all"),
                        dest="stack", default="all", help="Stack to build.")
    parser.add_argument("-d", "--dry-run", action="store_true", dest="dry_run",
                        help="Print what commands will run, do not execute.")

    args = parser.parse_args()

    if sys.platform != "linux":
        sys.stderr.write("This script only supports linux...\n")
        sys.exit(1)

    if os.geteuid() != 0:
        sys.stderr.write("This script must be run as root.\n")
        sys.exit(1)

    if args.stack == "all":
        stacks = ["alpine", "ubuntu"]
    else:
        stacks = [args.stack]

    def maybe_run(*subprocess_args, **kwargs):
        if args.dry_run:
            actual_args = ["echo", *subprocess_args]
        else:
            actual_args = [*subprocess_args]

        try:
            subprocess.run(actual_args, **kwargs, check=True)
        except Exception as e:
            sys.stderr.write(
                f"Error running {str(actual_args)}:\n{e}\nAborting!\n")
            sys.exit(1)

    vsep = "=" * 22
    print(f"{vsep} Build Targets {vsep}")
    for s in stacks:
        for img in ("core", "crossref", "latex"):
            maybe_run("make", f"PANDOC_VERSION={args.version}", f"{s}-{img}")

    print(f"{vsep} Push Targets {vsep}")
    for s in stacks:
        for img in ("core", "crossref", "latex"):
            if img == "core":
                tag = f"pandoc/{s}:{args.version}"
            else:
                tag = f"pandoc/{s}-{img}:{args.version}"

            # https://github.com/pandoc/dockerfiles/issues/78#issuecomment-655378804
            if s == "alpine" and args.version == "2.9.2.1" and img in ("core", "latex"):
                print(f"--> SKIPPING {tag}, must be done manually!!!")
            else:
                maybe_run("docker", "push", tag)
                if s == "alpine":
                    short_tag = f"pandoc/{img}:{args.version}"
                    maybe_run("docker", "tag", tag, short_tag)
                    maybe_run("docker", "push", short_tag)

            print("")  # separate things out a little more
