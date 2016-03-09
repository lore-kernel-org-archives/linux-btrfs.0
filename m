Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47714 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbcCIIgZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 03:36:25 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v4 4/6] fstests: btrfs: Add per inode dedup flag test
Date: Wed,  9 Mar 2016 16:33:42 +0800
Message-Id: <1457512424-9215-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1457512424-9215-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test will check per inode dedup flag.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/202     | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |  15 ++++++++
 tests/btrfs/group   |   1 +
 3 files changed, 124 insertions(+)
 create mode 100755 tests/btrfs/202
 create mode 100644 tests/btrfs/202.out

diff --git a/tests/btrfs/202 b/tests/btrfs/202
new file mode 100755
index 0000000..33ad51d
--- /dev/null
+++ b/tests/btrfs/202
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test 202
+#
+# Btrfs per inode dedup flag test
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
+here=`pwd`
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
+. ./common/defrag
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_btrfs_subcommand dedup
+_require_btrfs_subcommand property
+_require_btrfs_fs_feature dedup
+_require_btrfs_mkfs_feature dedup
+
+# File size is twice the maximum file extent of btrfs
+# So even fallbacked to non-dedup, it will have at least 2 extents
+file_size=256m
+dedup_bs=64k
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+# Return 0 for not deduped at all , return 1 for part or full deduped
+test_file_deduped () {
+	file=$1
+
+	nr_uniq_extents=$(_extent_count_uniq $file)
+	nr_total_extents=$(_extent_count $file)
+
+	if [ $nr_uniq_extents -eq $nr_total_extents ]; then
+		echo "$file: not de-duplicated"
+	else
+		echo "$file: de-duplicated"
+	fi
+}
+
+_run_btrfs_util_prog dedup enable -b $dedup_bs $SCRATCH_MNT
+touch $SCRATCH_MNT/dedup_file
+touch $SCRATCH_MNT/no_dedup_file
+mkdir $SCRATCH_MNT/dedup_dir
+mkdir $SCRATCH_MNT/no_dedup_dir
+
+_run_btrfs_util_prog property set $SCRATCH_MNT/no_dedup_file dedup disable
+_run_btrfs_util_prog property set $SCRATCH_MNT/no_dedup_dir dedup disable
+
+# use fsync write to ensure hash is added to dedup pool
+$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" -c "fsync" \
+	$SCRATCH_MNT/tmp | _filter_xfs_io
+
+$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
+	$SCRATCH_MNT/dedup_file | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
+	$SCRATCH_MNT/no_dedup_file | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
+	$SCRATCH_MNT/dedup_dir/default_file | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
+	$SCRATCH_MNT/no_dedup_dir/default_file | _filter_xfs_io
+
+test_file_deduped $SCRATCH_MNT/dedup_file | _filter_scratch
+test_file_deduped $SCRATCH_MNT/no_dedup_file | _filter_scratch
+test_file_deduped $SCRATCH_MNT/dedup_dir/default_file | _filter_scratch
+test_file_deduped $SCRATCH_MNT/no_dedup_dir/default_file | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/202.out b/tests/btrfs/202.out
new file mode 100644
index 0000000..6c1b4cb
--- /dev/null
+++ b/tests/btrfs/202.out
@@ -0,0 +1,15 @@
+QA output created by 202
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+SCRATCH_MNT/dedup_file: de-duplicated
+SCRATCH_MNT/no_dedup_file: not de-duplicated
+SCRATCH_MNT/dedup_dir/default_file: de-duplicated
+SCRATCH_MNT/no_dedup_dir/default_file: not de-duplicated
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 76ebea7..0c03cf1 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -121,3 +121,4 @@
 118 auto quick snapshot metadata
 200 auto dedup
 201 auto dedup
+202 auto dedup
-- 
2.7.2



