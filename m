Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36372 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934351AbdBQOnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:55 -0500
Received: by mail-wm0-f66.google.com with SMTP id r18so2935267wmd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:54 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/38] btrfs: make btrfs_is_free_space_inode take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:57 +0200
Message-Id: <1487342609-20652-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/btrfs_inode.h |  8 ++++----
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c |  4 ++--
 fs/btrfs/file-item.c   |  2 +-
 fs/btrfs/inode.c       | 22 +++++++++++-----------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 46d117b77bd2..36eca5464e1b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -243,14 +243,14 @@ static inline void btrfs_i_size_write(struct btrfs_inode *inode, u64 size)
 	inode->disk_i_size = size;
 }
 
-static inline bool btrfs_is_free_space_inode(struct inode *inode)
+static inline bool btrfs_is_free_space_inode(struct btrfs_inode *inode)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 
 	if (root == root->fs_info->tree_root &&
-	    btrfs_ino(BTRFS_I(inode)) != BTRFS_BTREE_INODE_OBJECTID)
+	    btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID)
 		return true;
-	if (BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
+	if (inode->location.objectid == BTRFS_FREE_INO_OBJECTID)
 		return true;
 	return false;
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 97f84a80b479..8ab0ce65a218 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3123,7 +3123,7 @@ static inline void btrfs_force_ra(struct address_space *mapping,
 }
 
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
-int btrfs_set_inode_index(struct inode *dir, u64 *index);
+int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 438c7312de33..883819c5abc0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4148,7 +4148,7 @@ int btrfs_alloc_data_chunk_ondemand(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, fs_info->sectorsize);
 
-	if (btrfs_is_free_space_inode(inode)) {
+	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		need_commit = 0;
 		ASSERT(current->journal_info);
 	}
@@ -5947,7 +5947,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	 * If we have a transaction open (can happen if we call truncate_block
 	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
 	 */
-	if (btrfs_is_free_space_inode(inode)) {
+	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 		delalloc_lock = false;
 	} else if (current->journal_info) {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index e35df48b4383..71ed7f051685 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -214,7 +214,7 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 	 * read from the commit root and sidestep a nasty deadlock
 	 * between reading the free space cache and updating the csum tree.
 	 */
-	if (btrfs_is_free_space_inode(inode)) {
+	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		path->search_commit_root = 1;
 		path->skip_locking = 1;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d5e9474b09b..fcdff1023718 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -933,7 +933,7 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map *em;
 	int ret = 0;
 
-	if (btrfs_is_free_space_inode(inode)) {
+	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		WARN_ON_ONCE(1);
 		ret = -EINVAL;
 		goto out_unlock;
@@ -1231,7 +1231,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		return -ENOMEM;
 	}
 
-	nolock = btrfs_is_free_space_inode(inode);
+	nolock = btrfs_is_free_space_inode(BTRFS_I(inode));
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1676,7 +1676,7 @@ static void btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		bool do_list = !btrfs_is_free_space_inode(inode);
+		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1726,7 +1726,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 	 */
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
-		bool do_list = !btrfs_is_free_space_inode(inode);
+		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1860,7 +1860,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	if (btrfs_is_free_space_inode(inode))
+	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
 		metadata = BTRFS_WQ_ENDIO_FREE_SPACE;
 
 	if (bio_op(bio) != REQ_OP_WRITE) {
@@ -2799,7 +2799,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool nolock;
 	bool truncated = false;
 
-	nolock = btrfs_is_free_space_inode(inode);
+	nolock = btrfs_is_free_space_inode(BTRFS_I(inode));
 
 	if (test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags)) {
 		ret = -EIO;
@@ -2999,7 +2999,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 					    end - start + 1, uptodate))
 		return 0;
 
-	if (btrfs_is_free_space_inode(inode)) {
+	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
 		wq = fs_info->endio_freespace_worker;
 		func = btrfs_freespace_write_helper;
 	} else {
@@ -3871,7 +3871,7 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	 * The data relocation inode should also be directly updated
 	 * without delay
 	 */
-	if (!btrfs_is_free_space_inode(inode)
+	if (!btrfs_is_free_space_inode(BTRFS_I(inode))
 	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
 	    && !test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		btrfs_update_root_times(trans, root);
@@ -4325,7 +4325,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 * for non-free space inodes and ref cows, we want to back off from
 	 * time to time
 	 */
-	if (!btrfs_is_free_space_inode(inode) &&
+	if (!btrfs_is_free_space_inode(BTRFS_I(inode)) &&
 	    test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		be_nice = 1;
 
@@ -5179,7 +5179,7 @@ void btrfs_evict_inode(struct inode *inode)
 	if (inode->i_nlink &&
 	    ((btrfs_root_refs(&root->root_item) != 0 &&
 	      root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID) ||
-	     btrfs_is_free_space_inode(inode)))
+	     btrfs_is_free_space_inode(BTRFS_I(inode))))
 		goto no_delete;
 
 	if (is_bad_inode(inode)) {
@@ -5896,7 +5896,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
-	if (btrfs_fs_closing(root->fs_info) && btrfs_is_free_space_inode(inode))
+	if (btrfs_fs_closing(root->fs_info) && btrfs_is_free_space_inode(BTRFS_I(inode)))
 		nolock = true;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
-- 
2.7.4

