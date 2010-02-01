From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: Fix oopsen when dropping empty tree.
Date: Mon, 01 Feb 2010 10:41:17 +0800
Message-ID: <4B663F4D.8090007@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When dropping a empty tree, walk_down_tree() skips checking
extent information for the tree root. This will triggers a
BUG_ON in walk_up_proc().

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2010-01-22 12:16:34.203525744 +0800
+++ 2/fs/btrfs/extent-tree.c	2010-02-01 10:26:19.865562007 +0800
@@ -5402,10 +5402,6 @@ static noinline int walk_down_tree(struc
 	int ret;
 
 	while (level >= 0) {
-		if (path->slots[level] >=
-		    btrfs_header_nritems(path->nodes[level]))
-			break;
-
 		ret = walk_down_proc(trans, root, path, wc, lookup_info);
 		if (ret > 0)
 			break;
@@ -5413,6 +5409,10 @@ static noinline int walk_down_tree(struc
 		if (level == 0)
 			break;
 
+		if (path->slots[level] >=
+		    btrfs_header_nritems(path->nodes[level]))
+			break;
+
 		ret = do_walk_down(trans, root, path, wc, &lookup_info);
 		if (ret > 0) {
 			path->slots[level]++;
