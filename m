Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:32796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbeHDNZx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Aug 2018 09:25:53 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs/extent_map: Remove unneeded variable "ret"
Date: Sat, 4 Aug 2018 19:13:43 +0800
Message-ID: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ret is not used after initalization, So just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/extent_map.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6648d55..b48ab41 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -276,7 +276,6 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 		       u64 gen)
 {
-	int ret = 0;
 	struct extent_map *em;
 	bool prealloc = false;
 
@@ -308,7 +307,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
-	return ret;
+	return 0;
 
 }
 
@@ -430,14 +429,13 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
  */
 int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
 {
-	int ret = 0;
-
 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
 	rb_erase(&em->rb_node, &tree->map);
 	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
 		list_del_init(&em->list);
 	RB_CLEAR_NODE(&em->rb_node);
-	return ret;
+
+	return 0;
 }
 
 void replace_extent_mapping(struct extent_map_tree *tree,
-- 
1.7.12.4

