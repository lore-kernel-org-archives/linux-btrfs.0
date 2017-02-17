Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34292 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934257AbdBQOoY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:24 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so2933026wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:24 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 37/38] btrfs: Make get_extent_t take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:28 +0200
Message-Id: <1487342609-20652-38-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In addition to changing the signature, this patch also switches
all the functions which are used as an argument to also take btrfs_inode.
Namely those are: btrfs_get_extent and btrfs_get_extent_filemap.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     |  4 ++--
 fs/btrfs/disk-io.c   |  6 +++---
 fs/btrfs/extent_io.c |  6 +++---
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/file.c      |  6 +++---
 fs/btrfs/inode.c     | 24 ++++++++++++------------
 fs/btrfs/ioctl.c     |  2 +-
 7 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d44d414a2127..7ac0338379b4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3100,7 +3100,7 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 						    int delay_iput);
 void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
 
-struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode, struct page *page,
 					   size_t pg_offset, u64 start, u64 len,
 					   int create);
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
@@ -3166,7 +3166,7 @@ void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
-struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
+struct extent_map *btrfs_get_extent(struct btrfs_inode *inode, struct page *page,
 				    size_t pg_offset, u64 start, u64 end,
 				    int create);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 32a9ec11888d..3c0dd67333ee 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -219,12 +219,12 @@ void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
  * extents on the btree inode are pretty simple, there's one extent
  * that covers the entire device
  */
-static struct extent_map *btree_get_extent(struct inode *inode,
+static struct extent_map *btree_get_extent(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start, u64 len,
 		int create)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct extent_map *em;
 	int ret;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fad5b2030c37..887d8a896ce1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2857,7 +2857,7 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
 		*em_cached = NULL;
 	}
 
-	em = get_extent(inode, page, pg_offset, start, len, 0);
+	em = get_extent(BTRFS_I(inode), page, pg_offset, start, len, 0);
 	if (em_cached && !IS_ERR_OR_NULL(em)) {
 		BUG_ON(*em_cached);
 		atomic_inc(&em->refs);
@@ -3370,7 +3370,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 							 page_end, NULL, 1);
 			break;
 		}
-		em = epd->get_extent(inode, page, pg_offset, cur,
+		em = epd->get_extent(BTRFS_I(inode), page, pg_offset, cur,
 				     end - cur + 1, 1);
 		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
@@ -4335,7 +4335,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 		if (len == 0)
 			break;
 		len = ALIGN(len, sectorsize);
-		em = get_extent(inode, NULL, 0, offset, len, 0);
+		em = get_extent(BTRFS_I(inode), NULL, 0, offset, len, 0);
 		if (IS_ERR_OR_NULL(em))
 			return em;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 302e64be2e20..5e922e87abab 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -210,7 +210,7 @@ static inline int extent_compress_type(unsigned long bio_flags)
 
 struct extent_map_tree;
 
-typedef struct extent_map *(get_extent_t)(struct inode *inode,
+typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 					  struct page *page,
 					  size_t pg_offset,
 					  u64 start, u64 len,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2d534d6c5514..d3e25730cdf0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2334,7 +2334,7 @@ static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
 	struct extent_map *em;
 	int ret = 0;
 
-	em = btrfs_get_extent(inode, NULL, 0, *start, *len, 0);
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start, *len, 0);
 	if (IS_ERR_OR_NULL(em)) {
 		if (!em)
 			ret = -ENOMEM;
@@ -2824,7 +2824,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	/* First, check if we exceed the qgroup limit */
 	INIT_LIST_HEAD(&reserve_list);
 	while (1) {
-		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
 		if (IS_ERR_OR_NULL(em)) {
 			if (!em)
@@ -2951,7 +2951,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 			 &cached_state);
 
 	while (start < inode->i_size) {
-		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
+		em = btrfs_get_extent_fiemap(BTRFS_I(inode), NULL, 0, start, len, 0);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
 			em = NULL;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1ba412440979..d78ec8d78781 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4843,7 +4843,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 	cur_offset = hole_start;
 	while (1) {
-		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, cur_offset,
 				block_end - cur_offset, 0);
 		if (IS_ERR(em)) {
 			err = PTR_ERR(em);
@@ -6721,25 +6721,25 @@ static noinline int uncompress_inline(struct btrfs_path *path,
  * This also copies inline extents directly into the page.
  */
 
-struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
+struct extent_map *btrfs_get_extent(struct btrfs_inode *inode, struct page *page,
 				    size_t pg_offset, u64 start, u64 len,
 				    int create)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	int ret;
 	int err = 0;
 	u64 extent_start = 0;
 	u64 extent_end = 0;
-	u64 objectid = btrfs_ino(BTRFS_I(inode));
+	u64 objectid = btrfs_ino(inode);
 	u32 found_type;
 	struct btrfs_path *path = NULL;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct btrfs_file_extent_item *item;
 	struct extent_buffer *leaf;
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map_tree *em_tree = &inode->extent_tree;
+	struct extent_io_tree *io_tree = &inode->io_tree;
 	struct btrfs_trans_handle *trans = NULL;
 	const bool new_inline = !page || create;
 
@@ -6852,7 +6852,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 		goto not_found_em;
 	}
 
-	btrfs_extent_item_to_extent_map(BTRFS_I(inode), path, item, new_inline, em);
+	btrfs_extent_item_to_extent_map(inode, path, item, new_inline, em);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -6988,7 +6988,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	write_unlock(&em_tree->lock);
 out:
 
-	trace_btrfs_get_extent(root, BTRFS_I(inode), em);
+	trace_btrfs_get_extent(root, inode, em);
 
 	btrfs_free_path(path);
 	if (trans) {
@@ -7004,7 +7004,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	return em;
 }
 
-struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode, struct page *page,
 					   size_t pg_offset, u64 start, u64 len,
 					   int create)
 {
@@ -7043,7 +7043,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
 	em = NULL;
 
 	/* ok, we didn't find anything, lets look for delalloc */
-	found = count_range_bits(&BTRFS_I(inode)->io_tree, &range_start,
+	found = count_range_bits(&inode->io_tree, &range_start,
 				 end, len, EXTENT_DELALLOC, 1);
 	found_end = range_start + found;
 	if (found_end < range_start)
@@ -7613,7 +7613,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		goto err;
 	}
 
-	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
 	if (IS_ERR(em)) {
 		ret = PTR_ERR(em);
 		goto unlock_err;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cdbf30e5743b..9011bd135223 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1009,7 +1009,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 
 		/* get the big lock and read metadata off disk */
 		lock_extent_bits(io_tree, start, end, &cached);
-		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
 		unlock_extent_cached(io_tree, start, end, &cached, GFP_NOFS);
 
 		if (IS_ERR(em))
-- 
2.7.4

