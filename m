Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJaRtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:49:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7DF78AD88
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:49:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: prepare to drop gfp mask parameter from clear_extent_bit
Date: Tue, 31 Oct 2017 18:47:55 +0100
Message-Id: <91ab430ab25a5e3b918422dc944284e4f746674f.1509471989.git.dsterba@suse.com>
In-Reply-To: <cover.1509471989.git.dsterba@suse.com>
References: <cover.1509471989.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use __clear_extent_bit directly in case we want to pass unknown
gfp flags. Otherwise all clear_extent_bit callers use GFP_NOFS, so we
can sink them to the function and reduce argument count, at the cost
that __clear_extent_bit has to be exported.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c |  6 +++---
 fs/btrfs/extent_io.h | 12 ++++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1dfd14678db8..2d16c609c12f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -580,7 +580,7 @@ static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
  *
  * This takes the tree lock, and returns 0 on success and < 0 on error.
  */
-static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 			      unsigned bits, int wake, int delete,
 			      struct extent_state **cached_state,
 			      gfp_t mask, struct extent_changeset *changeset)
@@ -4244,9 +4244,9 @@ static int try_release_extent_state(struct extent_map_tree *map,
 		 * at this point we can safely clear everything except the
 		 * locked bit and the nodatasum bit
 		 */
-		ret = clear_extent_bit(tree, start, end,
+		ret = __clear_extent_bit(tree, start, end,
 				 ~(EXTENT_LOCKED | EXTENT_NODATASUM),
-				 0, 0, NULL, mask);
+				 0, 0, NULL, mask, NULL);
 
 		/* if clear_extent_bit failed for enomem reasons,
 		 * we can't allow the release to continue.
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8b27af7101e..09923d49b699 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -300,6 +300,10 @@ int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
 		     struct extent_state **cached, gfp_t mask);
+int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
+		     unsigned bits, int wake, int delete,
+		     struct extent_state **cached, gfp_t mask,
+		     struct extent_changeset *changeset);
 
 static inline int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
@@ -310,8 +314,8 @@ static inline int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 static inline int unlock_extent_cached(struct extent_io_tree *tree, u64 start,
 		u64 end, struct extent_state **cached, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
-				mask);
+	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
+				mask, NULL);
 }
 
 static inline int clear_extent_bits(struct extent_io_tree *tree, u64 start,
@@ -341,8 +345,8 @@ static inline int set_extent_bits(struct extent_io_tree *tree, u64 start,
 static inline int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
 		u64 end, struct extent_state **cached_state, gfp_t mask)
 {
-	return clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
-				cached_state, mask);
+	return __clear_extent_bit(tree, start, end, EXTENT_UPTODATE, 0, 0,
+				cached_state, mask, NULL);
 }
 
 static inline int set_extent_dirty(struct extent_io_tree *tree, u64 start,
-- 
2.14.0

