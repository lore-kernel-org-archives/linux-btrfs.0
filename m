Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35136 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbeEPKCF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 06:02:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G9uiKY088644
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:02:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hx29w447s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:02:04 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA23BC025863
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:02:04 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4GA23Pl003371
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:02:03 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs/161: test raid1 missing writes
Date: Wed, 16 May 2018 18:04:30 +0800
Message-Id: <20180516100430.7837-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test to make sure that a raid1 device with missed write reads
good data when reassembled.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---

This test case fails as of now.

I am sending this to btrfs ML only as it depends on the
read_mirror_policy kernel patches which is in the ML.

Please use it using the mount option config.

MOUNT_OPTIONS="-o max_inline=0,nodatacow"
 OR
MOUNT_OPTIONS="-o max_inline=0,nodatasum"

max_inline=0 will make sure the data is not read when metadata is
read and we have the control on its checksum and datacow.

You can't reproduce it without nodatacow OR nodatasum because cow
and datasum makes the data block on the disk invalid just by fluke.

 tests/btrfs/161     | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/161.out |   7 +++
 tests/btrfs/group   |   1 +
 tests/generic/479   |   0
 4 files changed, 168 insertions(+)
 create mode 100755 tests/btrfs/161
 create mode 100644 tests/btrfs/161.out
 mode change 100644 => 100755 tests/generic/479

diff --git a/tests/btrfs/161 b/tests/btrfs/161
new file mode 100755
index 000000000000..6c5dd9da389b
--- /dev/null
+++ b/tests/btrfs/161
@@ -0,0 +1,160 @@
+#! /bin/bash
+# FS QA Test 161
+#
+# Test to make sure that RAID1 write hole reads good data.
+# To see the failure use the following mount options.
+#   -o max_inline=0,nodatasum
+#   or
+#   -o max_inline=0,nodatacow
+#  and needs ML kernel patch so that we can avoid the arbitary
+#  disk to be used to read the mirror (which is based on the PID).
+#
+#  btrfs: add mount option read_mirror_policy
+#  btrfs: add read_mirror_policy parameter devid
+#  btrfs: read_mirror_policy ability to reset
+#
+#---------------------------------------------------------------------
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
+. ./common/module
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch_dev_pool 2
+_require_loadable_fs_module "btrfs"
+
+_scratch_dev_pool_get 2
+
+MNT_OPT=$(echo $MOUNT_OPTIONS | cut -d" " -f2-)
+
+BS=20
+COUNT=1
+TF="$SCRATCH_MNT/testfile"
+
+CHECKPOINT1=""
+CHECKPOINT2=""
+CHECKPOINT3=""
+DEV_GOOD=""
+DEV_BAD=""
+DEVID_BAD=""
+
+#RAID1 devs good (devid 1) and bad (devid 2)
+DEV_GOOD=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
+DEV_BAD=$(echo $SCRATCH_DEV_POOL | awk '{print $2}')
+echo DEV_GOOD=$DEV_GOOD" "DEV_BAD=$DEV_BAD >> $seqres.full
+
+mount_bad()
+{
+	run_check _mount -o $MNT_OPT,read_mirror_policy=$DEVID_BAD,device=$DEV_GOOD $DEV_BAD $SCRATCH_MNT
+}
+
+mount_good_remount_bad()
+{
+	run_check _mount -o $MNT_OPT,read_mirror_policy=$DEVID_GOOD,device=$DEV_GOOD $DEV_BAD $SCRATCH_MNT
+	run_check _mount -o $MNT_OPT,remount,read_mirror_policy=-$DEVID_GOOD,read_mirror_policy=$DEVID_BAD,device=$DEV_GOOD $DEV_BAD $SCRATCH_MNT
+}
+
+check()
+{
+	echo -e "\\n-- check --" | tee -a $seqres.full
+
+	_reload_fs_module "btrfs"
+
+	echo ------ check mount ------------------ >> /dev/kmsg && dmesg -C
+
+if (false); then
+	# parent transid verify failed, data corruption
+	mount_bad
+else
+	# silent data corruption
+	mount_good_remount_bad
+fi
+
+	CHECKPOINT3=$(md5sum $TF | cut -d" " -f1)
+	mdres_status=$?
+	echo mdres_status=$mdres_status >> $seqres.full
+	echo CHECKPOINT3=$CHECKPOINT3 >> $seqres.full
+
+	[[ $mdres_status -ne 0 ]] &&
+		_fail "Read failed in non-degraded mount. What happened to the mirror."
+
+	[[ $CHECKPOINT2 != $CHECKPOINT3 ]] &&
+		_fail "Read junk data !!!"
+}
+
+write_degrade()
+{
+	echo -e "\\n-- degrade write --" | tee -a $seqres.full
+
+	_reload_fs_module "btrfs"
+	echo ------ degrade mount ------------------ >> /dev/kmsg && dmesg -C
+	run_check _mount -o $MNT_OPT,degraded $DEV_GOOD $SCRATCH_MNT
+
+	run_check dd if=/dev/urandom of=$TF bs=$BS count=$COUNT conv=fsync
+	CHECKPOINT2=$(md5sum $TF | cut -d" " -f1)
+	echo CHECKPOINT2=$CHECKPOINT2 >> $seqres.full
+	_scratch_unmount
+}
+
+setup()
+{
+	echo -e "\\n-- setup --" | tee -a $seqres.full
+
+	_scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
+	DEVID_BAD=$($BTRFS_UTIL_PROG filesystem show $DEV_BAD |\
+					grep $DEV_BAD | awk '{print $2}')
+	DEVID_GOOD=$($BTRFS_UTIL_PROG filesystem show $DEV_GOOD |\
+					grep $DEV_GOOD | awk '{print $2}')
+	run_check _mount -o $MNT_OPT,device=$DEV_GOOD $DEV_BAD $SCRATCH_MNT
+	run_check dd if=/dev/urandom of=$TF bs=$BS count=$COUNT conv=fsync
+	_scratch_unmount
+}
+
+setup
+write_degrade
+check
+
+_scratch_unmount
+_scratch_dev_pool_put
+
+status=0
+exit
diff --git a/tests/btrfs/161.out b/tests/btrfs/161.out
new file mode 100644
index 000000000000..4bf1af150b6d
--- /dev/null
+++ b/tests/btrfs/161.out
@@ -0,0 +1,7 @@
+QA output created by 161
+
+-- setup --
+
+-- degrade write --
+
+-- check --
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f04ee8d5297c..fe83631f0f33 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -163,3 +163,4 @@
 158 auto quick raid scrub
 159 auto quick
 160 auto quick
+161 auto quick
diff --git a/tests/generic/479 b/tests/generic/479
old mode 100644
new mode 100755
-- 
2.7.0

