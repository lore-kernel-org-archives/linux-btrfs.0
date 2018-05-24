Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030730AbeEXQJf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 12:09:35 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs: add seed sprout functionality test
Date: Fri, 25 May 2018 00:11:59 +0800
Message-Id: <20180524161159.17239-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Create a seed device and add the sprout device to it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/config       |  1 +
 tests/btrfs/161     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/161.out |  2 ++
 tests/btrfs/group   |  1 +
 4 files changed, 73 insertions(+)
 create mode 100755 tests/btrfs/161
 create mode 100644 tests/btrfs/161.out

diff --git a/common/config b/common/config
index af360cefc804..f0735cb0153d 100644
--- a/common/config
+++ b/common/config
@@ -235,6 +235,7 @@ case "$HOSTOS" in
         export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
         export BTRFS_SHOW_SUPER_PROG="`set_prog_path btrfs-show-super`"
 	export BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
+	export BTRFS_TUNE_PROG="`set_prog_path btrfstune`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"
         export MKFS_CIFS_PROG="false"
diff --git a/tests/btrfs/161 b/tests/btrfs/161
new file mode 100755
index 000000000000..2ed06f0bb3c8
--- /dev/null
+++ b/tests/btrfs/161
@@ -0,0 +1,69 @@
+#! /bin/bash
+# FS QA Test 161 seed sprout functionality test
+#
+#  Create a seed device, mount it and add a new device to create a
+#  sprout filesystem.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+# Author: Anand Jain <anand.jain@oracle.com>
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
+
+# Modify as appropriate.
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dev_pool 2
+
+_scratch_dev_pool_get 2
+
+DEV_SEED=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
+DEV_SPROUT=$(echo $SCRATCH_DEV_POOL | awk '{print $2}')
+
+_mkfs_dev $DEV_SEED
+$BTRFS_TUNE_PROG -S 1 $DEV_SEED
+_scratch_mount >> $seqres.full 2>&1
+_run_btrfs_util_prog device add -f $DEV_SPROUT $SCRATCH_MNT
+_scratch_unmount
+_scratch_dev_pool_put
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/161.out b/tests/btrfs/161.out
new file mode 100644
index 000000000000..1752a2433702
--- /dev/null
+++ b/tests/btrfs/161.out
@@ -0,0 +1,2 @@
+QA output created by 161
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f04ee8d5297c..fe83631f0f33 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -163,3 +163,4 @@
 158 auto quick raid scrub
 159 auto quick
 160 auto quick
+161 auto quick
-- 
2.15.0

