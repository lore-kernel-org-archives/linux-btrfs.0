Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751712AbeEUJ1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:27:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ADD19AD7A
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 09:27:30 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] btrfs: Remove fs_info argument from alloc_reserved_tree_block
Date: Mon, 21 May 2018 12:27:20 +0300
Message-Id: <1526894843-8732-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1526894843-8732-1-git-send-email-nborisov@suse.com>
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction handle which contains a
reference to the fs_info. So use this and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ff26fed6196a..e80fbfa11a89 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -66,7 +66,6 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				      u64 flags, u64 owner, u64 offset,
 				      struct btrfs_key *ins, int ref_mod);
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
 				     u64 parent, u64 root_objectid,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins);
@@ -2461,8 +2460,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		BUG_ON(!extent_op || !extent_op->update_flags);
-		ret = alloc_reserved_tree_block(trans, fs_info,
-						parent, ref_root,
+		ret = alloc_reserved_tree_block(trans, parent, ref_root,
 						extent_op->flags_to_set,
 						&extent_op->key,
 						ref->level, &ins);
@@ -8145,11 +8143,11 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 }
 
 static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
 				     u64 parent, u64 root_objectid,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret;
 	struct btrfs_extent_item *extent_item;
 	struct btrfs_tree_block_info *block_info;
-- 
2.7.4

