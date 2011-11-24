From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 09/99] btrfs: unlock_extent can return void
Date: Wed, 23 Nov 2011 19:35:42 -0500
Message-ID: <20111124004220.860130792@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that clear_extent_bit can return void when gfp_t & __GFP_WAIT, we can
 use that to convert unlock_extent to return void to callers as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |    5 ++---
 fs/btrfs/extent_io.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1266,10 +1266,9 @@ int unlock_extent_cached(struct extent_i
 				  cached, mask);
 }
 
-int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
+void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 {
-	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0,
-				  NULL, mask);
+	clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL, mask);
 }
 
 /*
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -183,7 +183,7 @@ int try_release_extent_state(struct exte
 int lock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, struct extent_state **cached, gfp_t mask);
-int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
+void unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask);
 int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 			 struct extent_state **cached, gfp_t mask);
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end,


