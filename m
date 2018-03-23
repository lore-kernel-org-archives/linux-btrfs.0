Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:39765 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbeCWR3W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 13:29:22 -0400
Received: by mail-it0-f54.google.com with SMTP id e98-v6so3505119itd.4
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 10:29:22 -0700 (PDT)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: ahferroin7@gmail.com
Subject: [PATCH] btrfs-progs: Add a basic monitoring script.
Date: Fri, 23 Mar 2018 13:29:17 -0400
Message-Id: <20180323172917.83326-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a minimalistic Python 3 based monitoring script to the standard
tools called `btrfs-status`.  The script itself depends only on a working
Python 3 installation, the `btrfs` command, and a regular `blkid` command
(the version of `blkid` in Busybox may not work, currently untested).

When called, `btrfs-status` runs some really basic monitoring checks on
the filesystems passed to it, and then exits 0 if they all passed, 1 if
any failed, or 2 if there was an internal error performing the checks.
If any checks fail, a message regarding that check will be printed to
stdout.

In order, it checks:
1. That each filesystem it is passed is not mounted degraded (done by
   parsing the contents of /proc/self/mountinfo).
2. That device error counters for each filesystem are all zero (done by
   calling out to `btrfs device stats --check`).
3. That chunk-level allocations aren't getting dangerously close to
   full (done by parsing data from /sys/fs/btrfs).

btrfs-status is intended to simplify automation of basic monitoring.  It
can be run as part of a systemd timer unit, as a cron job (in which case
you only get mail if something is wrong), or even just as a basic check
run by other monitoring software that doesn't natively support BTRFS.

This is _NOT_ intended to be a final monitoring solution, it's supposed
to be a stop-gap until we have something better.  There are a lot of
problems it won't catch (device failures for one), and the chunk
allocation check is unreliable in some cases (for example, three device
raid1 volumes with three different sized devices).
---

Sorry about the duplicate David, I screwed up the ML address on the
first one...

This ended up being ready sooner than I anticipated.  I've been working
on it for a couple of weeks now and testing the checks as I go.  The
last extant issue I had was related to trying to figure out the UUID of
a volume reliably, but that's gone since I just switched to calling out
to `blkid -o value -s UUID` instead of trying to look it up directly
from Python.

I've included a rudimentary man page and added btrfs-status to the
default install list, but if desired I can update the patch to just add
it to the source tree.

 Documentation/Makefile.in           |   1 +
 Documentation/btrfs-status.asciidoc |  56 +++++++++
 Makefile                            |   2 +-
 btrfs-status                        | 225 ++++++++++++++++++++++++++++++++++++
 4 files changed, 283 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-status.asciidoc
 create mode 100755 btrfs-status

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index 64947afb..4814139a 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -11,6 +11,7 @@ MAN8_TXT += btrfs-select-super.asciidoc
 MAN8_TXT += btrfstune.asciidoc
 MAN8_TXT += fsck.btrfs.asciidoc
 MAN8_TXT += mkfs.btrfs.asciidoc
+MAN8_TXT += btrfs-status.asciidoc
 
 # Sub commands for btrfs
 MAN8_TXT += btrfs-subvolume.asciidoc
diff --git a/Documentation/btrfs-status.asciidoc b/Documentation/btrfs-status.asciidoc
new file mode 100644
index 00000000..6e17c4a0
--- /dev/null
+++ b/Documentation/btrfs-status.asciidoc
@@ -0,0 +1,56 @@
+btrfs-status(8)
+===============
+
+NAME
+----
+btrfs-status - a script to sanity check a mounted BTRFS filesystem
+
+SYNOPSIS
+--------
+*btrfs-status* PATH [PATH ...]
+
+DESCRIPTION
+-----------
+*btrfs-status* is a small Python 3 script designed to simplify monitoring
+of BTRFS filesystems.  When run, it will perform the following checks
+on each of the BTRFS filesystems passed as an argument:
+
+1. Check that the filesystem isn't mounted with the `degraded` option.
+2. Check that there are no device errors recorded for any of the devices
+   in the filesystem.
+3. Check the chunk-level allocations on the filesystem to see if it's likely
+   to hit one of the more common ENOSPC cases in the near future.
+
+For each check that fails, *btrfs-status* will print out a message
+explaining what's wrong.
+
+NOTE: Depending on the exact combination of device sizes and chunk profies
+on a given filesystem, the allocation checks may act like nothing is wrong
+even if you are likely to get -ENOSPC.  In particular, raid10 filesystems
+with an odd number of disks, raid1 and raid10 filesystems where disks have
+different sizes, and any filesystem that mixes different raid profiles
+may hit this issue.  Fixing this deficiency would require a potentially
+large amount of data to be processed about the exact chunk layout of the
+filesystem, which would severely impact usability on large filesystems.
+
+OPTIONS
+-------
+-h:: Print out some basic help text about how to call *btrfs-status*
+
+EXIT STATUS
+-----------
+*btrfs-status* will return 0 if all the checks succeeded, 1 if any of
+them failed, or 2 if there was an internal error performing the checks.
+
+AVAILABILITY
+------------
+*btrfs-status* is part of btrfs-progs.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`btrfs`(8),
+`btrfs-check`(8),
+`btrfs-device`(8),
+`btrfs-filesystem`(8)
diff --git a/Makefile b/Makefile
index 92cfe7b5..ee7d218a 100644
--- a/Makefile
+++ b/Makefile
@@ -194,7 +194,7 @@ progs = $(progs_install) btrfsck btrfs-corrupt-block
 progs_install = btrfs mkfs.btrfs btrfs-debug-tree \
 	btrfs-map-logical btrfs-image btrfs-zero-log \
 	btrfs-find-root btrfstune \
