Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34559 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbcBLQVS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 11:21:18 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] fstests: generic test for file fsync after rename operation
Date: Fri, 12 Feb 2016 16:21:11 +0000
Message-Id: <1455294071-8864-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we have a file F1 with two links, one in a directory A and
the other in directory B, if we remove the link in directory B, move some
other file F2 from directory B into directory C, fsync inode F1, power
fail and remount the filesystem, file F2 exists and is located only in
directory C.

This is motivated by a bug found in btrfs, which is fixed by the patch
(for the linux kernel) titled:

   "Btrfs: fix file loss on log replay after renaming a file and fsync"

Tested against ext3, ext4, xfs, f2fs and reiserfs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/252     | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/252.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/generic/252
 create mode 100644 tests/generic/252.out

diff --git a/tests/generic/252 b/tests/generic/252
new file mode 100755
index 0000000..b42b21b
--- /dev/null
+++ b/tests/generic/252
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FSQA Test No. 252
+#
+# Test that if we have a file F1 with two links, one in a directory A and the
+# other in directory B, if we remove the link in directory B, move some other
+# file F2 from directory B into directory C, fsync inode F1, power fail and
+# remount the filesystem, file F2 exists and is located only in directory C.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
+	cd /
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
+_require_dm_target flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create our test directories and the file we will later check if it has
+# disappeared (file bar).
+mkdir $SCRATCH_MNT/a
+mkdir $SCRATCH_MNT/b
+mkdir $SCRATCH_MNT/c
+touch $SCRATCH_MNT/a/foo
+ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo_link
+touch $SCRATCH_MNT/b/bar
+
+# Make sure everything is durably persisted.
+sync
+
+# Now delete one of the hard links of file foo and move file bar into b/
+unlink $SCRATCH_MNT/b/foo_link
+mv $SCRATCH_MNT/b/bar $SCRATCH_MNT/c/
+
+# Now fsync file foo.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo
+
+# Simulate a power failure / crash and remount the filesystem, so that the
+# journal/log is replayed.
+_flakey_drop_and_remount
+
+# We expect that after the journal/log was replayed, we no longer have the link
+# foo_link and file bar was moved from directory b/ to directory c/.
+[ -e $SCRATCH_MNT/b/foo_link ] && echo "Link foo_link still exists"
+[ -e $SCRATCH_MNT/b/bar ] && echo "File bar is still at directory b/"
+[ -e $SCRATCH_MNT/c/bar ] || echo "File bar is not at directory c/"
+
+_unmount_flakey
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/252.out b/tests/generic/252.out
new file mode 100644
index 0000000..ddfa3e0
--- /dev/null
+++ b/tests/generic/252.out
@@ -0,0 +1,2 @@
+QA output created by 252
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index a1222b0..3ac92df 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -254,6 +254,7 @@
 249 auto quick rw
 250 auto quick metadata
 251 ioctl trim
+252 auto quick metadata
 255 auto quick prealloc
 256 auto quick
 257 dir auto quick
-- 
2.7.0.rc3

