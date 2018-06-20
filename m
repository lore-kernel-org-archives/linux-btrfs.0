Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754055AbeFTMtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:24 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE31DAF55
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:23 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 15/34] btrfs: Remove fs_info from __btrfs_free_extent
Date: Wed, 20 Jun 2018 15:48:57 +0300
Message-Id: <1529498956-4241-16-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle so we
can reference the fs_info from there. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 93dc421723ed..48d89ee676e0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -52,11 +52,10 @@ enum {
 };
 
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info,
-				struct btrfs_delayed_ref_node *node, u64 parent,
-				u64 root_objectid, u64 owner_objectid,
-				u64 owner_offset, int refs_to_drop,
-				struct btrfs_delayed_extent_op *extra_op);
+			       struct btrfs_delayed_ref_node *node, u64 parent,
+			       u64 root_objectid, u64 owner_objectid,
+			       u64 owner_offset, int refs_to_drop,
+			       struct btrfs_delayed_extent_op *extra_op);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
@@ -2293,7 +2292,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 					     ref->offset, node->ref_mod,
 					     extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
-		ret = __btrfs_free_extent(trans, fs_info, node, parent,
+		ret = __btrfs_free_extent(trans, node, parent,
 					  ref_root, ref->objectid,
 					  ref->offset, node->ref_mod,
 					  extent_op);
@@ -2446,8 +2445,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 					     ref->level, 0, 1,
 					     extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
-		ret = __btrfs_free_extent(trans, fs_info, node,
-					  parent, ref_root,
+		ret = __btrfs_free_extent(trans, node, parent, ref_root,
 					  ref->level, 0, 1, extent_op);
 	} else {
 		BUG();
@@ -6806,12 +6804,12 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 }
 
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *info,
-				struct btrfs_delayed_ref_node *node, u64 parent,
-				u64 root_objectid, u64 owner_objectid,
-				u64 owner_offset, int refs_to_drop,
-				struct btrfs_delayed_extent_op *extent_op)
+			       struct btrfs_delayed_ref_node *node, u64 parent,
+			       u64 root_objectid, u64 owner_objectid,
+			       u64 owner_offset, int refs_to_drop,
+			       struct btrfs_delayed_extent_op *extent_op)
 {
+	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_key key;
 	struct btrfs_path *path;
 	struct btrfs_root *extent_root = info->extent_root;
-- 
2.7.4

