#!/usr/bin/env python
# Script for getting printing the version number of current branch

from __future__ import print_function

import argparse
import git
import versioning

def set_quote_if(s,quote=True):
    return '"'+s+'"' if quote else s

if __name__ =='__main__':
  repo = git.Repo(".")
  parser = argparse.ArgumentParser(description='Make version and deploy.')
  parser.add_argument('--major', help="Prints major version",action='store_true')
  parser.add_argument('--minor', help="Prints minor version",action='store_true')
  parser.add_argument('--patch', help="Prints patch version",action='store_true')
  parser.add_argument('--quote', help="Output in quotes",action='store_true')
  parser.add_argument('--next', help="Prints next version",action='store_true')
  args = parser.parse_args()

  major,minor,patch = versioning.last_version(repo)
  if args.next:
    major,minor,patch = versioning.next_version(repo,major,minor,patch)

  if args.major:
    print(set_quote_if(str(major),args.quote))

  if args.minor:
    print(set_quote_if(str(minor),args.quote))

  if args.patch:
    print(set_quote_if(str(patch),args.quote))

  # Prints version string in the form $VERSION $COMMIT $BRANCH
  if not args.patch and not args.minor and not args.major:
    vs = "%s %s %s" % (versioning.version_string(minor,major,patch),
          repo.commit().hexsha[0:12],
          repo.active_branch.name)
    print(set_quote_if(vs,args.quote))

