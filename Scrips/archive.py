#!/usr/bin/env python
import os
import logging
import argparse
import subprocess
import hashlib

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s %(levelname)s %(message)s")

script_dir = os.path.dirname(os.path.realpath(__file__))
root_dir = os.path.join(script_dir, "../")
build_dir = os.path.join(root_dir, "Build")
archive_path = os.path.join(build_dir, "archive")
team_id = "HJ648XXPWE"
app_id = "1198165440"
scheme = "Otadoya"
ipa_name = "Otadoya.ipa"
plist_path = os.path.join(root_dir, "Otadoya/Info.plist")
workspace = os.path.join(root_dir, "Otadoya.xcworkspace")

def main():
    parser = create_parser()
    args = parser.parse_args()

    logging.debug("Passed arguments: {}".format(args))
    incement_build()
    create_archive()
    create_ipa()
    upload_ipa(args)

def incement_build():
    buildNumber = subprocess.check_output(["/usr/libexec/PlistBuddy", "-c", "Print CFBundleVersion", plist_path])
    buildNumber = int(buildNumber) + 1
    logging.info("Increment build to: {}".format(buildNumber))
    subprocess.check_call(["/usr/libexec/PlistBuddy", "-c", "Set CFBundleVersion {}".format(buildNumber), plist_path])


def create_parser():
    parser = argparse.ArgumentParser(description="Generating v4iOS module..")
    parser.add_argument("--name", "-n", help="Module name", default="")
    parser.add_argument("--login", "-l", help="Login", default="")
    parser.add_argument("--password", "-p", help="Password", default="")
    return parser

def create_archive():
    subprocess.check_call([
        "xcodebuild", 
        "archive", 
        "-workspace", workspace, 
        "-archivePath", archive_path,
        "-scheme", scheme,
        ])

def upload_ipa(args):
    ipa_path = os.path.join(build_dir, ipa_name)
    subprocess.check_call([
        "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool", 
        "--upload-app",
        "-f", ipa_path,
        "-t", "ios",
        "-u", args.login,
        "-p", args.password,
        "--output-format", "normal"
        ])

def create_ipa():
    plsit = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>method</key>
        <string>app-store</string>
        <key>teamID</key>
        <string>{}</string>
    </dict>
    </plist>
    """.format(team_id)
    plist_path = os.path.join(root_dir, "Build/ipa.plist")
    with open(plist_path, "w") as text_file:
        text_file.write(plsit)

    subprocess.check_call([
        "xcodebuild", 
        "-exportArchive", 
        "-archivePath", archive_path + ".xcarchive", 
        "-exportOptionsPlist", plist_path,
        "-exportPath", os.path.join(root_dir, "Build/"),
        ])

if __name__ == "__main__":
    main()
