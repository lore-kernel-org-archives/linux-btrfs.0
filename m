Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34139 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbbJHAY0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 20:24:26 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test btrfs send with shared and compressed extents
Date: Thu,  8 Oct 2015 01:24:14 +0100
Message-Id: <1444263854-26683-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that a send operation works correctly for files that have shared
extents which are compressed and partially overwritten after they are
cloned.

This used to fail on btrfs, resulting in different file digests after
receiving the send stream, and got fixed by the linux kernel patch
titled:

  "Btrfs: send, fix file corruption due to incorrect cloning operations"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/107     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/107.out |  15 +++++++
 tests/btrfs/group   |   1 +
 3 files changed, 128 insertions(+)
 create mode 100755 tests/btrfs/107
 create mode 100644 tests/btrfs/107.out

diff --git a/tests/btrfs/107 b/tests/btrfs/107
new file mode 100755
index 0000000..d305921
--- /dev/null
+++ b/tests/btrfs/107
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test No. btrfs/107
+#
+# Test that a send operation works correctly for files that have shared extents
+# which are compressed and partially overwritten after they are cloned.
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
+_require_cloner
+
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o compress"
+
+# Create file foo first, so that it has a lower inode number than file bar.
+# Btrfs send processes inodes in ascending order.
+touch $SCRATCH_MNT/foo
+
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 630K 20K" $SCRATCH_MNT/bar | _filter_xfs_io
+
+# Clone the whole extent into file foo.
+$CLONER_PROG -s $((540 * 1024)) -d $((200 * 1024)) -l 0 \
+	$SCRATCH_MNT/bar $SCRATCH_MNT/foo
+
+# After this write our file foo will reference the extent with a file extent
+# item that starts at offset 300K, has a length of 8K and a data offset of 12K.
+# So after this write file foo no longer refers to the first 12K of the extent
+# we cloned before from file bar.
+$XFS_IO_PROG -c "pwrite -S 0xcc 200K 100K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Append some data to file foo. This is just to verify later that the send
+# stream does not include clone operations for any of these data for file bar.
+$XFS_IO_PROG -c "pwrite -S 0xbb 400K 100K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+# Append some data to file bar. This is to verify later that the send stream
+# included these data for file bar.
+$XFS_IO_PROG -c "pwrite -S 0xdd 650K 100K" $SCRATCH_MNT/bar | _filter_xfs_io
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
+# Btrfs send had a bug where it sent a clone operation from file foo to bar
+# that covered the range from file foo [300K, 308K[ into file bar's range
+# [630K, 638K[ with the intention of cloning the whole extent that was cloned
+# before. That was incorrect because file foo no longer pointed to the first
+# 12K of the 20K extent that was originally cloned from file bar.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o compress"
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+
+echo "File digests in the new filesystem:"
+# Must match the digests we got in the original filesystem.
+md5sum $SCRATCH_MNT/snap/foo | _filter_scratch
+md5sum $SCRATCH_MNT/snap/bar | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/107.out b/tests/btrfs/107.out
new file mode 100644
index 0000000..d5976aa
--- /dev/null
+++ b/tests/btrfs/107.out
@@ -0,0 +1,15 @@
+QA output created by 107
+wrote 20480/20480 bytes at offset 645120
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 102400/102400 bytes at offset 204800
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 102400/102400 bytes at offset 409600
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 102400/102400 bytes at offset 665600
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the original filesystem:
+58099eacfd30a8ce2fa68706892fcd4e  SCRATCH_MNT/snap/foo
+d1ad0d166f78e04191a5bdb51e1f80b6  SCRATCH_MNT/snap/bar
+File digests in the new filesystem:
+58099eacfd30a8ce2fa68706892fcd4e  SCRATCH_MNT/snap/foo
+d1ad0d166f78e04191a5bdb51e1f80b6  SCRATCH_MNT/snap/bar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index ae16213..2416870 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -109,3 +109,4 @@
 104 auto quick send
 105 auto quick clone compress
 106 auto quick send clone
+107 auto quick send clone
-- 
2.1.3

