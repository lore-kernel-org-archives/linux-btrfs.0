Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31031 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751154AbdCPBum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 21:50:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fstests@vger.kernel.org>
Subject: [PATCH 2/3] fstests: btrfs: Add testcase for btrfs dedupe and metadata balance race test
Date: Thu, 16 Mar 2017 09:50:27 +0800
Message-ID: <20170316015028.20020-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
References: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 00000000..d6913c13
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
+_require_btrfs_command dedupe
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
+		_run_btrfs_util_prog dedupe enable -s inmemory \
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
index 00000000..5ac973f5
--- /dev/null
+++ b/tests/btrfs/201.out
@@ -0,0 +1,2 @@
+QA output created by 201
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bf001d3c..f87d995c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -143,3 +143,4 @@
 137 auto quick send
 138 auto compress
 200 auto ib-dedupe
+201 auto ib-dedupe
-- 
2.12.0



