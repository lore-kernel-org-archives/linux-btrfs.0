Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52012 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbbG2QYk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 12:24:40 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: test for btrfs incremental send after file extent cloning
Date: Wed, 29 Jul 2015 17:24:00 +0100
Message-Id: <1438187040-32677-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that an incremental send works after a file gets one of its extents
cloned/deduplicated into lower file offsets.

This is a regression test for the problem fixed by the linux kernel patch
titled:

  "Btrfs: teach backref walking about backrefs with underflowed
   offset values"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/097     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/097.out |   7 ++++
 tests/btrfs/group   |   1 +
 3 files changed, 121 insertions(+)
 create mode 100755 tests/btrfs/097
 create mode 100644 tests/btrfs/097.out

diff --git a/tests/btrfs/097 b/tests/btrfs/097
new file mode 100755
index 0000000..d9138ea
--- /dev/null
+++ b/tests/btrfs/097
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. btrfs/097
+#
+# Test that an incremental send works after a file gets one of its extents
+# cloned/deduplicated into lower file offsets.
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
+_scratch_mount
+
+# Create our test file with a single extent of 64K starting at file offset 128K.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 128K 64K" $SCRATCH_MNT/foo | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
+
+# Now clone parts of the original extent into lower offsets of the file.
+#
+# The first clone operation adds a file extent item to file offset 0 that points
+# to our initial extent with a data offset of 16K. The corresponding data back
+# reference in the extent tree has an offset of 18446744073709535232, which is
+# the result of file_offset - data_offset = 0 - 16K.
+#
+# The second clone operation adds a file extent item to file offset 16K that
+# points to our initial extent with a data offset of 48K. The corresponding data
+# back reference in the extent tree has an offset of 18446744073709518848, which
+# is the result of file_offset - data_offset = 16K - 48K.
+#
+# Those large back reference offsets (result of unsigned arithmetic underflow)
+# confused the back reference walking code (used by an incremental send and
+# the multiple inspect-internal ioctls) and made it miss the back references,
+# which for the case of an incremental send it made it fail with -EIO and print
+# a message like the following to dmesg:
+#
+# "BTRFS error (device sdc): did not find backref in send_root. inode=257, \
+#  offset=0, disk_byte=12845056 found extent=12845056"
+#
+$CLONER_PROG -s $(((128 + 16) * 1024)) -d 0 -l $((16 * 1024)) \
+	$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+$CLONER_PROG -s $(((128 + 48) * 1024)) -d $((16 * 1024)) -l $((16 * 1024)) \
+	$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
+	-f $send_files_dir/2.snap
+
+echo "File digest in the original filesystem:"
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
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
+echo "File digest in the new filesystem:"
+md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/097.out b/tests/btrfs/097.out
new file mode 100644
index 0000000..5e87eb2
--- /dev/null
+++ b/tests/btrfs/097.out
@@ -0,0 +1,7 @@
+QA output created by 097
+wrote 65536/65536 bytes at offset 131072
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest in the original filesystem:
+6c6079335cff141b8a31233ead04cbff  SCRATCH_MNT/mysnap2/foo
+File digest in the new filesystem:
+6c6079335cff141b8a31233ead04cbff  SCRATCH_MNT/mysnap2/foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 6ff5f3d..39700c0 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -98,3 +98,4 @@
 094 auto quick send
 095 auto quick metadata
 096 auto quick clone
+097 auto quick send clone
-- 
2.1.3

