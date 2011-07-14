From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 07/16] Btrfs: remove remaining ref-cache code
Date: Thu, 14 Jul 2011 11:17:27 +0800
Message-ID: <4E1E5FC7.1060402@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Since commit f2a97a9dbd86eb1ef956bdf20e05c507b32beb96
("btrfs: remove all unused functions"), there's no extern functions
at all in ref-cache.c, so just remove the remaining dead code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ref-cache.c |   68 --------------------------------------------------
 fs/btrfs/ref-cache.h |   52 --------------------------------------
 2 files changed, 0 insertions(+), 120 deletions(-)
 delete mode 100644 fs/btrfs/ref-cache.c
 delete mode 100644 fs/btrfs/ref-cache.h

diff --git a/fs/btrfs/ref-cache.c b/fs/btrfs/ref-cache.c
deleted file mode 100644
index 82d569c..0000000
--- a/fs/btrfs/ref-cache.c
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/sort.h>
-#include "ctree.h"
-#include "ref-cache.h"
-#include "transaction.h"
-
-static struct rb_node *tree_insert(struct rb_root *root, u64 bytenr,
-				   struct rb_node *node)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct btrfs_leaf_ref *entry;
-
-	while (*p) {
-		parent = *p;
-		entry = rb_entry(parent, struct btrfs_leaf_ref, rb_node);
-
-		if (bytenr < entry->bytenr)
-			p = &(*p)->rb_left;
-		else if (bytenr > entry->bytenr)
-			p = &(*p)->rb_right;
-		else
-			return parent;
-	}
-
-	entry = rb_entry(node, struct btrfs_leaf_ref, rb_node);
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return NULL;
-}
-
-static struct rb_node *tree_search(struct rb_root *root, u64 bytenr)
-{
-	struct rb_node *n = root->rb_node;
-	struct btrfs_leaf_ref *entry;
-
-	while (n) {
-		entry = rb_entry(n, struct btrfs_leaf_ref, rb_node);
-		WARN_ON(!entry->in_tree);
-
-		if (bytenr < entry->bytenr)
-			n = n->rb_left;
-		else if (bytenr > entry->bytenr)
-			n = n->rb_right;
-		else
-			return n;
-	}
-	return NULL;
-}
diff --git a/fs/btrfs/ref-cache.h b/fs/btrfs/ref-cache.h
deleted file mode 100644
index 24f7001..0000000
--- a/fs/btrfs/ref-cache.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-#ifndef __REFCACHE__
-#define __REFCACHE__
-
-struct btrfs_extent_info {
-	/* bytenr and num_bytes find the extent in the extent allocation tree */
-	u64 bytenr;
-	u64 num_bytes;
-
-	/* objectid and offset find the back reference for the file */
-	u64 objectid;
-	u64 offset;
-};
-
-struct btrfs_leaf_ref {
-	struct rb_node rb_node;
-	struct btrfs_leaf_ref_tree *tree;
-	int in_tree;
-	atomic_t usage;
-
-	u64 root_gen;
-	u64 bytenr;
-	u64 owner;
-	u64 generation;
-	int nritems;
-
-	struct list_head list;
-	struct btrfs_extent_info extents[];
-};
-
-static inline size_t btrfs_leaf_ref_size(int nr_extents)
-{
-	return sizeof(struct btrfs_leaf_ref) +
-	       sizeof(struct btrfs_extent_info) * nr_extents;
-}
-#endif
-- 
1.7.3.1
