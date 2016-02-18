Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1422791AbcBRG0e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 01:26:34 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 1C9EF4056407
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 14:26:29 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v2 3/5] fstests: btrfs: Add testcase for btrfs dedup enable disable race test
Date: Thu, 18 Feb 2016 14:24:26 +0800
Message-Id: <1455776668-12306-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455776668-12306-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455776668-12306-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add test case to check btrfs dedup enable/disable race.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/201     | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 103 insertions(+)
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out

diff --git a/tests/btrfs/201 b/tests/btrfs/201
new file mode 100755
index 0000000..dd573a5
--- /dev/null
+++ b/tests/btrfs/201
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test 201
+#
+# Basic btrfs inband dedup enable/disable race test
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
+	kill $trigger_work &> /dev/null
+	kill $fsstress_work &> /dev/null
+	wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
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
+# Use 64K dedup size to keep compatibility for 64K page size
+dedup_bs=64K
+
+_scratch_mkfs "-O dedup" >> $seqres.full 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/stressdir
+
+fsstress_work()
+{
+	$FSSTRESS_PROG $(_scale_fsstress_args -p 8 -n 5000) $FSSTRESS_AVOID \
+		-d $SCRATCH_MNT/stressdir > /dev/null 2>&1
+}
+
+trigger_work()
+{
+	while true; do
+		_run_btrfs_util_prog dedup enable -s inmemory \
+			-b $dedup_bs $SCRATCH_MNT
+		sleep 5
+		_run_btrfs_util_prog dedup disable $SCRATCH_MNT
+		sleep 5
+		_run_btrfs_util_prog dedup enable -s ondisk \
+			-b $dedup_bs $SCRATCH_MNT
+		sleep 5
+		_run_btrfs_util_prog dedup disable $SCRATCH_MNT
+		sleep 5
+	done
+}
+
+fsstress_work &
+fsstress_pid=$!
+
+trigger_work &
+trigger_pid=$!
+
+wait $fsstress_pid
+kill $trigger_pid
+wait
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/201.out b/tests/btrfs/201.out
new file mode 100644
index 0000000..b8969af
--- /dev/null
+++ b/tests/btrfs/201.out
@@ -0,0 +1 @@
+QA output created by 201
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 9b08570..6ee90a4 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -119,3 +119,4 @@
 116 auto quick metadata
 117 auto quick send clone
 200 auto dedup
+201 auto dedup
-- 
2.7.1



