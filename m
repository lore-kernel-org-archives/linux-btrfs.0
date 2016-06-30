Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbcF3J3d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:29:33 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 890A14056401
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:40 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 3/4] fstests: btrfs: Add testcase for btrfs dedupe and metadata balance race test
Date: Thu, 30 Jun 2016 17:24:38 +0800
Message-Id: <20160630092439.27693-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
References: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs balance with inband dedupe enable/disable will expose a lot of
hidden dedupe bug:

1) Enable/disable race bug
2) Btrfs dedupe tree balance corrupted delayed_ref
3) Btrfs disable and balance will cause balance BUG_ON

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/201     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 115 insertions(+)
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out

diff --git a/tests/btrfs/201 b/tests/btrfs/201
new file mode 100755
index 0000000..152e9f7
--- /dev/null
+++ b/tests/btrfs/201
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test 201
+#
+# Btrfs inband dedup enable/disable race with metadata balance
+#
+# This tests will test the following bugs exposed in development:
+# 1) enable/disable race
+# 2) tree balance cause delayed ref corruption
+# 3) disable and balance cause BUG_ON
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
+	killall $FSSTRESS_PROG &> /dev/null
+	kill $trigger_pid &> /dev/null
+	kill $balance_pid &> /dev/null
+	wait
+
+	# See comment later
+	$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
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
+_require_btrfs_subcommand dedupe
+_require_btrfs_fs_feature dedupe
+
+# Use 64K dedupe size to keep compatibility for 64K page size
+dedupe_bs=64K
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+mkdir -p $SCRATCH_MNT/stressdir
+
+runtime=$((60 * $TIME_FACTOR))
+
+trigger_work()
+{
+	while true; do
+		_run_btrfs_util_prog dedupe enable -f -s inmemory \
+			-b $dedupe_bs $SCRATCH_MNT
+		sleep 1
+		_run_btrfs_util_prog dedupe disable $SCRATCH_MNT
+		sleep 1
+	done
+}
+
+# redirect all output, as error output like 'balance cancelled by user'
+# will populuate the golden output.
+_btrfs_stress_balance -m $SCRATCH_MNT &> /dev/null &
+balance_pid=$!
+
+$FSSTRESS_PROG $(_scale_fsstress_args -p 1 -n 10000000) $FSSTRESS_AVOID \
+	-d $SCRATCH_MNT/stressdir > /dev/null 2>&1 &
+
+trigger_work &
+trigger_pid=$!
+
+sleep $runtime
+killall $FSSTRESS_PROG &> /dev/null
+kill $trigger_pid &> /dev/null
+kill $balance_pid &> /dev/null
+wait
+
+# Manually stop balance as it's possible balance is still running for a short
+# time. And we don't want to populate $seqres.full, so call $BTRFS_UTIL_PROG
+# directly
+$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/201.out b/tests/btrfs/201.out
new file mode 100644
index 0000000..5ac973f
--- /dev/null
+++ b/tests/btrfs/201.out
@@ -0,0 +1,2 @@
+QA output created by 201
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fc9577b..46f5c8e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -127,3 +127,4 @@
 122 auto quick snapshot qgroup
 123 auto quick qgroup
 200 auto ib-dedupe
+201 auto ib-dedupe
-- 
2.9.0



