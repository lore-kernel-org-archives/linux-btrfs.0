From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 43/99] btrfs: clear_extent_buffer_dirty should return void
Date: Wed, 23 Nov 2011 19:36:16 -0500
Message-ID: <20111124004224.795105064@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
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
@@ -3436,7 +3436,7 @@ void free_extent_buffer(struct extent_bu
 	WARN_ON(1);
 }
 
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb)
 {
 	unsigned long i;
@@ -3467,7 +3467,6 @@ int clear_extent_buffer_dirty(struct ext
 		ClearPageError(page);
 		unlock_page(page);
 	}
-	return 0;
 }
 
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -278,7 +278,7 @@ void memmove_extent_buffer(struct extent
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
 void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb);



