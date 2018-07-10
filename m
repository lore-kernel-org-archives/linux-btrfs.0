Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751104AbeGJF55 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 01:57:57 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BCD45AD31
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 05:57:55 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/2] btrfs: scrub: Cleanup the nodatasum fixup code
Date: Tue, 10 Jul 2018 13:57:51 +0800
Message-Id: <20180710055751.13309-2-wqu@suse.com>
In-Reply-To: <20180710055751.13309-1-wqu@suse.com>
References: <20180710055751.13309-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we no longer use the old method, which use inode page cache and
could cause serious data corruption for compressed nodatasum extent, to
fixup nodatasum error during scrub/replace, remove all related code.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 234 -----------------------------------------------
 1 file changed, 234 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 328232fa5646..8580b53fcf32 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -188,15 +188,6 @@ struct scrub_ctx {
 	refcount_t              refs;
 };
 
-struct scrub_fixup_nodatasum {
-	struct scrub_ctx	*sctx;
-	struct btrfs_device	*dev;
-	u64			logical;
-	struct btrfs_root	*root;
-	struct btrfs_work	work;
-	int			mirror_num;
-};
-
 struct scrub_nocow_inode {
 	u64			inum;
 	u64			offset;
@@ -882,194 +873,6 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	btrfs_free_path(path);
 }
 
-static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
-{
-	struct page *page = NULL;
-	unsigned long index;
-	struct scrub_fixup_nodatasum *fixup = fixup_ctx;
-	int ret;
-	int corrected = 0;
-	struct btrfs_key key;
-	struct inode *inode = NULL;
-	struct btrfs_fs_info *fs_info;
-	u64 end = offset + PAGE_SIZE - 1;
-	struct btrfs_root *local_root;
-	int srcu_index;
-
-	key.objectid = root;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-	key.offset = (u64)-1;
-
-	fs_info = fixup->root->fs_info;
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
-	index = offset >> PAGE_SHIFT;
-
-	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
-	if (!page) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (PageUptodate(page)) {
-		if (PageDirty(page)) {
-			/*
-			 * we need to write the data to the defect sector. the
-			 * data that was in that sector is not in memory,
-			 * because the page was modified. we must not write the
-			 * modified page to that sector.
-			 *
-			 * TODO: what could be done here: wait for the delalloc
-			 *       runner to write out that page (might involve
-			 *       COW) and see whether the sector is still
-			 *       referenced afterwards.
-			 *
-			 * For the meantime, we'll treat this error
-			 * incorrectable, although there is a chance that a
-			 * later scrub will find the bad sector again and that
-			 * there's no dirty page in memory, then.
-			 */
-			ret = -EIO;
-			goto out;
-		}
-		ret = repair_io_failure(fs_info, inum, offset, PAGE_SIZE,
-					fixup->logical, page,
-					offset - page_offset(page),
-					fixup->mirror_num);
-		unlock_page(page);
-		corrected = !ret;
-	} else {
-		/*
-		 * we need to get good data first. the general readpage path
-		 * will call repair_io_failure for us, we just have to make
-		 * sure we read the bad mirror.
-		 */
-		ret = set_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-					EXTENT_DAMAGED);
-		if (ret) {
-			/* set_extent_bits should give proper error */
-			WARN_ON(ret > 0);
-			if (ret > 0)
-				ret = -EFAULT;
-			goto out;
-		}
-
-		ret = extent_read_full_page(&BTRFS_I(inode)->io_tree, page,
-						btrfs_get_extent,
-						fixup->mirror_num);
-		wait_on_page_locked(page);
-
-		corrected = !test_range_bit(&BTRFS_I(inode)->io_tree, offset,
-						end, EXTENT_DAMAGED, 0, NULL);
-		if (!corrected)
-			clear_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-						EXTENT_DAMAGED);
-	}
-
-out:
-	if (page)
-		put_page(page);
-
-	iput(inode);
-
-	if (ret < 0)
-		return ret;
-
-	if (ret == 0 && corrected) {
-		/*
-		 * we only need to call readpage for one of the inodes belonging
-		 * to this extent. so make iterate_extent_inodes stop
-		 */
-		return 1;
-	}
-
-	return -EIO;
-}
-
-static void scrub_fixup_nodatasum(struct btrfs_work *work)
-{
-	struct btrfs_fs_info *fs_info;
-	int ret;
-	struct scrub_fixup_nodatasum *fixup;
-	struct scrub_ctx *sctx;
-	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_path *path;
-	int uncorrectable = 0;
-
-	fixup = container_of(work, struct scrub_fixup_nodatasum, work);
-	sctx = fixup->sctx;
-	fs_info = fixup->root->fs_info;
-
-	path = btrfs_alloc_path();
-	if (!path) {
-		spin_lock(&sctx->stat_lock);
-		++sctx->stat.malloc_errors;
-		spin_unlock(&sctx->stat_lock);
-		uncorrectable = 1;
-		goto out;
-	}
-
-	trans = btrfs_join_transaction(fixup->root);
-	if (IS_ERR(trans)) {
-		uncorrectable = 1;
-		goto out;
-	}
-
-	/*
-	 * the idea is to trigger a regular read through the standard path. we
-	 * read a page from the (failed) logical address by specifying the
-	 * corresponding copynum of the failed sector. thus, that readpage is
-	 * expected to fail.
-	 * that is the point where on-the-fly error correction will kick in
-	 * (once it's finished) and rewrite the failed sector if a good copy
-	 * can be found.
-	 */
-	ret = iterate_inodes_from_logical(fixup->logical, fs_info, path,
-					  scrub_fixup_readpage, fixup, false);
-	if (ret < 0) {
-		uncorrectable = 1;
-		goto out;
-	}
-	WARN_ON(ret != 1);
-
-	spin_lock(&sctx->stat_lock);
-	++sctx->stat.corrected_errors;
-	spin_unlock(&sctx->stat_lock);
-
-out:
-	if (trans && !IS_ERR(trans))
-		btrfs_end_transaction(trans);
-	if (uncorrectable) {
-		spin_lock(&sctx->stat_lock);
-		++sctx->stat.uncorrectable_errors;
-		spin_unlock(&sctx->stat_lock);
-		btrfs_dev_replace_stats_inc(
-			&fs_info->dev_replace.num_uncorrectable_read_errors);
-		btrfs_err_rl_in_rcu(fs_info,
-		    "unable to fixup (nodatasum) error at logical %llu on dev %s",
-			fixup->logical, rcu_str_deref(fixup->dev->name));
-	}
-
-	btrfs_free_path(path);
-	kfree(fixup);
-
-	scrub_pending_trans_workers_dec(sctx);
-}
-
 static inline void scrub_get_recover(struct scrub_recover *recover)
 {
 	refcount_inc(&recover->refs);
@@ -1263,43 +1066,6 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		goto out;
 	}
 
