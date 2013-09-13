Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48088 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3IMODQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 10:03:16 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B23C49A06B4
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 08:03:15 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id FcRZ5YrVs6jQCrOs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 08:03:14 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: improve replacing nocow extents V2
Date: Fri, 13 Sep 2013 10:03:12 -0400
Message-ID: <1379080992-4365-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Various people have hit a deadlock when running btrfs/011.  This is because when
replacing nocow extents we will take the i_mutex to make sure nobody messes with
the file while we are replacing the extent.  The problem is we are already
holding a transaction open, which is a locking inversion, so instead we need to
save these inodes we find and then process them outside of the transaction.

Further we can't just lock the inode and assume we are good to go.  We need to
lock the extent range and then read back the extent cache for the inode to make
sure the extent really still points at the physical block we want.  If it
doesn't we don't have to copy it.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: compare the logical extent against the inode's em, not the devices
phsyical location.

 fs/btrfs/scrub.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 98 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0afcd45..2fdf50e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -158,12 +158,20 @@ struct scrub_fixup_nodatasum {
 	int			mirror_num;
 };
 
+struct scrub_nocow_inode {
+	u64			inum;
+	u64			offset;
+	u64			root;
+	struct list_head	list;
+};
+
 struct scrub_copy_nocow_ctx {
 	struct scrub_ctx	*sctx;
 	u64			logical;
 	u64			len;
 	int			mirror_num;
 	u64			physical_for_dev_replace;
+	struct list_head	inodes;
 	struct btrfs_work	work;
 };
 
@@ -245,7 +253,7 @@ static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
 static int write_page_nocow(struct scrub_ctx *sctx,
 			    u64 physical_for_dev_replace, struct page *page);
 static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
-				      void *ctx);
+				      struct scrub_copy_nocow_ctx *ctx);
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			    int mirror_num, u64 physical_for_dev_replace);
 static void copy_nocow_pages_worker(struct btrfs_work *work);
@@ -3126,12 +3134,30 @@ static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	nocow_ctx->mirror_num = mirror_num;
 	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
 	nocow_ctx->work.func = copy_nocow_pages_worker;
+	INIT_LIST_HEAD(&nocow_ctx->inodes);
 	btrfs_queue_worker(&fs_info->scrub_nocow_workers,
 			   &nocow_ctx->work);
 
 	return 0;
 }
 
+static int record_inode_for_nocow(u64 inum, u64 offset, u64 root, void *ctx)
+{
+	struct scrub_copy_nocow_ctx *nocow_ctx = ctx;
+	struct scrub_nocow_inode *nocow_inode;
+
+	nocow_inode = kzalloc(sizeof(*nocow_inode), GFP_NOFS);
+	if (!nocow_inode)
+		return -ENOMEM;
+	nocow_inode->inum = inum;
+	nocow_inode->offset = offset;
+	nocow_inode->root = root;
+	list_add_tail(&nocow_inode->list, &nocow_ctx->inodes);
+	return 0;
+}
+
+#define COPY_COMPLETE 1
+
 static void copy_nocow_pages_worker(struct btrfs_work *work)
 {
 	struct scrub_copy_nocow_ctx *nocow_ctx =
@@ -3167,8 +3193,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 	}
 
 	ret = iterate_inodes_from_logical(logical, fs_info, path,
-					  copy_nocow_pages_for_inode,
-					  nocow_ctx);
+					  record_inode_for_nocow, nocow_ctx);
 	if (ret != 0 && ret != -ENOENT) {
 		pr_warn("iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %u, ret %d\n",
 			logical, physical_for_dev_replace, len, mirror_num,
@@ -3177,7 +3202,33 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 		goto out;
 	}
 
+	btrfs_end_transaction(trans, root);
+	trans = NULL;
+	while (!list_empty(&nocow_ctx->inodes)) {
+		struct scrub_nocow_inode *entry;
+		entry = list_first_entry(&nocow_ctx->inodes,
+					 struct scrub_nocow_inode,
+					 list);
+		list_del_init(&entry->list);
+		ret = copy_nocow_pages_for_inode(entry->inum, entry->offset,
+						 entry->root, nocow_ctx);
+		kfree(entry);
+		if (ret == COPY_COMPLETE) {
+			ret = 0;
+			break;
+		} else if (ret) {
+			break;
+		}
+	}
 out:
+	while (!list_empty(&nocow_ctx->inodes)) {
+		struct scrub_nocow_inode *entry;
+		entry = list_first_entry(&nocow_ctx->inodes,
+					 struct scrub_nocow_inode,
+					 list);
+		list_del_init(&entry->list);
+		kfree(entry);
+	}
 	if (trans && !IS_ERR(trans))
 		btrfs_end_transaction(trans, root);
 	if (not_written)
@@ -3190,20 +3241,25 @@ out:
 	scrub_pending_trans_workers_dec(sctx);
 }
 
