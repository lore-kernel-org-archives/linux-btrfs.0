Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34047 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdLLVD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 16:03:57 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB266ADBF
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 21:03:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: sink unlock_extent parameter gfp_flags
Date: Tue, 12 Dec 2017 22:01:55 +0100
Message-Id: <8df3c1270ea633924395abbb97ebf4a8fd788a18.1513112255.git.dsterba@suse.com>
In-Reply-To: <cover.1513112255.git.dsterba@suse.com>
References: <cover.1513112255.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass either GFP_NOFS or GFP_KERNEL now, so we can sink the
parameter to the function, though we lose some of the slightly better
semantics of GFP_KERNEL in some places, it's worth cleaning up the
callchains.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c          |  2 +-
 fs/btrfs/extent_io.c        | 10 ++++------
 fs/btrfs/extent_io.h        |  4 ++--
 fs/btrfs/file.c             | 15 +++++++--------
 fs/btrfs/free-space-cache.c |  5 ++---
 fs/btrfs/inode.c            | 26 ++++++++++++--------------
 fs/btrfs/ioctl.c            |  7 +++----
 fs/btrfs/scrub.c            |  3 +--
 8 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a3e9b74f6006..cb14c2188e6f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -381,7 +381,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		clear_extent_buffer_uptodate(eb);
 out:
 	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 	if (need_lock)
 		btrfs_tree_read_unlock_blocking(eb);
 	return ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 90ecccbf0211..7980f19dbe49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1647,7 +1647,7 @@ STATIC u64 find_lock_delalloc_range(struct inode *inode,
 			     EXTENT_DELALLOC, 1, cached_state);
 	if (!ret) {
 		unlock_extent_cached(tree, delalloc_start, delalloc_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		__unlock_for_delalloc(inode, locked_page,
 			      delalloc_start, delalloc_end);
 		cond_resched();
@@ -2942,8 +2942,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur,
-					     cur + iosize - 1,
-					     &cached, GFP_NOFS);
+					     cur + iosize - 1, &cached);
 			break;
 		}
 		em = __get_extent_map(inode, page, pg_offset, cur,
@@ -3036,8 +3035,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur,
-					     cur + iosize - 1,
-					     &cached, GFP_NOFS);
+					     cur + iosize - 1, &cached);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -4632,7 +4630,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 out:
 	btrfs_free_path(path);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len - 1,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 	return ret;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 978351e8e8dc..72e5af2965a8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -312,10 +312,10 @@ static inline int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 }
 
 static inline int unlock_extent_cached(struct extent_io_tree *tree, u64 start,
-		u64 end, struct extent_state **cached, gfp_t mask)
+		u64 end, struct extent_state **cached)
 {
 	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
-				mask, NULL);
+				GFP_NOFS, NULL);
 }
 
 static inline int unlock_extent_cached_atomic(struct extent_io_tree *tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1096398e1351..1ed2e6e9e204 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1504,7 +1504,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		    ordered->file_offset + ordered->len > start_pos &&
 		    ordered->file_offset <= last_pos) {
 			unlock_extent_cached(&inode->io_tree, start_pos,
-					last_pos, cached_state, GFP_NOFS);
+					last_pos, cached_state);
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				put_page(pages[i]);
@@ -1758,8 +1758,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						pos, copied, NULL);
 		if (extents_locked)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     lockstart, lockend, &cached_state,
-					     GFP_NOFS);
+					     lockstart, lockend, &cached_state);
 		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
