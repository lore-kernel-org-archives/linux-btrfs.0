Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:30536 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab3HPOvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 10:51:23 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: silence btrfs balance in btrfs/003
Date: Fri, 16 Aug 2013 16:51:20 +0200
Message-Id: <1376664680-16046-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test failed for me with output from 'btrfs balance':
     QA output created by 003
    +Done, had to relocate 4 out of 4 chunks
    +Done, had to relocate 5 out of 5 chunks
     Silence is golden

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 tests/btrfs/003 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 3790935..795badb 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -109,7 +109,7 @@ _test_add()
 	for i in `seq 1 $n`; do
 		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
 	done
-	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "balance failed"
 	umount $SCRATCH_MNT
 }
 
@@ -152,7 +152,7 @@ _test_replace()
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
 	# sleep 10
-	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
 	umount $SCRATCH_MNT
-- 
1.8.3.4

