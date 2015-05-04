Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42922 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750707AbbEDOeh (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 4 May 2015 10:34:37 -0400
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, marc@merlins.org,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test for btrfs send with compressed file extents
Date: Mon,  4 May 2015 15:34:19 +0100
Message-Id: <1430750059-4833-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test that an incremental send issues valid clone operations for
compressed file extents.

For some compressed extents, namely those referred by a file extent item
with a non-zero data offset, btrfs could issue a clone operation in the
send stream with an offset and length pair that were not entirely
contained in the source file's range, causing the receiving side to get
-EINVAL errors from the clone ioctl when attempting to perform the clone
operations.

This issue was fixed by the following linux kernel btrfs patch:

  Btrfs: incremental send, fix clone operations for compressed extents

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/094     | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/094.out |  15 ++++++
 tests/btrfs/group   |   1 +
 3 files changed, 144 insertions(+)
 create mode 100755 tests/btrfs/094
 create mode 100644 tests/btrfs/094.out

diff --git a/tests/btrfs/094 b/tests/btrfs/094
new file mode 100755
index 0000000..6f6cdeb
--- /dev/null
+++ b/tests/btrfs/094
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FS QA Test No. btrfs/094
+#
+# Test that an incremental send issues valid clone operations for compressed
+# file extents.
+#
+# For some compressed extents, namely those referred by a file extent item with
+# a non-zero data offset, btrfs could issue a clone operation in the send stream
+# with an offset and length pair that were not entirely contained in the source
+# file's range, causing the receiving side to get -EINVAL errors from the clone
+# ioctl when attempting to perform the clone operations.
+#
+# This issue was fixed by the following linux kernel btrfs patch:
+#
+#   Btrfs: incremental send, fix clone operations for compressed extents
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
+_require_cloner
+_need_to_be_root
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
+# Create the file with a single extent of 128K. This creates a metadata file
+# extent item with a data start offset of 0 and a logical length of 128K.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 64K 128K" -c "fsync" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now rewrite the range 64K to 112K of our file. This will make the inode's
+# metadata continue to point to the 128K extent we created before, but now
+# with an extent item that points to the extent with a data start offset of
+# 112K and a logical length of 16K.
+# That metadata file extent item is associated with the logical file offset
+# at 176K and covers the logical file range 176K to 192K.
+$XFS_IO_PROG -c "pwrite -S 0xbb 64K 112K" -c "fsync" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+# Now rewrite the range 180K to 12K. This will make the inode's metadata
+# continue to point the the 128K extent we created earlier, with a single
+# extent item that points to it with a start offset of 112K and a logical
+# length of 4K.
+# That metadata file extent item is associated with the logical file offset
+# at 176K and covers the logical file range 176K to 180K.
+$XFS_IO_PROG -c "pwrite -S 0xcc 180K 12K" -c "fsync" \
+	$SCRATCH_MNT/foo | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+# Now clone that same region of the 128K extent into a new file, so that it
+# gets referenced twice and the incremental send operation below decides to
+# issue a clone operation instead of copying the data.
+touch $SCRATCH_MNT/bar
+$CLONER_PROG -s $((176 * 1024)) -d $((176 * 1024)) -l $((4 * 1024)) \
+	$SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+echo "File digests in the original filesystem:"
+md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/bar | _filter_scratch
+
+# Now recreate the filesystem by receiving both send streams and verify we get
+# the same file contents that the original filesystem had.
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+
+echo "File digests in the new filesystem:"
+md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+md5sum $SCRATCH_MNT/mysnap2/bar | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/094.out b/tests/btrfs/094.out
new file mode 100644
index 0000000..c3ac1bf
--- /dev/null
+++ b/tests/btrfs/094.out
@@ -0,0 +1,15 @@
+QA output created by 094
+wrote 131072/131072 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 114688/114688 bytes at offset 65536
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 12288/12288 bytes at offset 184320
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the original filesystem:
+f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap1/foo
+f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap2/foo
+7fccf6175f5c68504b408719a21db99f  SCRATCH_MNT/mysnap2/bar
+File digests in the new filesystem:
+f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap1/foo
+f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap2/foo
+7fccf6175f5c68504b408719a21db99f  SCRATCH_MNT/mysnap2/bar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a2112ab..ffe18bf 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -95,3 +95,4 @@
 091 auto quick qgroup
 092 auto quick send
 093 auto quick clone
+094 auto quick send
-- 
2.1.3

