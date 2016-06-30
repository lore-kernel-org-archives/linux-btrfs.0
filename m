Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbcF3J2r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:28:47 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 43FA84056406
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:40 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/4] fstests: btrfs: Add basic test for btrfs in-band de-duplication
Date: Thu, 30 Jun 2016 17:24:37 +0800
Message-Id: <20160630092439.27693-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
References: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic test for btrfs in-band de-duplication(inmemory backend), including:
1) Enable
3) Dedup rate
4) File correctness
5) Disable

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/defrag       |  13 ++++++
 tests/btrfs/200     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  22 ++++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 152 insertions(+)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out

diff --git a/common/defrag b/common/defrag
index 7db0cb4..2d0ae13 100644
--- a/common/defrag
+++ b/common/defrag
@@ -54,6 +54,19 @@ _extent_count()
 	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep -v hole | wc -l| $AWK_PROG '{print $1}'
 }
 
+# Get the number of unique file extents
+# Unique file extents means they have different ondisk bytenr
+# Some filesystem supports reflinkat() or in-band de-dup can create
+# a file whose all file extents points to the same ondisk bytenr
+# this can be used to test if such reflinkat() or in-band de-dup works
+_extent_count_uniq()
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
index 0000000..5a190dd
--- /dev/null
+++ b/tests/btrfs/200
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test 200
+#
+# Basic btrfs inband dedupe test for inmemory backend
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
+_require_btrfs_subcommand dedupe
+_require_btrfs_fs_feature dedupe
+
+# File size is twice the maximum file extent of btrfs
+# So even fallbacked to non-dedupe, it will have at least 2 extents
+file_size=256m
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+do_dedupe_test()
+{
+	dedupe_bs=$1
+
+	echo "Testing inmemory dedupe backend with block size $dedupe_bs"
+	_run_btrfs_util_prog dedupe enable -f -s inmemory -b $dedupe_bs \
+		$SCRATCH_MNT
+	# do sync write to ensure dedupe hash is added into dedupe pool
+	$XFS_IO_PROG -f -c "pwrite -b $dedupe_bs 0 $dedupe_bs" -c "fsync"\
+		$SCRATCH_MNT/initial_block | _filter_xfs_io
+
+	# do sync write to ensure we can get stable fiemap later
+	$XFS_IO_PROG -f -c "pwrite -b $dedupe_bs 0 $file_size" -c "fsync"\
+		$SCRATCH_MNT/real_file | _filter_xfs_io
+
+	# Test if real_file is de-duplicated
+	nr_uniq_extents=$(_extent_count_uniq $SCRATCH_MNT/real_file)
+	nr_total_extents=$(_extent_count $SCRATCH_MNT/real_file)
+	nr_deduped_extents=$(($nr_total_extents - $nr_uniq_extents))
+
+	echo "deduped/total: $nr_deduped_extents/$nr_total_extents" \
+		>> $seqres.full
+	# Allow a small amount of dedupe miss, as commit interval or
+	# memory pressure may break a dedupe_bs block and cause
+	# small extent which won't go through dedupe routine
+	_within_tolerance "number of deduped extents" $nr_deduped_extents \
+		$nr_total_extents 5% -v
+
+	# Also check the md5sum to ensure data is not corrupted
+	md5=$(_md5_checksum $SCRATCH_MNT/real_file)
+	echo "md5sum: $md5"
+}
+
+# Test inmemory dedupe first, use 64K dedupe bs to keep compatibility
+# with 64K page size
+do_dedupe_test 64K
+
+# Test 128K(default) dedupe bs
+do_dedupe_test 128K
+
+# Test 1M dedupe bs
+do_dedupe_test 1M
+
+# Check dedupe disable
+_run_btrfs_util_prog dedupe disable $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
+# Check dedupe disable
+_run_btrfs_util_prog dedupe disable $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/200.out b/tests/btrfs/200.out
new file mode 100644
index 0000000..e09e573
--- /dev/null
+++ b/tests/btrfs/200.out
@@ -0,0 +1,22 @@
+QA output created by 200
+Testing inmemory dedupe backend with block size 64K
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+number of deduped extents is in range
+md5sum: a30e0f3f1b0884081de11d4357811c2e
+Testing inmemory dedupe backend with block size 128K
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+number of deduped extents is in range
+md5sum: a30e0f3f1b0884081de11d4357811c2e
+Testing inmemory dedupe backend with block size 1M
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+number of deduped extents is in range
+md5sum: a30e0f3f1b0884081de11d4357811c2e
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5a26ed7..fc9577b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -126,3 +126,4 @@
 121 auto quick snapshot qgroup
 122 auto quick snapshot qgroup
 123 auto quick qgroup
+200 auto ib-dedupe
-- 
2.9.0



