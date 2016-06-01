Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39390 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751197AbcFAGkl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 02:40:41 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
CC: <fdmanana@gmail.com>, <mfasheh@suse.de>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2] fstests: btrfs: add test for qgroup handle extent de-reference
Date: Wed, 1 Jun 2016 14:40:11 +0800
Message-ID: <1464763211-17762-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test if qgroup can handle extent de-reference during reallocation.
"extent de-reference" means that reducing an extent's reference count
or freeing an extent.
Although current qgroup can handle it, we still need to prevent any
regression which may break current qgroup.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 common/rc           |   4 +--
 tests/btrfs/028     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/028.out |   2 ++
 tests/btrfs/group   |   1 +
 4 files changed, 107 insertions(+), 2 deletions(-)
 create mode 100755 tests/btrfs/028
 create mode 100644 tests/btrfs/028.out

diff --git a/common/rc b/common/rc
index 51092a0..650d198 100644
--- a/common/rc
+++ b/common/rc
@@ -3284,9 +3284,9 @@ _btrfs_get_profile_configs()
 # stress btrfs by running balance operation in a loop
 _btrfs_stress_balance()
 {
-	local btrfs_mnt=$1
+	local options=$@
 	while true; do
-		$BTRFS_UTIL_PROG balance start $btrfs_mnt
+		$BTRFS_UTIL_PROG balance start $options
 	done
 }
 
diff --git a/tests/btrfs/028 b/tests/btrfs/028
new file mode 100755
index 0000000..04a3508
--- /dev/null
+++ b/tests/btrfs/028
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test 028
+#
+# Test if qgroup can handle extent de-reference during reallocation.
+# "extent de-reference" means that reducing an extent's reference count
+# or freeing an extent.
+# Although current qgroup can handle it, we still need to prevent any
+# regression which may break current qgroup.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+# Currently in btrfs the node/leaf size can not be smaller than the page
+# size (but it can be greater than the page size). So use the largest
+# supported node/leaf size (64Kb) so that the test can run on any platform
+# that Linux supports.
+_scratch_mkfs "--nodesize 64k"
+_scratch_mount
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+# Increase the probability of generating de-refer extent, and decrease
+# other.
+args=`_scale_fsstress_args -z \
+	-f write=10 -f unlink=10 \
+	-f creat=10 -f fsync=10 \
+	-f fsync=10 -n 100000 -p 2 \
+	-d $SCRATCH_MNT/stress_dir`
+echo "Run fsstress $args" >>$seqres.full
+$FSSTRESS_PROG $args >/dev/null 2>&1 &
+fsstress_pid=$!
+
+echo "Start balance" >>$seqres.full
+_btrfs_stress_balance -d $SCRATCH_MNT >/dev/null 2>&1 &
+balance_pid=$!
+
+# 30s is enough to trigger bug
+sleep $((30*$TIME_FACTOR))
+kill $fsstress_pid $balance_pid
+wait
+
+# kill _btrfs_stress_balance can't end balance, so call btrfs balance cancel
+# to cancel running or paused balance.
+$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
+
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+
+_scratch_unmount
+
+# generate a qgroup report and look for inconsistent groups
+$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
+			grep -q -E "Counts for qgroup.*are different"
+if [ $? -ne 0 ]; then
+	echo "Silence is golden"
+	# success, all done
+	status=0
+fi
+
+exit
diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
new file mode 100644
index 0000000..2615f73
--- /dev/null
+++ b/tests/btrfs/028.out
@@ -0,0 +1,2 @@
+QA output created by 028
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index da0e27f..35ecf59 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -30,6 +30,7 @@
 025 auto quick send clone
 026 auto quick compress prealloc
 027 auto replace
+028 auto qgroup balance
 029 auto quick clone
 030 auto quick send
 031 auto quick subvol clone
-- 
2.5.5



