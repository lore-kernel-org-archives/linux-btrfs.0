Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24046 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1427206AbcBSNZm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 08:25:42 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/2] fstests: btrfs/011 use replace_options
Date: Fri, 19 Feb 2016 21:25:28 +0800
Message-Id: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes test btrfs/011 which intended to use -r option
but was never used since its associated args 'replace_options'
didn't make it to the cli.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/011 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/011 b/tests/btrfs/011
index 72c53abfbed0..3bc7f0af70a3 100755
--- a/tests/btrfs/011
+++ b/tests/btrfs/011
@@ -220,7 +220,7 @@ btrfs_replace_test()
 
 	if [ "${with_cancel}Q" = "cancelQ" ]; then
 		# background the replace operation (no '-B' option given)
-		$BTRFS_UTIL_PROG replace start -f $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
+		$BTRFS_UTIL_PROG replace start -f $replace_options $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
 		sleep 1
 		$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace cancel failed"
 
@@ -236,7 +236,7 @@ btrfs_replace_test()
 			# a sync in the middle of the replace operation.
 			(sleep 1; sync) > /dev/null 2>&1 &
 		fi
-		$BTRFS_UTIL_PROG replace start -Bf $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
+		$BTRFS_UTIL_PROG replace start -Bf $replace_options $source_dev $target_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
 
 		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
 		cat $tmp.tmp >> $seqres.full
-- 
2.7.0

