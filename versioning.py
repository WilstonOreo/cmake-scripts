#!/usr/bin/env python
# Generic functions for versioning

from __future__ import print_function

import re, git
from operator import itemgetter, attrgetter, methodcaller


""" Calculates the next version based on the existing one.
"""
def next_version(repo,major,minor,patch):
    last_major, last_minor, last_patch = last_version(repo)

    last_v = (last_major * 100 + last_minor) * 100 + last_patch
    v = (major * 100 + minor) * 100 + patch
    if v/100 > last_v/100:
        v = v / 100 * 100 
    if v/10000 > last_v/10000:
        v = v / 10000 * 10000 + v / 100 * 100 % 100
    elif v <= last_v:
        v = last_v
        v += 1

    return v/10000,(v/100 % 100),v % 100

""" Returns a version from a string
"""
def version_string(major,minor,patch):
    return "v%d.%d.%d" % (major,minor,patch)

""" Get major, minor and patch version from a string
"""
def version_from_string(version):
  result = re.match("v([0-9]).([0-9]).([0-9])",version)
  if not result: return None
  major,minor,patch = result.group(1,2,3)
  return int(major),int(minor),int(patch)

def versions_sorted(repo):
    versions = [] 
    for tag in repo.tags:
      version = version_from_string(tag.name)
      if version is None: continue 
      versions.append(version)
    versions.sort(key=itemgetter(0,1,2))
    return versions

def tags_as_str(repo):
    tags = []
    for tag in repo.tags:
        tags.append(tag.name)
    return tags

def last_version(repo):
    versions = versions_sorted(repo) 
    if not versions: return 0,0,0
    major,minor,patch = versions[-1]
    return major,minor,patch

if __name__ =='__main__':
    repo = git.Repo(".")

