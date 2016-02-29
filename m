Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbcB2IP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 03:15:58 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/5] fstests: btrfs: Add basic test for btrfs in-band de-duplication
Date: Mon, 29 Feb 2016 16:15:20 +0800
Message-Id: <1456733723-27432-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1456733723-27432-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456733723-27432-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic test for btrfs in-band de-duplication, including:
1) Enable
2) Re-enable
3) Dedup
4) File correctness
5) Disable

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/defrag       |  13 +++++++
 tests/btrfs/200     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  21 ++++++++++
 tests/btrfs/group   |   1 +
 4 files changed, 144 insertions(+)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out

diff --git a/common/defrag b/common/defrag
index 942593e..2eb9ee9 100644
--- a/common/defrag
+++ b/common/defrag
@@ -47,6 +47,19 @@ _extent_count()
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
index 0000000..240b7db
--- /dev/null
+++ b/tests/btrfs/200
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test 200
+#
+# Basic btrfs inband dedup test
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
+_require_btrfs_fs_feature dedup
+_require_btrfs_mkfs_feature dedup
+
+# File size is twice the maximum file extent of btrfs
+# So even fallbacked to non-dedup, it will have at least 2 extents
+file_size=256m
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+do_dedup_test()
+{
+	backend=$1
+	dedup_bs=$2
+
+	_run_btrfs_util_prog dedup enable -s $backend -b $dedup_bs $SCRATCH_MNT
+	# do sync write to ensure dedup hash is added into dedup pool
+	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" -c "fsync"\
+		$SCRATCH_MNT/initial_block | _filter_xfs_io
+
+	# do sync write to ensure we can get stable fiemap later
+	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $file_size" -c "fsync"\
+		$SCRATCH_MNT/real_file | _filter_xfs_io
+
+	# Test if real_file is de-duplicated
+	nr_uniq_extents=$(_extent_count_uniq $SCRATCH_MNT/real_file)
+	nr_total_extents=$(_extent_count $SCRATCH_MNT/real_file)
+
+	echo "uniq/total: $nr_uniq_extents/$nr_total_extents" >> $seqres.full
+	# Allow a small amount of dedup miss, as commit interval or
+	# memory pressure may break a dedup_bs block and cause
+	# small extent which won't go through dedup routine
+	_within_tolerance "number of uniq extents" $nr_uniq_extents \
+		$nr_total_extents $(($nr_total_extents - 1)) 5%
+
+	# Also check the md5sum to ensure data is not corrupted
+	md5=$(_md5_checksum $SCRATCH_MNT/real_file)
+	echo "md5sum: $md5"
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
index 0000000..e965f8a
--- /dev/null
+++ b/tests/btrfs/200.out
@@ -0,0 +1,21 @@
+QA output created by 200
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+md5sum: a30e0f3f1b0884081de11d4357811c2e
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+md5sum: a30e0f3f1b0884081de11d4357811c2e
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+md5sum: a30e0f3f1b0884081de11d4357811c2e
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 268435456/268435456 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+md5sum: a30e0f3f1b0884081de11d4357811c2e
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a2fa412..0b7354b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -119,3 +119,4 @@
 116 auto quick metadata
 117 auto quick send clone
 118 auto quick snapshot metadata
+200 auto dedup
-- 
2.7.2



