Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbcF3K51 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 06:57:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/6] fstests: btrfs: test RAID1 device reappear and balanced
Date: Thu, 30 Jun 2016 18:58:21 +0800
Message-Id: <1467284301-3410-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463495530-425-5-git-send-email-anand.jain@oracle.com>
References: <1463495530-425-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

The test does the following:
  Initialize a RAID1 with some data

  Re-mount RAID1 degraded with _dev1_ and write up to
  half of the FS capacity
  Save md5sum checkpoint1

  Re-mount healthy RAID1

  Let balance re-silver.
  Save md5sum checkpoint2

  Re-mount RAID1 degraded with _dev2_
  Save md5sum checkpoint3

  Verify if all three md5sum match

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3:
  Removed _require_scratch_nocheck
  Fix fs fill size, 1.2g took 1xxsec, looks reasonable
  Log and .out typo fix
  Rebase on latest fstests
v2:
  add tmp= and its rm
  add comments to why _reload_btrfs_ko is used
  add missing put and test_mount at notrun exit
  use echo instead of _fail when checkpoints are checked
  .out updated to remove Silence..

 tests/btrfs/124     | 166 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/124.out |   7 +++
 tests/btrfs/group   |   1 +
 3 files changed, 174 insertions(+)
 create mode 100755 tests/btrfs/124
 create mode 100644 tests/btrfs/124.out

diff --git a/tests/btrfs/124 b/tests/btrfs/124
new file mode 100755
index 000000000000..731614431e78
--- /dev/null
+++ b/tests/btrfs/124
@@ -0,0 +1,166 @@
+#! /bin/bash
+# FS QA Test 124
+#
+# This test verify the RAID1 reconstruction on the reappeared
+# device. By using the following steps:
+# Initialize a RAID1 with some data
+#
+# Re-mount RAID1 degraded with dev2 missing and write up to
+# half of the FS capacity.
+# Save md5sum checkpoint1
+#
+# Re-mount healthy RAID1
+#
+# Let balance re-silver.
+# Save md5sum checkpoint2
+#
+# Re-mount RAID1 degraded with dev1 missing
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
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dev_pool 2
+
+# the mounted test dir prevent btrfs unload, we need to unmount
+_test_unmount
+_require_btrfs_loadable
+
+_scratch_dev_pool_get 2
+
+dev1=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+dev2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
+
+dev1_sz=`blockdev --getsize64 $dev1`
+dev2_sz=`blockdev --getsize64 $dev2`
+# get min of both
+max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort | head -1`
+# Need disks with more than 2G.
+if [ $max_fs_sz -lt 2000000000 ]; then
+	_scratch_dev_pool_put
+	_test_mount
+	_notrun "Smallest dev size $max_fs_sz, Need at least 2G"
+fi
+max_fs_sz=1200000000
+bs="1M"
+count=$(($max_fs_sz / 1000000))
+
+echo >> $seqres.full
+echo "max_fs_sz=$max_fs_sz count=$count" >> $seqres.full
+echo "-----Initialize -----" >> $seqres.full
+_scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+_run_btrfs_util_prog filesystem show
+dd if=/dev/zero of="$SCRATCH_MNT"/tf1 bs=$bs count=1 \
+					>>$seqres.full 2>&1
+count=$(( count-- ))
+echo "unmount" >> $seqres.full
+echo "clean btrfs ko" >> $seqres.full
+_scratch_unmount
+
+# un-scan the btrfs devices
+_reload_btrfs_ko
+
+echo >> $seqres.full
+echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
+echo
+echo "Write data with degraded mount"
+# Since we didn't run dev scan, btrfs kernel does not know
+# about the dev2
+# don't use _scratch_mount as we want to control
+# the device used for mounting.
+
+_mount -o degraded $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
+_run_btrfs_util_prog filesystem show
+dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
+					>>$seqres.full 2>&1
+checkpoint1=`md5sum $SCRATCH_MNT/tf2`
+echo $checkpoint1 >> $seqres.full 2>&1
+_scratch_unmount
+echo "unmount" >> $seqres.full
+
+echo >> $seqres.full
+echo "-----Mount normal-----" >> $seqres.full
+echo
+echo "Mount normal and balance"
+_run_btrfs_util_prog device scan
+_scratch_mount >> $seqres.full 2>&1
+_run_btrfs_util_prog filesystem show
+echo >> $seqres.full
+_run_btrfs_util_prog balance start ${SCRATCH_MNT}
+
+checkpoint2=`md5sum $SCRATCH_MNT/tf2`
+echo $checkpoint2 >> $seqres.full 2>&1
+
+echo >> $seqres.full
+echo "-----Mount degraded with the other dev -----" >> $seqres.full
+echo
+echo "Mount degraded with the other dev"
+_scratch_unmount
+# un-scan the btrfs devices
+_reload_btrfs_ko
+_mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
+_run_btrfs_util_prog filesystem show
+checkpoint3=`md5sum $SCRATCH_MNT/tf2`
+echo $checkpoint3 >> $seqres.full 2>&1
+
+if [ "$checkpoint1" != "$checkpoint2" ]; then
+	echo $checkpoint1
+	echo $checkpoint2
+	echo "Inital sum does not match with after balance"
+fi
+
+if [ "$checkpoint1" != "$checkpoint3" ]; then
+	echo $checkpoint1
+	echo $checkpoint3
+	echo "Inital sum does not match with data on dev2 written by balance"
+fi
+
+_scratch_dev_pool_put
+_test_mount
+
+status=0
+exit
diff --git a/tests/btrfs/124.out b/tests/btrfs/124.out
new file mode 100644
index 000000000000..cc3bb34efccb
--- /dev/null
+++ b/tests/btrfs/124.out
@@ -0,0 +1,7 @@
+QA output created by 124
+
+Write data with degraded mount
+
+Mount normal and balance
+
+Mount degraded with the other dev
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 5a26ed737496..ba13e128b173 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -126,3 +126,4 @@
 121 auto quick snapshot qgroup
 122 auto quick snapshot qgroup
 123 auto quick qgroup
+124 auto replace
-- 
2.7.0

