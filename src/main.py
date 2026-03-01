import os
import sys
import argparse
import shutil

from pathlib import Path


def no_log(*args):
    pass


log = no_log


def user_get(msg, valid: []):
    while True:
        ui = input(f"{msg} {valid}: ").lower()

        if ui in valid:
            return ui


def _copy(src, dst):
    out = []

    for x in os.scandir(src):
        s = Path(src, x.name)
        d = Path(dst, x.name)
        act = {}

        if x.is_dir():
            d.mkdir(parents=True, exist_ok=True)
            out.extend(_copy(s, d))
        elif x.is_file():
            act["src"] = s
            act["dst"] = d
            act["action"] = "copy"

            if not d.exists():
                # log(f"{s} --> {d}")
                pass
            elif s.stat().st_mtime == d.stat().st_mtime:
                # log(f"Skipping dst is same age: {s} --> {d}")
                continue
            elif s.stat().st_mtime < d.stat().st_mtime:
                user_input = user_get(
                    f"Do you want to override [ {d} ]",
                    ["yes", "no", "upstream"]
                )

                match user_input:
                    case "no":
                        act["action"] = "ignore"
                        # log(f"Skipping dst is same: {s} --> {d}")
                    case "yes":
                        act["action"] = "overwrite"
                        # log(f"Overriding dst: {s} --> {d}")
                    case "upstream":
                        act["action"] = "upstream"
                        # log(f"Upstreaming dst: {s} --> {d}")
            else:
                pass
                # log(f"{s} --> {d}")
            out.append(act)
    return out


def copy(src, dst):
    out = _copy(src, dst)

    for x in out:
        print(x)

    user_input = user_get(
        "Do you wish to continue? [ yes, no ]: ", ["yes", "no"])

    if "yes" == user_input:
        for x in out:
            match x["action"]:
                case "upstream":
                    shutil.copy(x["dst"], x["src"])
                case "ignore":
                    pass


def handle_linux(s_path, system, env, args):
    if "HOME" not in env:
        log("No home dir found!")
        return

    src_config = Path(s_path.parent, "config")

    dst_config = Path(env["HOME"], ".config")

    if not dst_config.exists():
        log(f"Config dir doesn't exist creating {dst_config}")
        dst_config.mkdir(parents=True, exist_ok=True)

    log("Copying user configuration!")
    copy(src_config, dst_config)


def parse_args(args):
    parser = argparse.ArgumentParser(prog='config handler')

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="verbose mode"
    )

    return parser.parse_args(args)


def main(args):
    sys_info = os.uname()

    args = parse_args(args[1:])

    if args.verbose:
        global log
        log = print

    match sys_info.sysname:
        case "Linux":
            print("On Linux!")
            handle_linux(
                Path(os.path.realpath(__file__)).parent,
                sys_info,
                os.environ,
                args
            )
        case _:
            print(f"Unknown system! [{sys_info.sysname}]")


if "__main__" == __name__:
    main(sys.argv)
