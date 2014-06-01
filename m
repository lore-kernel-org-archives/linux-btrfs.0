Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35244 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbaFAMGg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jun 2014 08:06:36 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v4] xfstests: add test for btrfs cloning with file holes
Date: Sun,  1 Jun 2014 14:06:06 +0100
Message-Id: <1401627966-21233-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401499053-11162-1-git-send-email-fdmanana@gmail.com>
References: <1401499053-11162-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for the btrfs ioctl clone operation when the source range
contains hole(s) and the FS has the NO_HOLES feature enabled (file holes
don't need file extent items in the btree to represent them).

This issue is fixed by the following linux kernel btrfs patch:

    Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Increased test coverage by testing the cases where a hole overlaps
    the start and end of the cloning range.

V3: Test the case where the cloning range includes an hole at the end
    of the source file and might increase the size of the target file.

V4: Added test for the case where the clone range covers only a hole at
    the beginning of the source file.
    Made the test be skipped if the available version of mkfs.btrfs
    doesn't support the no-holes feature. And when testing the case
    where the no-holes feature isn't enabled, explicitly ask mkfs.btrfs
    to disable no-holes (future versions of mkfs.btrfs might enable
    this feature by default).

 common/rc           |  13 ++
 tests/btrfs/055     | 165 ++++++++++++++++++++++++++
 tests/btrfs/055.out | 333 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 512 insertions(+)
 create mode 100755 tests/btrfs/055
 create mode 100644 tests/btrfs/055.out

diff --git a/common/rc b/common/rc
index f27ee53..0ef0ece 100644
--- a/common/rc
+++ b/common/rc
@@ -2177,6 +2177,19 @@ _require_btrfs_send_stream_version()
 	fi
 }
 
+_require_btrfs_fs_feature()
+{
+	if [ -z $1 ]; then
+		echo "Missing feature name argument for _require_btrfs_fs_feature"
+		exit 1
+	fi
+	feat=$1
+	$MKFS_BTRFS_PROG -O list-all 2>&1 | \
+		grep '^[ \t]*'"$feat"'\b' > /dev/null 2>&1
+	[ $? -eq 0 ] || \
+		_notrun "Feature $feat not supported in the available version of mkfs.btrfs"
+}
+
 init_rc()
 {
 	if [ "$iam" == new ]
diff --git a/tests/btrfs/055 b/tests/btrfs/055
new file mode 100755
index 0000000..0e67c88
--- /dev/null
+++ b/tests/btrfs/055
@@ -0,0 +1,165 @@
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
+_require_btrfs_fs_feature "no-holes"
+_need_to_be_root
+
+rm -f $seqres.full
+
+test_btrfs_clone_with_holes()
+{
+	_scratch_mkfs "$1" >/dev/null 2>&1
+	_scratch_mount
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
+	# Clone destination file, 1 extent of 96kb.
+	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 98304 0 98304" $SCRATCH_MNT/bar \
+		| _filter_xfs_io
+	sync
+
+	# Clone 2nd extent, 8Kb hole and 3rd extent of foo into bar.
+	$CLONER_PROG -s 8192 -d 0 -l 24576 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+	# Verify both extents and the hole were cloned.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Cloning range starts at the middle of a hole.
+	$CLONER_PROG -s 20480 -d 32768 -l 12288 $SCRATCH_MNT/foo \
+		$SCRATCH_MNT/bar
+
+	# Verify that half of the hole and the following 8Kb extent were cloned.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Cloning range ends at the middle of a hole.
+	$CLONER_PROG -s 0 -d 65536 -l 20480 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+
+	# Verify that 2 extents of 8kb and a 4kb hole were cloned.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Create a 24Kb hole at the end of the source file (foo).
+	$XFS_IO_PROG -c "truncate 65536" $SCRATCH_MNT/foo
+	sync
+
+	# Now clone a range that overlaps that hole at the end of the foo file.
+	# It should clone the last 4Kb of the extent at offset 32768 and the
+	# first 8kb of the 24kb hole at the end of foo.
+	$CLONER_PROG -s 36864 -d 86016 -l 12288 $SCRATCH_MNT/foo \
+		$SCRATCH_MNT/bar
+
+	# Verify that the second half of the 8Kb extent at offset 32768 of foo
+	# and the first 8Kb of the 24kb hole of foo were cloned into bar.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Clone the same range as before, but clone it into a different offset
+	# of the target (bar) such that it increases the size of the target
+	# by 8Kb.
+	$CLONER_PROG -s 36864 -d 94208 -l 12288 $SCRATCH_MNT/foo \
+		$SCRATCH_MNT/bar
+
+	# Verify that the second half of the 8Kb extent at offset 32768 of foo
+	# and the first 8Kb of the 24kb hole of foo were cloned into bar at
+	# bar's offset 94208 and that bar's size increased by 8Kb.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Create a new completely sparse file (no extents, it's a big hole).
+	$XFS_IO_PROG -f -c "truncate 100000" $SCRATCH_MNT/qwerty
+	sync
+
+	# Test cloning a range from the sparse file to the bar file without
+	# increasing bar's size.
+	$CLONER_PROG -s 4096 -d 0 -l 8192 $SCRATCH_MNT/qwerty $SCRATCH_MNT/bar
+
+	# First 8Kb of bar should now be zeroes.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Test cloning a range from the sparse file to the end of the bar file.
+	# The bar file currently has a size of 106496 bytes.
+	$CLONER_PROG -s 0 -d 106496 -l 32768 $SCRATCH_MNT/qwerty \
+		$SCRATCH_MNT/bar
+
+	# Verify bar's size increased to 106496 + 32768 bytes (136Kb), and its
+	# last 32768 bytes are all zeroes.
+	od -t x1 $SCRATCH_MNT/bar
+
+	# Verify that there are no consistency errors.
+	_check_scratch_fs
+}
+
+# Regardless of the NO_HOLES feature being enabled or not, the test results
+# should be exactly the same for both cases.
+
+echo "Testing without the NO_HOLES feature"
+# As of btrfs-progs 3.14.x, the no-holes feature isn't enabled by default.
+# But explicitly disable it at mkfs time as it might be enabled by default
+# in future versions.
+test_btrfs_clone_with_holes "-O ^no-holes"
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
index 0000000..714ede8
--- /dev/null
+++ b/tests/btrfs/055.out
@@ -0,0 +1,333 @@
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
+wrote 98304/98304 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0320000
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0320000
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0420000
+Testing with the NO_HOLES feature enabled
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 98304/98304 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0300000
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0320000
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0320000
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0420000
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

