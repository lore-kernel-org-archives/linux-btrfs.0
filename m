Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59169 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbeEDHrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 03:47:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C542AC9F
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 07:47:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs-progs: Remove add_cache_extent2
Date: Fri,  4 May 2018 10:47:26 +0300
Message-Id: <1525420047-17397-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1525420047-17397-1-git-send-email-nborisov@suse.com>
References: <1525420047-17397-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 17793e3e6a49 ("Btrfs-progs: extend the extent cache for the
device extent") extended the cache extent APIs to support objectid to
distinguish between phyisical extents with same dimensions but on
different devices. However, it seems that this particular function is
not used to allocate a device extent with accompanying objectid.
Instead such extents as processed solely by insert_device_extent_record.
Remove the unused code as a result.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-cache.c | 16 ++--------------
 extent-cache.h |  2 --
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/extent-cache.c b/extent-cache.c
index 38bed8b5db70..662c801e6760 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -107,10 +107,9 @@ alloc_cache_extent(u64 objectid, u64 start, u64 size)
 	return pe;
 }
 
-static int __add_cache_extent(struct cache_tree *tree,
-			      u64 objectid, u64 start, u64 size)
+int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
 {
-	struct cache_extent *pe = alloc_cache_extent(objectid, start, size);
+	struct cache_extent *pe = alloc_cache_extent(0, start, size);
 	int ret;
 
 	if (!pe) {
@@ -125,17 +124,6 @@ static int __add_cache_extent(struct cache_tree *tree,
 	return ret;
 }
 
-int add_cache_extent(struct cache_tree *tree, u64 start, u64 size)
-{
-	return __add_cache_extent(tree, 0, start, size);
-}
-
-int add_cache_extent2(struct cache_tree *tree,
-		      u64 objectid, u64 start, u64 size)
-{
-	return __add_cache_extent(tree, objectid, start, size);
-}
-
 int insert_cache_extent(struct cache_tree *tree, struct cache_extent *pe)
 {
 	return rb_insert(&tree->root, &pe->rb_node, cache_tree_comp_nodes);
diff --git a/extent-cache.h b/extent-cache.h
index 82db7fa3e463..33d018dd5fef 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -106,8 +106,6 @@ struct cache_extent *search_cache_extent2(struct cache_tree *tree,
  */
 struct cache_extent *lookup_cache_extent2(struct cache_tree *tree,
 					  u64 objectid, u64 start, u64 size);
-int add_cache_extent2(struct cache_tree *tree,
-		      u64 objectid, u64 start, u64 size);
 int insert_cache_extent2(struct cache_tree *tree, struct cache_extent *pe);
 
 /*
-- 
2.7.4

