From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs: remove tree_search() in extent_map.c
Date: Tue, 15 Dec 2009 14:54:17 +0800
Message-ID: <4B273299.5040309@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes tree_search() in extent_map.c because it is not called by
anything.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 07ec673..fe4bb5e 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -150,20 +150,6 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 	return NULL;
 }
 
-/*
- * look for an offset in the tree, and if it can't be found, return
- * the first offset we can find smaller than 'offset'.
- */
-static inline struct rb_node *tree_search(struct rb_root *root, u64 offset)
-{
-	struct rb_node *prev;
-	struct rb_node *ret;
-	ret = __tree_search(root, offset, &prev, NULL);
-	if (!ret)
-		return prev;
-	return ret;
-}
-
 /* check to see if two extent_map structs are adjacent and safe to merge */
 static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 {
-- 
1.6.2.2


