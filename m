From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 17/65] btrfs: wait_extent_bit should return void
Date: Mon, 03 Oct 2011 23:22:47 -0400
Message-ID: <20111004032301.872308460@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
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
@@ -274,7 +274,7 @@ void memmove_extent_buffer(struct extent
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
 int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,


