Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32973 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbcCWJm6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 05:42:58 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH Resend] fstests: btrfs, test log replay with qgroups enabled and orphan roots
Date: Wed, 23 Mar 2016 02:49:15 +0000
Message-Id: <1458701355-1475-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that replaying a log tree when qgroups are enabled and orphan roots
(deleted snapshots) exist, the replay process does not crash.

This is motivated by a bug found in btrfs, introduced in the linux kernel
4.4 release, and is fixed by the linux kernel commit 909c3a22da3b
("Btrfs: fix loading of orphan roots leading to BUG_ON") that landed in
kernel 4.5.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

Resending as it was missing in the last git update.

 tests/btrfs/119     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/119.out |   9 ++++
 tests/btrfs/group   |   1 +
 3 files changed, 126 insertions(+)
 create mode 100755 tests/btrfs/119
 create mode 100644 tests/btrfs/119.out

diff --git a/tests/btrfs/119 b/tests/btrfs/119
new file mode 100755
index 0000000..cf07550
--- /dev/null
+++ b/tests/btrfs/119
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FSQA Test No. 119
+#
+# Test log tree replay when qgroups are enabled and orphan roots (deleted
+# snapshots) exist.
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
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+
+# Create 2 directories with one file in one of them.
+# We use these just to trigger a transaction commit later, moving the file from
+# directory a to directory b and doing an fsync against directory a.
+mkdir $SCRATCH_MNT/a
+mkdir $SCRATCH_MNT/b
+touch $SCRATCH_MNT/a/f
+sync
+
+# Create our test file with 2 4K extents.
+$XFS_IO_PROG -f -s -c "pwrite -S 0xaa 0 8K" $SCRATCH_MNT/foobar | _filter_xfs_io
+
+# Create a snapshot and delete it. This doesn't really delete the snapshot
+# immediately, just makes it inaccessible and invisible to user space, the
+# snapshot is deleted later by a dedicated kernel thread (cleaner kthread)
+# which is woke up at the next transaction commit.
+# A root orphan item is inserted into the tree of tree roots, so that if a
+# power failure happens before the dedicated kernel thread does the snapshot
+# deletion, the next time the filesystem is mounted it resumes the snapshot
+# deletion.
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
+_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap
+
+# Now overwrite half of the extents we wrote before. Because we made a snapshpot
+# before, which isn't really deleted yet (since no transaction commit happened
+# after we did the snapshot delete request), the non overwritten extents get
+# referenced twice, once by the default subvolume and once by the snapshot.
+$XFS_IO_PROG -c "pwrite -S 0xbb 4K 8K" $SCRATCH_MNT/foobar | _filter_xfs_io
+
+# Now move file f from directory a to directory b and fsync directory a.
+# The fsync on the directory a triggers a transaction commit (because a file
+# was moved from it to another directory) and the file fsync leaves a log tree
+# with file extent items to replay.
+mv $SCRATCH_MNT/a/f $SCRATCH_MNT/a/b
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
+
+echo "File digest before power failure:"
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+# Now simulate a power failure and mount the filesystem to replay the log tree.
+# After the log tree was replayed, we used to hit a BUG_ON() when processing
+# the root orphan item for the deleted snapshot. This is because when processing
+# an orphan root the code expected to be the first code inserting the root into
+# the fs_info->fs_root_radix radix tree, while in reallity it was the second
+# caller attempting to do it - the first caller was the transaction commit that
+# took place after replaying the log tree, when updating the qgroup counters.
+_flakey_drop_and_remount
+
+echo "File digest before after failure:"
+# Must match what he got before the power failure.
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/btrfs/119.out b/tests/btrfs/119.out
new file mode 100644
index 0000000..dc48d6c
--- /dev/null
+++ b/tests/btrfs/119.out
@@ -0,0 +1,9 @@
+QA output created by 119
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest before power failure:
+6b1ddec97df32c31d595067a4392ae12  SCRATCH_MNT/foobar
+File digest before after failure:
+6b1ddec97df32c31d595067a4392ae12  SCRATCH_MNT/foobar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a2fa412..d312874 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -119,3 +119,4 @@
 116 auto quick metadata
 117 auto quick send clone
 118 auto quick snapshot metadata
+119 auto quick snapshot metadata qgroup
-- 
2.7.0.rc3