-static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
+static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
+				      struct scrub_copy_nocow_ctx *nocow_ctx)
 {
-	struct scrub_copy_nocow_ctx *nocow_ctx = ctx;
 	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->dev_root->fs_info;
 	struct btrfs_key key;
 	struct inode *inode;
 	struct page *page;
 	struct btrfs_root *local_root;
+	struct btrfs_ordered_extent *ordered;
+	struct extent_map *em;
+	struct extent_state *cached_state = NULL;
+	struct extent_io_tree *io_tree;
 	u64 physical_for_dev_replace;
-	u64 len;
+	u64 len = nocow_ctx->len;
+	u64 lockstart = offset, lockend = offset + len - 1;
 	unsigned long index;
 	int srcu_index;
-	int ret;
-	int err;
+	int ret = 0;
+	int err = 0;
 
 	key.objectid = root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -3229,9 +3285,33 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	mutex_lock(&inode->i_mutex);
 	inode_dio_wait(inode);
 
-	ret = 0;
 	physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
-	len = nocow_ctx->len;
+	io_tree = &BTRFS_I(inode)->io_tree;
+
+	lock_extent_bits(io_tree, lockstart, lockend, 0, &cached_state);
+	ordered = btrfs_lookup_ordered_range(inode, lockstart, len);
+	if (ordered) {
+		btrfs_put_ordered_extent(ordered);
+		goto out_unlock;
+	}
+
+	em = btrfs_get_extent(inode, NULL, 0, lockstart, len, 0);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto out_unlock;
+	}
+
+	/*
+	 * This extent does not actually cover our physical area anymore, just
+	 * move on to the next inode.
+	 */
+	if (em->block_start > nocow_ctx->logical ||
+	    em->block_start + em->block_len < nocow_ctx->logical + len) {
+		free_extent_map(em);
+		goto out_unlock;
+	}
+	free_extent_map(em);
+
 	while (len >= PAGE_CACHE_SIZE) {
 		index = offset >> PAGE_CACHE_SHIFT;
 again:
@@ -3247,10 +3327,9 @@ again:
 				goto next_page;
 		} else {
 			ClearPageError(page);
-			err = extent_read_full_page(&BTRFS_I(inode)->
-							 io_tree,
-							page, btrfs_get_extent,
-							nocow_ctx->mirror_num);
+			err = extent_read_full_page_nolock(io_tree, page,
+							   btrfs_get_extent,
+							   nocow_ctx->mirror_num);
 			if (err) {
 				ret = err;
 				goto next_page;
@@ -3264,6 +3343,7 @@ again:
 			 * page in the page cache.
 			 */
 			if (page->mapping != inode->i_mapping) {
+				unlock_page(page);
 				page_cache_release(page);
 				goto again;
 			}
@@ -3287,6 +3367,10 @@ next_page:
 		physical_for_dev_replace += PAGE_CACHE_SIZE;
 		len -= PAGE_CACHE_SIZE;
 	}
+	ret = COPY_COMPLETE;
+out_unlock:
+	unlock_extent_cached(io_tree, lockstart, lockend, &cached_state,
+			     GFP_NOFS);
 out:
 	mutex_unlock(&inode->i_mutex);
 	iput(inode);
-- 
1.7.7.6

