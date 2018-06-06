Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751888AbeFFFNS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 01:13:18 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D10A1AEC7
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 05:13:16 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: scrub: Remove unused copy_nocow_pages() and its children functions
Date: Wed,  6 Jun 2018 13:13:12 +0800
Message-Id: <20180606051312.3886-2-wqu@suse.com>
In-Reply-To: <20180606051312.3886-1-wqu@suse.com>
References: <20180606051312.3886-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Entrance function copy_nocow_pages() is no longer used, and remove all
its children functions, since they can't handle compressed nodatasum
extent properly and in fact the "optimization" is pretty niche, using
the unified scrub_pages() would be a much better idea.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v1:
  Split the cleanup code from the original RFC ver.b.
  And more comprehensive cleanup, including the workqueue and related
  structures.
---
 fs/btrfs/scrub.c | 374 -----------------------------------------------
 1 file changed, 374 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 79e154575366..b7df97529e63 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -197,23 +197,6 @@ struct scrub_fixup_nodatasum {
 	int			mirror_num;
 };
 
-struct scrub_nocow_inode {
-	u64			inum;
-	u64			offset;
-	u64			root;
-	struct list_head	list;
-};
-
-struct scrub_copy_nocow_ctx {
-	struct scrub_ctx	*sctx;
-	u64			logical;
-	u64			len;
-	int			mirror_num;
-	u64			physical_for_dev_replace;
-	struct list_head	inodes;
-	struct btrfs_work	work;
-};
-
 struct scrub_warning {
 	struct btrfs_path	*path;
 	u64			extent_item_size;
@@ -277,13 +260,6 @@ static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 static void scrub_wr_submit(struct scrub_ctx *sctx);
 static void scrub_wr_bio_end_io(struct bio *bio);
 static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
-static int write_page_nocow(struct scrub_ctx *sctx,
-			    u64 physical_for_dev_replace, struct page *page);
-static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
-				      struct scrub_copy_nocow_ctx *ctx);
-static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
-			    int mirror_num, u64 physical_for_dev_replace);
-static void copy_nocow_pages_worker(struct btrfs_work *work);
 static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
 static void scrub_put_ctx(struct scrub_ctx *sctx);
@@ -2799,26 +2775,10 @@ static int scrub_extent(struct scrub_ctx *sctx, struct map_lookup *map,
 			have_csum = scrub_find_csum(sctx, logical, csum);
 			if (have_csum == 0)
 				++sctx->stat.no_csum;
-
-			/*
-			 * For replace on nodatasum extent, don't use
-			 * copy_nocow_pages() routine which will copy pages
-			 * from inode to disk. It could cause deadly corruption
-			 * for compressed extent.
-			 * NOTE: copy_nocow_pages() and all its children will
-			 * be removed later.
-			 */
-			if (0 && sctx->is_dev_replace && !have_csum) {
-				ret = copy_nocow_pages(sctx, logical, l,
-						       mirror_num,
-						      physical_for_dev_replace);
-				goto behind_scrub_pages;
-			}
 		}
 		ret = scrub_pages(sctx, logical, l, physical, dev, flags, gen,
 				  mirror_num, have_csum ? csum : NULL, 0,
 				  physical_for_dev_replace);
-behind_scrub_pages:
 		if (ret)
 			return ret;
 		len -= l;
@@ -4079,10 +4039,6 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 		if (!fs_info->scrub_wr_completion_workers)
 			goto fail_scrub_wr_completion_workers;
 
-		fs_info->scrub_nocow_workers =
-			btrfs_alloc_workqueue(fs_info, "scrubnc", flags, 1, 0);
-		if (!fs_info->scrub_nocow_workers)
-			goto fail_scrub_nocow_workers;
 		fs_info->scrub_parity_workers =
 			btrfs_alloc_workqueue(fs_info, "scrubparity", flags,
 					      max_active, 2);
@@ -4093,8 +4049,6 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 	return 0;
 
 fail_scrub_parity_workers:
-	btrfs_destroy_workqueue(fs_info->scrub_nocow_workers);
-fail_scrub_nocow_workers:
 	btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
 fail_scrub_wr_completion_workers:
 	btrfs_destroy_workqueue(fs_info->scrub_workers);
@@ -4107,7 +4061,6 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 	if (--fs_info->scrub_workers_refcnt == 0) {
 		btrfs_destroy_workqueue(fs_info->scrub_workers);
 		btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
-		btrfs_destroy_workqueue(fs_info->scrub_nocow_workers);
 		btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
 	}
 	WARN_ON(fs_info->scrub_workers_refcnt < 0);
@@ -4366,330 +4319,3 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 	*extent_dev = bbio->stripes[0].dev;
 	btrfs_put_bbio(bbio);
 }
