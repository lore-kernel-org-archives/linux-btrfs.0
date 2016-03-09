Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20615 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcCIJx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 04:53:59 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] fstests: btrfs/011 add debug logs to seqres.full
Date: Wed,  9 Mar 2016 17:53:46 +0800
Message-Id: <1457517226-440-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455888329-16981-2-git-send-email-anand.jain@oracle.com>
References: <1455888329-16981-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds debug logs to $seqres.full and as the btrfs fi show command shows
unwanted extra errors from the previous test defunct volumes, avoid this
by adding wipefs -a of scratch_pool_device before the each sub test case.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2:
 Commit update and,
 Add wipefs for each of the scratch_pool_device, so that
 we circumvent a known issue about the 'btrfs fi show'
 that it reports extra warnings/errors about the defunct
 volumes.

 common/rc       | 10 ++++++++++
 tests/btrfs/011 | 21 +++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/common/rc b/common/rc
index 52c4a36ec8d9..4c6ec2d6448f 100644
--- a/common/rc
+++ b/common/rc
@@ -783,6 +783,16 @@ _scratch_pool_mkfs()
     esac
 }
 
+_scratch_pool_wipe()
+{
+	local sdp
+
+	for sdp in ${SCRATCH_DEV_POOL}; do
+		echo "$WIPEFS_PROG -a ${sdp}" >> $seqres.full
+		$WIPEFS_PROG -a ${sdp} > /dev/null 2>&1
+	done
+}
+
 # Create fs of certain size on scratch device
 # _scratch_mkfs_sized <size in bytes> [optional blocksize]
 _scratch_mkfs_sized()
diff --git a/tests/btrfs/011 b/tests/btrfs/011
index 3bc7f0af70a3..e93ab8769536 100755
--- a/tests/btrfs/011
+++ b/tests/btrfs/011
@@ -64,6 +64,7 @@ _supported_fs btrfs
 _require_scratch_nocheck
 _require_scratch_dev_pool 4
 _require_command "$BTRFS_SHOW_SUPER_PROG" btrfs-show-super
+_require_command "$WIPEFS_PROG" wipefs
 
 rm -f $seqres.full
 rm -f $tmp.tmp
@@ -80,6 +81,11 @@ workout()
 	local target_dev="`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`"
 	local fssize
 
+	_scratch_pool_wipe
+
+	echo >> $seqres.full
+	echo "---------workout \"$1\" $2 $3 $4-----------" >> $seqres.full
+
 	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt `expr $num_devs4raid + 1` ]; then
 		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
 		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL, required: " `expr $num_devs4raid + 1` >> $seqres.full
@@ -112,8 +118,14 @@ workout()
 		_notrun "device size too small"
 	fi
 
+	# Since mkfs on target_dev was only to find size, wipefs after about
+	# size is done
+	$WIPEFS_PROG -a ${target_dev} > /dev/null 2>&1
 	_scratch_mount
 
+	echo "$BTRFS_UTIL_PROG filesystem show (1)" >> $seqres.full
+	$BTRFS_UTIL_PROG filesystem show >> $seqres.full 2>&1
+
 	# Generate metadata and some minimal user data, generate 500 times
 	# 20K extents in the data chunk and fill up metadata with inline
 	# extents.
@@ -220,8 +232,10 @@ btrfs_replace_test()
 
 	if [ "${with_cancel}Q" = "cancelQ" ]; then
 		# background the replace operation (no '-B' option given)
+		echo "$BTRFS_UTIL_PROG replace start -f $replace_options $source_dev $target_dev $SCRATCH_MNT" >> $seqres.full
 		$BTRFS_UTIL_PROG replace start -f $replace_options $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
 		sleep 1
+		echo "$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT" >> $seqres.full
 		$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace cancel failed"
 
 		# 'replace status' waits for the replace operation to finish
@@ -236,6 +250,7 @@ btrfs_replace_test()
 			# a sync in the middle of the replace operation.
 			(sleep 1; sync) > /dev/null 2>&1 &
 		fi
+		echo "$BTRFS_UTIL_PROG replace start -Bf $replace_options $source_dev $target_dev $SCRATCH_MNT" >> $seqres.full
 		$BTRFS_UTIL_PROG replace start -Bf $replace_options $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
 
 		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
@@ -267,9 +282,15 @@ btrfs_replace_test()
 	_scratch_unmount > /dev/null 2>&1
 	if [ "${with_cancel}Q" != "cancelQ" ]; then
 		# after the replace operation, use the target_dev for everything
+		echo "$BTRFS_UTIL_PROG filesystem show -d (2)" >> $seqres.full
+		$BTRFS_UTIL_PROG filesystem show -d >> $seqres.full 2>&1
+		echo "$BTRFS_UTIL_PROG filesystem show (3)" >> $seqres.full
+		$BTRFS_UTIL_PROG filesystem show >> $seqres.full 2>&1
+		echo "_check_btrfs_filesystem $target_dev" >> $seqres.full
 		_check_btrfs_filesystem $target_dev
 		_mount -t $FSTYP `_scratch_mount_options | sed "s&${SCRATCH_DEV}&${target_dev}&"`
 	else
+		echo "_check_btrfs_filesystem $source_dev" >> $seqres.full
 		_check_btrfs_filesystem $source_dev
 		_scratch_mount
 	fi
-- 
2.7.0

