Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35374 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcEQOco (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 10:32:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 6/6] fstests: btrfs: test RAID5 device reappear and balance
Date: Tue, 17 May 2016 22:32:10 +0800
Message-Id: <1463495530-425-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test does the following:
Initialize a RAID5 with some data

Re-mount RAID5 degraded with _dev3_ missing and write data.
Save md5sum checkpoint1

Re-mount healthy RAID5

Let balance fix degraded blocks.
Save md5sum checkpoint2

Re-mount RAID1 degraded now with _dev1_ missing.
Save md5sum checkpoint3

Verify if all three md5sum matches

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/122     | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/122.out |   8 +++
 tests/btrfs/group   |   1 +
 3 files changed, 187 insertions(+)
 create mode 100755 tests/btrfs/122
 create mode 100644 tests/btrfs/122.out

diff --git a/tests/btrfs/122 b/tests/btrfs/122
new file mode 100755
index 000000000000..89c0103fef08
--- /dev/null
+++ b/tests/btrfs/122
@@ -0,0 +1,178 @@
+#! /bin/bash
+# FS QA Test 122
+#
+# This test verify if the reconstructed data on the RAID5 is good.
+# Steps:
+# Initialize RAID5 with some data
+#
+# Re-mount RAID5 degraded with dev3 missing and write data
+# Save md5sum checkpoint1
+#
+# Re-mount healthy RAID5
+#
+# Let balance fix the RAID5.
+# Save md5sum checkpoint2
+#
+# Re-mount RAID5 degraded with dev1 as missing.
+# Save md5sum checkpoint3
+#
+# Verify if all three checkpoints match
+#
+#---------------------------------------------------------------------
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
+#---------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
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
+_require_scratch_nocheck
+_require_scratch_dev_pool 3
+
+# we need btrfs to unload, need test dir unmounted
+_test_unmount
+_require_btrfs_unloadable
+
+_scratch_dev_pool_get 3
+
+dev1=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+dev2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
+dev3=`echo $SCRATCH_DEV_POOL | awk '{print $3}'`
+
+echo dev1=$dev1 >> $seqres.full
+echo dev2=$dev2 >> $seqres.full
+echo dev3=$dev3 >> $seqres.full
+
+# Balance won't be successful if filled too much
+dev1_sz=`blockdev --getsize64 $dev1`
+dev2_sz=`blockdev --getsize64 $dev2`
+dev3_sz=`blockdev --getsize64 $dev3`
+
+# get min of both
+max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz\n$dev3_sz" | sort | head -1`
+if [ $max_fs_sz -gt 1000000 ]; then
+	bs="1M"
+	count=$(( max_fs_sz/1000000 ))
+	count=$(( count/100 ))
+else
+	_notrun "Smallest dev size $max_fs_sz, Need at least 2M"
+fi
+
+#-------------init-------------------
+echo >> $seqres.full
+echo "max_fs_sz=$max_fs_sz count=$count" >> $seqres.full
+echo "-----Initialize -----" >> $seqres.full
+_scratch_pool_mkfs "-mraid5 -draid5" >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+dd if=/dev/zero of="$SCRATCH_MNT"/tf1 bs=$bs count=1 \
+					>>$seqres.full 2>&1
+_run_btrfs_util_prog filesystem show
+_run_btrfs_util_prog filesystem df $SCRATCH_MNT
+count=$(( count-- ))
+
+
+#-------------degraded-init-------------------
+echo >> $seqres.full
+echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
+echo
+echo "Write data with degraded mount"
+
+echo "unmount" >> $seqres.full
+_scratch_unmount
+echo "clean btrfs ko" >> $seqres.full
+_reload_btrfs_ko
+_mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
+dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
+					>>$seqres.full 2>&1
+_run_btrfs_util_prog filesystem show
+_run_btrfs_util_prog filesystem df $SCRATCH_MNT
+checkpoint1=`md5sum $SCRATCH_MNT/tf2`
+echo $checkpoint1 >> $seqres.full 2>&1
+
+#-------------balance-------------------
+echo >> $seqres.full
+echo "-----Mount normal-----" >> $seqres.full
+echo
+echo "Mount normal after balance"
+
+_scratch_unmount
+_run_btrfs_util_prog device scan
+_scratch_mount >> $seqres.full 2>&1
+
+echo >> $seqres.full
+_run_btrfs_util_prog balance start ${SCRATCH_MNT}
+
+_run_btrfs_util_prog filesystem show
+_run_btrfs_util_prog filesystem df ${SCRATCH_MNT}
+
+checkpoint2=`md5sum $SCRATCH_MNT/tf2`
+echo $checkpoint2 >> $seqres.full 2>&1
+
+#-------------degraded-mount-------------------
+echo >> $seqres.full
+echo "-----Mount degraded with dev1 missing-----" >> $seqres.full
+echo
+echo "Mount degraded but with other dev"
+
+_scratch_unmount
+_reload_btrfs_ko
+
+_mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
+
+_run_btrfs_util_prog filesystem show
+_run_btrfs_util_prog filesystem df $SCRATCH_MNT
+checkpoint3=`md5sum $SCRATCH_MNT/tf2`
+echo $checkpoint3 >> $seqres.full 2>&1
+
+if [ "$checkpoint1" != "$checkpoint2" ]; then
+	echo $checkpoint1
+	echo $checkpoint2
+	_fail "Inital sum does not match with after balance"
+fi
+
+if [ "$checkpoint1" != "$checkpoint3" ]; then
+	echo $checkpoint1
+	echo $checkpoint3
+	_fail "Inital sum does not match with data on dev2 written by balance"
+fi
+
+_scratch_dev_pool_put
+_test_mount
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/122.out b/tests/btrfs/122.out
new file mode 100644
index 000000000000..5bac6be9bec2
--- /dev/null
+++ b/tests/btrfs/122.out
@@ -0,0 +1,8 @@
+QA output created by 122
+
+Write data with degraded mount
+
+Mount normal after balance
+
+Mount degraded but with other dev
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5c28a3ca0687..848037bbacd8 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -123,3 +123,4 @@
 119 auto quick snapshot metadata qgroup
 120 auto quick snapshot metadata
 121 auto replace
+122 auto replace
-- 
2.7.0

