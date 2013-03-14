Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46267 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3CNO7x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 10:59:53 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2EExqME031000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 14:59:53 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2EExpxr015741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 14:59:52 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2EExpBo024341
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 09:59:51 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use helper to cleanup tree roots
Date: Thu, 14 Mar 2013 22:58:05 +0800
Message-Id: <1363273085-15598-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

free_root_pointers() has been introduced to cleanup all of tree roots,
so just use it instead.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d84651..7136643 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3420,20 +3420,7 @@ int close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	free_extent_buffer(fs_info->extent_root->node);
-	free_extent_buffer(fs_info->extent_root->commit_root);
-	free_extent_buffer(fs_info->tree_root->node);
-	free_extent_buffer(fs_info->tree_root->commit_root);
-	free_extent_buffer(fs_info->chunk_root->node);
-	free_extent_buffer(fs_info->chunk_root->commit_root);
-	free_extent_buffer(fs_info->dev_root->node);
-	free_extent_buffer(fs_info->dev_root->commit_root);
-	free_extent_buffer(fs_info->csum_root->node);
-	free_extent_buffer(fs_info->csum_root->commit_root);
-	if (fs_info->quota_root) {
-		free_extent_buffer(fs_info->quota_root->node);
-		free_extent_buffer(fs_info->quota_root->commit_root);
-	}
+	free_root_pointers(fs_info, 1);
 
 	btrfs_free_block_groups(fs_info);
 
-- 
1.7.7.6

