From: "Yan Zheng" <yanzheng@21cn.com>
Subject: [PATCH] Fix potential locking issue in btrfs_find_next_key
Date: Wed, 16 Jul 2008 00:21:24 +0800
Message-ID: <3d0408630807150921j6b850993r4d202cfa549d3283@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

During the descent through the tree, if path->slots[...] points to an
intermediate slot in the current node, we release upper level node's
lock. When cache_only is true, btrfs_find_next_key may advance
path->slots[] several times. Therefore, when we found path->slots[...]
>= btrfs_header_nritems(...), upper level node may be not locked.

Note: this patch wasn't tested.

Regards
YZ
---
diff -r 3f0eee804974 ctree.c
--- a/ctree.c	Thu Jun 26 10:34:20 2008 -0400
+++ b/ctree.c	Wed Jul 16 00:15:09 2008 +0800
@@ -3114,10 +3114,39 @@ int btrfs_find_next_key(struct btrfs_roo
 		c = path->nodes[level];
 next:
 		if (slot >= btrfs_header_nritems(c)) {
-			level++;
-			if (level == BTRFS_MAX_LEVEL) {
+			int ret;
+			int orig_lowest;
+			struct btrfs_key last_key;
+
+			if (!path->nodes[level + 1] ||
+			    level + 1 == BTRFS_MAX_LEVEL) {
 				return 1;
 			}
+			if (path->locks[level + 1]) {
+				level++;
+				continue;
+			}
+
+			/*
+			 * Upper level node isn't locked, this can happen
+			 * when cache_only is true.
+			 */
+			slot = btrfs_header_nritems(c) - 1;
+			if (level == 0)
+				btrfs_item_key_to_cpu(c, &last_key, slot);
+			else
+				btrfs_node_key_to_cpu(c, &last_key, slot);
+
+			btrfs_release_path(root, path);
+			orig_lowest = path->lowest_level;
+			path->lowest_level = level;
+			ret = btrfs_search_slot(NULL, root, &last_key, path,
+						0, 0);
+			path->lowest_level = orig_lowest;
+			if (ret < 0)
+				return ret;
+			if (ret == 0)
+				path->slots[level]++;
 			continue;
 		}
 		if (level == 0)
