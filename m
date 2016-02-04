Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbcBDALi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Feb 2016 19:11:38 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: btrfs, test for send with clone operations
Date: Thu,  4 Feb 2016 00:11:28 +0000
Message-Id: <1454544688-18723-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that an incremental send operation which issues clone operations
works for files that have a full path containing more than one parent
directory component.

This used to fail before the following patch for the linux kernel:

  "[PATCH] Btrfs: send, fix extent buffer tree lock assertion failure"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/117     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/117.out |  13 +++++++
 tests/btrfs/group   |   1 +
 3 files changed, 123 insertions(+)
 create mode 100755 tests/btrfs/117
 create mode 100644 tests/btrfs/117.out

diff --git a/tests/btrfs/117 b/tests/btrfs/117
new file mode 100755
index 0000000..f2e58de
--- /dev/null
+++ b/tests/btrfs/117
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. btrfs/117
+#
+# Test that an incremental send operation which issues clone operations works
+# for files that have a full path containing more than one parent directory
+# component.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
+tmp=`mktemp -d`
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
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cp_reflink
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/a/b/c
+$XFS_IO_PROG -f -c "pwrite -S 0xfd 0 128K" $SCRATCH_MNT/a/b/c/x | _filter_xfs_io
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap1
+
+# Create a bunch of small and empty files, this is just to make sure our
+# subvolume's btree gets more than 1 leaf, a condition necessary to trigger a
+# past bug (1000 files is enough even for a leaf/node size of 64K, the largest
+# possible size).
+for ((i = 1; i <= 1000; i++)); do
+	echo -n > $SCRATCH_MNT/a/b/c/z_$i
+done
+
+# Create a clone of file x's extent and write some data to the middle of this
+# new file, this is to guarantee the incremental send operation below issues
+# a clone operation.
+cp --reflink=always $SCRATCH_MNT/a/b/c/x $SCRATCH_MNT/a/b/c/y
+$XFS_IO_PROG -c "pwrite -S 0xab 32K 16K" $SCRATCH_MNT/a/b/c/y | _filter_xfs_io
+
+# Will be used as an extra source root for clone operations for the incremental
+# send operation below.
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/clones_snap
+
+_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/snap2
+
+_run_btrfs_util_prog send $SCRATCH_MNT/snap1 -f $tmp/1.snap
+_run_btrfs_util_prog send $SCRATCH_MNT/clones_snap -f $tmp/clones.snap
+_run_btrfs_util_prog send -p $SCRATCH_MNT/snap1 \
+	-c $SCRATCH_MNT/clones_snap $SCRATCH_MNT/snap2 -f $tmp/2.snap
+
+echo "File digests in the original filesystem:"
+md5sum $SCRATCH_MNT/snap1/a/b/c/x | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/a/b/c/x | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/a/b/c/y | _filter_scratch
+
+_scratch_unmount
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/clones.snap
+_run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
+
+echo "File digests in the new filesystem:"
+# Should match the digests we had in the original filesystem.
+md5sum $SCRATCH_MNT/snap1/a/b/c/x | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/a/b/c/x | _filter_scratch
+md5sum $SCRATCH_MNT/snap2/a/b/c/y | _filter_scratch
+
+status=0
+exit
diff --git a/tests/btrfs/117.out b/tests/btrfs/117.out
new file mode 100644
index 0000000..d7723ff
--- /dev/null
+++ b/tests/btrfs/117.out
@@ -0,0 +1,13 @@
+QA output created by 117
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 16384/16384 bytes at offset 32768
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+File digests in the original filesystem:
+38bf19185758f77c41d712b8bf74b61f  SCRATCH_MNT/snap1/a/b/c/x
+38bf19185758f77c41d712b8bf74b61f  SCRATCH_MNT/snap2/a/b/c/x
+d607e49e9085627d561bb117d8b197b7  SCRATCH_MNT/snap2/a/b/c/y
+File digests in the new filesystem:
+38bf19185758f77c41d712b8bf74b61f  SCRATCH_MNT/snap1/a/b/c/x
+38bf19185758f77c41d712b8bf74b61f  SCRATCH_MNT/snap2/a/b/c/x
+d607e49e9085627d561bb117d8b197b7  SCRATCH_MNT/snap2/a/b/c/y
diff --git a/tests/btrfs/group b/tests/btrfs/group
index de628be..f74ffbb 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -117,3 +117,4 @@
 114 auto qgroup
 115 auto qgroup
 116 auto quick metadata
+117 auto quick send clone
-- 
2.7.0.rc3

