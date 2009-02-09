From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH] Btrfs: remove redundant codes for split_state()
Date: Mon, 9 Feb 2009 20:41:10 +0800
Message-ID: <49902469.044e6e0a.6ef4.6a60@mx.google.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

These two lines are needless, remove them.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 37d43b5..ebe6b29 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -415,8 +415,6 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 
 	node = tree_insert(&tree->state, prealloc->end, &prealloc->rb_node);
 	if (node) {
-		struct extent_state *found;
-		found = rb_entry(node, struct extent_state, rb_node);
 		free_extent_state(prealloc);
 		return -EEXIST;
 	}

