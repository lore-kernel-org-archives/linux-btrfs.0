Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLPJn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 04:43:57 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: btrfs/080 add test case for qgroup account on shared extents
Date: Tue, 16 Dec 2014 17:43:24 +0800
Message-Id: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a regression test of
'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'

It can produce qgroup related warnings.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/080     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/080.out |  3 +++
 2 files changed, 76 insertions(+)
 create mode 100755 tests/btrfs/080
 create mode 100644 tests/btrfs/080.out

diff --git a/tests/btrfs/080 b/tests/btrfs/080
new file mode 100755
index 0000000..2a12bf2
--- /dev/null
+++ b/tests/btrfs/080
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 080
+#
+# Regression of 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'
+# this will throw a warning into dmesg.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Liu Bo.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
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
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+run_check _scratch_mkfs "-b 1g --nodesize 4096"
+run_check _scratch_mount
+
+run_check xfs_io -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo
+
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
+
+run_check cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
+run_check cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
+run_check cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+rm -fr $SCRATCH_MNT/* >& /dev/null
+
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+
+$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | $AWK_PROG '{print $2" "$3}'
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/080.out b/tests/btrfs/080.out
new file mode 100644
index 0000000..eafa7c3
--- /dev/null
+++ b/tests/btrfs/080.out
@@ -0,0 +1,3 @@
+QA output created by 080
+4096 4096
+4096 4096
-- 
1.8.2.1

