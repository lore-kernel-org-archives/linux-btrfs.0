Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3F0KyV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 06:54:21 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5RAsHo4013964
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 18:54:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix several potential problems in copy_nocow_pages_for_inode
Date: Thu, 27 Jun 2013 18:51:00 +0800
Message-Id: <1372330260-1584-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372330260-1584-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372330260-1584-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- It makes no sense that we deal with a inode in the dead tree.
- fix the race between dio and page copy by waiting the dio completion
- avoid the page copy vs truncate/punch hole
- check if the page is in the page cache or not

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 186ea82..4ba2a69 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3224,6 +3224,11 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 		return PTR_ERR(local_root);
 	}
 
+	if (btrfs_root_refs(&local_root->root_item) == 0) {
+		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
+		return -ENOENT;
+	}
+
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.objectid = inum;
 	key.offset = 0;
@@ -3232,12 +3237,16 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
+	/* Avoid truncate/dio/punch hole.. */
+	mutex_lock(&inode->i_mutex);
+	inode_dio_wait(inode);
+
 	ret = 0;
 	physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
 	len = nocow_ctx->len;
 	while (len >= PAGE_CACHE_SIZE) {
 		index = offset >> PAGE_CACHE_SHIFT;
-
+again:
 		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
 		if (!page) {
 			pr_err("find_or_create_page() failed\n");
@@ -3258,7 +3267,18 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 				ret = err;
 				goto next_page;
 			}
+
 			lock_page(page);
+			/*
+			 * If the page has been remove from the page cache,
+			 * the data on it is meaningless, because it may be
+			 * old one, the new data may be written into the new
+			 * page in the page cache.
+			 */
+			if (page->mapping != inode->i_mapping) {
+				page_cache_release(page);
+				goto again;
+			}
 			if (!PageUptodate(page)) {
 				ret = -EIO;
 				goto next_page;
@@ -3280,6 +3300,7 @@ next_page:
 		len -= PAGE_CACHE_SIZE;
 	}
 out:
+	mutex_unlock(&inode->i_mutex);
 	iput(inode);
 	return ret;
 }
-- 
1.8.1.4

