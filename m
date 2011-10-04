From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 22/65] btrfs: clear_extent_buffer_dirty should return void
Date: Mon, 03 Oct 2011 23:22:52 -0400
Message-ID: <20111004032302.445794450@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 clear_extent_buffer_dirty has no error conditions and should return void.
 Its callers already ignore the error code anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    3 +--
 fs/btrfs/extent_io.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3246,7 +3246,7 @@ void free_extent_buffer(struct extent_bu
 	WARN_ON(1);
 }
 
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb)
 {
 	unsigned long i;
@@ -3277,7 +3277,6 @@ int clear_extent_buffer_dirty(struct ext
 		spin_unlock_irq(&page->mapping->tree_lock);
 		unlock_page(page);
 	}
-	return 0;
 }
 
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -275,7 +275,7 @@ void memmove_extent_buffer(struct extent
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
 void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb);


