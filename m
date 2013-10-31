Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27024 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3JaJeh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 05:34:37 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3] xfstests: add regression test for running btrfs balance and defrag concurrently
Date: Thu, 31 Oct 2013 17:34:22 +0800
Message-Id: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test aims to trigger snapshot-aware defrag path in write endio by
running balance, which is not expected and leads to a crash.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v3:
- replace dd with xfs_io, which is preferable in xfstests.
- unify the for loop style.
- remove unneeded comments as required.
v2: remove unneeded comments as required.

 tests/btrfs/021     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/021.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/btrfs/021
 create mode 100644 tests/btrfs/021.out

diff --git a/tests/btrfs/021 b/tests/btrfs/021
new file mode 100755
index 0000000..e6d645c
--- /dev/null
+++ b/tests/btrfs/021
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 021
+#
+# A regression test of running btrfs balance and defrag concurrently.
+#
+# The test aims to trigger snapshot-aware defrag path in endio by
+# running balance, which is not expected and leads to a crash.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle.  All Rights Reserved.
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
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+run_test()
+{
+	$BTRFS_UTIL_PROG balance start $SCRATCH_MNT >> $seqres.full &
+
+	sleep 0.5
+
+	find $SCRATCH_MNT -type f -print0 | xargs -0 \
+	$BTRFS_UTIL_PROG filesystem defrag -f
+
+	sync
+	wait
+}
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+# This is going to reproduce a race senario between balance and the writeback
+# of snapshot-aware defragment.
+
+# we first create a few files to get higher btree height.
+for j in `seq 0 100`; do
+	touch $SCRATCH_MNT/padding-$j
+done
+
+# Get 50 files with fragments by using backwards writes.
+for j in `seq 0 50`; do
+	for i in `seq 20 -1 1`; do
+		$XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
+		$SCRATCH_MNT/foo-$j >> $seqres.full | _filter_xfs_io
+	done
+done
+
+# Make sure that our metadata makes it self on disk.
+sync
+
+run_test
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/021.out b/tests/btrfs/021.out
new file mode 100644
index 0000000..09f4062
--- /dev/null
+++ b/tests/btrfs/021.out
@@ -0,0 +1,2 @@
+QA output created by 021
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1159499..410f8ed 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -23,3 +23,4 @@
 018 auto quick
 019 auto quick
 020 auto quick
+021 auto quick
-- 
1.8.2.1

