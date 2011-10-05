From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/8] btrfs: use unsigned long type for extent state bits
Date: Wed,  5 Oct 2011 12:21:52 +0200
Message-ID: <8bc68eccc6b6f826a0389a774e84bc9b1ebc1ed6.1317746377.git.dsterba@suse.cz>
References: <cover.1317746377.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317746377.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |   45 ++++++++++++++++++++++++---------------------
 fs/btrfs/extent_io.h |   33 +++++++++++++++++++--------------
 fs/btrfs/inode.c     |    7 ++++---
 3 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0ada0b7..0e206ff 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -290,21 +290,21 @@ static void merge_state(struct extent_io_tree *tree,
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
@@ -318,7 +318,7 @@ static void set_state_bits(struct extent_io_tree *tree,
  */
 static int insert_state(struct extent_io_tree *tree,
 			struct extent_state *state, u64 start, u64 end,
-			int *bits)
+			unsigned long *bits)
 {
 	struct rb_node *node;
 
@@ -400,9 +400,9 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
  */
 static int clear_state_bit(struct extent_io_tree *tree,
 			    struct extent_state *state,
-			    int *bits, int wake)
+			    unsigned long *bits, int wake)
 {
-	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
+	unsigned long bits_to_clear = *bits & ~EXTENT_CTLBITS;
 	int ret = state->state & bits_to_clear;
 
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
@@ -451,7 +451,7 @@ alloc_extent_state_atomic(struct extent_state *prealloc)
  * bits were already set, or zero if none of the bits were already set.
  */
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, int wake, int delete,
+		     unsigned long bits, int wake, int delete,
 		     struct extent_state **cached_state,
 		     gfp_t mask)
 {
@@ -615,7 +615,7 @@ static int wait_on_state(struct extent_io_tree *tree,
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, unsigned long bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -657,9 +657,9 @@ out:
 
 static void set_state_bits(struct extent_io_tree *tree,
 			   struct extent_state *state,
-			   int *bits)
+			   unsigned long *bits)
 {
-	int bits_to_set = *bits & ~EXTENT_CTLBITS;
+	unsigned long bits_to_set = *bits & ~EXTENT_CTLBITS;
 
 	set_state_cb(tree, state, bits);
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
@@ -700,9 +700,10 @@ static void uncache_state(struct extent_state **cached_ptr)
  * [start, end] is inclusive This takes the tree lock.
  */
 
-int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int exclusive_bits, u64 *failed_start,
-		   struct extent_state **cached_state, gfp_t mask)
+int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, unsigned
+		   long bits, unsigned long exclusive_bits,
+		   u64 *failed_start, struct extent_state **cached_state,
+		   gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -910,7 +911,8 @@ search_again:
  * boundary bits like LOCK.
  */
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask)
+		       unsigned long bits, unsigned long clear_bits,
+		       gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -1091,14 +1093,14 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		    int bits, gfp_t mask)
+		    unsigned long bits, gfp_t mask)
 {
 	return set_extent_bit(tree, start, end, bits, 0, NULL,
 			      NULL, mask);
 }
 
 int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		      int bits, gfp_t mask)
+		      unsigned long bits, gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask);
 }
@@ -1146,7 +1148,8 @@ static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
  * us if waiting is desired.
  */
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached_state, gfp_t mask)
+		     unsigned long bits, struct extent_state **cached_state,
+		     gfp_t mask)
 {
 	int err;
 	u64 failed_start;
@@ -1224,7 +1227,7 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
  * nothing was found after 'start'
  */
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
-						 u64 start, int bits)
+						 u64 start, unsigned long bits)
 {
 	struct rb_node *node;
 	struct extent_state *state;
@@ -1258,7 +1261,7 @@ out:
  * If nothing was found, 1 is returned, < 0 on error
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits)
+			  u64 *start_ret, u64 *end_ret, unsigned long bits)
 {
 	struct extent_state *state;
 	int ret = 1;
@@ -1526,7 +1529,7 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 	unsigned long end_index = end >> PAGE_CACHE_SHIFT;
 	unsigned long nr_pages = end_index - index + 1;
 	int i;
-	int clear_bits = 0;
+	unsigned long clear_bits = 0;
 
 	if (op & EXTENT_CLEAR_UNLOCK)
 		clear_bits |= EXTENT_LOCKED;
@@ -1699,7 +1702,7 @@ out:
  * range is found set.
  */
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int filled, struct extent_state *cached)
+		   unsigned long bits, int filled, struct extent_state *cached)
 {
 	struct extent_state *state = NULL;
 	struct rb_node *node;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 325a346..7f79872 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -78,9 +78,9 @@ struct extent_io_ops {
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
@@ -179,7 +179,8 @@ int try_release_extent_state(struct extent_map_tree *map,
 			     gfp_t mask);
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		     int bits, struct extent_state **cached, gfp_t mask);
+		     unsigned long bits, struct extent_state **cached,
+		     gfp_t mask);
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask);
@@ -196,17 +197,19 @@ u64 count_range_bits(struct extent_io_tree *tree,
 
 void free_extent_state(struct extent_state *state);
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, int filled, struct extent_state *cached_state);
+		   unsigned long bits, int filled, struct extent_state
+		   *cached_state);
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
-		   int bits, int exclusive_bits, u64 *failed_start,
-		   struct extent_state **cached_state, gfp_t mask);
+		   unsigned long bits, unsigned long exclusive_bits,
+		   u64 *failed_start, struct extent_state **cached_state,
+		   gfp_t mask);
 int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
@@ -216,13 +219,14 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask);
+		       unsigned long bits, unsigned long clear_bits,
+		       gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits);
+			  u64 *start_ret, u64 *end_ret, unsigned long bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
-						 u64 start, int bits);
+						 u64 start, unsigned long bits);
 int extent_invalidatepage(struct extent_io_tree *tree,
 			  struct page *page, unsigned long offset);
 int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
@@ -277,7 +281,8 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		    unsigned long bits);
 int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95f15b2..471282f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1320,7 +1320,7 @@ static void btrfs_merge_extent_hook(struct inode *inode,
  * have pending delalloc work to be done.
  */
 static void btrfs_set_bit_hook(struct inode *inode,
-			       struct extent_state *state, int *bits)
+			       struct extent_state *state, unsigned long *bits)
 {
 
 	/*
@@ -1356,7 +1356,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
 static void btrfs_clear_bit_hook(struct inode *inode,
-				 struct extent_state *state, int *bits)
+				 struct extent_state *state,
+				 unsigned long *bits)
 {
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
@@ -6161,7 +6162,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	u64 lockstart, lockend;
 	ssize_t ret;
 	int writing = rw & WRITE;
-	int write_bits = 0;
+	unsigned long write_bits = 0;
 	size_t count = iov_length(iov, nr_segs);
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
-- 
1.7.6

