Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52681 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbcBJNc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 08:32:58 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs, test directory fsync after deleting snapshots
Date: Wed, 10 Feb 2016 13:32:51 +0000
Message-Id: <1455111171-25449-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we fsync a directory that had a snapshot entry in it that
was deleted and crash, the next time we mount the filesystem, the log
replay procedure will not fail and the snapshot is not present anymore.

This issue is fixed by the following patch for the linux kernel:

  "Btrfs: fix unreplayable log after snapshot delete + parent dir fsync"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/118     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/118.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/btrfs/118
 create mode 100644 tests/btrfs/118.out

diff --git a/tests/btrfs/118 b/tests/btrfs/118
new file mode 100755
index 0000000..3ed1cbe
--- /dev/null
+++ b/tests/btrfs/118
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FSQA Test No. 118
+#
+# Test that if we fsync a directory that had a snapshot entry in it that was
+# deleted and crash, the next time we mount the filesystem, the log replay
+# procedure will not fail and the snapshot is not present anymore.
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
+_supported_fs btrfs
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
+# Create a snapshot at the root of our filesystem (mount point path), delete it,
+# fsync the mount point path, crash and mount to replay the log. This should
+# succeed and after the filesystem is mounted the snapshot should not be visible
+# anymore.
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap1
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT
+_flakey_drop_and_remount
+[ -e $SCRATCH_MNT/snap1 ] && echo "Snapshot snap1 still exists after log replay"
+
+# Similar scenario as above, but this time the snapshot is created inside a
+# directory and not directly under the root (mount point path).
+mkdir $SCRATCH_MNT/testdir
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/testdir/snap2
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/testdir/snap2
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir
+_flakey_drop_and_remount
+[ -e $SCRATCH_MNT/testdir/snap2 ] && \
+	echo "Snapshot snap2 still exists after log replay"
+
+_unmount_flakey
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/118.out b/tests/btrfs/118.out
new file mode 100644
index 0000000..3daed86
--- /dev/null
+++ b/tests/btrfs/118.out
@@ -0,0 +1,2 @@
+QA output created by 118
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f74ffbb..a2fa412 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -118,3 +118,4 @@
 115 auto qgroup
 116 auto quick metadata
 117 auto quick send clone
+118 auto quick snapshot metadata
-- 
2.7.0.rc3

