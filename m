Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbbBYSY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D3821AAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:54 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 07/11] btrfs: cleanup, use kmalloc_array/kcalloc array helpers
Date: Wed, 25 Feb 2015 19:24:54 +0100
Message-Id: <fd5ff2cd4e6345f95dd1fe8507e491facbd26c95.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert kmalloc(nr * size, ..) to kmalloc_array that does additional
overflow checks, the zeroing variant is kcalloc.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/check-integrity.c  | 4 ++--
 fs/btrfs/compression.c      | 2 +-
 fs/btrfs/ctree.c            | 9 ++++-----
 fs/btrfs/disk-io.c          | 2 +-
 fs/btrfs/file-item.c        | 4 ++--
 fs/btrfs/file.c             | 2 +-
 fs/btrfs/free-space-cache.c | 2 +-
 fs/btrfs/inode.c            | 2 +-
 fs/btrfs/raid56.c           | 3 +--
 fs/btrfs/scrub.c            | 5 ++---
 fs/btrfs/volumes.c          | 4 ++--
 11 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d897ef803b3b..089d6fac01a7 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2990,8 +2990,8 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 			       (unsigned long long)bio->bi_iter.bi_sector,
 			       dev_bytenr, bio->bi_bdev);
 
-		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
-				       GFP_NOFS);
+		mapped_datav = kmalloc_array(bio->bi_vcnt,
+					     sizeof(*mapped_datav), GFP_NOFS);
 		if (!mapped_datav)
 			goto leave;
 		cur_bytenr = dev_bytenr;
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e9df8862012c..ecacb7a2d422 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -622,7 +622,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	cb->orig_bio = bio;
 
 	nr_pages = DIV_ROUND_UP(compressed_len, PAGE_CACHE_SIZE);
-	cb->compressed_pages = kzalloc(sizeof(struct page *) * nr_pages,
+	cb->compressed_pages = kcalloc(nr_pages, sizeof(struct page *),
 				       GFP_NOFS);
 	if (!cb->compressed_pages)
 		goto fail1;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 993642199326..8595fdd50a22 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -578,7 +578,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	if (!tree_mod_need_log(fs_info, eb))
 		return 0;
 
-	tm_list = kzalloc(nr_items * sizeof(struct tree_mod_elem *), flags);
+	tm_list = kcalloc(nr_items, sizeof(struct tree_mod_elem *), flags);
 	if (!tm_list)
 		return -ENOMEM;
 
@@ -677,7 +677,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 
 	if (log_removal && btrfs_header_level(old_root) > 0) {
 		nritems = btrfs_header_nritems(old_root);
-		tm_list = kzalloc(nritems * sizeof(struct tree_mod_elem *),
+		tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *),
 				  flags);
 		if (!tm_list) {
 			ret = -ENOMEM;
@@ -814,7 +814,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0)
 		return 0;
 
-	tm_list = kzalloc(nr_items * 2 * sizeof(struct tree_mod_elem *),
+	tm_list = kcalloc(nr_items * 2, sizeof(struct tree_mod_elem *),
 			  GFP_NOFS);
 	if (!tm_list)
 		return -ENOMEM;
@@ -905,8 +905,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 		return 0;
 
 	nritems = btrfs_header_nritems(eb);
-	tm_list = kzalloc(nritems * sizeof(struct tree_mod_elem *),
-			  GFP_NOFS);
+	tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *), GFP_NOFS);
 	if (!tm_list)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 73b152138221..14e4a3e0f9b2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -302,7 +302,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		offset += cur_len;
 	}
 	if (csum_size > sizeof(inline_result)) {
-		result = kzalloc(csum_size * sizeof(char), GFP_NOFS);
+		result = kzalloc(csum_size, GFP_NOFS);
 		if (!result)
 			return 1;
 	} else {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 84a2d1868271..3a4a7924fa38 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -185,8 +185,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	nblocks = bio->bi_iter.bi_size >> inode->i_sb->s_blocksize_bits;
 	if (!dst) {
 		if (nblocks * csum_size > BTRFS_BIO_INLINE_CSUM_SIZE) {
-			btrfs_bio->csum_allocated = kmalloc(nblocks * csum_size,
-							    GFP_NOFS);
+			btrfs_bio->csum_allocated = kmalloc_array(nblocks,
+					csum_size, GFP_NOFS);
 			if (!btrfs_bio->csum_allocated) {
 				btrfs_free_path(path);
 				return -ENOMEM;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1e34bc00249f..e74abb3018d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1481,7 +1481,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			PAGE_CACHE_SIZE / (sizeof(struct page *)));
 	nrptrs = min(nrptrs, current->nr_dirtied_pause - current->nr_dirtied);
 	nrptrs = max(nrptrs, 8);
-	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	pages = kmalloc_array(nrptrs, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 63219ba3a6c1..df550eb5cddd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -298,7 +298,7 @@ static int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
 
 	memset(io_ctl, 0, sizeof(struct io_ctl));
 
-	io_ctl->pages = kzalloc(sizeof(struct page *) * num_pages, GFP_NOFS);
+	io_ctl->pages = kcalloc(num_pages, sizeof(struct page *), GFP_NOFS);
 	if (!io_ctl->pages)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8564d8ce03de..21e4affafa3e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -463,7 +463,7 @@ again:
 	 */
 	if (inode_need_compress(inode)) {
 		WARN_ON(pages);
-		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
+		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
 			/* just bail out to the uncompressed code */
 			goto cont;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5264858ed768..b4634c30981e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1807,8 +1807,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	int err;
 	int i;
 
-	pointers = kzalloc(rbio->real_stripes * sizeof(void *),
-			   GFP_NOFS);
+	pointers = kcalloc(rbio->real_stripes, sizeof(void *), GFP_NOFS);
 	if (!pointers) {
 		err = -ENOMEM;
 		goto cleanup_io;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5c3ca68b1fb4..0d1414659bc1 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -964,9 +964,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	 * the statistics.
 	 */
 
-	sblocks_for_recheck = kzalloc(BTRFS_MAX_MIRRORS *
-				     sizeof(*sblocks_for_recheck),
-				     GFP_NOFS);
+	sblocks_for_recheck = kcalloc(BTRFS_MAX_MIRRORS,
+				      sizeof(*sblocks_for_recheck), GFP_NOFS);
 	if (!sblocks_for_recheck) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.malloc_errors++;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5f3133e5390b..11bd47ba6a48 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4288,7 +4288,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
+	devices_info = kcalloc(fs_devices->rw_devices, sizeof(*devices_info),
 			       GFP_NOFS);
 	if (!devices_info)
 		return -ENOMEM;
@@ -5546,7 +5546,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		rmap_len = map->stripe_len * nr_data_stripes(map);
 	}
 
-	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
+	buf = kcalloc(map->num_stripes, sizeof(u64), GFP_NOFS);
 	BUG_ON(!buf); /* -ENOMEM */
 
 	for (i = 0; i < map->num_stripes; i++) {
-- 
2.1.3

