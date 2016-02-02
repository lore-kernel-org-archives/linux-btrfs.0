Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbcBBCov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 21:44:51 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id C50574056404
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 10:44:25 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 2/4] fstests: btrfs: Add basic test for btrfs in-band de-duplication
Date: Tue,  2 Feb 2016 10:44:17 +0800
Message-Id: <1454381059-27870-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic test for btrfs in-band de-duplication, including:
1) Enable
2) Re-enable
3) On disk extents are refering to same bytenr
4) Disable

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/defrag       |   8 ++++
 tests/btrfs/200     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  17 ++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 138 insertions(+)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out

diff --git a/common/defrag b/common/defrag
index d2b137e..46175f5 100644
--- a/common/defrag
+++ b/common/defrag
@@ -47,6 +47,14 @@ _extent_count()
 	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l| $AWK_PROG '{print $1}'
 }
 
+_uniq_extent_count()
+{
+	file=$1
+	$XFS_IO_PROG -c "fiemap" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "fiemap" $file | tail -n +2 | grep -v hole |\
+		$AWK_PROG '{print $3}' | sort | uniq | wc -l
+}
+
 _check_extent_count()
 {
 	min=$1
diff --git a/tests/btrfs/200 b/tests/btrfs/200
new file mode 100755
index 0000000..856e1fb
--- /dev/null
+++ b/tests/btrfs/200
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test 200
+#
+# Basic btrfs inband dedup test, including:
+# 1) Enable
+# 2) Uniq file extent number
+# 3) Re-enable
+# 4) Disable
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
+_require_btrfs_kernel_feature dedup
+_require_btrfs_mkfs_feature dedup
+
+# File size is twice the maximum file extent of btrfs
+# So even fallbacked to non-dedup, it will have at least 2 extents
+file_size=$(( 256 * 1024 * 1024 ))
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+do_dedup_test()
+{
+	backend=$1
+	dedup_bs=$2
+	_run_btrfs_util_prog dedup enable -s $backend -b $dedup_bs $SCRATCH_MNT
+	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" \
+		$SCRATCH_MNT/initial_block | _filter_xfs_io
+
+	# sync to ensure dedup hash is added into dedup pool
+	sync
+	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" \
+		$SCRATCH_MNT/real_file | _filter_xfs_io
+	# sync again to ensure data are all rewriten to disk
+	sync
+
+	# Test if real_file is de-duplicated
+	nr_uniq_extents=$(_uniq_extent_count $SCRATCH_MNT/real_file)
+	nr_total_extents=$(_extent_count $SCRATCH_MNT/real_file)
+
+	echo "uniq/total: $nr_uniq_extents/$nr_total_extents" >> $seqres.full
+	# Allow a small amount of dedup miss, as commit interval or
+	# memory pressure may break a dedup_bs block and cause
+	# smalll extent which won't go through dedup routine
+	if [ $nr_uniq_extents -ge $(( $nr_total_extents * 5 / 100 )) ]; then
+		echo "Too high dedup failure rate"
+	fi
+}
+
+# Test inmemory dedup first, use 64K dedup bs to keep compatibility
+# with 64K page size
+do_dedup_test inmemory 64K
+
+# Test ondisk backend, and re-enable function
+do_dedup_test ondisk 64K
+
+# Test 128K(default) dedup bs
+do_dedup_test inmemory 128K
+do_dedup_test ondisk 128K
+
+# Check dedup disable
+_run_btrfs_util_prog dedup disable $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/200.out b/tests/btrfs/200.out
new file mode 100644
index 0000000..5197dbc
--- /dev/null
+++ b/tests/btrfs/200.out
@@ -0,0 +1,17 @@
+QA output created by 200
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index de628be..b54ee6e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -117,3 +117,4 @@
 114 auto qgroup
 115 auto qgroup
 116 auto quick metadata
+200 auto dedup
-- 
2.7.0



