Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbcBBCow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 21:44:52 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 7DBF54056407
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 10:44:26 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 4/4] fstests: btrfs: Add per inode dedup flag test
Date: Tue,  2 Feb 2016 10:44:19 +0800
Message-Id: <1454381059-27870-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test will check per inode dedup flag.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/202     | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |  15 +++++++
 tests/btrfs/group   |   1 +
 3 files changed, 133 insertions(+)
 create mode 100755 tests/btrfs/202
 create mode 100644 tests/btrfs/202.out

diff --git a/tests/btrfs/202 b/tests/btrfs/202
new file mode 100755
index 0000000..92143fb
--- /dev/null
+++ b/tests/btrfs/202
@@ -0,0 +1,117 @@
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
+_need_to_be_root
+_require_btrfs_subcommand dedup
+_require_btrfs_subcommand property
+_require_btrfs_kernel_feature dedup
+_require_btrfs_mkfs_feature dedup
+
+# File size is twice the maximum file extent of btrfs
+# So even fallbacked to non-dedup, it will have at least 2 extents
+file_size=$(( 256 * 1024 * 1024 ))
+dedup_bs=$(( 64 * 1024 ))
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+# Return 0 for not deduped at all , return 1 for part or full deduped
+test_file_deduped () {
+	file=$1
+
+	nr_uniq_extents=$(_uniq_extent_count $file)
+	nr_total_extents=$(_extent_count $file)
+
+	if [ $nr_uniq_extents -eq $nr_total_extents ]; then
+		echo "not de-duplicated"
+	else
+		echo "de-duplicated"
+	fi
+}
+
+dedup_write_file () {
+	file=$1
+	size=$2
+
+	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $size" $file | _filter_xfs_io
+}
+
+print_result () {
+	file=$1
+
+	echo "$file: $(test_file_deduped $file)"
+}
+_run_btrfs_util_prog dedup enable -b $dedup_bs $SCRATCH_MNT
+touch $SCRATCH_MNT/dedup_file
+touch $SCRATCH_MNT/no_dedup_file
+mkdir $SCRATCH_MNT/dedup_dir
+mkdir $SCRATCH_MNT/no_dedup_dir
+
+_run_btrfs_util_prog property set $SCRATCH_MNT/no_dedup_file dedup disable
+_run_btrfs_util_prog property set $SCRATCH_MNT/no_dedup_dir dedup disable
+
+dedup_write_file $SCRATCH_MNT/tmp $dedup_bs
+# sync to ensure hash is added to dedup tree
+sync
+
+dedup_write_file $SCRATCH_MNT/dedup_file $file_size
+dedup_write_file $SCRATCH_MNT/no_dedup_file $file_size
+dedup_write_file $SCRATCH_MNT/dedup_dir/dedup_file $file_size
+dedup_write_file $SCRATCH_MNT/no_dedup_dir/no_dedup_file $file_size
+
+print_result $SCRATCH_MNT/dedup_file
+print_result $SCRATCH_MNT/no_dedup_file
+print_result $SCRATCH_MNT/dedup_dir/dedup_file
+print_result $SCRATCH_MNT/no_dedup_dir/no_dedup_file
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/202.out b/tests/btrfs/202.out
new file mode 100644
index 0000000..cc18013
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
+/mnt/scratch/dedup_file: de-duplicated
+/mnt/scratch/no_dedup_file: not de-duplicated
+/mnt/scratch/dedup_dir/dedup_file: de-duplicated
+/mnt/scratch/no_dedup_dir/no_dedup_file: not de-duplicated
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 8159148..62bb414 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -119,3 +119,4 @@
 116 auto quick metadata
 200 auto dedup
 201 auto dedup
+202 auto dedup
-- 
2.7.0



