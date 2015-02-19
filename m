Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34879 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751939AbbBSS3p (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 19 Feb 2015 13:29:45 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for directory fsync after adding hard links
Date: Thu, 19 Feb 2015 18:29:11 +0000
Message-Id: <1424370551-18884-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test is motivated by an fsync issue discovered in btrfs.
The issue was that after adding a new hard link to an existing file
(one that was created in a past transaction) and fsync'ing the parent
directory of the new hard link, after the fsync log replay the file's
inode link count did not get its link count incremented, while the new
directory entry was visible.
Also, unlike xfs and ext4, new files under the directory we fsync were
not being written to the fsync log, nor were any child directories and
new files and links under the children directories. So this test verifies
too that btrfs has the same behaviour as xfs and ext4.

The btrfs issue was fixed by the following linux kernel patch:

  Btrfs: fix metadata inconsistencies after directory fsync

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/060     | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/060.out |   3 +
 tests/generic/group   |   1 +
 3 files changed, 154 insertions(+)
 create mode 100755 tests/generic/060
 create mode 100644 tests/generic/060.out

diff --git a/tests/generic/060 b/tests/generic/060
new file mode 100755
index 0000000..a3ff618
--- /dev/null
+++ b/tests/generic/060
@@ -0,0 +1,150 @@
+#! /bin/bash
+# FS QA Test No. 060
+#
+# This test is motivated by an fsync issue discovered in btrfs.
+# The issue was that after adding a new hard link to an existing file (one that
+# was created in a past transaction) and fsync'ing the parent directory of the
+# new hard link, after the fsync log replay the file's inode link count did not
+# get its link count incremented, while the new directory entry was visible.
+# Also, unlike xfs and ext4, new files under the directory we fsync were not
+# being written to the fsync log, nor were any child directories and new files
+# and links under the children directories. So this test verifies too that
+# btrfs has the same behaviour as xfs and ext4.
+#
+# The btrfs issue was fixed by the following linux kernel patch:
+#
+#  Btrfs: fix metadata inconsistencies after directory fsync
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
+# Author: Filipe Manana <fdmanana@suse.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create our test file and directory.
+touch $SCRATCH_MNT/foo
+mkdir $SCRATCH_MNT/mydir
+
+# Make sure all metadata is durably persisted.
+sync
+
+# Add a hard link to 'foo' inside our test directory and fsync only the
+# directory. The btrfs fsync implementation had a bug that caused the new
+# directory entry to be visible after the fsync log replay but, the inode
+# of our file remained with a link count of 1.
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/mydir/foo_2
+
+# Add a few more links and files created in the current transaction.
+# Just to verify nothing breaks or gives incorrect results.
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/mydir/foo_3
+echo "hello world" > $SCRATCH_MNT/hello
+ln $SCRATCH_MNT/hello $SCRATCH_MNT/mydir/hello_2
+
+# Add some subdirectories and new files and links to them. This is to verify
+# that after fsyncing our top level directory 'mydir', all the subdirectories
+# and their files/links are registered in the fsync log and exist after the
+# fsync log is replayed - xfs and ext4 give this guarantee.
+mkdir -p $SCRATCH_MNT/mydir/x/y/z
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/mydir/x/y/foo_y_link
+ln $SCRATCH_MNT/foo $SCRATCH_MNT/mydir/x/y/z/foo_z_link
+touch $SCRATCH_MNT/mydir/x/y/z/qwerty
+
+# Now fsync only our top directory.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/mydir
+
+# Simulate a crash/power loss.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Remove the first name of our inode. Because of the directory fsync bug, the
+# inode's link count was 1 instead of 5, so removing the 'foo' name ends up
+# deleting the inode and the other names are stale directory entries (and still
+# visible to applications). Attempting to remove or access the remaining
+# dentries pointing to that inode resulted in stale file handle errors, and
+# made it impossible to remove the parent directories since it was impossible
+# for them to become empty.
+echo "file 'foo' link count after log replay: $(stat -c %h $SCRATCH_MNT/foo)"
+rm -f $SCRATCH_MNT/foo
+
+# Now verify that all files, links and directories created before fsyncing our
+# directory exist after the fsync log was replayed.
+[ -f $SCRATCH_MNT/mydir/foo_2 ] || echo "Link mydir/foo_2 is missing"
+[ -f $SCRATCH_MNT/mydir/foo_3 ] || echo "Link mydir/foo_3 is missing"
+[ -f $SCRATCH_MNT/hello ] || echo "File hello is missing"
+echo "file 'hello' size after log replay: $(stat -c %s $SCRATCH_MNT/hello)"
+[ -f $SCRATCH_MNT/mydir/hello_2 ] || echo "Link mydir/hello_2 is missing"
+[ -f $SCRATCH_MNT/mydir/x/y/foo_y_link ] || \
+	echo "Link mydir/x/y/foo_y_link is missing"
+[ -f $SCRATCH_MNT/mydir/x/y/z/foo_z_link ] || \
+	echo "Link mydir/x/y/z/foo_z_link is missing"
+[ -f $SCRATCH_MNT/mydir/x/y/z/qwerty ] || \
+	echo "File mydir/x/y/z/qwerty is missing"
+
+# Now remove all files/links, under our test directory 'mydir', and verify we
+# can remove all the directories.
+rm -f $SCRATCH_MNT/mydir/x/y/z/*
+rmdir $SCRATCH_MNT/mydir/x/y/z
+rm -f $SCRATCH_MNT/mydir/x/y/*
+rmdir $SCRATCH_MNT/mydir/x/y
+rmdir $SCRATCH_MNT/mydir/x
+rm -f $SCRATCH_MNT/mydir/*
+rmdir $SCRATCH_MNT/mydir
+
+# An fsck, run by the fstests framework everytime a test finishes, also detected
+# the inconsistency and printed the following error message:
+#
+# root 5 inode 257 errors 2001, no inode item, link count wrong
+#    unresolved ref dir 258 index 2 namelen 5 name foo_2 filetype 1 errors 4, no inode ref
+#    unresolved ref dir 258 index 3 namelen 5 name foo_3 filetype 1 errors 4, no inode ref
+
+status=0
+exit
diff --git a/tests/generic/060.out b/tests/generic/060.out
new file mode 100644
index 0000000..3ecb0a1
--- /dev/null
+++ b/tests/generic/060.out
@@ -0,0 +1,3 @@
+QA output created by 060
+file 'foo' link count after log replay: 5
+file 'hello' size after log replay: 0
diff --git a/tests/generic/group b/tests/generic/group
index f2eb87a..85ff384 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -61,6 +61,7 @@
 056 metadata auto quick
 057 metadata auto quick
 059 metadata auto quick
+060 metadata auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
 069 rw udf auto quick
-- 
2.1.3

