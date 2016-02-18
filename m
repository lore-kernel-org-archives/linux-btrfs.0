Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425120AbcBRG0o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 01:26:44 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 3DF68405640A
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 14:26:29 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v2 5/5] fstests: btrfs: Test inband dedup with balance.
Date: Thu, 18 Feb 2016 14:24:28 +0800
Message-Id: <1455776668-12306-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455776668-12306-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455776668-12306-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs balance will reloate date extent, but its hash is removed too late
at run_delayed_ref() time, which will cause extent ref increased
increased during balance, cause either find_data_references() gives
WARN_ON() or even run_delayed_refs() fails and cause transaction abort.

Add such concurrency test for inband dedup and balance.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/203     | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |  3 ++
 tests/btrfs/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/btrfs/203
 create mode 100644 tests/btrfs/203.out

diff --git a/tests/btrfs/203 b/tests/btrfs/203
new file mode 100755
index 0000000..f09af27
--- /dev/null
+++ b/tests/btrfs/203
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test 203
+#
+# Btrfs reflink with balance concurrency test
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
+	kill $balance_pid &> /dev/null
+	wait
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_cp_reflink
+_need_to_be_root
+_require_btrfs_subcommand dedup
+_require_btrfs_kernel_feature dedup
+_require_btrfs_mkfs_feature dedup
+
+dedup_bs=$(( 128 * 1024 ))
+file=$SCRATCH_MNT/foo
+nr=20000
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+_run_btrfs_util_prog dedup enable -b $dedup_bs $SCRATCH_MNT
+
+# create the initial file
+$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" $file | _filter_xfs_io
+
+# make sure hash is added into hash pool
+sync
+
+_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
+balance_pid=$!
+
+for n in $(seq 1 $nr); do
+	$XFS_IO_PROG -f -c "pwrite -b $dedup_bs 0 $dedup_bs" \
+		${file}_${n} > /dev/null 2>&1
+done
+
+kill $balance_pid &> /dev/null
+wait
+
+# Sometimes even we killed $balance_pid and wait returned,
+# balance may still be running, use balance cancel to wait it.
+_run_btrfs_util_prog balance cancel $SCRATCH_MNT &> /dev/null
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/203.out b/tests/btrfs/203.out
new file mode 100644
index 0000000..404394c
--- /dev/null
+++ b/tests/btrfs/203.out
@@ -0,0 +1,3 @@
+QA output created by 203
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 34f49b8..ccd4cc7 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -121,3 +121,4 @@
 200 auto dedup
 201 auto dedup
 202 auto dedup
+203 auto dedup balance
-- 
2.7.1



