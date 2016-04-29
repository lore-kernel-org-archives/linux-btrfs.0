Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbcD2JVV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:21:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F1404AD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:21:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 16/16] btrfs: sink gfp parameter to convert_extent_bit
Date: Fri, 29 Apr 2016 11:21:07 +0200
Message-Id: <5c73331ee86270cf6316a58136c17deb49455ccd.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Single caller passes GFP_NOFS. We can get rid of the
gfpflags_allow_blocking checks as NOFS can block but does not recurse to
filesystem through reclaim.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c   | 14 +++++++-------
 fs/btrfs/extent_io.h   |  2 +-
 fs/btrfs/transaction.c |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 092f697470d8..58483f928000 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1092,17 +1092,18 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * @bits:	the bits to set in this range
  * @clear_bits:	the bits to clear in this range
  * @cached_state:	state that we're going to cache
- * @mask:	the allocation mask
  *
  * This will go through and set bits for the given range.  If any states exist
  * already in this range they are set with the given bit and cleared of the
  * clear_bits.  This is only meant to be used by things that are mergeable, ie
  * converting from say DELALLOC to DIRTY.  This is not meant to be used with
  * boundary bits like LOCK.
+ *
+ * All allocations are done with GFP_NOFS.
  */
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       unsigned bits, unsigned clear_bits,
-		       struct extent_state **cached_state, gfp_t mask)
+		       struct extent_state **cached_state)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -1117,7 +1118,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 again:
-	if (!prealloc && gfpflags_allow_blocking(mask)) {
+	if (!prealloc) {
 		/*
 		 * Best effort, don't worry if extent state allocation fails
 		 * here for the first iteration. We might have a cached state
@@ -1125,7 +1126,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		 * extent state allocations are needed. We'll only know this
 		 * after locking the tree.
 		 */
-		prealloc = alloc_extent_state(mask);
+		prealloc = alloc_extent_state(GFP_NOFS);
 		if (!prealloc && !first_iteration)
 			return -ENOMEM;
 	}
@@ -1286,15 +1287,14 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (start > end)
 		goto out;
 	spin_unlock(&tree->lock);
-	if (gfpflags_allow_blocking(mask))
-		cond_resched();
+	cond_resched();
 	/*
 	 * If we used the preallocated state, try again here out of the
 	 * locked section so we can avoid GFP_ATOMIC. No error checking
 	 * as we might not need it in the end.
 	 */
 	if (!prealloc)
-		prealloc = alloc_extent_state(mask);
+		prealloc = alloc_extent_state(GFP_NOFS);
 	first_iteration = false;
 	goto again;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 94b376446042..9c1f160c5984 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -287,7 +287,7 @@ static inline int clear_extent_dirty(struct extent_io_tree *tree, u64 start,
 
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       unsigned bits, unsigned clear_bits,
-		       struct extent_state **cached_state, gfp_t mask);
+		       struct extent_state **cached_state);
 
 static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
 		u64 end, struct extent_state **cached_state)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 43885e51b882..98b93d9c6213 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -943,7 +943,7 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 
 		err = convert_extent_bit(dirty_pages, start, end,
 					 EXTENT_NEED_WAIT,
-					 mark, &cached_state, GFP_NOFS);
+					 mark, &cached_state);
 		/*
 		 * convert_extent_bit can return -ENOMEM, which is most of the
 		 * time a temporary error. So when it happens, ignore the error
-- 
2.7.1

