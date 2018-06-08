Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44277 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752753AbeFHMsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:05 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D898EAF91
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/15] btrfs-progs: Always pass 0 for offset when calling btrfs_free_extent for btree blocks.
Date: Fri,  8 Jun 2018 15:47:52 +0300
Message-Id: <1528462078-24490-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently some instances of btrfs_free_extent are called with the
last parameter ("offset") being set to 1. This makes no sense, since
offset is used for data extents. I suspect this is a left-over from
95d3f20b51e9 ("Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)")
since this commit changed the signature of the function from :

-int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root
-                     *root, u64 bytenr, u64 num_bytes, u64 parent,
-                     u64 root_objectid, u64 ref_generation,
-                     u64 owner_objectid, int pin);

to

+int btrfs_free_extent(struct btrfs_trans_handle *trans,
+                     struct btrfs_root *root,
+                     u64 bytenr, u64 num_bytes, u64 parent,
+                     u64 root_objectid, u64 owner, u64 offset);

I.e the last parameter was "pin" and not offset. So these are just
leftovers with no semantic meaning. Fix this by passing 0.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.c       | 4 ++--
 extent-tree.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/ctree.c b/ctree.c
index 8f3338b4693a..d8a6883aa85f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -334,7 +334,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		WARN_ON(btrfs_header_generation(parent) != trans->transid);
 
 		btrfs_free_extent(trans, root, buf->start, buf->len,
-				  0, root->root_key.objectid, level, 1);
+				  0, root->root_key.objectid, level, 0);
 	}
 	if (!list_empty(&buf->recow)) {
 		list_del_init(&buf->recow);
@@ -738,7 +738,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_free_extent(trans, root, mid->start, mid->len,
 					0, root->root_key.objectid,
-					level, 1);
+					level, 0);
 		/* once for the root ptr */
 		free_extent_buffer(mid);
 		return ret;
diff --git a/extent-tree.c b/extent-tree.c
index 079204ed290f..ab57c20d9dee 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2961,7 +2961,7 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 			path->slots[*level]++;
 			ret = btrfs_free_extent(trans, root, bytenr, blocksize,
 						parent->start, root_owner,
-						root_gen, *level - 1, 1);
+						root_gen, *level - 1, 0);
 			BUG_ON(ret);
 			continue;
 		}
@@ -3003,7 +3003,7 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
 	root_gen = btrfs_header_generation(parent);
 	ret = btrfs_free_extent(trans, root, path->nodes[*level]->start,
 				path->nodes[*level]->len, parent->start,
-				root_owner, root_gen, *level, 1);
+				root_owner, root_gen, *level, 0);
 	free_extent_buffer(path->nodes[*level]);
 	path->nodes[*level] = NULL;
 	*level += 1;
@@ -3054,7 +3054,7 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len,
 						parent->start, root_owner,
-						root_gen, *level, 1);
+						root_gen, *level, 0);
 			BUG_ON(ret);
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
-- 
2.7.4

