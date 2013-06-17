Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59651 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3FQSZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 14:25:57 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 79A177C069B
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 12:25:57 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id dvETt7GOKxxQGiTa (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 12:25:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: optimize reada_for_balance
Date: Mon, 17 Jun 2013 14:25:54 -0400
Message-ID: <1371493554-24930-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch does two things.  First we no longer explicitly read in the blocks
we're trying to readahead.  For things like balance_level we may never actually
use the blocks so this just adds uneeded latency, and balance_level and
split_node will both read in the blocks they care about explicitly so if the
blocks need to be waited on it will be done there.  Secondly we no longer drop
the path if we do readahead, we just set the path blocking before we call
reada_for_balance() and then we're good to go.  Hopefully this will cut down on
the number of re-searches.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c |   46 +++++++++-------------------------------------
 1 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c85cde7..c32d03d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2178,12 +2178,8 @@ static void reada_for_search(struct btrfs_root *root,
 	}
 }
 
-/*
- * returns -EAGAIN if it had to drop the path, or zero if everything was in
- * cache
- */
-static noinline int reada_for_balance(struct btrfs_root *root,
-				      struct btrfs_path *path, int level)
+static noinline void reada_for_balance(struct btrfs_root *root,
+				       struct btrfs_path *path, int level)
 {
 	int slot;
 	int nritems;
@@ -2192,12 +2188,11 @@ static noinline int reada_for_balance(struct btrfs_root *root,
 	u64 gen;
 	u64 block1 = 0;
 	u64 block2 = 0;
-	int ret = 0;
 	int blocksize;
 
 	parent = path->nodes[level + 1];
 	if (!parent)
-		return 0;
+		return;
 
 	nritems = btrfs_header_nritems(parent);
 	slot = path->slots[level + 1];
@@ -2224,28 +2219,11 @@ static noinline int reada_for_balance(struct btrfs_root *root,
 			block2 = 0;
 		free_extent_buffer(eb);
 	}
-	if (block1 || block2) {
-		ret = -EAGAIN;
-
-		/* release the whole path */
-		btrfs_release_path(path);
 
-		/* read the blocks */
-		if (block1)
-			readahead_tree_block(root, block1, blocksize, 0);
-		if (block2)
-			readahead_tree_block(root, block2, blocksize, 0);
-
-		if (block1) {
-			eb = read_tree_block(root, block1, blocksize, 0);
-			free_extent_buffer(eb);
-		}
-		if (block2) {
-			eb = read_tree_block(root, block2, blocksize, 0);
-			free_extent_buffer(eb);
-		}
-	}
-	return ret;
+	if (block1)
+		readahead_tree_block(root, block1, blocksize, 0);
+	if (block2)
+		readahead_tree_block(root, block2, blocksize, 0);
 }
 
 
@@ -2441,11 +2419,8 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 			goto again;
 		}
 
-		sret = reada_for_balance(root, p, level);
-		if (sret)
-			goto again;
-
 		btrfs_set_path_blocking(p);
+		reada_for_balance(root, p, level);
 		sret = split_node(trans, root, p, level);
 		btrfs_clear_path_blocking(p, NULL, 0);
 
@@ -2465,11 +2440,8 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 			goto again;
 		}
 
-		sret = reada_for_balance(root, p, level);
-		if (sret)
-			goto again;
-
 		btrfs_set_path_blocking(p);
+		reada_for_balance(root, p, level);
 		sret = balance_level(trans, root, p, level);
 		btrfs_clear_path_blocking(p, NULL, 0);
 
-- 
1.7.7.6

