Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58566 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbcCXRHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 13:07:36 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: add btrfs test for fsync after snapshot deletion
Date: Thu, 24 Mar 2016 17:07:21 +0000
Message-Id: <1458839241-12379-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that if we delete a snapshot, delete its parent directory, create
another directory with the same name as that parent and then fsync either
the new directory or a file inside the new directory, the fsync succeeds,
the fsync log is replayable and produces a correct result.

This is motivated by a bug that is fixed by the following patch for
btrfs (linux kernel):

  Btrfs: fix unreplayable log after snapshot deletion and parent
  re-creation

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/120     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/120.out | 12 +++++++
 tests/btrfs/group   |  1 +
 3 files changed, 104 insertions(+)
 create mode 100755 tests/btrfs/120
 create mode 100644 tests/btrfs/120.out

diff --git a/tests/btrfs/120 b/tests/btrfs/120
new file mode 100755
index 0000000..4ede4e6
--- /dev/null
+++ b/tests/btrfs/120
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FSQA Test No. 120
+#
+# Test that if we delete a snapshot, delete its parent directory, create
+# another directory with the same name as that parent and then fsync either
+# the new directory or a file inside the new directory, the fsync succeeds,
+# the fsync log is replayable and produces a correct result.
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
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_dm_target flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+rm -f $seqres.full
+
+_populate_fs()
+{
+	_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
+		$SCRATCH_MNT/testdir/snap
+	_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/testdir/snap
+	rmdir $SCRATCH_MNT/testdir
+	mkdir $SCRATCH_MNT/testdir
+}
+
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+mkdir $SCRATCH_MNT/testdir
+_populate_fs
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir
+_flakey_drop_and_remount
+
+echo "Filesystem contents after the first log replay:"
+ls -R $SCRATCH_MNT | _filter_scratch
+
+# Now do the same as before but instead of doing an fsync against the directory,
+# do an fsync against a file inside the directory.
+
+_populate_fs
+touch $SCRATCH_MNT/testdir/foobar
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/testdir/foobar
+_flakey_drop_and_remount
+
+echo "Filesystem contents after the second log replay:"
+ls -R $SCRATCH_MNT | _filter_scratch
+
+_unmount_flakey
+status=0
+exit
diff --git a/tests/btrfs/120.out b/tests/btrfs/120.out
new file mode 100644
index 0000000..4210bfa
--- /dev/null
+++ b/tests/btrfs/120.out
@@ -0,0 +1,12 @@
+QA output created by 120
+Filesystem contents after the first log replay:
+SCRATCH_MNT:
+testdir
+
+SCRATCH_MNT/testdir:
+Filesystem contents after the second log replay:
+SCRATCH_MNT:
+testdir
+
+SCRATCH_MNT/testdir:
+foobar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d312874..13aa1e5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -120,3 +120,4 @@
 117 auto quick send clone
 118 auto quick snapshot metadata
 119 auto quick snapshot metadata qgroup
+120 auto quick snapshot metadata
-- 
2.7.0.rc3

