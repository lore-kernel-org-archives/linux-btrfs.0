Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:33286 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbeHWDD2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 23:03:28 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: btrfs_get_extent: put btrfs_free_path ahead
Date: Thu, 23 Aug 2018 07:36:17 +0800
Message-Id: <1534980978-91392-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

trace_btrfs_get_extent() has nothing to do with path, place
btrfs_free_path ahead so that we can unlock path on error.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 31d43355f052..6a0380f3f318 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7000,10 +7000,10 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	err = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	write_unlock(&em_tree->lock);
 out:
+	btrfs_free_path(path);
 
 	trace_btrfs_get_extent(root, inode, em);
 
-	btrfs_free_path(path);
 	if (err) {
 		free_extent_map(em);
 		return ERR_PTR(err);
-- 
1.8.3.1
