Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754071AbeFTMt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:26 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E4A5AAE90
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 22/34] btrfs: Remove fs_info from run_delayed_tree_ref
Date: Wed, 20 Jun 2018 15:49:04 +0300
Message-Id: <1529498956-4241-23-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can always be referneced from the passed transaction handle since
it's always valid. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 95361d4195bc..229cb3a229b0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2409,7 +2409,6 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 }
 
 static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
 				struct btrfs_delayed_ref_node *node,
 				struct btrfs_delayed_extent_op *extent_op,
 				int insert_reserved)
@@ -2420,14 +2419,14 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	u64 ref_root = 0;
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
-	trace_run_delayed_tree_ref(fs_info, node, ref, node->action);
+	trace_run_delayed_tree_ref(trans->fs_info, node, ref, node->action);
 
 	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
 		parent = ref->parent;
 	ref_root = ref->root;
 
 	if (node->ref_mod != 1) {
-		btrfs_err(fs_info,
+		btrfs_err(trans->fs_info,
 	"btree block(%llu) has %d references rather than 1: action %d ref_root %llu parent %llu",
 			  node->bytenr, node->ref_mod, node->action, ref_root,
 			  parent);
@@ -2466,7 +2465,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
-		ret = run_delayed_tree_ref(trans, fs_info, node, extent_op,
+		ret = run_delayed_tree_ref(trans, node, extent_op,
 					   insert_reserved);
 	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		 node->type == BTRFS_SHARED_DATA_REF_KEY)
-- 
2.7.4

