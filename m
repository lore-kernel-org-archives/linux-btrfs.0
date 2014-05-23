Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37179 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaEWDFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 23:05:48 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2] xfstests: add test for btrfs ioctl clone operation
Date: Fri, 23 May 2014 05:05:31 +0100
Message-Id: <1400817931-32326-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1400817931-32326-1-git-send-email-fdmanana@gmail.com>
References: <1400817931-32326-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a test to verify that the btrfs ioctl clone operation is
able to clone extents of a file to different positions of the file,
that is, the source and target files are the same. Existing tests
only cover the case where the source and target files are different.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/052     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/052.out |  30 ++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 131 insertions(+)
 create mode 100755 tests/btrfs/052
 create mode 100644 tests/btrfs/052.out

diff --git a/tests/btrfs/052 b/tests/btrfs/052
new file mode 100755
index 0000000..292eb50
--- /dev/null
+++ b/tests/btrfs/052
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. btrfs/052
+#
+# Verify that the btrfs ioctl clone operation can operate on the same
+# file as a source and target. That is, clone extents within the same
+# file.
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
+_cleanup()
+{
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
+_require_btrfs_cloner
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# Create a file with 4 extents of 8Kb each.
+$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+sync
+$XFS_IO_PROG -c "pwrite -S 0x02 -b 8192 8192 8192" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+sync
+$XFS_IO_PROG -c "pwrite -S 0x03 -b 8192 16384 8192" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+sync
+$XFS_IO_PROG -c "pwrite -S 0x04 -b 8192 24576 8192" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+sync
+
+# Digest of initial content.
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+# Same source and target ranges - must fail.
+$CLONER_PROG -s 8192 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+# Check file content didn't change.
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+# Intersection between source and target ranges - must fail too.
+$CLONER_PROG -s 4096 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+# Check file content didn't change.
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+# Clone from a higher range to a lower range.
+$CLONER_PROG -s 24576 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+# Check entire file, the 8Kb block at offset 0 now has the same content as the
+# 8Kb block at offset 24576.
+od -t x1 $SCRATCH_MNT/foo
+
+# Clone from a lower range to a higher range.
+$CLONER_PROG -s 8192 -d 16384 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+# Check entire file, the 8Kb block at offset 0 now has the same content as the
+# 8Kb block at offset 24576, and the 8Kb block at offset 16384 now has the same
+# content as the 8Kb block at offset 8192.
+od -t x1 $SCRATCH_MNT/foo
+
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/btrfs/052.out b/tests/btrfs/052.out
new file mode 100644
index 0000000..0073813
--- /dev/null
+++ b/tests/btrfs/052.out
@@ -0,0 +1,30 @@
+QA output created by 052
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+b328fe91ed791d96b3ca6830ef50475f  SCRATCH_MNT/foo
+clone failed: Invalid argument
+b328fe91ed791d96b3ca6830ef50475f  SCRATCH_MNT/foo
+clone failed: Invalid argument
+b328fe91ed791d96b3ca6830ef50475f  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 0673449..5ff9b8e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -54,3 +54,4 @@
 049 auto quick
 050 auto
 051 auto quick
+052 auto quick
-- 
1.9.1

