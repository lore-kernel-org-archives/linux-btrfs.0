Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28180 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbD3KLk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 06:11:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] xfstests: btrfs: test device delete with EIO on src dev
Date: Thu, 30 Apr 2015 18:08:47 +0800
Message-Id: <1430388527-16700-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test case tests if the device delete would work when
the source device has failed with EIO errors.

EIO errors are achieved usign the DM device.

Also this test needs the latest btrfs-progs and kernel patch
under title
  [PATCH] device delete by devid

When this patch is not found in the btrfs-progs, this test
will not run. However when the require patch is not found
in the kernel it will fail gracefully.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/rc           |  6 ++++
 tests/btrfs/088     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/088.out |  2 ++
 tests/btrfs/group   |  1 +
 4 files changed, 98 insertions(+)
 create mode 100755 tests/btrfs/088
 create mode 100644 tests/btrfs/088.out

diff --git a/common/rc b/common/rc
index 2a50491..a1df01b 100644
--- a/common/rc
+++ b/common/rc
@@ -2688,6 +2688,12 @@ _require_test_fcntl_advisory_locks()
 		_notrun "Require fcntl advisory locks support"
 }
 
+_require_btrfs_dev_del_by_devid()
+{
+	$BTRFS_UTIL_PROG device delete --help | egrep devid > /dev/null 2>&1
+	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support 'btrfs device delete <devid> /<mnt>')"
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/btrfs/088 b/tests/btrfs/088
new file mode 100755
index 0000000..a794352
--- /dev/null
+++ b/tests/btrfs/088
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. btrfs/088
+#
+# test device delete when the source device has EIO
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
+	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$DM_ERROR_DEV *##"`
+	_cleanup_dm_error_dev
+	SCRATCH_DEV_POOL="$SCRATCH_DEV_POOL $DEV_DELETE_SRC"
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
+_require_scratch_dev_pool 3
+_require_command "$WIPEFS_PROG" wipefs
+_require_btrfs_dev_del_by_devid
+
+# peal the last device in SCRATCH_DEV_POOL and assign it to DEV_DELETE_SRC
+DEV_DELETE_SRC="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $NF}'`"
+SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$DEV_DELETE_SRC *##"`
+
+# Create dm linear device /dev/mapper/error-dev using DEV_DELETE_SRC
+# DM_ERROR_DEV will have dm linear device set if created successfully
+_require_dm_error $DEV_REPLACE_SRC
+_init_dm_error_dev  $DEV_DELETE_SRC
+
+# assign created dm device to the scratch pool
+SCRATCH_DEV_POOL="$SCRATCH_DEV_POOL $DM_ERROR_DEV"
+
+echo DEV_DELETE_SRC=$DEV_DELETE_SRC >> $seqres.full
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
+$BTRFS_UTIL_PROG device delete $error_dev_devid $DEV_REPLACE_TGT $SCRATCH_MNT ||\
+		_fail "btrfs device delete failed, errno $errno, ret $?, devid $error_dev_devid"
+
+echo "Silence is golden"
+status=0; exit
diff --git a/tests/btrfs/088.out b/tests/btrfs/088.out
new file mode 100644
index 0000000..c24480a
--- /dev/null
+++ b/tests/btrfs/088.out
@@ -0,0 +1,2 @@
+QA output created by 088
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index d66b4fc..d474c47 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -90,3 +90,4 @@
 085 auto quick metadata subvol
 086 auto quick clone
 087 auto quick replace
+088 auto quick replace
-- 
2.0.0.153.g79dcccc

