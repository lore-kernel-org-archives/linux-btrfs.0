Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab2GJLkk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 07:40:40 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6ABHmaE004477
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2012 19:17:51 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: kill root from btrfs_is_free_space_inode
Date: Tue, 10 Jul 2012 19:28:39 +0800
Message-Id: <1341919719-13825-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since root can be fetched via BTRFS_I macro directly, we can save an args
for btrfs_is_free_space_inode().

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    5 +++--
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/file-item.c   |    2 +-
 fs/btrfs/inode.c       |   22 +++++++++++-----------
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index b168238..21b8cfe 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -191,9 +191,10 @@ static inline void btrfs_i_size_write(struct inode *inode, u64 size)
 	BTRFS_I(inode)->disk_i_size = size;
 }
 
-static inline bool btrfs_is_free_space_inode(struct btrfs_root *root,
-				       struct inode *inode)
+static inline bool btrfs_is_free_space_inode(struct inode *inode)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
 	if (root == root->fs_info->tree_root &&
 	    btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID)
 		return true;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6e1d367..07087f6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4444,7 +4444,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	int ret;
 
 	/* Need to be holding the i_mutex here if we aren't free space cache */
-	if (btrfs_is_free_space_inode(root, inode))
+	if (btrfs_is_free_space_inode(inode))
 		flush = 0;
 
 	if (flush && btrfs_transaction_in_commit(root->fs_info))
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5d158d3..af87025 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -183,7 +183,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	 * read from the commit root and sidestep a nasty deadlock
 	 * between reading the free space cache and updating the csum tree.
 	 */
-	if (btrfs_is_free_space_inode(root, inode)) {
+	if (btrfs_is_free_space_inode(inode)) {
 		path->search_commit_root = 1;
 		path->skip_locking = 1;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a7d1921..5d463d4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -825,7 +825,7 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
-	BUG_ON(btrfs_is_free_space_inode(root, inode));
+	BUG_ON(btrfs_is_free_space_inode(inode));
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		extent_clear_unlock_delalloc(inode,
@@ -1153,7 +1153,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		return -ENOMEM;
 	}
 
-	nolock = btrfs_is_free_space_inode(root, inode);
+	nolock = btrfs_is_free_space_inode(inode);
 
 	if (nolock)
 		trans = btrfs_join_transaction_nolock(root);
@@ -1466,7 +1466,7 @@ static void btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		bool do_list = !btrfs_is_free_space_inode(root, inode);
+		bool do_list = !btrfs_is_free_space_inode(inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1501,7 +1501,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 	if ((state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		bool do_list = !btrfs_is_free_space_inode(root, inode);
+		bool do_list = !btrfs_is_free_space_inode(inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
@@ -1612,7 +1612,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	if (btrfs_is_free_space_inode(root, inode))
+	if (btrfs_is_free_space_inode(inode))
 		metadata = 2;
 
 	if (!(rw & REQ_WRITE)) {
@@ -1869,7 +1869,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	int ret;
 	bool nolock;
 
-	nolock = btrfs_is_free_space_inode(root, inode);
+	nolock = btrfs_is_free_space_inode(inode);
 
 	if (test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags)) {
 		ret = -EIO;
@@ -2007,7 +2007,7 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
 	ordered_extent->work.func = finish_ordered_fn;
 	ordered_extent->work.flags = 0;
 
-	if (btrfs_is_free_space_inode(root, inode))
+	if (btrfs_is_free_space_inode(inode))
 		workers = &root->fs_info->endio_freespace_worker;
 	else
 		workers = &root->fs_info->endio_write_workers;
@@ -2732,7 +2732,7 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	 * The data relocation inode should also be directly updated
 	 * without delay
 	 */
-	if (!btrfs_is_free_space_inode(root, inode)
+	if (!btrfs_is_free_space_inode(inode)
 	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
 		ret = btrfs_delayed_update_inode(trans, root, inode);
 		if (!ret)
@@ -3743,7 +3743,7 @@ void btrfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
-			       btrfs_is_free_space_inode(root, inode)))
+			       btrfs_is_free_space_inode(inode)))
 		goto no_delete;
 
 	if (is_bad_inode(inode)) {
@@ -4457,7 +4457,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
-	if (btrfs_fs_closing(root->fs_info) && btrfs_is_free_space_inode(root, inode))
+	if (btrfs_fs_closing(root->fs_info) && btrfs_is_free_space_inode(inode))
 		nolock = true;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
@@ -7046,7 +7046,7 @@ int btrfs_drop_inode(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    !btrfs_is_free_space_inode(root, inode))
+	    !btrfs_is_free_space_inode(inode))
 		return 1;
 	else
 		return generic_drop_inode(inode);
-- 
1.6.5.2

