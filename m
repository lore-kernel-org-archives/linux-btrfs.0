Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53431 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbKBMdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 07:33:23 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: generic test for fsync after hole punching
Date: Mon,  2 Nov 2015 12:32:57 +0000
Message-Id: <1446467577-32220-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that a file fsync works after punching a hole for the same file
range multiple times, and that after log/journal replay the file's
content and layout are correct.

This test is motivated by a bug found in btrfs, which is fixed by
the following linux kernel patch:

  "Btrfs: fix hole punching when using the no-holes feature"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/generic/110     | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/110.out |  13 ++++++
 tests/generic/group   |   1 +
 3 files changed, 137 insertions(+)
 create mode 100755 tests/generic/110
 create mode 100644 tests/generic/110.out

diff --git a/tests/generic/110 b/tests/generic/110
new file mode 100755
index 0000000..1e3daac
--- /dev/null
+++ b/tests/generic/110
@@ -0,0 +1,123 @@
+#! /bin/bash
+# FSQA Test No. 110
+#
+# Test that a file fsync works after punching a hole for the same file range
+# multiple times and that after log/journal replay the file's content is
+# correct.
+#
+# This test is motivated by a bug found in btrfs.
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
+	_cleanup_flakey
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/punch
+. ./common/dmflakey
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fiemap"
+_require_dm_target flakey
+_require_metadata_journaling $SCRATCH_DEV
+
+# This test was motivated by an issue found in btrfs when the btrfs no-holes
+# feature is enabled (introduced in kernel 3.14). So enable the feature if the
+# fs being tested is btrfs.
+if [ $FSTYP == "btrfs" ]; then
+	_require_btrfs_fs_feature "no_holes"
+	_require_btrfs_mkfs_feature "no-holes"
+	MKFS_OPTIONS="$MKFS_OPTIONS -O no-holes"
+fi
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_init_flakey
+_mount_flakey
+
+# Create out test file with some data and then fsync it.
+# We do the fsync only to make sure the last fsync we do in this test triggers
+# the fast code path of btrfs' fsync implementation, a condition necessary to
+# trigger the bug btrfs had.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 128K" \
+		-c "fsync"                  \
+		$SCRATCH_MNT/foobar | _filter_xfs_io
+
+# Now punch a hole against the range [96K, 128K[.
+$XFS_IO_PROG -c "fpunch 96K 32K" $SCRATCH_MNT/foobar
+
+# Punch another hole against a range that overlaps the previous range and ends
+# beyond eof.
+$XFS_IO_PROG -c "fpunch 64K 128K" $SCRATCH_MNT/foobar
+
+# Punch another hole against a range that overlaps the first range ([96K, 128K[)
+# and ends at eof.
+$XFS_IO_PROG -c "fpunch 32K 96K" $SCRATCH_MNT/foobar
+
+# Fsync our file. We want to verify that, after a power failure and mounting the
+# filesystem again, the file content reflects all the hole punch operations.
+$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
+
+echo "File digest before power failure:"
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+echo "Fiemap before power failure:"
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar | _filter_fiemap
+
+# Silently drop all writes and unmount to simulate a crash/power failure.
+_load_flakey_table $FLAKEY_DROP_WRITES
+_unmount_flakey
+
+# Allow writes again, mount to trigger log replay and validate file contents.
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+_mount_flakey
+
+echo "File digest after log replay:"
+# Must match the same digest we got before the power failure.
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+echo "Fiemap after log replay:"
+# Must match the same extent listing we got before the power failure.
+$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foobar | _filter_fiemap
+
+_unmount_flakey
+
+status=0
+exit
diff --git a/tests/generic/110.out b/tests/generic/110.out
new file mode 100644
index 0000000..ba016c8
--- /dev/null
+++ b/tests/generic/110.out
@@ -0,0 +1,13 @@
+QA output created by 110
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digest before power failure:
+d26bbb9a8396a9c0dd76423471b72b15  SCRATCH_MNT/foobar
+Fiemap before power failure:
+0: [0..63]: data
+1: [64..255]: hole
+File digest after log replay:
+d26bbb9a8396a9c0dd76423471b72b15  SCRATCH_MNT/foobar
+Fiemap after log replay:
+0: [0..63]: data
+1: [64..255]: hole
diff --git a/tests/generic/group b/tests/generic/group
index 1dd4269..59a6f43 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -112,6 +112,7 @@
 107 auto quick metadata
 108 auto quick rw
 109 auto metadata dir
+110 auto quick prealloc metadata
 112 rw aio auto quick
 113 rw aio auto quick
 114 rw aio auto quick
-- 
2.1.3

