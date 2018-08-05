Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:37480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbeHEPVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 11:21:04 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <lufq.fnst@cn.fujitsu.com>, <suy.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] btrfs/extent_map: Remove unneeded variable "ret"
Date: Sun, 5 Aug 2018 21:04:47 +0800
Message-ID: <1533474287-15049-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ret is not used after initalization, and we do not care about
the return value. So make it void function.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/extent_map.c | 10 ++--------
 fs/btrfs/extent_map.h |  4 ++--
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6648d55..da4e4f3 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -273,10 +273,9 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
  * to the generation that actually added the file item to the inode so we know
  * we need to sync this extent when we call fsync().
  */
-int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
+void unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 		       u64 gen)
 {
-	int ret = 0;
 	struct extent_map *em;
 	bool prealloc = false;
 
@@ -308,8 +307,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
-	return ret;
-
 }
 
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em)
@@ -428,16 +425,13 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
  * Removes @em from @tree.  No reference counts are dropped, and no checks
  * are done to see if the range is in use
  */
-int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
+void remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 {
-	int ret = 0;
-
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
 	rb_erase(&em->rb_node, &tree->map);
 	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
 		list_del_init(&em->list);
 	RB_CLEAR_NODE(&em->rb_node);
-	return ret;
 }
 
 void replace_extent_mapping(struct extent_map_tree *tree,
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 25d985e..c80649b 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -78,7 +78,7 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
 int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em, int modified);
-int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
+void remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em);
 void replace_extent_mapping(struct extent_map_tree *tree,
 			    struct extent_map *cur,
 			    struct extent_map *new,
@@ -88,7 +88,7 @@ void replace_extent_mapping(struct extent_map_tree *tree,
 void free_extent_map(struct extent_map *em);
 int __init extent_map_init(void);
 void __cold extent_map_exit(void);
-int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen);
+void unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen);
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em);
 struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 					 u64 start, u64 len);
-- 
1.7.12.4

