From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 29/99] btrfs: convert_extent_bit should return void with __GFP_WAIT set
Date: Wed, 23 Nov 2011 19:36:02 -0500
Message-ID: <20111124004223.177157609@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that allocations that are allowed to sleep can't fail,
 convert_extent_bit has no more error conditions and we can assume the
 return value will be 0 and return void to callers.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   18 ++++++++++++++----
 fs/btrfs/extent_io.h |    4 ++--
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1011,8 +1011,8 @@ int set_extent_bit_excl(struct extent_io
  * converting from say DELALLOC to DIRTY.  This is not meant to be used with
  * boundary bits like LOCK.
  */
-int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask)
+static int __convert_extent_bit(struct extent_io_tree *tree, u64 start,
+				 u64 end, int bits, int clear_bits, gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -1020,9 +1020,10 @@ int convert_extent_bit(struct extent_io_
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	int wait = mask & __GFP_WAIT;
 
 again:
-	if (!prealloc && (mask & __GFP_WAIT))
+	if (!prealloc && !wait)
 		prealloc = alloc_extent_state_nofail(mask);
 
 	spin_lock(&tree->lock);
@@ -1176,11 +1177,20 @@ search_again:
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (mask & __GFP_WAIT)
+	if (wait)
 		cond_resched();
 	goto again;
 }
 
+void convert_extent_bit(struct extent_io_tree *tree, u64 start,
+			u64 end, int bits, int clear_bits, gfp_t mask)
+{
+	int ret;
+	WARN_ON(!(mask & __GFP_WAIT));
+	ret = __convert_extent_bit(tree, start, end, bits, clear_bits, mask);
+	BUG_ON(ret < 0);
+}
+
 /* wrappers around set/clear extent bit */
 void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
 {
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -233,8 +233,8 @@ void set_extent_uptodate(struct extent_i
 void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end);
 void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
-int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask);
+void convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+			int bits, int clear_bits, gfp_t mask);
 void set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached_state);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,



