#!/usr/bin/env python
# This script generates a version makes a tag from the last commit

from __future__ import print_function

import os, sys, subprocess

import versioning
import re
import argparse
import git

if __name__ =='__main__':
    parser = argparse.ArgumentParser(description='Make branch for new version and create a new package.')
    parser.add_argument('--major', help="Sets major version",type=int)
    parser.add_argument('--minor', help="Sets minor version",type=int)
    parser.add_argument('--patch', help="Sets patch version",type=int)
    parser.add_argument('--remote','-r', help="Name of remote. Default: origin",dest='remote', default="origin")
    parser.add_argument('--no-commit',help="Does not commit the last changes.",dest='no_commit', action='store_true')
    parser.add_argument('--no-push',help="Does push tags.",dest='no_push', action='store_true')
    parser.add_argument('--message','-m', help="Commit and tag message",dest='message', default="")

    args = parser.parse_args()
    remote_name = args.remote

    repo = git.Repo(".")
    tags = versioning.tags_as_str(repo)

    # Get last version
    major,minor,patch = versioning.last_version(repo)
    if args.major: major = args.major
    if args.minor: minor = args.minor
    if args.patch: patch = args.patch
    
    # Make new version
    major,minor,patch = versioning.next_version(repo,major,minor,patch)
    vs = versioning.version_string(major,minor,patch)
    message = args.message
    if not message:
        message = vs

    # Test if version exists
    tag_set = set(tags)
    if vs in tag_set:
      print("Error: Version %s already exists." % vs)
      exit()

    print("New version is %s. Press enter to continue." % vs)
    c = sys.stdin.read(1)

    ## Make commit and tag and push it to remote
    # TODO replace this with the proper python git command
    if not args.no_commit:
        os.system("git commit -a -m '%s'" % message)
    os.system("git tag -a %s -m '%s'" % (vs,message))
    print("Successfully made tag %s on %s." % (vs,remote_name)) 
    if not args.no_push:
        remote = repo.remote(remote_name)
        os.system("git push %s --tags" % remote_name)

