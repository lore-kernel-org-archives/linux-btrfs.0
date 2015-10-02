Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37666 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbbJBKSh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 06:18:37 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test btrfs send for reflinked files
Date: Fri,  2 Oct 2015 11:18:29 +0100
Message-Id: <1443781109-18914-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that a send operation works correctly with reflinked files (cloned
extents which multiple files point to).

The btrfs issue was fixed by the linux kernel patch titled:
"Btrfs: send, fix file corruption due to incorrect cloning operations"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/106     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/106.out |  13 +++++++
 tests/btrfs/group   |   1 +
 3 files changed, 116 insertions(+)
 create mode 100755 tests/btrfs/106
 create mode 100644 tests/btrfs/106.out

diff --git a/tests/btrfs/106 b/tests/btrfs/106
new file mode 100755
index 0000000..d3a47f0
--- /dev/null
+++ b/tests/btrfs/106
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. btrfs/106
+#
+# Test that a send operation works correctly with reflinked files (cloned
+# extents which multiple files point to).
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
+_require_cp_reflink
+_require_xfs_io_command "fpunch"
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
+# Create our test file with a single 100K extent.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 100K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Clone our file into a new file named bar.
+cp --reflink=always $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+# Now overwrite parts of our foo file.
+$XFS_IO_PROG -c "pwrite -S 0xbb 50K 10K" \
+	-c "pwrite -S 0xcc 90K 10K" \
+	-c "fpunch 70K 10k" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap
+
+echo "File digests in the original filesystem:"
+md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap/bar | _filter_scratch
+
+_run_btrfs_util_prog send $SCRATCH_MNT/snap -f $send_files_dir/1.snap
+
+# Now recreate the filesystem by receiving the send stream and verify we get
+# the same file contents that the original filesystem had.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+
+# We expect the destination filesystem to have exactly the same file data as
+# the original filesystem.
+# The btrfs send implementation had a bug where it sent a clone operation from
+# file foo into file bar covering the whole [0, 100K[ range after creating
+# and writing the file foo. This was incorrect because the file bar now included
+# the updates done to file foo after we cloned foo to bar, breaking the COW
+# nature of reflink copies (cloned extents).
+echo "File digests in the new filesystem:"
+md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap/bar | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/106.out b/tests/btrfs/106.out
new file mode 100644
index 0000000..594b937
--- /dev/null
+++ b/tests/btrfs/106.out
@@ -0,0 +1,13 @@
+QA output created by 106
+wrote 102400/102400 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10240/10240 bytes at offset 51200
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 10240/10240 bytes at offset 92160
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the original filesystem:
+fbf36a062ffcbd644b5739c4d683ccc7  SCRATCH_MNT/snap/foo
+5d2c92827a70aad932cfe7363105c55e  SCRATCH_MNT/snap/bar
+File digests in the new filesystem:
+fbf36a062ffcbd644b5739c4d683ccc7  SCRATCH_MNT/snap/foo
+5d2c92827a70aad932cfe7363105c55e  SCRATCH_MNT/snap/bar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index b9936f9..ae16213 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -108,3 +108,4 @@
 103 auto quick clone compress
 104 auto quick send
 105 auto quick clone compress
+106 auto quick send clone
-- 
2.1.3

