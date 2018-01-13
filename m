Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43794 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965201AbeAMCHh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 21:07:37 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: common/rc: fix device still mounted error with SCRATCH_DEV_POOL
Date: Fri, 12 Jan 2018 18:04:59 -0700
Message-Id: <20180113010459.24321-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of btrfs tests, btrfs/011, uses SCRATCH_DEV_POOL and puts a non-SCRATCH_DEV
device as the first one when doing mkfs, and this makes
_require_scratch{_nocheck} fail to umount $SCRATCH_MNT since it checks mount
point with SCRATCH_DEV only, and for sure it finds nothing to umount and the
following tests complain about 'device still mounted' alike errors.

Introduce a helper to address this special case where both btrfs and scratch
dev pool are in use.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 common/rc | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/common/rc b/common/rc
index 9216efd..eab1bb7 100644
--- a/common/rc
+++ b/common/rc
@@ -1450,6 +1450,29 @@ _check_mounted_on()
 	return 0 # 0 = mounted as expected
 }
 
+_check_scratch_dev_pool_mounted_on()
+{
+	local devname=$1
+	local dev=$2
+	local mntname=$3
+	local mnt=$4
+
+	local mount_rec=`findmnt -rncv -M $mnt -o SOURCE,TARGET`
+	[ -n "$mount_rec" ] || return 1 # 1 = not mounted
+
+	# if it's mounted, make sure mount dev is one of the pool devices
+	for mount_dev in $SCRATCH_DEV_POOL; do
+		if [ "$mount_rec" == "$mount_dev $mnt" ]; then
+			return 0 # 0 = mounted as expected
+		fi
+	done
+
+	echo "$devname=$dev is mounted but not on $mntname=$mnt - aborting"
+	echo "Already mounted result:"
+	echo $mount_rec
+	return 2 # 2 == mounted on wrong mnt
+}
+
 # this test needs a scratch partition - check we're ok & unmount it
 # No post-test check of the device is required. e.g. the test intentionally
 # finishes the test with the filesystem in a corrupt state
@@ -1537,6 +1560,14 @@ _require_scratch_nocheck()
     _check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT
     local err=$?
     [ $err -le 1 ] || exit 1
+
+    if [ $err -eq 1 -a "$FSTYP" == "btrfs" -a ! -z "$SCRATCH_DEV_POOL" ]
+    then
+	_check_scratch_dev_pool_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT
+	err=$?
+	[ $err -le 1 ] || exit 1
+    fi
+
     if [ $err -eq 0 ]
     then
         # if it's mounted, unmount it
-- 
2.5.0

