From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 26/99] btrfs: set_extent_buffer_uptodate should return void
Date: Wed, 23 Nov 2011 19:35:59 -0500
Message-ID: <20111124004222.829920294@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 set_extent_buffer_uptodate has no error conditions and should return
 void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    3 +--
 fs/btrfs/extent_io.h |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3940,7 +3940,7 @@ void clear_extent_buffer_uptodate(struct
 	}
 }
 
-int set_extent_buffer_uptodate(struct extent_io_tree *tree,
+void set_extent_buffer_uptodate(struct extent_io_tree *tree,
 				struct extent_buffer *eb)
 {
 	unsigned long i;
@@ -3962,7 +3962,6 @@ int set_extent_buffer_uptodate(struct ex
 		}
 		SetPageUptodate(page);
 	}
-	return 0;
 }
 
 int extent_range_uptodate(struct extent_io_tree *tree,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -310,8 +310,8 @@ int clear_extent_buffer_dirty(struct ext
 			      struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb);
-int set_extent_buffer_uptodate(struct extent_io_tree *tree,
-			       struct extent_buffer *eb);
+void set_extent_buffer_uptodate(struct extent_io_tree *tree,
+				struct extent_buffer *eb);
 void clear_extent_buffer_uptodate(struct extent_io_tree *tree,
 				  struct extent_buffer *eb,
 				  struct extent_state **cached_state);


