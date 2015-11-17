Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44197 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbbKQR7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 12:59:48 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH RESEND] fstests: test for btrfs direct IO write against compressed extent
Date: Tue, 17 Nov 2015 17:59:34 +0000
Message-Id: <1447783174-26877-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that doing a direct IO write against a file range that contains one
prealloc extent and one compressed extent works correctly.

>From the linux kernel 4.0 onwards, this either triggered an assertion
failure (leading to a BUG_ON) when CONFIG_BTRFS_ASSERT=y or resulted
in an arithmetic underflow of an inode's space reservation for write
operations.

That issue is fixed by the following linux kernel patch:

  "Btrfs: fix extent accounting for partial direct IO writes"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

Resending since it was not merged in the last branch update.
Renumbered the test to reflect the latest branch update, otherwise it's
unchanged.

 tests/btrfs/026     | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/026.out |  15 ++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 124 insertions(+)
 create mode 100644 tests/btrfs/026
 create mode 100644 tests/btrfs/026.out

diff --git a/tests/btrfs/026 b/tests/btrfs/026
new file mode 100644
index 0000000..0477ed4
--- /dev/null
+++ b/tests/btrfs/026
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FSQA Test No. 026
+#
+# Test that doing a direct IO write against a file range that contains one
+# prealloc extent and one compressed extent works correctly.
+#
+#-----------------------------------------------------------------------
+#
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
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount "-o compress"
+
+# Create a compressed extent covering the range [700K, 800K[.
+$XFS_IO_PROG -f -s -c "pwrite -S 0xaa -b 100K 700K 100K" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+# Create prealloc extent covering the range [600K, 700K[.
+$XFS_IO_PROG -c "falloc 600K 100K" $SCRATCH_MNT/foo
+
+# Write 80K of data to the range [640K, 720K[ using direct IO. This range covers
+# both the prealloc extent and the compressed extent. Because there's a
+# compressed extent in the range we are writing to, the DIO write code path ends
+# up only writing the first 60k of data, which goes to the prealloc extent, and
+# then falls back to buffered IO for writing the remaining 20K of data - because
+# that remaining data maps to a file range containing a compressed extent.
+# When falling back to buffered IO, we used to trigger an assertion when
+# releasing reserved space due to bad accounting of the inode's outstanding
+# extents counter, which was set to 1 but we ended up decrementing it by 1 twice,
+# once through the ordered extent for the 60K of data we wrote using direct IO,
+# and once through the main direct IO handler (inode.cbtrfs_direct_IO()) because
+# the direct IO write wrote less than 80K of data (60K).
+$XFS_IO_PROG -d -c "pwrite -S 0xbb -b 80K 640K 80K" $SCRATCH_MNT/foo \
+	| _filter_xfs_io
+
+# Now similar test as above but for very large write operations. This triggers
+# special cases for an inode's outstanding extents accounting, as internally
+# btrfs logically splits extents into 128Mb units.
+$XFS_IO_PROG -f -s \
+	-c "pwrite -S 0xaa -b 128M 258M 128M" \
+	-c "falloc 0 258M" \
+	$SCRATCH_MNT/bar | _filter_xfs_io
+$XFS_IO_PROG -d -c "pwrite -S 0xbb -b 256M 3M 256M" $SCRATCH_MNT/bar \
+	| _filter_xfs_io
+
+# Now verify the file contents are correct and that they are the same even after
+# unmounting and mounting the fs again (or evicting the page cache).
+#
+# For file foo, all bytes in the range [0, 640K[ must have a value of 0x00, all
+# bytes in the range [640K, 720K[ must have a value of 0xbb and all bytes in the
+# range [720K, 800K[ must have a value of 0xaa.
+#
+# For file bar, all bytes in the range [0, 3M[ must havea value of 0x00, all
+# bytes in the range [3M, 259M[ must have a value of 0xbb and all bytes in the
+# range [259M, 386M[ must have a value of 0xaa.
+#
+echo "File digests before remounting the file system:"
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+md5sum $SCRATCH_MNT/bar | _filter_scratch
+_scratch_remount
+echo "File digests after remounting the file system:"
+md5sum $SCRATCH_MNT/foo | _filter_scratch
+md5sum $SCRATCH_MNT/bar | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/026.out b/tests/btrfs/026.out
new file mode 100644
index 0000000..4183275
--- /dev/null
+++ b/tests/btrfs/026.out
@@ -0,0 +1,15 @@
+QA output created by 026
+wrote 102400/102400 bytes at offset 716800
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 81920/81920 bytes at offset 655360
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 134217728/134217728 bytes at offset 270532608
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 3145728
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests before remounting the file system:
+647d815906324ccdf288c7681f900ec0  SCRATCH_MNT/foo
+5876dba1217b4c2915cda86f4c67640e  SCRATCH_MNT/bar
+File digests after remounting the file system:
+647d815906324ccdf288c7681f900ec0  SCRATCH_MNT/foo
+5876dba1217b4c2915cda86f4c67640e  SCRATCH_MNT/bar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9f99ddc..3a99289 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -28,6 +28,7 @@
 023 auto
 024 auto quick compress
 025 auto quick send clone
+026 auto quick compress prealloc
 029 auto quick clone
 030 auto quick send
 031 auto quick subvol clone
-- 
2.1.3

