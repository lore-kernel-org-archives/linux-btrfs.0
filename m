Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37987 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752071Ab3KDVg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:36:59 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] btrfs: remove unused variables from extent_io.c
Date: Mon,  4 Nov 2013 22:34:25 +0100
Message-Id: <1383600869-10085-6-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused variables:
* tree from end_bio_extent_writepage,
* item from extent_fiemap.

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/extent_io.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d8ea0cb..2e6cd72 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2333,13 +2333,11 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
 
 	do {
 		struct page *page = bvec->bv_page;
-		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
 		/* We always issue full-page reads, but if some block
 		 * in a page fails to read, blk_update_request() will
@@ -4070,12 +4068,10 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	struct btrfs_path *path;
-	struct btrfs_file_extent_item *item;
 	int end = 0;
 	u64 em_start = 0;
 	u64 em_len = 0;
 	u64 em_end = 0;
-	unsigned long emflags;
 
 	if (len == 0)
 		return -EINVAL;
@@ -4100,8 +4096,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 	WARN_ON(!ret);
 	path->slots[0]--;
-	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-			      struct btrfs_file_extent_item);
 	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
 	found_type = btrfs_key_type(&found_key);
 
@@ -4169,7 +4163,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			offset_in_extent = em_start - em->start;
 		em_end = extent_map_end(em);
 		em_len = em_end - em_start;
-		emflags = em->flags;
 		disko = 0;
 		flags = 0;
 
-- 
1.7.10.4

