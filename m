Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbJIUWd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 16:22:33 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <jbacik@fb.com>, Robin Ruede <rruede+git@gmail.com>
Subject: [PATCH 2/2] fstests: btrfs, test sending snapshots received from other filesystems
Date: Fri,  9 Oct 2015 21:22:24 +0100
Message-Id: <1444422144-2735-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that sending a snapshot received from a different filesystem is
possible for both full and incremental send operations.

This used to work until the linux kernel release 4.2, but a commit [1] in
that release introduced a regression which did not allow this anymore.

The regression is fixed by the linux kernel patch titled:

  "btrfs: fix resending received snapshot with parent"

[1] 37b8d27de5d0 ("Btrfs: use received_uuid of parent during send")

Cc: Josef Bacik <jbacik@fb.com>
Cc: Robin Ruede <rruede+git@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/109     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/109.out |  14 ++++++
 tests/btrfs/group   |   1 +
 3 files changed, 148 insertions(+)
 create mode 100755 tests/btrfs/109
 create mode 100644 tests/btrfs/109.out

diff --git a/tests/btrfs/109 b/tests/btrfs/109
new file mode 100755
index 0000000..b7b0c85
--- /dev/null
+++ b/tests/btrfs/109
@@ -0,0 +1,133 @@
+#! /bin/bash
+# FS QA Test No. btrfs/109
+#
+# Test that resending snapshots from a different filesystem is possible for
+# both full and incremental send operations.
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -fr $send_files_dir
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+# Create a test file
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 32K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Create the first snapshot.
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
+
+# Modify our file and create the second snapshot, used later for an incremental
+# send operation.
+$XFS_IO_PROG -c "pwrite -S 0xbb 4K 4K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
+
+echo "File digests in the first filesystem:"
+md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
+
+# Save send streams for the snapshots. For the first one we use a full send
+# operation and the for the second snapshot we use an incremental send.
+_run_btrfs_util_prog send $SCRATCH_MNT/snap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2 \
+	-f $send_files_dir/2.snap
+
+# Create a new filesystem and receive the snapshots.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -vv -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -vv -f $send_files_dir/2.snap
+
+echo "File digests in the second filesystem:"
+# Must match the digests we got in the first filesystem.
+md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
+
+# Call sync to flush all delalloc data that the receiver processes created.
+# Although 'btrfs receive' at the end calls a btrfs specific ioctl to change
+# the snapshot from RW mode to RO mode, which commits the current btrfs
+# transaction, the dealalloc data is not flushed, as the transaction commit
+# intentionally does not do it unless the fs is mounted with '-o flushoncommit'.
+# This is a detail that should probably be addressed either in the btrfs ioctls
+# called by 'btrfs receive' or in the tools - our test has a different purpose,
+# so we get around this by calling 'sync' to make sure all delalloc data is
+# durably persisted and the respective file extent items are added to the
+# snapshot's btree.
+sync
+
+# Now create send streams for the snapshots from this new filesystem. For the
+# first snapshot we do a full send while for the second snapshot we do an
+# incremental send.
+_run_btrfs_util_prog send $SCRATCH_MNT/snap1 -f $send_files_dir/1_2.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2 \
+	-f $send_files_dir/2_2.snap
+
+# Create a new filesystem and receive the send streams we just created from the
+# second filesystem. This worked until the linux kernel 4.2, where a regression
+# was introduced. The problem was that the send stream included an incorrect
+# value for the uuid field, which matched a snapshot's uuid (which is different
+# on each filesystem) instead of the snapshot's received_uuid value (which is
+# preserved across different filesystems).
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -vv -f $send_files_dir/1_2.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -vv -f $send_files_dir/2_2.snap
+
+echo "File digests in the third filesystem:"
+# Must match the digests we got in the first and second filesystems.
+md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/109.out b/tests/btrfs/109.out
new file mode 100644
index 0000000..8a86c52
--- /dev/null
+++ b/tests/btrfs/109.out
@@ -0,0 +1,14 @@
+QA output created by 109
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the first filesystem:
+c28418534a020122aca59fd3ff9581b5  SCRATCH_MNT/snap1/foo
+b93cf657bd4e3fa6f6a7f3d1142fd691  SCRATCH_MNT/snap2/foo
+File digests in the second filesystem:
+c28418534a020122aca59fd3ff9581b5  SCRATCH_MNT/snap1/foo
+b93cf657bd4e3fa6f6a7f3d1142fd691  SCRATCH_MNT/snap2/foo
+File digests in the third filesystem:
+c28418534a020122aca59fd3ff9581b5  SCRATCH_MNT/snap1/foo
+b93cf657bd4e3fa6f6a7f3d1142fd691  SCRATCH_MNT/snap2/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 45e4da6..6effd1e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -111,3 +111,4 @@
 106 auto quick send clone
 107 auto quick send clone compress
 108 auto quick send
+109 auto quick send
-- 
2.1.3

