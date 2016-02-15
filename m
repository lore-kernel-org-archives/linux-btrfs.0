Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34416 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcBOKy3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 05:54:29 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] fstests: generic test for directory fsync after rename operation
Date: Mon, 15 Feb 2016 10:54:23 +0000
Message-Id: <1455533663-7704-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we move one file between directories, fsync the parent
directory of the old directory, power fail and remount the filesystem,
the file is not lost and it's located at the destination directory.

This is motivated by a bug found in btrfs, which is fixed by the patch
(for the linux kernel) titled:

  "Btrfs: fix file loss on log replay after renaming a file and fsync"

Tested against ext3, ext4, xfs, f2fs and reiserfs.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

Resend since it was not picked in the last update.
Rebased against current master branch (changed test number).

 tests/generic/335     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/335.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 99 insertions(+)
 create mode 100755 tests/generic/335
 create mode 100644 tests/generic/335.out

diff --git a/tests/generic/335 b/tests/generic/335
new file mode 100755
index 0000000..544533c
--- /dev/null
+++ b/tests/generic/335
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FSQA Test No. 335
+#
+# Test that if we move one file between directories, fsync the parent directory
+# of the old directory, power fail and remount the filesystem, the file is not
+# lost and it's located at the destination directory.
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
+# disappeared.
+mkdir -p $SCRATCH_MNT/a/b
+mkdir $SCRATCH_MNT/c
+touch $SCRATCH_MNT/a/b/foo
+
+# Make sure everything is durably persisted.
+sync
+
+# Now move our test file into a new parent directory.
+mv $SCRATCH_MNT/a/b/foo $SCRATCH_MNT/c/
+
+# Create a new file inside the parent directory of the directory where our test
+# file foo was previously at. This is just to ensure the fsync we do next
+# against that parent directory actually does something and it's not a noop.
+touch $SCRATCH_MNT/a/bar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a
+
+# Simulate a power failure / crash and remount the filesystem, so that the
+# journal/log is replayed.
+_flakey_drop_and_remount
+
+# We expect our file foo to exist, have an entry in the new parent
+# directory (c/) and not have anymore an entry in the old parent directory
+# (a/b/).
+[ -e $SCRATCH_MNT/a/b/foo ] && echo "File foo is still at directory a/b/"
+[ -e $SCRATCH_MNT/c/foo ] || echo "File foo is not at directory c/"
+
+# The new file named bar should also exist.
+[ -e $SCRATCH_MNT/a/bar ] || echo "File bar is missing"
+
+_unmount_flakey
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/335.out b/tests/generic/335.out
new file mode 100644
index 0000000..353f394
--- /dev/null
+++ b/tests/generic/335.out
@@ -0,0 +1,2 @@
+QA output created by 335
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 5f699ce..f270edb 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -337,3 +337,4 @@
 332 auto quick clone
 333 auto clone
 334 auto clone
+335 auto quick metadata
-- 
2.7.0.rc3

