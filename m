Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49700 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbcEQOca (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 10:32:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/6] fstests: btrfs: 027 make use of new device get and put helper functions
Date: Tue, 17 May 2016 22:32:07 +0800
Message-Id: <1463495530-425-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Below patches added helper function to get the requested
number of devices for scratch and spare device

fstest: btrfs: add functions to get and put a device for replace target
fstests: btrfs: add functions to set and reset required number of SCRATCH_DEV_POOL

This patch makes use of them.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/027 | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tests/btrfs/027 b/tests/btrfs/027
index f0844a14f8e6..905dc0ebaa27 100755
--- a/tests/btrfs/027
+++ b/tests/btrfs/027
@@ -57,17 +57,22 @@ _require_command "$WIPEFS_PROG" wipefs
 run_test()
 {
 	local mkfs_opts=$1
-	local saved_scratch_dev_pool=$SCRATCH_DEV_POOL
-	local replace_dev=`echo $SCRATCH_DEV_POOL | awk '{print $NF}'`
+	local ndevs=`echo $SCRATCH_DEV_POOL | wc -w`
+
+	# reserve one for replace target
+	((ndevs--))
+
+	_scratch_dev_pool_get $ndevs
+	_spare_dev_get
 
 	echo "Test $mkfs_opts" >>$seqres.full
 
-	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | sed -e "s# *$replace_dev *##"`
 	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
 	# make sure we created btrfs with desired options
 	if [ $? -ne 0 ]; then
 		echo "mkfs $mkfs_opts failed"
-		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		_spare_dev_put
+		_scratch_dev_pool_put
 		return
 	fi
 	_scratch_mount >>$seqres.full 2>&1
@@ -89,17 +94,19 @@ run_test()
 	_scratch_mount -o degraded >>$seqres.full 2>&1
 
 	# replace $missing_dev with $replace_dev and scrub it to double-check
-	$BTRFS_UTIL_PROG replace start -B -r $missing_dev_id $replace_dev \
+	$BTRFS_UTIL_PROG replace start -B -r $missing_dev_id $SPARE_DEV \
 		$SCRATCH_MNT -f >>$seqres.full 2>&1
 	if [ $? -ne 0 ]; then
 		echo "btrfs replace failed"
-		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		_spare_dev_put
+		_scratch_dev_pool_put
 		return
 	fi
 	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1
 	if [ $? -ne 0 ]; then
 		echo "btrfs scrub failed"
-		SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+		_spare_dev_put
+		_scratch_dev_pool_put
 		return
 	fi
 
@@ -107,7 +114,8 @@ run_test()
 	# we called _require_scratch_nocheck instead of _require_scratch
 	# do check after test for each profile config
 	_check_scratch_fs
-	SCRATCH_DEV_POOL=$saved_scratch_dev_pool
+	_spare_dev_put
+	_scratch_dev_pool_put
 }
 
 echo "Silence is golden"
-- 
2.7.0

