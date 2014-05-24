Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:59996 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXPw1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 11:52:27 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ddiss@suse.de,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2 v3] xfstests: add test for btrfs ioctl clone operation
Date: Sat, 24 May 2014 17:50:55 +0100
Message-Id: <1400950255-24346-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1400817931-32326-2-git-send-email-fdmanana@gmail.com>
References: <1400817931-32326-2-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a test to verify that the btrfs ioctl clone operation is
able to clone extents of a file to different positions of the file,
that is, the source and target files are the same. Existing tests
only cover the case where the source and target files are different.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Made the test exercise a more complex code path in the btrfs ioctl clone
    code. Now we have extents with different sizes and make the cloner process
    partial extents and split existing extents with smaller ones.

V3: Add tests to verify that after writing to a cloned extent, the original
    extent isn't modified, that defragmenting a file with cloned extents
    doesn't change the file contents and that all the tests have the same
    exact semantics (as observed by an application/user) regardless of the
    following options (and any combination): cow/nodatacow/compression.

 tests/btrfs/052     | 171 ++++++++++++++++++
 tests/btrfs/052.out | 499 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 671 insertions(+)
 create mode 100755 tests/btrfs/052
 create mode 100644 tests/btrfs/052.out

diff --git a/tests/btrfs/052 b/tests/btrfs/052
new file mode 100755
index 0000000..671034e
--- /dev/null
+++ b/tests/btrfs/052
@@ -0,0 +1,171 @@
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
+test_btrfs_clone_same_file()
+{
+	if [ -z $1 ]; then
+		MOUNT_OPTIONS=""
+	else
+		MOUNT_OPTIONS="-O $1"
+	fi
+	_scratch_mkfs >/dev/null 2>&1
+	_scratch_mount $MOUNT_OPTIONS
+
+	# Create a file with 5 extents, 4 of 8Kb each and 1 of 64Kb.
+	$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	$XFS_IO_PROG -c "pwrite -S 0x02 -b 8192 8192 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	$XFS_IO_PROG -c "pwrite -S 0x03 -b 8192 16384 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	$XFS_IO_PROG -c "pwrite -S 0x04 -b 8192 24576 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+	$XFS_IO_PROG -c "pwrite -S 0x05 -b 65536 32768 65536" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	sync
+
+	# Digest of initial content.
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+	# Same source and target ranges - must fail.
+	$CLONER_PROG -s 8192 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	# Check file content didn't change.
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+	# Intersection between source and target ranges - must fail too.
+	$CLONER_PROG -s 4096 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	# Check file content didn't change.
+	md5sum $SCRATCH_MNT/foo | _filter_scratch
+
+	# Clone an entire extent from a higher range to a lower range.
+	$CLONER_PROG -s 24576 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+	# Check entire file, the 8Kb block at offset 0 now has the same content
+	# as the 8Kb block at offset 24576.
+	od -t x1 $SCRATCH_MNT/foo
+
+	# Clone an entire extent from a lower range to a higher range.
+	$CLONER_PROG -s 8192 -d 16384 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+	# Check entire file, the 8Kb block at offset 0 now has the same content
+	# as the 8Kb block at offset 24576, and the 8Kb block at offset 16384
+	# now has the same content as the 8Kb block at offset 8192.
+	od -t x1 $SCRATCH_MNT/foo
+
+	# Now clone 1 extent and an half into the file range starting at offset
+	# 65536. So we get the second half of the extent at offset 16384 and the
+	# whole extent at 24576 cloned into the middle of the 64Kb extent that
+	# starts at file offset 32768. This makes the clone ioctl process more
+	# extent items from the b+tree and forces a split of the large 64Kb
+	# extent at the end of the file.
+	$CLONER_PROG -s 20480 -d 65536 -l 12288 $SCRATCH_MNT/foo \
+		$SCRATCH_MNT/foo
+
+	# Check entire file. Besides the previous changes, we now should have
+	# 4096 bytes with the value 0x02 at file offset 65536, and 8192 bytes
+	# with value 0x04 at the file offset 69632. The ranges [32768, 65536[
+	# and [77824, 98304[ should remain with all bytes having the value 0x05.
+	od -t x1 $SCRATCH_MNT/foo
+
+	# Now update 8Kb of data at offset 0. The extent at this position is a
+	# clone of the extent at offset 24576. Check that writing to this offset
+	# doesn't change data at offset 24576.
+	$XFS_IO_PROG -c "pwrite -S 0xff -b 8192 0 8192" $SCRATCH_MNT/foo \
+		| _filter_xfs_io
+	od -t x1 $SCRATCH_MNT/foo
+
+	# Check that after defragmenting the file and re-mounting, the file
+	# content remains exactly the same as before.
+	_run_btrfs_util_prog filesystem defragment $SCRATCH_MNT/foo
+	_scratch_remount
+	od -t x1 $SCRATCH_MNT/foo
+
+	# Verify that there are no consistency errors.
+	_check_scratch_fs
+}
+
+# For any of the tests below, regardless of cow/nodatacow/compression, the
+# results as observed by an application/user should be exactly the same.
+
+echo "Testing with a cow file (default)"
+test_btrfs_clone_same_file
+
+_scratch_unmount
+
+echo "Testing with a nocow file (-O nodatacow)"
+test_btrfs_clone_same_file "nodatacow"
+
+_scratch_unmount
+
+echo "Testing with a cow file and lzo compression"
+test_btrfs_clone_same_file "compress-force=lzo"
+
+_scratch_unmount
+
+echo "Testing with a cow file and zlib compression"
+test_btrfs_clone_same_file "compress-force=zlib"
+
+_scratch_unmount
+
+echo "Testing with a nocow file and lzo compression"
+test_btrfs_clone_same_file "nodatacow,compress-force=lzo"
+
+_scratch_unmount
+
+echo "Testing with a nocow file and zlib compression"
+test_btrfs_clone_same_file "nodatacow,compress-force=zlib"
+
+status=0
+exit
diff --git a/tests/btrfs/052.out b/tests/btrfs/052.out
new file mode 100644
index 0000000..53a1868
--- /dev/null
+++ b/tests/btrfs/052.out
@@ -0,0 +1,499 @@
+QA output created by 052
+Testing with a cow file (default)
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+Testing with a nocow file (-O nodatacow)
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+Testing with a cow file and lzo compression
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+Testing with a cow file and zlib compression
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+Testing with a nocow file and lzo compression
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+Testing with a nocow file and zlib compression
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 8192
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 16384
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 8192/8192 bytes at offset 24576
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+clone failed: Invalid argument
+5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+wrote 8192/8192 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
+0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0300000
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

