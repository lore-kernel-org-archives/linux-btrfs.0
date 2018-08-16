Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57394 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbeHQAGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 20:06:33 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove always true if branch in btrfs_get_extent
Date: Fri, 17 Aug 2018 05:05:28 +0800
Message-Id: <1534453528-13556-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@path is always NULL when it comes to the if branch.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8b135a46835f..4b79916472fb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6825,18 +6825,15 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	em->len = (u64)-1;
 	em->block_len = (u64)-1;
 
+	path = btrfs_alloc_path();
 	if (!path) {
-		path = btrfs_alloc_path();
-		if (!path) {
-			err = -ENOMEM;
-			goto out;
-		}
-		/*
-		 * Chances are we'll be called again, so go ahead and do
-		 * readahead
-		 */
-		path->reada = READA_FORWARD;
+		err = -ENOMEM;
+		goto out;
 	}
+	/*
+	 * Chances are we'll be called again, so go ahead and do readahead.
+	 */
+	path->reada = READA_FORWARD;
 
 	ret = btrfs_lookup_file_extent(NULL, root, path, objectid, start, 0);
 	if (ret < 0) {
-- 
1.8.3.1
