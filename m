Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35108 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbbGXPIv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 11:08:51 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test for file fsync after unlink and inode eviction
Date: Fri, 24 Jul 2015 06:31:12 +0100
Message-Id: <1437715872-5984-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we remove one hard link from an inode, evict the inode,
fsync the inode, power fail and then mount the filesystem, the hard
link we removed does not exists anymore and the filesystem metadata
is in a consistent state.

This test is motivated by an issue found on btrfs, and on an unpatched
btrfs it fails with:

  FSTYP         -- btrfs
  PLATFORM      -- Linux/x86_64 debian3 4.1.0-rc6-btrfs-next-11+
  MKFS_OPTIONS  -- /dev/sdc
  MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

  generic/098 4s ... - output mismatch (see .../generic/098.out.bad)
    --- tests/generic/098.out	2015-07-23 18:01:12.616175932 +0100
    +++ .../generic/098.out.bad	2015-07-23 18:04:58.924138308 +0100
    @@ -1,3 +1,6 @@
     QA output created by 098
     Entries in testdir:
    +bar
     foo
    +rm: cannot remove '.../testdir/foo': Stale file handle
    +rmdir: failed to remove '.../scratch_1/testdir': Directory not empty
    ...
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent ...
  (...)

  $ cat /home/fdmanana/git/hub/xfstests/results/generic/098.full
  (...)
  checking fs roots
  root 5 inode 258 errors 2001, no inode item, link count wrong
   unresolved ref dir 257 index 0 namelen 3 name foo filetype 1 errors 6,\
       no dir index, no inode ref
   unresolved ref dir 257 index 3 namelen 3 name bar filetype 1 errors 5,\
       no dir item, no inode ref
  (...)

Tested against ext3/4, xfs, f2fs and reiserfs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/098     | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/098.out |  3 ++
 tests/generic/group   |  1 +
 3 files changed, 101 insertions(+)
 create mode 100755 tests/generic/098
 create mode 100644 tests/generic/098.out

diff --git a/tests/generic/098 b/tests/generic/098
new file mode 100755
index 0000000..c156f8d
--- /dev/null
+++ b/tests/generic/098
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FSQA Test No. 098
+#
+# Test that if we remove one hard link from an inode, evict the inode, fsync the
+# inode, power fail and then mount the filesystem, the hard link we removed does
+# not exists anymore and the filesystem metadata is in a consistent state.
+#
+#-----------------------------------------------------------------------
+#
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_dm_flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create our test file with 2 hard links.
+mkdir $SCRATCH_MNT/testdir
+touch $SCRATCH_MNT/testdir/foo
+ln $SCRATCH_MNT/testdir/foo $SCRATCH_MNT/testdir/bar
+
+# Make sure everything done so far is durably persisted.
+sync
+
+# Now remove one of the links, trigger inode eviction and then fsync our
+# inode.
+unlink $SCRATCH_MNT/testdir/bar
+echo 2 > /proc/sys/vm/drop_caches
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir/foo
+
+# Silently drop all writes on our scratch device to simulate a power failure.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+# Allow writes again and mount the fs to trigger log/journal replay.
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+# Now verify our directory entries.
+echo "Entries in testdir:"
+ls -1 $SCRATCH_MNT/testdir
+
+# If we remove our inode, its parent should become empty and therefore we should
+# be able to remove the parent.
+rm -f $SCRATCH_MNT/testdir/*
+rmdir $SCRATCH_MNT/testdir
+
+_unmount_flakey
+
+# The fstests framework will call fsck against our filesystem which will verify
+# that all metadata is in a consistent state.
+
+status=0
+exit
diff --git a/tests/generic/098.out b/tests/generic/098.out
new file mode 100644
index 0000000..a23e90a
--- /dev/null
+++ b/tests/generic/098.out
@@ -0,0 +1,3 @@
+QA output created by 098
+Entries in testdir:
+foo
diff --git a/tests/generic/group b/tests/generic/group
index 1e21d17..14a1cc8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -100,6 +100,7 @@
 095 auto quick metadata
 096 auto quick metadata
 097 udf auto
+098 auto quick metadata
 099 udf auto
 100 udf auto
 105 acl auto quick
-- 
2.1.3

