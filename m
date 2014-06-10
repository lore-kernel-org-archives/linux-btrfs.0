Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:53615 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaFJJOt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 05:14:49 -0400
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v3] xfstests: add test for btrfs clone + fsync durability
Date: Tue, 10 Jun 2014 11:14:31 +0100
Message-Id: <1402395271-17619-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1402027700-9813-1-git-send-email-fdmanana@gmail.com>
References: <1402027700-9813-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression test for btrfs ioctl clone operation + fsync + log
recovery. The issue was that doing an fsync after cloning into
a file didn't gave any persistence guarantees as it should.
What happened was that the in memory metadata (extent maps)
weren't updated, which made the fsync code not able to detect
that file data has been changed and must be persisted to the
log.

This issue is fixed by the following linux kernel btrfs patch:

    Btrfs: make fsync work after cloning into a file

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Test small files too, consisting of a single inline extent, as
    it triggers different code paths.

V3: Pass -s to xfs_io when creating test files.

 tests/btrfs/056     | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/056.out | 129 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 275 insertions(+)
 create mode 100755 tests/btrfs/056
 create mode 100644 tests/btrfs/056.out

diff --git a/tests/btrfs/056 b/tests/btrfs/056
new file mode 100755
index 0000000..9ecfeb8
--- /dev/null
+++ b/tests/btrfs/056
@@ -0,0 +1,145 @@
+#! /bin/bash
+# FS QA Test No. btrfs/056
+#
+# Regression test for btrfs ioctl clone operation + fsync + log recovery.
+# The issue was that doing an fsync after cloning into a file didn't gave any
+# persistence guarantees as it should. What happened was that the in memory
+# metadata (extent maps) weren't updated, which made the fsync code not able
+# to detect that file data has been changed.
+#
+# This issue is fixed by the following linux kernel btrfs patch:
+#
+#    Btrfs: make fsync work after cloning into a file
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
+	_cleanup_flakey
+	rm -fr $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_btrfs_cloner
+_require_btrfs_fs_feature "no_holes"
+_require_btrfs_mkfs_feature "no-holes"
+_require_dm_flakey
+_need_to_be_root
+
+rm -f $seqres.full
+
+test_btrfs_clone_fsync_log_recover()
+{
+	_scratch_mkfs "$1" >/dev/null 2>&1
+	_init_flakey
+	SAVE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+	MOUNT_OPTIONS="$MOUNT_OPTIONS $2"
+	_mount_flakey
+
+	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
+	# The hole is in the range [16384, 24576[.
+	$XFS_IO_PROG -s -f -c "pwrite -S 0x01 -b 8192 0 8192" \
+			-c "pwrite -S 0x02 -b 8192 8192 8192" \
+			-c "pwrite -S 0x04 -b 8192 24576 8192" \
+			-c "pwrite -S 0x05 -b 8192 32768 8192" \
+		$SCRATCH_MNT/foo | _filter_xfs_io
+
+	# Clone destination file, 1 extent of 96kb.
+	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 98304 0 98304" -c "fsync" \
+		$SCRATCH_MNT/bar | _filter_xfs_io
+
+	# Clone second half of the 2nd extent, the 8kb hole, the 3rd extent
+	# and the first half of the 4th extent into file bar.
+	$CLONER_PROG -s 12288 -d 0 -l 24576 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
+
+	# Test small files too consisting of 1 inline extent
+	$XFS_IO_PROG -f -c "pwrite -S 0x00 -b 3500 0 3500" -c "fsync" \
+		$SCRATCH_MNT/foo2 | _filter_xfs_io
+
+	$XFS_IO_PROG -f -c "pwrite -S 0xcc -b 1000 0 1000" -c "fsync" \
+		$SCRATCH_MNT/bar2 | _filter_xfs_io
+
+	# Clone the entire foo2 file into bar2, overwriting all data in bar2
+	# and increasing its size.
+	$CLONER_PROG -s 0 -d 0 -l 3500 $SCRATCH_MNT/foo2 $SCRATCH_MNT/bar2
+	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar2
+
+	_load_flakey_table $FLAKEY_DROP_WRITES
+	_unmount_flakey
+
+	# Verify that there are no consistency errors.
+	_check_scratch_fs $FLAKEY_DEV
+
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+
+	# Verify the cloned range was persisted by fsync and the log recovery
+	# code did its work well.
+	echo "Verifying file bar content"
+	od -t x1 $SCRATCH_MNT/bar
+
+	echo "Verifying file bar2 content"
+	od -t x1 $SCRATCH_MNT/bar2
+
+	_unmount_flakey
+
+	# Verify that there are no consistency errors.
+	_check_scratch_fs $FLAKEY_DEV
+
+	_cleanup_flakey
+	MOUNT_OPTIONS="$SAVE_MOUNT_OPTIONS"
+}
+
+# Regardless of the NO_HOLES feature being enabled or not, the test results
+# should be exactly the same for both cases.
+
+echo "Testing without the NO_HOLES feature"
+# As of btrfs-progs 3.14.x, the no-holes feature isn't enabled by default.
+# But explicitly disable it at mkfs time as it might be enabled by default
+# in future versions.
+test_btrfs_clone_fsync_log_recover "-O ^no-holes"
+
+echo "Testing without the NO_HOLES feature and compression (lzo)"
+test_btrfs_clone_fsync_log_recover "-O ^no-holes" "-o compress-force=lzo"
+
+echo "Testing with the NO_HOLES feature enabled"
+test_btrfs_clone_fsync_log_recover "-O no-holes"
+
+echo "Testing with the NO_HOLES feature enabled and compression (lzo)"
+test_btrfs_clone_fsync_log_recover "-O no-holes" "-o compress-force=lzo"
+
+status=0
+exit
diff --git a/tests/btrfs/056.out b/tests/btrfs/056.out
new file mode 100644
index 0000000..1b77ae3
--- /dev/null
+++ b/tests/btrfs/056.out
@@ -0,0 +1,129 @@
+QA output created by 056
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
+wrote 3500/3500 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Verifying file bar content
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+Verifying file bar2 content
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0006640 00 00 00 00 00 00 00 00 00 00 00 00
+0006654
+Testing without the NO_HOLES feature and compression (lzo)
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
+wrote 3500/3500 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Verifying file bar content
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+Verifying file bar2 content
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0006640 00 00 00 00 00 00 00 00 00 00 00 00
+0006654
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
+wrote 3500/3500 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Verifying file bar content
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+Verifying file bar2 content
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0006640 00 00 00 00 00 00 00 00 00 00 00 00
+0006654
+Testing with the NO_HOLES feature enabled and compression (lzo)
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
+wrote 3500/3500 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1000/1000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Verifying file bar content
+0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+0300000
+Verifying file bar2 content
+0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+0006640 00 00 00 00 00 00 00 00 00 00 00 00
+0006654
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2c10c5b..2da7127 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -58,3 +58,4 @@
 053 auto quick
 054 auto quick
 055 auto quick
+056 auto quick
-- 
1.9.1

