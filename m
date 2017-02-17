Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36601 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934466AbdBQOoN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:13 -0500
Received: by mail-wr0-f193.google.com with SMTP id z61so4717998wrc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:13 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 20/38] btrfs: Make btrfs_lookup_ordered_range take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:11 +0200
Message-Id: <1487342609-20652-21-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c    |  4 ++--
 fs/btrfs/file.c         |  4 ++--
 fs/btrfs/inode.c        | 10 +++++-----
 fs/btrfs/ordered-data.c |  6 +++---
 fs/btrfs/ordered-data.h |  2 +-
 fs/btrfs/scrub.c        |  2 +-
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d15b5ddb6732..996306d322de 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3101,7 +3101,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 	inode = pages[0]->mapping->host;
 	while (1) {
 		lock_extent(tree, start, end);
-		ordered = btrfs_lookup_ordered_range(inode, start,
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start,
 						     end - start + 1);
 		if (!ordered)
 			break;
@@ -3173,7 +3173,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 	while (1) {
 		lock_extent(tree, start, end);
-		ordered = btrfs_lookup_ordered_range(inode, start,
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start,
 						PAGE_SIZE);
 		if (!ordered)
 			break;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8e48094ae831..c12d7308205b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1436,7 +1436,7 @@ lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
 				 start_pos, last_pos, cached_state);
-		ordered = btrfs_lookup_ordered_range(inode, start_pos,
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start_pos,
 						     last_pos - start_pos + 1);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > start_pos &&
@@ -1494,7 +1494,7 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 
 	while (1) {
 		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
-		ordered = btrfs_lookup_ordered_range(inode, lockstart,
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), lockstart,
 						     lockend - lockstart + 1);
 		if (!ordered) {
 			break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ac134d75cd08..8c03abf69ac8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1969,7 +1969,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	if (PagePrivate2(page))
 		goto out;
 
-	ordered = btrfs_lookup_ordered_range(inode, page_start,
+	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), page_start,
 					PAGE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
@@ -4833,7 +4833,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 		lock_extent_bits(io_tree, hole_start, block_end - 1,
 				 &cached_state);
-		ordered = btrfs_lookup_ordered_range(inode, hole_start,
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), hole_start,
 						     block_end - hole_start);
 		if (!ordered)
 			break;
@@ -7421,7 +7421,7 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 		 * doing DIO to, so we need to make sure there's no ordered
 		 * extents in this range.
 		 */
-		ordered = btrfs_lookup_ordered_range(inode, lockstart,
+		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), lockstart,
 						     lockend - lockstart + 1);
 
 		/*
@@ -8794,7 +8794,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 		lock_extent_bits(tree, page_start, page_end, &cached_state);
 again:
 	start = page_start;
-	ordered = btrfs_lookup_ordered_range(inode, start,
+	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start,
 					page_end - start + 1);
 	if (ordered) {
 		end = min(page_end, ordered->file_offset + ordered->len - 1);
@@ -8960,7 +8960,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
+	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), page_start, PAGE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index bc2aba810629..b69c5b854789 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -879,7 +879,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 /* Since the DIO code tries to lock a wide area we need to look for any ordered
  * extents that exist in the range, rather than just the start of the range.
  */
-struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
+struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct btrfs_inode *inode,
 							u64 file_offset,
 							u64 len)
 {
@@ -887,7 +887,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry = NULL;
 
-	tree = &BTRFS_I(inode)->ordered_tree;
+	tree = &inode->ordered_tree;
 	spin_lock_irq(&tree->lock);
 	node = tree_search(tree, file_offset);
 	if (!node) {
@@ -923,7 +923,7 @@ bool btrfs_have_ordered_extents_in_range(struct inode *inode,
 {
 	struct btrfs_ordered_extent *oe;
 
-	oe = btrfs_lookup_ordered_range(inode, file_offset, len);
+	oe = btrfs_lookup_ordered_range(BTRFS_I(inode), file_offset, len);
 	if (oe) {
 		btrfs_put_ordered_extent(oe);
 		return true;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index a8cb8efe6fae..601900fcb738 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -189,7 +189,7 @@ void btrfs_start_ordered_extent(struct inode *inode,
 int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
 struct btrfs_ordered_extent *
 btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
-struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
+struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct btrfs_inode *inode,
 							u64 file_offset,
 							u64 len);
 bool btrfs_have_ordered_extents_in_range(struct inode *inode,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ff9a11c39f5e..82d873406aa3 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4249,7 +4249,7 @@ static int check_extent_to_block(struct inode *inode, u64 start, u64 len,
 	io_tree = &BTRFS_I(inode)->io_tree;
 
 	lock_extent_bits(io_tree, lockstart, lockend, &cached_state);
-	ordered = btrfs_lookup_ordered_range(inode, lockstart, len);
+	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), lockstart, len);
 	if (ordered) {
 		btrfs_put_ordered_extent(ordered);
 		ret = 1;
-- 
2.7.4

