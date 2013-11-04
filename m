Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37984 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751927Ab3KDVg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:36:59 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs: remove unused variables from disk-io.c
Date: Mon,  4 Nov 2013 22:34:23 +0100
Message-Id: <1383600869-10085-4-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused variables:
* tree from csum_dirty_buffer,
* tree from btree_readpage_end_io_hook,
* tree from btree_writepages,
* bytenr from btrfs_create_tree,
* fs_info from end_workqueue_fn.

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/disk-io.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..9c2bb64 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -466,13 +466,10 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
-	struct extent_io_tree *tree;
 	u64 start = page_offset(page);
 	u64 found_start;
 	struct extent_buffer *eb;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-
 	eb = (struct extent_buffer *)page->private;
 	if (page != eb->pages[0])
 		return 0;
@@ -577,7 +574,6 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 				      u64 phy_offset, struct page *page,
 				      u64 start, u64 end, int mirror)
 {
-	struct extent_io_tree *tree;
 	u64 found_start;
 	int found_level;
 	struct extent_buffer *eb;
@@ -588,7 +584,6 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	if (!page->private)
 		goto out;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	eb = (struct extent_buffer *)page->private;
 
 	/* the pending IO might have been the only thing that kept this buffer
@@ -975,11 +970,9 @@ static int btree_migratepage(struct address_space *mapping,
 static int btree_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	struct extent_io_tree *tree;
 	struct btrfs_fs_info *fs_info;
 	int ret;
 
-	tree = &BTRFS_I(mapping->host)->io_tree;
 	if (wbc->sync_mode == WB_SYNC_NONE) {
 
 		if (wbc->for_kupdate)
@@ -1262,7 +1255,6 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	int ret = 0;
-	u64 bytenr;
 	uuid_le uuid;
 
 	root = btrfs_alloc_root(fs_info);
@@ -1284,7 +1276,6 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	bytenr = leaf->start;
 	memset_extent_buffer(leaf, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(leaf, leaf->start);
 	btrfs_set_header_generation(leaf, trans->transid);
@@ -1673,12 +1664,10 @@ static void end_workqueue_fn(struct btrfs_work *work)
 {
 	struct bio *bio;
 	struct end_io_wq *end_io_wq;
-	struct btrfs_fs_info *fs_info;
 	int error;
 
 	end_io_wq = container_of(work, struct end_io_wq, work);
 	bio = end_io_wq->bio;
-	fs_info = end_io_wq->info;
 
 	error = end_io_wq->error;
 	bio->bi_private = end_io_wq->private;
-- 
1.7.10.4

