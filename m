Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752983AbeFTMtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:24 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0EAE5ADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:23 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 12/34] btrfs: Remove fs_info from btrfs_add_delayed_data_ref
Date: Wed, 20 Jun 2018 15:48:54 +0300
Message-Id: <1529498956-4241-13-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where fs_info can be referenced. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 4 ++--
 fs/btrfs/delayed-ref.h | 3 +--
 fs/btrfs/extent-tree.c | 7 +++----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 82ac1273c65f..6eb00eb65d76 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -791,13 +791,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 /*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
-int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
-			       struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
 			       int *old_ref_mod, int *new_ref_mod)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 31729302c827..d9f2a4ebd5db 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -239,8 +239,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
-int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
-			       struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c9b6bfe001d1..cf54cd48c75d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2182,7 +2182,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 						 BTRFS_ADD_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
-		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
+		ret = btrfs_add_delayed_data_ref(trans, bytenr,
 						 num_bytes, parent,
 						 root_objectid, owner, offset,
 						 0, BTRFS_ADD_DELAYED_REF,
@@ -7247,7 +7247,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 						 BTRFS_DROP_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
-		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
+		ret = btrfs_add_delayed_data_ref(trans, bytenr,
 						 num_bytes, parent,
 						 root_objectid, owner, offset,
 						 0, BTRFS_DROP_DELAYED_REF,
@@ -8221,7 +8221,6 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     u64 offset, u64 ram_bytes,
 				     struct btrfs_key *ins)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 
 	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
@@ -8230,7 +8229,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 			   root->root_key.objectid, owner, offset,
 			   BTRFS_ADD_DELAYED_EXTENT);
 
-	ret = btrfs_add_delayed_data_ref(fs_info, trans, ins->objectid,
+	ret = btrfs_add_delayed_data_ref(trans, ins->objectid,
 					 ins->offset, 0,
 					 root->root_key.objectid, owner,
 					 offset, ram_bytes,
-- 
2.7.4

