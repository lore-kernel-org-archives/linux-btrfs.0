Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47934 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934625AbaEaARv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 20:17:51 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] xfstests: add test for btrfs cloning with file holes
Date: Sat, 31 May 2014 02:17:33 +0100
Message-Id: <1401499053-11162-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for the btrfs ioctl clone operation when the source range
contains hole(s) and the FS has the NO_HOLES feature enabled (file holes
don't need file extent items in the btree to represent them).

This issue is fixed by the following linux kernel btrfs patch:

    Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 tests/btrfs/055     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/055.out |  43 ++++++++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 144 insertions(+)
 create mode 100755 tests/btrfs/055
 create mode 100644 tests/btrfs/055.out

diff --git a/tests/btrfs/055 b/tests/btrfs/055
new file mode 100755
index 0000000..7241b66
--- /dev/null
+++ b/tests/btrfs/055
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. btrfs/055
+#
+# Regression test for the btrfs ioctl clone operation when the source range
+# contains hole(s) and the FS has the NO_HOLES feature enabled (file holes
+# don't need file extent items in the btree to represent them).
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#    Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled
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
+test_btrfs_clone_with_holes()
+{
+	_scratch_mkfs "$1" >/dev/null 2>&1
+	_scratch_mount $MOUNT_OPTIONS
+
+	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
+	$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	$XFS_IO_PROG -c "pwrite -S 0x02 -b 8192 8192 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	# After the following write we get a hole in the range [16384, 24576[
+	$XFS_IO_PROG -c "pwrite -S 0x04 -b 8192 24576 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	$XFS_IO_PROG -c "pwrite -S 0x05 -b 8192 32768 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+
+	# Clone destination file, 1 extent of 64kb.
+	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 64536 0 64536" $SCRATCH_MNT/bar \
+		| _filter_xfs_io
+	sync
+
+	# Clone 2nd extent, 8Kb hole and 3rd extent of foo into bar.
+	$CLONER_PROG -s 8192 -d 0 -l 24576 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+	# Verify both extents and the hole were cloned.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Verify that there are no consistency errors.
+	_check_scratch_fs
+}
+
+echo "Testing without the NO_HOLES feature"
+test_btrfs_clone_with_holes
+
+_scratch_unmount
+
+echo "Testing with the NO_HOLES feature enabled"
+test_btrfs_clone_with_holes "-O no-holes"
+
+status=0
+exit
diff --git a/tests/btrfs/055.out b/tests/btrfs/055.out
new file mode 100644
index 0000000..faa0477
--- /dev/null
+++ b/tests/btrfs/055.out
@@ -0,0 +1,43 @@
+QA output created by 055
+Testing without the NO_HOLES feature
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 64536/64536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0176020 ff ff ff ff ff ff ff ff
+0176030
+Testing with the NO_HOLES feature enabled
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 64536/64536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0176020 ff ff ff ff ff ff ff ff
+0176030
diff --git a/tests/btrfs/group b/tests/btrfs/group
index b668485..2c10c5b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -57,3 +57,4 @@
 052 auto quick
 053 auto quick
 054 auto quick
+055 auto quick
-- 
1.9.1

