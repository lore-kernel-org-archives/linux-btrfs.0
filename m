From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 38/99] btrfs: wait_extent_bit should return void
Date: Wed, 23 Nov 2011 19:36:11 -0500
Message-ID: <20111124004224.217989474@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 wait_extent_bit has no error conditions and should return void. Its
 callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    3 +--
 fs/btrfs/extent_io.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -639,7 +639,7 @@ static void wait_on_state(struct extent_
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -676,7 +676,6 @@ again:
 	}
 out:
 	spin_unlock(&tree->lock);
-	return 0;
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -277,7 +277,7 @@ void memmove_extent_buffer(struct extent
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
 int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,



