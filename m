Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38691 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbJIUWT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 16:22:19 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <jbacik@fb.com>, Robin Ruede <rruede+git@gmail.com>
Subject: [PATCH 1/2] fstests: test btrfs send/receive across different filesystems
Date: Fri,  9 Oct 2015 21:18:16 +0100
Message-Id: <1444421896-2666-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that sending and receiving snapshots across different filesystems
works for full and incremental send operations.

This used to fail before the linux kernel release 4.2. The linux kernel
commit that fixed this issue was the following:

  37b8d27de5d0 ("Btrfs: use received_uuid of parent during send")

Cc: Josef Bacik <jbacik@fb.com>
Cc: Robin Ruede <rruede+git@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/108     | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/108.out |  14 ++++++
 tests/btrfs/group   |   1 +
 3 files changed, 135 insertions(+)
 create mode 100755 tests/btrfs/108
 create mode 100644 tests/btrfs/108.out

diff --git a/tests/btrfs/108 b/tests/btrfs/108
new file mode 100755
index 0000000..1ea28ea
--- /dev/null
+++ b/tests/btrfs/108
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. btrfs/108
+#
+# Test that sending and receiving snapshots across different filesystems works
+# for full and incremental send operations.
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
+echo "File digest in the first filesystem, first snapshot:"
+md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
+
+# Save send stream for this snapshot.
+_run_btrfs_util_prog send $SCRATCH_MNT/snap1 -f $send_files_dir/1.snap
+
+# Create a new filesystem and receive the snapshot.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+
+echo "File digest in the second filesystem, first snapshot:"
+# Must match the digest we got in the first filesystem.
+md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
+
+# Snapshot the first snapshot as rw, modify this new snapshot and then snapshot
+# it as RO to use in a send operation (send requires RO snapshots).
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2_rw
+
+$XFS_IO_PROG -c "pwrite -S 0xbb 4K 4K" \
+	$SCRATCH_MNT/snap2_rw/foo | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT/snap2_rw \
+	$SCRATCH_MNT/snap2
+
+echo "File digest in the second filesystem, second snapshot:"
+md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
+
+_run_btrfs_util_prog send -p $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2 \
+	-f $send_files_dir/2.snap
+
+# Create a new filesystem and receive both the first snapshot, through the first
+# send stream we created, and the second snapshot through the incremental send
+# stream we just created. Verify this works and the file data is correct in both
+# snapshots.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+# Receiving the second snapshot used to fail because the send stream used an
+# incorrect value for the clone sources uuid field - it used the uuid of
+# snapshot 1, which is different on each filesystem, instead of the received
+# uuid value, which is preserved across different filesystems.
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+
+echo "File digests in the third filesystem:"
+# Must match the digests we got in the previous filesystems.
+md5sum $SCRATCH_MNT/snap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/foo | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/108.out b/tests/btrfs/108.out
new file mode 100644
index 0000000..3319c88
--- /dev/null
+++ b/tests/btrfs/108.out
@@ -0,0 +1,14 @@
+QA output created by 108
+wrote 32768/32768 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest in the first filesystem, first snapshot:
+c28418534a020122aca59fd3ff9581b5  SCRATCH_MNT/snap1/foo
+File digest in the second filesystem, first snapshot:
+c28418534a020122aca59fd3ff9581b5  SCRATCH_MNT/snap1/foo
+wrote 4096/4096 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest in the second filesystem, second snapshot:
+b93cf657bd4e3fa6f6a7f3d1142fd691  SCRATCH_MNT/snap2/foo
+File digests in the third filesystem:
+c28418534a020122aca59fd3ff9581b5  SCRATCH_MNT/snap1/foo
+b93cf657bd4e3fa6f6a7f3d1142fd691  SCRATCH_MNT/snap2/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 886bdd8..45e4da6 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -110,3 +110,4 @@
 105 auto quick clone compress
 106 auto quick send clone
 107 auto quick send clone compress
+108 auto quick send
-- 
2.1.3

