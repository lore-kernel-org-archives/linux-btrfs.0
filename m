Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaB0J3K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 04:29:10 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1R9T9ex016427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 09:29:09 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s1R9T8ea028654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 09:29:09 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s1R9T86o028641
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 09:29:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: skip search tree for REG files
Date: Thu, 27 Feb 2014 17:29:01 +0800
Message-Id: <1393493341-19107-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is really unnecessary to search tree again for @gen, @mode and @rdev
in the case of REG inodes' creation, as we've got btrfs_inode_item in sctx,
and @gen, @mode and @rdev can easily be fetched.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/send.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3609685..5b493e8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -109,6 +109,7 @@ struct send_ctx {
 	int cur_inode_deleted;
 	u64 cur_inode_size;
 	u64 cur_inode_mode;
+	u64 cur_inode_rdev;
 	u64 cur_inode_last_extent;
 
 	u64 send_progress;
@@ -2432,10 +2433,16 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 	if (!p)
 		return -ENOMEM;
 
-	ret = get_inode_info(sctx->send_root, ino, NULL, &gen, &mode, NULL,
-			NULL, &rdev);
-	if (ret < 0)
-		goto out;
+	if (ino != sctx->cur_ino) {
+		ret = get_inode_info(sctx->send_root, ino, NULL, &gen, &mode,
+				     NULL, NULL, &rdev);
+		if (ret < 0)
+			goto out;
+	} else {
+		gen = sctx->cur_inode_gen;
+		mode = sctx->cur_inode_mode;
+		rdev = sctx->cur_inode_rdev;
+	}
 
 	if (S_ISREG(mode)) {
 		cmd = BTRFS_SEND_C_MKFILE;
@@ -4827,6 +4834,8 @@ static int changed_inode(struct send_ctx *sctx,
 				sctx->left_path->nodes[0], left_ii);
 		sctx->cur_inode_mode = btrfs_inode_mode(
 				sctx->left_path->nodes[0], left_ii);
+		sctx->cur_inode_rdev = btrfs_inode_rdev(
+				sctx->left_path->nodes[0], left_ii);
 		if (sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID)
 			ret = send_create_inode_if_needed(sctx);
 	} else if (result == BTRFS_COMPARE_TREE_DELETED) {
@@ -4871,6 +4880,8 @@ static int changed_inode(struct send_ctx *sctx,
 					sctx->left_path->nodes[0], left_ii);
 			sctx->cur_inode_mode = btrfs_inode_mode(
 					sctx->left_path->nodes[0], left_ii);
+			sctx->cur_inode_rdev = btrfs_inode_rdev(
+					sctx->left_path->nodes[0], left_ii);
 			ret = send_create_inode_if_needed(sctx);
 			if (ret < 0)
 				goto out;
-- 
1.8.2.1