-	btrfs-select-super
+	btrfs-select-super btrfs-status
 
 # other tools, not built by default
 progs_extra = btrfs-fragments btrfs-calc-size btrfs-show-super
diff --git a/btrfs-status b/btrfs-status
new file mode 100755
index 00000000..1c3494c5
--- /dev/null
+++ b/btrfs-status
@@ -0,0 +1,225 @@
+#!/usr/bin/env python3
+'''btrfs-status.py  Check the basic status of a BTRFS volume.
+
+This script will check and report on a number of the more basic sanity
+checks for a BTRFS filesystem, namely:
+
+- Check if the filesystem is mounted degraded or not.
+- Check if any of the device error counters are non-zero.
+- Do some slightly complex checks relating to chunk allocation to try and
+  predict when a user is likely to have ENOSPC eissues.
+
+Each of these checks cna be performed with zero knowledge of prior state
+of the volume, which allows this script to be easily used from cron or as
+a systemd timer.
+
+Takes a list of paths to BTRFS volumes to check, and returns 0 (with
+no output) if all the checks passed, or returns 1 with info about what
+checks failed if any checks fail.  Returns 2 if an internal error
+occurred.
+
+Copyright (C) 2018 Austin S. Hemmelgarn
+
+This program is free software; you can redistribute it and/or
+modify it under the terms of the GNU General Public
+License v2 as published by the Free Software Foundation.
+
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+General Public License for more details.
+
+You should have received a copy of the GNU General Public
+License along with this program; if not, write to the
+Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+Boston, MA 021110-1307, USA.
+'''
+
+import argparse
+import glob
+import os
+import subprocess
+import sys
+
+
+class BtrfsVolumePathAction(argparse.Action):
+    '''Parse BTRFS volume paths.
+
+       This checks that the paths passed in are actually BTRFS volumes
+       (or at least, that they're mounted subvolumes from BTRFS
+       volumes), and also finds the associated volume UUID and line
+       in /proc/self/mountinfo, then stores the path, UUID, and split
+       mountinfo line as a 3-tuple in a list at the destination.
+
+       We use a relatively efficient approach that only scans through
+       /proc/self/mountinfo once and caches the results.  While this
+       leaves us open to a TOCTOU race condition, such a race condition
+       is inherent to the checks we perform here, because we are parsing
+       mount information and then using it later.
+
+       The `blkid` command is used to retrieve the volume UUID.'''
+    def __call__(self, parser, namespace, values, option_string=None):
+        btrfsmounts = list()
+        resultlist = list()
+
+        with open('/proc/self/mountinfo', 'r') as mntinfo:
+            for line in mntinfo:
+                mntitem = line.split()
+                if mntitem[7] == 'btrfs':
+                    btrfsmounts.append(mntitem)
+
+        for value in values:
+            mntitem = False
+            if os.path.ismount(value):
+                mntpath = os.path.abspath(value)
+                for mntitem in btrfsmounts:
+                    if value == mntitem[4]:
+                        mntinfo = mntitem
+                        break
+            if not mntitem:
+                raise ValueError(value + ' is not a mounted BTRFS volume.')
+            try:
+                uuid = subprocess.check_output(['blkid', '-o', 'value', '-s', 'UUID', mntitem[8]]).decode().rstrip()
+            except (subprocess.CalledProcessError, FileNotFoundError):
+                raise ValueError('Unable to determine volume UUID for ' + value)
+            resultlist.append((value, uuid, mntitem))
+
+        setattr(namespace, self.dest, resultlist)
+
+
+def check_degraded(args):
+    '''Check if any of the volumes are mounted degraded.
+
+      Returns True if none of the volumes are degraded, False
+      otherwise.
+
+      This simply looks at the information from /proc/self/mountinfo we
+      retrieved earlier. '''
+    ret = True
+
+    for item in args.paths:
+        if item[2][-1].find('degraded') != -1:
+            print(item[0] + ' is currently degraded!')
+            ret = False
+
+    return ret
+
+def check_dev_errors(args):
+    '''Check if any of the volumes have seen device errors.
+
+      Returns True if none of the volumes have any recorded device errors,
+      False otherwise.
+
+      This takes advantage of the `--check` option for `btrfs device
+      stats` to see if any counters are non-zero.'''
+    ret = True
+
+    for item in args.paths:
+        try:
+            if subprocess.call(['btrfs', 'device', 'stats', '--check', item[0]], stdout=subprocess.DEVNULL) != 0:
+                print(item[0] + ' shows device level errors!')
+                ret = False
+        except (subprocess.CalledProcessError, FileNotFoundError):
+            print('An error occured while attempting to retrieve error counters for ' + item[0])
+            os.exit(2)
+
+    return ret
+
+def check_allocations(args):
+    '''Check if the chunk allocations are problematic.
+
+       Returns True if everything looks OK, False otherwise.
+
+       THis is the most complex check in the set.  It uses the UUID
+       we looked up for each volume while parsing the arguments to
+       find info about the chunk-level allocations in /sys/fs/btrfs,
+       and then does some math to figure out if that volume is likely
+       to have ENOSPC issues soon or not.
+
+       Note that the current checking done here is only reliable if
+       there volume is configured such that every possible combination
+       of chunk allocations using the currently ctive profiles for each
+       chunk type will completely fill all devices in the volume.  As a
+       particular example, this may be unreliable for volumes using
+       raid1 profiles with three devices of different sizes.
+
+       Each step is independently commented below.'''
+    ret = True
+    alloctypes = (
+        'data',
+        'metadata',
+        'system'
+    )
+
+    for volume in args.paths:
+        alloc = { 'size': 0 }
+        syspath = os.path.join('/sys/fs/btrfs', volume[1])
+
+        # This figures out the total size of the BTRFS volume.
+        for dev in glob.glob(os.path.join(syspath, 'devices', '*')):
+            with open(os.path.join(syspath, 'devices', dev, 'size'), 'r') as devsize:
+                alloc['size'] += int(devsize.read(None))
+
+        # This looks up the individual amounts of space allocated for
+        # each chunk type.
+        for alloctype in alloctypes:
+            alloc[alloctype] = dict()
+            for value in ('bytes_used', 'disk_total', 'disk_used', 'total_bytes'):
+                with open(os.path.join(syspath, 'allocation', alloctype, value), 'r') as valuefile:
+                    alloc[alloctype][value] = int(valuefile.read(None))
+
+        # Now we compute usage ratios and global free space.  First, we
+        # iterate over each chunk type and compute it's usage ratio while
+        # also adding it's size on disk to the total amount of space used,
+        # then we calculate the global free space and usage ratio.
+        disk_usage_total = 0
+        usage_ratio = dict()
+        for alloctype in alloctypes:
+            usage_ratio[alloctype] = alloc[alloctype]['bytes_used'] / alloc[alloctype]['total_bytes']
+            disk_usage_total += alloc[alloctype]['disk_total']
+        disk_free_space = alloc['size'] - disk_usage_total
+        disk_usage_ratio = disk_usage_total / alloc['size']
+
+        # If our global usage ratio is greater than 95% or we have less
+        # than 1GB of global free space, then we may be in trouble.
+        if (disk_usage_ratio >= 0.95) or (disk_free_space < (1024 * 1024 * 1024)):
+            # Check each type of chunk allocation, and give a noisy
+            # warning if any o thema re close to being out of space,
+            # because that means we're dangerously close to hitting
+            # ENOSPC issues.
+            for alloctype in alloctypes:
+                if usage_ratio[alloctype] >= 0.95:
+                    print('{0} is in danger of running out of space soon (overall usage is {1!s}% and {2} usage is {3!s}%)!'.format(
+                          volume[0],
+                          100 * disk_usage_ratio,
+                          alloctype,
+                          100 * usage_ratio[alloctype]
+                          ))
+                    ret = False
+
+    return ret
+
+def parse_args():
+    '''Parse our command-line arguments.'''
+    parser = argparse.ArgumentParser(description='Check the basic status of a BTRFS volume.')
+    parser.add_argument('paths', metavar='PATH', nargs='+', action=BtrfsVolumePathAction, help='Path to a mounted BTRFS volume to check.')
+    return parser.parse_args()
+
+def main(cli=False):
+    '''Main program logic.'''
+    args = parse_args()
+    ret = 0
+    checks = [
+        check_degraded,
+        check_dev_errors,
+        check_allocations
+    ]
+
+    for item in checks:
+        if not item(args):
+            ret = 1
+
+    return ret
+
+if __name__ == '__main__':
+    sys.exit(main())
-- 
2.16.2

