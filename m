Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48970 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754014AbeFTMtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:24 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 332DDAF59
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:24 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 16/34] btrfs: Remove fs_info from alloc_reserved_file_extent
Date: Wed, 20 Jun 2018 15:48:58 +0300
Message-Id: <1529498956-4241-17-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info can be referenced from the transaction handle, which is always
valid. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 48d89ee676e0..449ebd1bb8c9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -60,7 +60,6 @@ static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
 static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				      struct btrfs_fs_info *fs_info,
 				      u64 parent, u64 root_objectid,
 				      u64 flags, u64 owner, u64 offset,
 				      struct btrfs_key *ins, int ref_mod);
@@ -2282,10 +2281,10 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		if (extent_op)
 			flags |= extent_op->flags_to_set;
-		ret = alloc_reserved_file_extent(trans, fs_info,
-						 parent, ref_root, flags,
-						 ref->objectid, ref->offset,
-						 &ins, node->ref_mod);
+		ret = alloc_reserved_file_extent(trans, parent, ref_root,
+						 flags, ref->objectid,
+						 ref->offset, &ins,
+						 node->ref_mod);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, fs_info, node, parent,
 					     ref_root, ref->objectid,
@@ -8041,11 +8040,11 @@ int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
 }
 
 static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				      struct btrfs_fs_info *fs_info,
 				      u64 parent, u64 root_objectid,
 				      u64 flags, u64 owner, u64 offset,
 				      struct btrfs_key *ins, int ref_mod)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret;
 	struct btrfs_extent_item *extent_item;
 	struct btrfs_extent_inline_ref *iref;
@@ -8272,8 +8271,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	spin_unlock(&block_group->lock);
 	spin_unlock(&space_info->lock);
 
-	ret = alloc_reserved_file_extent(trans, fs_info, 0, root_objectid,
-					 0, owner, offset, ins, 1);
+	ret = alloc_reserved_file_extent(trans, 0, root_objectid, 0, owner,
+					 offset, ins, 1);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
-- 
2.7.4

