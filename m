Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3D2Niv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 09:38:51 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5E9B1A5623
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 15:38:50 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: use unsigned long type for extent state bits
Date: Mon, 29 Apr 2013 15:38:46 +0200
Message-Id: <1367242726-8893-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |   48 +++++++++++++++++++++++++-----------------------
 fs/btrfs/extent_io.h |   28 +++++++++++++++-------------
 fs/btrfs/inode.c     |    5 +++--
 3 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e1abebd..718c431 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -308,21 +308,21 @@ static void merge_state(struct extent_io_tree *tree,
 }
 
 static void set_state_cb(struct extent_io_tree *tree,
-			 struct extent_state *state, int *bits)
+			 struct extent_state *state, unsigned long *bits)
 {
 	if (tree->ops && tree->ops->set_bit_hook)
 		tree->ops->set_bit_hook(tree->mapping->host, state, bits);
 }
 
 static void clear_state_cb(struct extent_io_tree *tree,
-			   struct extent_state *state, int *bits)
+			   struct extent_state *state, unsigned long *bits)
 {
 	if (tree->ops && tree->ops->clear_bit_hook)
 		tree->ops->clear_bit_hook(tree->mapping->host, state, bits);
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
-			   struct extent_state *state, int *bits);
+			   struct extent_state *state, unsigned long *bits);
 
 /*
  * insert an extent_state struct into the tree.  'bits' are set on the
@@ -336,7 +336,7 @@ static void set_state_bits(struct extent_io_tree *tree,
  */
 static int insert_state(struct extent_io_tree *tree,
 			struct extent_state *state, u64 start, u64 end,
-			int *bits)
+			unsigned long *bits)
 {
 	struct rb_node *node;
 
@@ -424,10 +424,10 @@ static struct extent_state *next_state(struct extent_state *state)
  */
 static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 					    struct extent_state *state,
-					    int *bits, int wake)
+					    unsigned long *bits, int wake)
 {
 	struct extent_state *next;
-	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
+	unsigned long bits_to_clear = *bits & ~EXTENT_CTLBITS;
 
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
@@ -483,7 +483,7 @@ void extent_io_tree_panic(struct extent_io_tree *tree, int err)
  * This takes the tree lock, and returns 0 on success and < 0 on error.
  */
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete,
+		     unsigned long bits, int wake, int delete,
 		     struct extent_state **cached_state,
 		     gfp_t mask)
 {
@@ -644,7 +644,8 @@ static void wait_on_state(struct extent_io_tree *tree,
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		     unsigned long bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -685,9 +686,9 @@ out:
 
 static void set_state_bits(struct extent_io_tree *tree,
 			   struct extent_state *state,
-			   int *bits)
+			   unsigned long *bits)
 {
-	int bits_to_set = *bits & ~EXTENT_CTLBITS;
+	unsigned long bits_to_set = *bits & ~EXTENT_CTLBITS;
 
 	set_state_cb(tree, state, bits);
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
@@ -730,8 +731,9 @@ static void uncache_state(struct extent_state **cached_ptr)
 
 static int __must_check
 __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		 int bits, int exclusive_bits, u64 *failed_start,
-		 struct extent_state **cached_state, gfp_t mask)
+		 unsigned long bits, unsigned long exclusive_bits,
+		 u64 *failed_start, struct extent_state **cached_state,
+		 gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -923,9 +925,9 @@ search_again:
 	goto again;
 }
 
-int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
-		   u64 *failed_start, struct extent_state **cached_state,
-		   gfp_t mask)
+int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		   unsigned long bits, u64 * failed_start,
+		   struct extent_state **cached_state, gfp_t mask)
 {
 	return __set_extent_bit(tree, start, end, bits, 0, failed_start,
 				cached_state, mask);
@@ -950,7 +952,7 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
  * boundary bits like LOCK.
  */
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits,
+		       unsigned long bits, unsigned long clear_bits,
 		       struct extent_state **cached_state, gfp_t mask)
 {
 	struct extent_state *state;
@@ -1143,14 +1145,14 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		    int bits, gfp_t mask)
+		    unsigned long bits, gfp_t mask)
 {
 	return set_extent_bit(tree, start, end, bits, NULL,
 			      NULL, mask);
 }
 
 int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		      int bits, gfp_t mask)
