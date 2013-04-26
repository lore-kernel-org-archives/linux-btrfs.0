Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3DZO4i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 10:56:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 14F465E000202
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 16:56:37 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: remove unused gfp mask parameter from release_extent_buffer callchain
Date: Fri, 26 Apr 2013 16:56:29 +0200
Message-Id: <1366988189-17961-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unused since 0b32f4bbb423f02ac.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c   |    8 +-------
 fs/btrfs/extent_io.c |   13 +++++--------
 fs/btrfs/extent_io.h |    2 +-
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa8438f..678bdc6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1031,14 +1031,8 @@ static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	if (PageWriteback(page) || PageDirty(page))
 		return 0;
-	/*
-	 * We need to mask out eg. __GFP_HIGHMEM and __GFP_DMA32 as we're doing
-	 * slab allocation from alloc_extent_state down the callchain where
-	 * it'd hit a BUG_ON as those flags are not allowed.
-	 */
-	gfp_flags &= ~GFP_SLAB_BUG_MASK;
 
-	return try_release_extent_buffer(page, gfp_flags);
+	return try_release_extent_buffer(page);
 }
 
 static void btree_invalidatepage(struct page *page, unsigned long offset)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 617b577..dbb2bde 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4444,7 +4444,7 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 }
 
 /* Expects to have eb->eb_lock already held */
-static int release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
+static int release_extent_buffer(struct extent_buffer *eb)
 {
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
@@ -4502,7 +4502,7 @@ void free_extent_buffer(struct extent_buffer *eb)
 	 * I know this is terrible, but it's temporary until we stop tracking
 	 * the uptodate bits and such for the extent buffers.
 	 */
-	release_extent_buffer(eb, GFP_ATOMIC);
+	release_extent_buffer(eb);
 }
 
 void free_extent_buffer_stale(struct extent_buffer *eb)
@@ -4516,7 +4516,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 	if (atomic_read(&eb->refs) == 2 && !extent_buffer_under_io(eb) &&
 	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
 		atomic_dec(&eb->refs);
-	release_extent_buffer(eb, GFP_NOFS);
+	release_extent_buffer(eb);
 }
 
 void clear_extent_buffer_dirty(struct extent_buffer *eb)
@@ -5076,7 +5076,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	}
 }
 
-int try_release_extent_buffer(struct page *page, gfp_t mask)
+int try_release_extent_buffer(struct page *page)
 {
 	struct extent_buffer *eb;
 
@@ -5106,9 +5106,6 @@ int try_release_extent_buffer(struct page *page, gfp_t mask)
 	}
 	spin_unlock(&page->mapping->private_lock);
 
-	if ((mask & GFP_NOFS) == GFP_NOFS)
-		mask = GFP_NOFS;
-
 	/*
 	 * If tree ref isn't set then we know the ref on this eb is a real ref,
 	 * so just return, this page will likely be freed soon anyway.
@@ -5118,5 +5115,5 @@ int try_release_extent_buffer(struct page *page, gfp_t mask)
 		return 0;
 	}
 
-	return release_extent_buffer(eb, mask);
+	return release_extent_buffer(eb);
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index db009d8..5e409ea 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -185,7 +185,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
-int try_release_extent_buffer(struct page *page, gfp_t mask);
+int try_release_extent_buffer(struct page *page);
 int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask);
-- 
1.7.9

