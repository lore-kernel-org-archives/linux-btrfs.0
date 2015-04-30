Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbD3KLk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 06:11:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] xfstests: btrfs: test device replace, with EIO on the src dev
Date: Thu, 30 Apr 2015 18:08:46 +0800
Message-Id: <1430388527-16700-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test case will test to confirm the replace works when
the replacing source device has EIO errors.

EIO condition is achieved using the DM device.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/087     | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/087.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 100 insertions(+)
 create mode 100755 tests/btrfs/087
 create mode 100644 tests/btrfs/087.out

diff --git a/tests/btrfs/087 b/tests/btrfs/087
new file mode 100755
index 0000000..c2eb16a
--- /dev/null
+++ b/tests/btrfs/087
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. btrfs/087
+#
+# test device replace works when the source device has EIO
+#
+# Copyright (c) 2015 Oracle.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+rm -f $seqres.full
+
+_cleanup()
+{
+	# remove dm erro-dev from the scratch pool
+	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$DM_ERROR_DEV *##"`
+
+	_cleanup_dm_error_dev
+	SCRATCH_DEV_POOL="$SCRATCH_DEV_POOL $DEV_REPLACE_SRC"
+	SCRATCH_DEV_POOL="$SCRATCH_DEV_POOL $DEV_REPLACE_TGT"
+	for i in $SCRATCH_DEV_POOL; do
+		$WIPEFS_PROG -a $i > /dev/null 2>&1
+	done
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool 4
+_require_command "$WIPEFS_PROG" wipefs
+
+# peal a (last) device from dev pool to be use it as replace target device
+DEV_REPLACE_TGT="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $NF}'`"
+SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$DEV_REPLACE_TGT *##"`
+
+# create a dmerror device
+# peal the last device in SCRATCH_DEV_POOL and assign it to DM_ERROR_DEV
+DEV_REPLACE_SRC="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $NF}'`"
+SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$DEV_REPLACE_SRC *##"`
+
+# Create dm linear device /dev/mapper/error-dev using dev_last
+# DM_ERROR_DEV will have dm linear device set if created successfully
+_require_dm_error $DEV_REPLACE_SRC
+_init_dm_error_dev  $DEV_REPLACE_SRC
+
+# assign created dm device to the scratch pool
+SCRATCH_DEV_POOL="$SCRATCH_DEV_POOL $DM_ERROR_DEV"
+
+echo DEV_REPLACE_SRC=$DEV_REPLACE_SRC >> $seqres.full
+echo DEV_REPLACE_TGT=$DEV_REPLACE_TGT >> $seqres.full
+echo DM_ERROR_DEV=$DM_ERROR_DEV >> $seqres.full
+echo SCRATCH_DEV_POOL=$SCRATCH_DEV_POOL >> $seqres.full
+
+MKFS_OPTIONS="-m raid1 -d raid1"
+_scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT >> $seqres.full
+
+error_dev_devid=`$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT |\
+			egrep $DM_ERROR_DEV | $AWK_PROG '{print $2}'`
+echo error_dev_devid=$error_dev_devid >> $seqres.full
+
+# now load the error into the DM_ERROR_DEV
+_load_dm_error_table
+
+$BTRFS_UTIL_PROG replace start -B $error_dev_devid $DEV_REPLACE_TGT $SCRATCH_MNT -f ||\
+		_fail "btrfs device replace failed, devid $error_dev_devid"
+
+echo "Silence is golden"
+status=0; exit
diff --git a/tests/btrfs/087.out b/tests/btrfs/087.out
new file mode 100644
index 0000000..e84c64c
--- /dev/null
+++ b/tests/btrfs/087.out
@@ -0,0 +1,2 @@
+QA output created by 087
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e9c15af..d66b4fc 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -89,3 +89,4 @@
 084 auto quick send
 085 auto quick metadata subvol
 086 auto quick clone
+087 auto quick replace
-- 
2.0.0.153.g79dcccc