-	/*
-	 * NOTE: Even for nodatasum data case, it's still possible that it's
-	 * compressed data extent, thus scrub_fixup_nodatasum(), which
-	 * write inode page cache onto disk, could cause serious data
-	 * corruption.
-	 *
-	 * So here we could only read from disk, and hopes our recovery
-	 * could reach disk before newer write.
-	 */
-	if (0 && !is_metadata && !have_csum) {
-		struct scrub_fixup_nodatasum *fixup_nodatasum;
-
-		WARN_ON(sctx->is_dev_replace);
-
-		/*
-		 * !is_metadata and !have_csum, this means that the data
-		 * might not be COWed, that it might be modified
-		 * concurrently. The general strategy to work on the
-		 * commit root does not help in the case when COW is not
-		 * used.
-		 */
-		fixup_nodatasum = kzalloc(sizeof(*fixup_nodatasum), GFP_NOFS);
-		if (!fixup_nodatasum)
-			goto did_not_correct_error;
-		fixup_nodatasum->sctx = sctx;
-		fixup_nodatasum->dev = dev;
-		fixup_nodatasum->logical = logical;
-		fixup_nodatasum->root = fs_info->extent_root;
-		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
-		scrub_pending_trans_workers_inc(sctx);
-		btrfs_init_work(&fixup_nodatasum->work, btrfs_scrub_helper,
-				scrub_fixup_nodatasum, NULL, NULL);
-		btrfs_queue_work(fs_info->scrub_workers,
-				 &fixup_nodatasum->work);
-		goto out;
-	}
-
 	/*
 	 * now build and submit the bios for the other mirrors, check
 	 * checksums.
-- 
2.18.0