@@ -2600,7 +2599,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
-				     lockend, &cached_state, GFP_NOFS);
+				     lockend, &cached_state);
 		ret = btrfs_wait_ordered_range(inode, lockstart,
 					       lockend - lockstart + 1);
 		if (ret) {
@@ -2751,7 +2750,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	btrfs_free_block_rsv(fs_info, rsv);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 out_only_mutex:
 	if (!updated_inode && truncated_block && !ret && !err) {
 		/*
@@ -2913,7 +2912,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     alloc_start, locked_end,
-					     &cached_state, GFP_KERNEL);
+					     &cached_state);
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -3015,7 +3014,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	}
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
-			     &cached_state, GFP_KERNEL);
+			     &cached_state);
 out:
 	inode_unlock(inode);
 	/* Let go of our reservation. */
@@ -3088,7 +3087,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 			*offset = min_t(loff_t, start, inode->i_size);
 	}
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 	return ret;
 }
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b8ab90c9a9fb..014f3c090231 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1125,8 +1125,7 @@ cleanup_write_cache_enospc(struct inode *inode,
 {
 	io_ctl_drop_pages(io_ctl);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
-			     i_size_read(inode) - 1, cached_state,
-			     GFP_NOFS);
+			     i_size_read(inode) - 1, cached_state);
 }
 
 static int __btrfs_wait_cache_io(struct btrfs_root *root,
@@ -1320,7 +1319,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	io_ctl_drop_pages(io_ctl);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
-			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);
+			     i_size_read(inode) - 1, &cached_state);
 
 	/*
 	 * at this point the pages are under IO and we're happy,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 46df5e2a64e7..0d08b1647e08 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2100,7 +2100,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 					PAGE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
-				     page_end, &cached_state, GFP_NOFS);
+				     page_end, &cached_state);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
@@ -2130,7 +2130,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
-			     &cached_state, GFP_NOFS);
+			     &cached_state);
 out_page:
 	unlock_page(page);
 	put_page(page);
@@ -2722,7 +2722,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	btrfs_end_transaction(trans);
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
-			     &cached, GFP_NOFS);
+			     &cached);
 	iput(inode);
 	return ret;
 }
@@ -4812,7 +4812,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	ordered = btrfs_lookup_ordered_extent(inode, block_start);
 	if (ordered) {
 		unlock_extent_cached(io_tree, block_start, block_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		unlock_page(page);
 		put_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
@@ -4829,7 +4829,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 					&cached_state, 0);
 	if (ret) {
 		unlock_extent_cached(io_tree, block_start, block_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		goto out_unlock;
 	}
 
@@ -4848,8 +4848,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	}
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	unlock_extent_cached(io_tree, block_start, block_end, &cached_state,
-			     GFP_NOFS);
+	unlock_extent_cached(io_tree, block_start, block_end, &cached_state);
 
 out_unlock:
 	if (ret)
@@ -4950,7 +4949,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 		if (!ordered)
 			break;
 		unlock_extent_cached(io_tree, hole_start, block_end - 1,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 	}
@@ -5015,8 +5014,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			break;
 	}
 	free_extent_map(em);
-	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
-			     GFP_NOFS);
+	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state);
 	return err;
 }
 
@@ -7629,7 +7627,7 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 			break;
 
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     cached_state, GFP_NOFS);
+				     cached_state);
 
 		if (ordered) {
 			/*
@@ -9122,7 +9120,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 			PAGE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		unlock_page(page);
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
@@ -9155,7 +9153,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 					&cached_state, 0);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state, GFP_NOFS);
+				     &cached_state);
 		ret = VM_FAULT_SIGBUS;
 		goto out_unlock;
 	}
@@ -9181,7 +9179,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
 
-	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
+	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
 out_unlock:
 	if (!ret) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be5bd81b3669..f6d4d5810cc1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -977,7 +977,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 		/* get the big lock and read metadata off disk */
 		lock_extent_bits(io_tree, start, end, &cached);
 		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
-		unlock_extent_cached(io_tree, start, end, &cached, GFP_NOFS);
+		unlock_extent_cached(io_tree, start, end, &cached);
 
 		if (IS_ERR(em))
 			return NULL;
@@ -1128,7 +1128,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 			ordered = btrfs_lookup_ordered_extent(inode,
 							      page_start);
 			unlock_extent_cached(tree, page_start, page_end,
-					     &cached_state, GFP_NOFS);
+					     &cached_state);
 			if (!ordered)
 				break;
 
@@ -1204,8 +1204,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 			  &cached_state);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-			     page_start, page_end - 1, &cached_state,
-			     GFP_NOFS);
+			     page_start, page_end - 1, &cached_state);
 
 	for (i = 0; i < i_done; i++) {
 		clear_page_dirty_for_io(pages[i]);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d766c73eb29a..ecfe3118d9dd 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4468,8 +4468,7 @@ static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
 	free_extent_map(em);
 
 out_unlock:
-	unlock_extent_cached(io_tree, lockstart, lockend, &cached_state,
-			     GFP_NOFS);
+	unlock_extent_cached(io_tree, lockstart, lockend, &cached_state);
 	return ret;
 }
 
-- 
2.15.1