-
-static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
-			    int mirror_num, u64 physical_for_dev_replace)
-{
-	struct scrub_copy_nocow_ctx *nocow_ctx;
-	struct btrfs_fs_info *fs_info = sctx->fs_info;
-
-	nocow_ctx = kzalloc(sizeof(*nocow_ctx), GFP_NOFS);
-	if (!nocow_ctx) {
-		spin_lock(&sctx->stat_lock);
-		sctx->stat.malloc_errors++;
-		spin_unlock(&sctx->stat_lock);
-		return -ENOMEM;
-	}
-
-	scrub_pending_trans_workers_inc(sctx);
-
-	nocow_ctx->sctx = sctx;
-	nocow_ctx->logical = logical;
-	nocow_ctx->len = len;
-	nocow_ctx->mirror_num = mirror_num;
-	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
-	btrfs_init_work(&nocow_ctx->work, btrfs_scrubnc_helper,
-			copy_nocow_pages_worker, NULL, NULL);
-	INIT_LIST_HEAD(&nocow_ctx->inodes);
-	btrfs_queue_work(fs_info->scrub_nocow_workers,
-			 &nocow_ctx->work);
-
-	return 0;
-}
-
-static int record_inode_for_nocow(u64 inum, u64 offset, u64 root, void *ctx)
-{
-	struct scrub_copy_nocow_ctx *nocow_ctx = ctx;
-	struct scrub_nocow_inode *nocow_inode;
-
-	nocow_inode = kzalloc(sizeof(*nocow_inode), GFP_NOFS);
-	if (!nocow_inode)
-		return -ENOMEM;
-	nocow_inode->inum = inum;
-	nocow_inode->offset = offset;
-	nocow_inode->root = root;
-	list_add_tail(&nocow_inode->list, &nocow_ctx->inodes);
-	return 0;
-}
-
-#define COPY_COMPLETE 1
-
-static void copy_nocow_pages_worker(struct btrfs_work *work)
-{
-	struct scrub_copy_nocow_ctx *nocow_ctx =
-		container_of(work, struct scrub_copy_nocow_ctx, work);
-	struct scrub_ctx *sctx = nocow_ctx->sctx;
-	struct btrfs_fs_info *fs_info = sctx->fs_info;
-	struct btrfs_root *root = fs_info->extent_root;
-	u64 logical = nocow_ctx->logical;
-	u64 len = nocow_ctx->len;
-	int mirror_num = nocow_ctx->mirror_num;
-	u64 physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
-	int ret;
-	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_path *path;
-	int not_written = 0;
-
-	path = btrfs_alloc_path();
-	if (!path) {
-		spin_lock(&sctx->stat_lock);
-		sctx->stat.malloc_errors++;
-		spin_unlock(&sctx->stat_lock);
-		not_written = 1;
-		goto out;
-	}
-
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		not_written = 1;
-		goto out;
-	}
-
-	ret = iterate_inodes_from_logical(logical, fs_info, path,
-			record_inode_for_nocow, nocow_ctx, false);
-	if (ret != 0 && ret != -ENOENT) {
-		btrfs_warn(fs_info,
-			   "iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %u, ret %d",
-			   logical, physical_for_dev_replace, len, mirror_num,
-			   ret);
-		not_written = 1;
-		goto out;
-	}
-
-	btrfs_end_transaction(trans);
-	trans = NULL;
-	while (!list_empty(&nocow_ctx->inodes)) {
-		struct scrub_nocow_inode *entry;
-		entry = list_first_entry(&nocow_ctx->inodes,
-					 struct scrub_nocow_inode,
-					 list);
-		list_del_init(&entry->list);
-		ret = copy_nocow_pages_for_inode(entry->inum, entry->offset,
-						 entry->root, nocow_ctx);
-		kfree(entry);
-		if (ret == COPY_COMPLETE) {
-			ret = 0;
-			break;
-		} else if (ret) {
-			break;
-		}
-	}
-out:
-	while (!list_empty(&nocow_ctx->inodes)) {
-		struct scrub_nocow_inode *entry;
-		entry = list_first_entry(&nocow_ctx->inodes,
-					 struct scrub_nocow_inode,
-					 list);
-		list_del_init(&entry->list);
-		kfree(entry);
-	}
-	if (trans && !IS_ERR(trans))
-		btrfs_end_transaction(trans);
-	if (not_written)
-		btrfs_dev_replace_stats_inc(&fs_info->dev_replace.
-					    num_uncorrectable_read_errors);
-
-	btrfs_free_path(path);
-	kfree(nocow_ctx);
-
-	scrub_pending_trans_workers_dec(sctx);
-}
-
-static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
-				 u64 logical)
-{
-	struct extent_state *cached_state = NULL;
-	struct btrfs_ordered_extent *ordered;
-	struct extent_io_tree *io_tree;
-	struct extent_map *em;
-	u64 lockstart = start, lockend = start + len - 1;
-	int ret = 0;
-
-	io_tree = &inode->io_tree;
-
-	lock_extent_bits(io_tree, lockstart, lockend, &cached_state);
-	ordered = btrfs_lookup_ordered_range(inode, lockstart, len);
-	if (ordered) {
-		btrfs_put_ordered_extent(ordered);
-		ret = 1;
-		goto out_unlock;
-	}
-
-	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
-	if (IS_ERR(em)) {
-		ret = PTR_ERR(em);
-		goto out_unlock;
-	}
-
-	/*
-	 * This extent does not actually cover the logical extent anymore,
-	 * move on to the next inode.
-	 */
-	if (em->block_start > logical ||
-	    em->block_start + em->block_len < logical + len ||
-	    test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
-		free_extent_map(em);
-		ret = 1;
-		goto out_unlock;
-	}
-	free_extent_map(em);
-
-out_unlock:
-	unlock_extent_cached(io_tree, lockstart, lockend, &cached_state);
-	return ret;
-}
-
-static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
-				      struct scrub_copy_nocow_ctx *nocow_ctx)
-{
-	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->fs_info;
-	struct btrfs_key key;
-	struct inode *inode;
-	struct page *page;
-	struct btrfs_root *local_root;
-	struct extent_io_tree *io_tree;
-	u64 physical_for_dev_replace;
-	u64 nocow_ctx_logical;
-	u64 len = nocow_ctx->len;
-	unsigned long index;
-	int srcu_index;
-	int ret = 0;
-	int err = 0;
-
-	key.objectid = root;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-	key.offset = (u64)-1;
-
-	srcu_index = srcu_read_lock(&fs_info->subvol_srcu);
-
-	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
-	if (IS_ERR(local_root)) {
-		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
-		return PTR_ERR(local_root);
-	}
-
-	key.type = BTRFS_INODE_ITEM_KEY;
-	key.objectid = inum;
-	key.offset = 0;
-	inode = btrfs_iget(fs_info->sb, &key, local_root, NULL);
-	srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
-	if (IS_ERR(inode))
-		return PTR_ERR(inode);
-
-	/* Avoid truncate/dio/punch hole.. */
-	inode_lock(inode);
-	inode_dio_wait(inode);
-
-	physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
-	io_tree = &BTRFS_I(inode)->io_tree;
-	nocow_ctx_logical = nocow_ctx->logical;
-
-	ret = check_extent_to_block(BTRFS_I(inode), offset, len,
-			nocow_ctx_logical);
-	if (ret) {
-		ret = ret > 0 ? 0 : ret;
-		goto out;
-	}
-
-	while (len >= PAGE_SIZE) {
-		index = offset >> PAGE_SHIFT;
-again:
-		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
-		if (!page) {
-			btrfs_err(fs_info, "find_or_create_page() failed");
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		if (PageUptodate(page)) {
-			if (PageDirty(page))
-				goto next_page;
-		} else {
-			ClearPageError(page);
-			err = extent_read_full_page(io_tree, page,
-							   btrfs_get_extent,
-							   nocow_ctx->mirror_num);
-			if (err) {
-				ret = err;
-				goto next_page;
-			}
-
-			lock_page(page);
-			/*
-			 * If the page has been remove from the page cache,
-			 * the data on it is meaningless, because it may be
-			 * old one, the new data may be written into the new
-			 * page in the page cache.
-			 */
-			if (page->mapping != inode->i_mapping) {
-				unlock_page(page);
-				put_page(page);
-				goto again;
-			}
-			if (!PageUptodate(page)) {
-				ret = -EIO;
-				goto next_page;
-			}
-		}
-
-		ret = check_extent_to_block(BTRFS_I(inode), offset, len,
-					    nocow_ctx_logical);
-		if (ret) {
-			ret = ret > 0 ? 0 : ret;
-			goto next_page;
-		}
-
-		err = write_page_nocow(nocow_ctx->sctx,
-				       physical_for_dev_replace, page);
-		if (err)
-			ret = err;
-next_page:
-		unlock_page(page);
-		put_page(page);
-
-		if (ret)
-			break;
-
-		offset += PAGE_SIZE;
-		physical_for_dev_replace += PAGE_SIZE;
-		nocow_ctx_logical += PAGE_SIZE;
-		len -= PAGE_SIZE;
-	}
-	ret = COPY_COMPLETE;
-out:
-	inode_unlock(inode);
-	iput(inode);
-	return ret;
-}
-
-static int write_page_nocow(struct scrub_ctx *sctx,
-			    u64 physical_for_dev_replace, struct page *page)
-{
-	struct bio *bio;
-	struct btrfs_device *dev;
-
-	dev = sctx->wr_tgtdev;
-	if (!dev)
-		return -EIO;
-	if (!dev->bdev) {
-		btrfs_warn_rl(dev->fs_info,
-			"scrub write_page_nocow(bdev == NULL) is unexpected");
-		return -EIO;
-	}
-	bio = btrfs_io_bio_alloc(1);
-	bio->bi_iter.bi_size = 0;
-	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
-	bio_set_dev(bio, dev->bdev);
-	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
-	/* bio_add_page won't fail on a freshly allocated bio */
-	bio_add_page(bio, page, PAGE_SIZE, 0);
-
-	if (btrfsic_submit_bio_wait(bio)) {
-		bio_put(bio);
-		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
-		return -EIO;
-	}
-
-	bio_put(bio);
-	return 0;
-}
-- 
2.17.1

