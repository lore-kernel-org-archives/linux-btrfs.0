Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44271 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752685AbeFHMsE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:04 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 47879AF8F
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/15] btrfs-progs: Remove root argument from __free_extent
Date: Fri,  8 Jun 2018 15:47:50 +0300
Message-Id: <1528462078-24490-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This argument is no longer used in this function so remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 9132cb3f8e15..c16bd85e92be 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -50,7 +50,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins);
 static int __free_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner_objectid,
 			 u64 owner_offset, int refs_to_drop);
@@ -2141,7 +2140,6 @@ void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
  * remove an extent from the root, returns 0 on success
  */
 static int __free_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner_objectid,
 			 u64 owner_offset, int refs_to_drop)
@@ -2149,7 +2147,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 
 	struct btrfs_key key;
 	struct btrfs_path *path;
-	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_root *extent_root = trans->fs_info->extent_root;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
@@ -2409,8 +2407,7 @@ static int del_pending_extents(struct btrfs_trans_handle *trans)
 
 		if (!test_range_bit(extent_ins, start, end,
 				    EXTENT_LOCKED, 0)) {
-			ret = __free_extent(trans, extent_root,
-					    start, end + 1 - start, 0,
+			ret = __free_extent(trans, start, end + 1 - start, 0,
 					    extent_root->root_key.objectid,
 					    extent_op->level, 0, 1);
 			kfree(extent_op);
-- 
2.7.4

