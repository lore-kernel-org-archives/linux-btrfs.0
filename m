Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752739AbeFHMsE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:04 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8BF86AF85
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/15] btrfs-progs: Remove root argument from alloc_reserved_tree_block
Date: Fri,  8 Jun 2018 15:47:51 +0300
Message-Id: <1528462078-24490-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is not really needed, since we can reference the fs_info from the
passed transaction. This is in preparation for delayed-refs support.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index c16bd85e92be..079204ed290f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -45,7 +45,6 @@ struct pending_extent_op {
 };
 
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
 				     u64 root_objectid, u64 generation,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins);
@@ -2070,7 +2069,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
 				key.offset = extent_op->num_bytes;
 				key.type = BTRFS_EXTENT_ITEM_KEY;
 			}
-			ret = alloc_reserved_tree_block(trans, extent_root,
+
+			ret = alloc_reserved_tree_block(trans,
 						extent_root->root_key.objectid,
 						trans->transid,
 						extent_op->flags,
@@ -2677,13 +2677,12 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 }
 
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
 				     u64 root_objectid, u64 generation,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins)
 {
 	int ret;
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_extent_item *extent_item;
 	struct btrfs_tree_block_info *block_info;
 	struct btrfs_extent_inline_ref *iref;
-- 
2.7.4

