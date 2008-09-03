From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: missing endianess conversion in insert_new_root
Date: Wed, 3 Sep 2008 20:18:57 +0200
Message-ID: <20080903181857.GB17704@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add two missing endianess conversions in this function, found by sparse.

(Btw, there are a _lot_ more endianess warnings, but they're old hidden
 in the obsfucated macros from hell mess.  I'll try to detangle and fix
 it when I get some time)

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/ctree.c
===================================================================
--- btrfs-unstable.orig/ctree.c	2008-08-31 15:40:46.000000000 -0300
+++ btrfs-unstable/ctree.c	2008-08-31 15:41:44.000000000 -0300
@@ -1653,8 +1653,8 @@ static int noinline insert_new_root(stru
 
 	c = btrfs_alloc_free_block(trans, root, root->nodesize,
 				   root->root_key.objectid,
-				   root_gen, lower_key.objectid, level,
-				   root->node->start, 0);
+				   root_gen, le64_to_cpu(lower_key.objectid),
+				   level, root->node->start, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
@@ -2345,8 +2345,9 @@ again:
 
 	right = btrfs_alloc_free_block(trans, root, root->leafsize,
 					 root->root_key.objectid,
-					 root_gen, disk_key.objectid, 0,
-					 l->start, 0);
+					 root_gen,
+					 le64_to_cpu(disk_key.objectid),
+					 0, l->start, 0);
 	if (IS_ERR(right)) {
 		BUG_ON(1);
 		return PTR_ERR(right);
