From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 13/99] btrfs: clear_extent_uptodate can drop gfp_t argumetn
Date: Wed, 23 Nov 2011 19:35:46 -0500
Message-ID: <20111124004221.324209031@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 All of the callers of clear_extent_uptodate call it with gfp_t == GFP_NOFS.

 This patch simplifies the call sites by calling clear_extent_bit with
 GFP_NOFS from clear_extent_uptodate itself.

 Since the extent io code will probably never be used outside of a file
 system, this is generally ok. If there are new callers, they can add
 their own version or re-genericize it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1203,11 +1203,10 @@ int set_extent_uptodate(struct extent_io
 }
 
 static void clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
-				  u64 end, struct extent_state **cached_state,
-				  gfp_t mask)
+				  u64 end, struct extent_state **cached_state)
 {
 	clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
-			 cached_state, mask);
+			 cached_state, GFP_NOFS);
 }
 
 /*
@@ -2285,7 +2284,7 @@ static void end_bio_extent_writepage(str
 		}
 
 		if (!uptodate) {
-			clear_extent_uptodate(tree, start, end, NULL, GFP_NOFS);
+			clear_extent_uptodate(tree, start, end, NULL);
 			ClearPageUptodate(page);
 			SetPageError(page);
 		}
@@ -3917,7 +3916,7 @@ void clear_extent_buffer_uptodate(struct
 
 	if (eb_straddles_pages(eb)) {
 		clear_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-				      cached_state, GFP_NOFS);
+				      cached_state);
 	}
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);


