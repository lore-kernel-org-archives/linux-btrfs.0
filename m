Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31031 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751259AbdCPBui (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 21:50:38 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fstests@vger.kernel.org>
Subject: [PATCH 3/3] fstests: btrfs: Test inband dedupe with data balance.
Date: Thu, 16 Mar 2017 09:50:28 +0800
Message-ID: <20170316015028.20020-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
References: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs balance will reloate date extent, but its hash is removed too late
at run_delayed_ref() time, which will cause extent ref increased
during balance, cause either find_data_references() gives WARN_ON()
or even run_delayed_refs() fails and cause transaction abort.

Add such concurrency test for inband dedupe and data balance.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/203     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |   3 ++
 tests/btrfs/group   |   1 +
 3 files changed, 113 insertions(+)
 create mode 100755 tests/btrfs/203
 create mode 100644 tests/btrfs/203.out

diff --git a/tests/btrfs/203 b/tests/btrfs/203
new file mode 100755
index 00000000..aea756cb
--- /dev/null
+++ b/tests/btrfs/203
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test 203
+#
+# Btrfs inband dedupe with balance concurrency test
+#
+# This can spot inband dedupe error which will increase delayed ref on
+# an data extent inside RO block group
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
+	kill $populate_pid &> /dev/null
+	kill $balance_pid &> /dev/null
+	wait
+	# Check later comment for reason
+	$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
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
+_require_btrfs_command dedupe
+_require_btrfs_fs_feature dedupe
+
+dedupe_bs=128k
+file_size_in_kilo=4096
+init_file=$SCRATCH_MNT/foo
+run_time=$((60 * $TIME_FACTOR))
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+do_dedupe_balance_test()
+{
+	_run_btrfs_util_prog dedupe enable -b $dedupe_bs -s inmemory $SCRATCH_MNT
+
+	# create the initial file and fill hash pool
+	$XFS_IO_PROG -f -c "pwrite -S 0x0 -b $dedupe_bs 0 $dedupe_bs" -c "fsync" \
+		$init_file | _filter_xfs_io
+
+	_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
+	balance_pid=$!
+
+	# Populate fs with all 0 data, to trigger enough in-band dedupe work
+	# to race with balance
+	_populate_fs -n 5 -f 10000000 -d 1 -r $SCRATCH_MNT \
+		-s $file_size_in_kilo &> /dev/null &
+	populate_pid=$!
+
+	sleep $run_time
+
+	kill $populate_pid
+	kill $balance_pid
+	wait
+
+	# Sometimes even we killed $balance_pid and wait returned,
+	# balance may still be running, use balance cancel to wait it.
+	# As this is just a workaround, we don't want it pollute seqres
+	# so call $BTRFS_UTIL_PROG directly
+	$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
+
+	rm $SCRATCH_MNT/* -rf &> /dev/null
+	_run_btrfs_util_prog dedupe disable $SCRATCH_MNT
+}
+
+do_dedupe_balance_test
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/203.out b/tests/btrfs/203.out
new file mode 100644
index 00000000..404394c3
--- /dev/null
+++ b/tests/btrfs/203.out
@@ -0,0 +1,3 @@
+QA output created by 203
+wrote 131072/131072 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f87d995c..2ef7a498 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -144,3 +144,4 @@
 138 auto compress
 200 auto ib-dedupe
 201 auto ib-dedupe
+203 auto ib-dedupe balance
-- 
2.12.0



