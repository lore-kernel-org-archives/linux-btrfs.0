Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18553 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbcE2TsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 15:48:17 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4TJmGtZ018417
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u4TJmFQi021931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:15 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u4TJmBNk003583
	for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 19:48:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs: test case to make sure seed FS is writable after device add
Date: Mon, 30 May 2016 03:48:18 +0800
Message-Id: <1464551298-11291-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
References: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally when the device is added to a seed FS, the mount point
converts to writeable. However there appears to be a regression
that in 4.6 the sprouted FS still remains read-only. Traced back
untill 3.8 and still there is regression.

Seed sprout btrfs feature is one of the unique feature of btrfs
and interesting solutions can be developed using this feature.

So this test case makes sure that original expected output is
preserved.
---
 tests/btrfs/125     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/125.out |  1 +
 tests/btrfs/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/btrfs/125
 create mode 100644 tests/btrfs/125.out

diff --git a/tests/btrfs/125 b/tests/btrfs/125
new file mode 100755
index 000000000000..189d30614ad0
--- /dev/null
+++ b/tests/btrfs/125
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. btrfs/123
+#
+# Test BTRFS seed device add
+#
+# Steps:
+#   Create seed FS and mount
+#   Device add
+#   Check if the FS is now RW-able
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle.  All Rights Reserved.
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
+#
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
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_nocheck
+_require_scratch_dev_pool 2
+
+rm -f $seqres.full
+
+_scratch_dev_pool_get 1
+_spare_dev_get
+
+_scratch_pool_mkfs >> $seqres.full 2>&1
+
+btrfstune -S 1 $SCRATCH_DEV_POOL || \
+	_fail "btrfstune failed to mark '$SCRATCH_DEV_POOL' as seed"
+
+_scratch_mount >> $seqres.full 2>&1
+
+_run_btrfs_util_prog filesystem show -m
+
+_run_btrfs_util_prog device add $SPARE_DEV "$SCRATCH_MNT"
+
+_run_btrfs_util_prog filesystem show -m
+
+touch "$SCRATCH_MNT"/tf1 || _fail "FS not Writeable"
+
+_scratch_unmount
+_spare_dev_put
+_scratch_dev_pool_put
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/125.out b/tests/btrfs/125.out
new file mode 100644
index 000000000000..4f22ab0cb5e9
--- /dev/null
+++ b/tests/btrfs/125.out
@@ -0,0 +1 @@
+QA output created by 125
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 1866b17aa6df..0afc82940f61 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -126,3 +126,4 @@
 122 auto quick snapshot qgroup
 123 auto replace
 124 auto replace
+125 auto replace
-- 
2.7.0

