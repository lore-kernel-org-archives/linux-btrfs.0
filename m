Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19388 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1427335AbcBSNZn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 08:25:43 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/2] fstests: btrfs/011 add debug logs to seqres.full
Date: Fri, 19 Feb 2016 21:25:29 +0800
Message-Id: <1455888329-16981-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
References: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/011 | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tests/btrfs/011 b/tests/btrfs/011
index 3bc7f0af70a3..8cf6ff265aa5 100755
--- a/tests/btrfs/011
+++ b/tests/btrfs/011
@@ -80,6 +80,9 @@ workout()
 	local target_dev="`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`"
 	local fssize
 
+	echo >> $seqres.full
+	echo "---------workout \"$1\" $2 $3 $4-----------" >> $seqres.full
+
 	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt `expr $num_devs4raid + 1` ]; then
 		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
 		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL, required: " `expr $num_devs4raid + 1` >> $seqres.full
@@ -114,6 +117,9 @@ workout()
 
 	_scratch_mount
 
+	echo "$BTRFS_UTIL_PROG filesystem show" >> $seqres.full
+	$BTRFS_UTIL_PROG filesystem show >> $seqres.full
+
 	# Generate metadata and some minimal user data, generate 500 times
 	# 20K extents in the data chunk and fill up metadata with inline
 	# extents.
@@ -220,8 +226,10 @@ btrfs_replace_test()
 
 	if [ "${with_cancel}Q" = "cancelQ" ]; then
 		# background the replace operation (no '-B' option given)
+		echo "$BTRFS_UTIL_PROG replace start -f $replace_options $source_dev $target_dev $SCRATCH_MNT" >> $seqres.full
 		$BTRFS_UTIL_PROG replace start -f $replace_options $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
 		sleep 1
+		echo "$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT" >> $seqres.full
 		$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace cancel failed"
 
 		# 'replace status' waits for the replace operation to finish
@@ -236,6 +244,7 @@ btrfs_replace_test()
 			# a sync in the middle of the replace operation.
 			(sleep 1; sync) > /dev/null 2>&1 &
 		fi
+		echo "$BTRFS_UTIL_PROG replace start -Bf $replace_options $source_dev $target_dev $SCRATCH_MNT" >> $seqres.full
 		$BTRFS_UTIL_PROG replace start -Bf $replace_options $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
 
 		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
@@ -267,6 +276,11 @@ btrfs_replace_test()
 	_scratch_unmount > /dev/null 2>&1
 	if [ "${with_cancel}Q" != "cancelQ" ]; then
 		# after the replace operation, use the target_dev for everything
+		echo "$BTRFS_UTIL_PROG filesystem show -d" >> $seqres.full
+		$BTRFS_UTIL_PROG filesystem show -d >> $seqres.full
+		echo "$BTRFS_UTIL_PROG filesystem show" >> $seqres.full
+		$BTRFS_UTIL_PROG filesystem show >> $seqres.full
+		echo "_check_btrfs_filesystem $target_dev" >> $seqres.full
 		_check_btrfs_filesystem $target_dev
 		_mount -t $FSTYP `_scratch_mount_options | sed "s&${SCRATCH_DEV}&${target_dev}&"`
 	else
-- 
2.7.0

