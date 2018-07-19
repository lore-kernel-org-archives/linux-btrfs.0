Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731154AbeGSLsI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:48:08 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C54EBACAA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs: drop extent_io_ops::merge_bio_hook callback
Date: Thu, 19 Jul 2018 13:05:21 +0200
Message-Id: <0e2c838370aab0b2da788a4c88174ec50979fc4c.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The data and metadata callback implementation both use the same
function. We can remove the call indirection completely.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 10 +++-------
 fs/btrfs/disk-io.c     |  2 --
 fs/btrfs/extent_io.c   |  4 ++--
 fs/btrfs/extent_io.h   |  3 ---
 fs/btrfs/inode.c       |  5 ++---
 5 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 70dace47258b..9bfa66592aa7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -299,7 +299,6 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	struct bio *bio = NULL;
 	struct compressed_bio *cb;
 	unsigned long bytes_left;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	int pg_index = 0;
 	struct page *page;
 	u64 first_byte = disk_start;
@@ -338,9 +337,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 		page = compressed_pages[pg_index];
 		page->mapping = inode->i_mapping;
 		if (bio->bi_iter.bi_size)
-			submit = io_tree->ops->merge_bio_hook(page, 0,
-							   PAGE_SIZE,
-							   bio, 0);
+			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE, bio, 0);
 
 		page->mapping = NULL;
 		if (submit || bio_add_page(bio, page, PAGE_SIZE, 0) <
@@ -622,9 +619,8 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		page->index = em_start >> PAGE_SHIFT;
 
 		if (comp_bio->bi_iter.bi_size)
-			submit = tree->ops->merge_bio_hook(page, 0,
-							PAGE_SIZE,
-							comp_bio, 0);
+			submit = btrfs_merge_bio_hook(page, 0, PAGE_SIZE,
+					comp_bio, 0);
 
 		page->mapping = NULL;
 		if (submit || bio_add_page(comp_bio, page, PAGE_SIZE, 0) <
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d6c04933abbc..31ab764cf4e3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4527,8 +4527,6 @@ static const struct extent_io_ops btree_extent_io_ops = {
 	/* mandatory callbacks */
 	.submit_bio_hook = btree_submit_bio_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
-	/* note we're sharing with inode.c for the merge bio hook */
-	.merge_bio_hook = btrfs_merge_bio_hook,
 	.readpage_io_failed_hook = btree_io_failed_hook,
 	.set_range_writeback = btrfs_set_range_writeback,
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f7a138278f16..55a845621f85 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2784,8 +2784,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 		else
 			contig = bio_end_sector(bio) == sector;
 
-		if (tree->ops && tree->ops->merge_bio_hook(page, offset,
-					page_size, bio, bio_flags))
+		if (tree->ops && btrfs_merge_bio_hook(page, offset, page_size,
+						      bio, bio_flags))
 			can_merge = false;
 
 		if (prev_bio_flags != bio_flags || !contig || !can_merge ||
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 6edbe01fd09d..ec7c4a2982d0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -101,9 +101,6 @@ struct extent_io_ops {
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
-	int (*merge_bio_hook)(struct page *page, unsigned long offset,
-			      size_t size, struct bio *bio,
-			      unsigned long bio_flags);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
 	void (*set_range_writeback)(void *private_data, u64 start, u64 end);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1614551cf953..845621a71468 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1893,8 +1893,8 @@ static void btrfs_clear_bit_hook(void *private_data,
 }
 
 /*
- * extent_io.c merge_bio_hook, this must check the chunk tree to make sure
- * we don't create bios that span stripes or chunks
+ * Merge bio hook, this must check the chunk tree to make sure we don't create
+ * bios that span stripes or chunks
  *
  * return 1 if page cannot be merged to bio
  * return 0 if page can be merged to bio
@@ -10540,7 +10540,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	/* mandatory callbacks */
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.readpage_end_io_hook = btrfs_readpage_end_io_hook,
-	.merge_bio_hook = btrfs_merge_bio_hook,
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 	.set_range_writeback = btrfs_set_range_writeback,
 
-- 
2.18.0

