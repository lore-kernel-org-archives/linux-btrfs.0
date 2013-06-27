Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3F0KyU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 06:54:20 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5RAsHpB013965
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 18:54:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: cleanup the code of copy_nocow_pages_for_inode()
Date: Thu, 27 Jun 2013 18:50:59 +0800
Message-Id: <1372330260-1584-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372330260-1584-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372330260-1584-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- It make no sense that we continue to do something after the error
  happened, just go back with this patch.
- remove some check of copy_nocow_pages_for_inode(), such as page check
  after write, inode check in the end of the function, because we are
  sure they exist.
- remove the unnecessary goto in the return value check of the write

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c1647f8..186ea82 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3199,16 +3199,18 @@ out:
 
 static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 {
-	unsigned long index;
 	struct scrub_copy_nocow_ctx *nocow_ctx = ctx;
-	int ret = 0;
+	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->dev_root->fs_info;
 	struct btrfs_key key;
-	struct inode *inode = NULL;
+	struct inode *inode;
+	struct page *page;
 	struct btrfs_root *local_root;
 	u64 physical_for_dev_replace;
 	u64 len;
-	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->dev_root->fs_info;
+	unsigned long index;
 	int srcu_index;
+	int ret;
+	int err;
 
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -3230,19 +3232,17 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
+	ret = 0;
 	physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
 	len = nocow_ctx->len;
 	while (len >= PAGE_CACHE_SIZE) {
-		struct page *page = NULL;
-		int ret_sub;
-
 		index = offset >> PAGE_CACHE_SHIFT;
 
 		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
 		if (!page) {
 			pr_err("find_or_create_page() failed\n");
 			ret = -ENOMEM;
-			goto next_page;
+			goto out;
 		}
 
 		if (PageUptodate(page)) {
@@ -3250,12 +3250,12 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 				goto next_page;
 		} else {
 			ClearPageError(page);
-			ret_sub = extent_read_full_page(&BTRFS_I(inode)->
+			err = extent_read_full_page(&BTRFS_I(inode)->
 							 io_tree,
 							page, btrfs_get_extent,
 							nocow_ctx->mirror_num);
-			if (ret_sub) {
-				ret = ret_sub;
+			if (err) {
+				ret = err;
 				goto next_page;
 			}
 			lock_page(page);
@@ -3264,25 +3264,23 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 				goto next_page;
 			}
 		}
-		ret_sub = write_page_nocow(nocow_ctx->sctx,
-					   physical_for_dev_replace, page);
-		if (ret_sub) {
-			ret = ret_sub;
-			goto next_page;
-		}
-
+		err = write_page_nocow(nocow_ctx->sctx,
+				       physical_for_dev_replace, page);
+		if (err)
+			ret = err;
 next_page:
-		if (page) {
-			unlock_page(page);
-			put_page(page);
-		}
+		unlock_page(page);
+		page_cache_release(page);
+
+		if (ret)
+			break;
+
 		offset += PAGE_CACHE_SIZE;
 		physical_for_dev_replace += PAGE_CACHE_SIZE;
 		len -= PAGE_CACHE_SIZE;
 	}
-
-	if (inode)
-		iput(inode);
+out:
+	iput(inode);
 	return ret;
 }
 
-- 
1.8.1.4