+		      unsigned long bits, gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask);
 }
@@ -1205,7 +1207,7 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
  * us if waiting is desired.
  */
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached_state)
+		     unsigned long bits, struct extent_state **cached_state)
 {
 	int err;
 	u64 failed_start;
@@ -1314,7 +1316,7 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
  * nothing was found after 'start'
  */
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
-						 u64 start, int bits)
+						 u64 start, unsigned long bits)
 {
 	struct rb_node *node;
 	struct extent_state *state;
@@ -1348,7 +1350,7 @@ out:
  * If nothing was found, 1 is returned. If found something, return 0.
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits,
+			  u64 *start_ret, u64 *end_ret, unsigned long bits,
 			  struct extent_state **cached_state)
 {
 	struct extent_state *state;
@@ -1638,7 +1640,7 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
 	unsigned long nr_pages = end_index - index + 1;
 	int i;
-	int clear_bits = 0;
+	unsigned long clear_bits = 0;
 
 	if (op & EXTENT_CLEAR_UNLOCK)
 		clear_bits |= EXTENT_LOCKED;
@@ -1869,7 +1871,7 @@ out:
  * range is found set.
  */
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int filled, struct extent_state *cached)
+		   unsigned long bits, int filled, struct extent_state *cached)
 {
 	struct extent_state *state = NULL;
 	struct rb_node *node;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5e409ea..81ad141 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -81,9 +81,9 @@ struct extent_io_ops {
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
-			     int *bits);
+			     unsigned long *bits);
 	void (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
-			       int *bits);
+			       unsigned long *bits);
 	void (*merge_extent_hook)(struct inode *inode,
 				  struct extent_state *new,
 				  struct extent_state *other);
@@ -191,7 +191,7 @@ int try_release_extent_state(struct extent_map_tree *map,
 			     gfp_t mask);
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached);
+		     unsigned long bits, struct extent_state **cached);
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask);
@@ -207,16 +207,17 @@ u64 count_range_bits(struct extent_io_tree *tree,
 
 void free_extent_state(struct extent_state *state);
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int filled, struct extent_state *cached_state);
+		   unsigned long bits, int filled,
+		   struct extent_state *cached_state);
 int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		      int bits, gfp_t mask);
+		      unsigned long bits, gfp_t mask);
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete, struct extent_state **cached,
-		     gfp_t mask);
+		     unsigned long bits, int wake, int delete,
+		     struct extent_state **cached, gfp_t mask);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		    int bits, gfp_t mask);
+		    unsigned long bits, gfp_t mask);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, u64 *failed_start,
+		   unsigned long bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
@@ -229,17 +230,17 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits,
+		       unsigned long bits, unsigned long clear_bits,
 		       struct extent_state **cached_state, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
 		      struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits,
+			  u64 *start_ret, u64 *end_ret, unsigned long bits,
 			  struct extent_state **cached_state);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
-						 u64 start, int bits);
+						 u64 start, unsigned long bits);
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
@@ -317,7 +318,8 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		     unsigned long bits);
 void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_buffer *eb);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d65a55c..11623f4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1522,7 +1522,7 @@ static void btrfs_merge_extent_hook(struct inode *inode,
  * have pending delalloc work to be done.
  */
 static void btrfs_set_bit_hook(struct inode *inode,
-			       struct extent_state *state, int *bits)
+			       struct extent_state *state, unsigned long *bits)
 {
 
 	/*
@@ -1566,7 +1566,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
 static void btrfs_clear_bit_hook(struct inode *inode,
-				 struct extent_state *state, int *bits)
+				 struct extent_state *state,
+				 unsigned long *bits)
 {
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
-- 
1.7.9

