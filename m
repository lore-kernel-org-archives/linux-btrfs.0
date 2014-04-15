Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49857 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaDOPn1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 11:43:27 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so5922487wiv.6
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 08:43:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: btrfs, test send's ability to punch holes and prealloc extents
Date: Tue, 15 Apr 2014 17:43:21 +0100
Message-Id: <1397580201-27475-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test verifies that after an incremental btrfs send the replicated file has
the same exact hole and data structure as in the origin filesystem. This didn't
use to be the case before the send stream version 2 - holes were sent as write
operations of 0 valued bytes instead of punching holes with the fallocate system
call, and pre-allocated extents were sent as well as write operations of 0 valued
bytes instead of intructions for the receiver to use the fallocate system call.
Also checks that prealloc extents that lie beyond the file's size are replicated
by an incremental send.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/047     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/047.out |  57 +++++++++++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 177 insertions(+)
 create mode 100755 tests/btrfs/047
 create mode 100644 tests/btrfs/047.out

diff --git a/tests/btrfs/047 b/tests/btrfs/047
new file mode 100755
index 0000000..bf71595
--- /dev/null
+++ b/tests/btrfs/047
@@ -0,0 +1,119 @@
+#! /bin/bash
+# FS QA Test No. btrfs/047
+#
+# Verify that after an incremental btrfs send the replicated file has
+# the same exact hole and data structure as in the origin filesystem.
+# This didn't use to be the case before the send stream version 2 -
+# holes were sent as write operations of 0 valued bytes instead of punching
+# holes with the fallocate system call, and pre-allocated extents were sent
+# as well as write operations of 0 valued bytes instead of intructions for
+# the receiver to use the fallocate system call. Also check that prealloc
+# extents that lie beyond the file's size are replicated by an incremental
+# send.
+#
+# More specifically, this structure preserving guarantee was added by the
+# following linux kernel commits:
+#
+#    Btrfs: send, use fallocate command to punch holes
+#    Btrfs: send, use fallocate command to allocate extents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
+send_files_dir=$TEST_DIR/btrfs-test-$seq
+
+_cleanup()
+{
+    rm -fr $send_files_dir
+    rm -fr $tmp
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
+_require_fssum
+_require_xfs_io_fiemap
+_need_to_be_root
+
+rm -f $seqres.full
+rm -fr $send_files_dir
+mkdir $send_files_dir
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 300000 0 300000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+$XFS_IO_PROG -c "fpunch 100000 50000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "falloc 100000 50000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "pwrite -S 0xff -b 1000 120000 1000" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+$XFS_IO_PROG -c "fpunch 250000 20000" $SCRATCH_MNT/foo
+
+$XFS_IO_PROG -c "falloc -k 300000 1000000" $SCRATCH_MNT/foo
+$XFS_IO_PROG -c "falloc -k 9000000 2000000" $SCRATCH_MNT/foo
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+# List all hole and data segments.
+$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
+# List all extents, we're interested here in prealloc extents that lie beyond
+# the file's size.
+$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+_scratch_unmount
+_check_scratch_fs
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
+
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+# List all hole and data segments.
+$XFS_IO_PROG -r -c "seek -r -a 0" $SCRATCH_MNT/mysnap2/foo
+# List all extents, we're interested here in prealloc extents that lie beyond
+# the file's size.
+$XFS_IO_PROG -r -c "fiemap -l" $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/047.out b/tests/btrfs/047.out
new file mode 100644
index 0000000..44e4546
--- /dev/null
+++ b/tests/btrfs/047.out
@@ -0,0 +1,57 @@
+QA output created by 047
+wrote 300000/300000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 120000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5a88aa0da62c8999c16515050947a70a  SCRATCH_MNT/mysnap2/foo
+Whence	Result
+DATA	0
+HOLE	102400
+DATA	118784
+HOLE	122880
+DATA	147456
+HOLE	253952
+DATA	266240
+HOLE	300000
+SCRATCH_MNT/mysnap2/foo:
+	0: [0..191]: 25088..25279 192 blocks
+	1: [192..199]: 24576..24583 8 blocks
+	2: [200..231]: 24592..24623 32 blocks
+	3: [232..239]: 24688..24695 8 blocks
+	4: [240..287]: 24632..24679 48 blocks
+	5: [288..295]: 24584..24591 8 blocks
+	6: [296..487]: 25384..25575 192 blocks
+	7: [488..495]: 24696..24703 8 blocks
+	8: [496..519]: hole 24 blocks
+	9: [520..527]: 24704..24711 8 blocks
+	10: [528..583]: 25616..25671 56 blocks
+	11: [584..591]: 24712..24719 8 blocks
+	12: [592..2543]: 26192..28143 1952 blocks
+	13: [2544..17575]: hole 15032 blocks
+	14: [17576..21487]: 28144..32055 3912 blocks
+5a88aa0da62c8999c16515050947a70a  SCRATCH_MNT/mysnap2/foo
+Whence	Result
+DATA	0
+HOLE	102400
+DATA	118784
+HOLE	122880
+DATA	147456
+HOLE	253952
+DATA	266240
+HOLE	300000
+SCRATCH_MNT/mysnap2/foo:
+	0: [0..191]: 25096..25287 192 blocks
+	1: [192..199]: 24672..24679 8 blocks
+	2: [200..231]: 24584..24615 32 blocks
+	3: [232..239]: 24680..24687 8 blocks
+	4: [240..287]: 24616..24663 48 blocks
+	5: [288..295]: 24688..24695 8 blocks
+	6: [296..487]: 25392..25583 192 blocks
+	7: [488..495]: 24696..24703 8 blocks
+	8: [496..519]: hole 24 blocks
+	9: [520..527]: 24704..24711 8 blocks
+	10: [528..583]: 25624..25679 56 blocks
+	11: [584..591]: 24712..24719 8 blocks
+	12: [592..2543]: 26192..28143 1952 blocks
+	13: [2544..17575]: hole 15032 blocks
+	14: [17576..21487]: 28144..32055 3912 blocks
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3a6d34e..d4e3fc1 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -49,3 +49,4 @@
 044 auto quick
 045 auto quick
 046 auto quick
+047 auto quick
-- 
1.9.1

