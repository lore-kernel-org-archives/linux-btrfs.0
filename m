Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754027AbeFTMtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:23 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C8BEFAF62
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/34] btrfs: Remove fs_info from btrfs_add_delayed_tree_ref
Date: Wed, 20 Jun 2018 15:48:53 +0300
Message-Id: <1529498956-4241-12-git-send-email-nborisov@suse.com>
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
 fs/btrfs/extent-tree.c | 8 ++++----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 03dec673d12a..82ac1273c65f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -709,13 +709,13 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
  * to make sure the delayed ref is eventually processed before this
  * transaction commits.
  */
-int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
-			       struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root,  int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index ea1aecb6a50d..31729302c827 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -234,8 +234,7 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head);
 }
 
-int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
-			       struct btrfs_trans_handle *trans,
+int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0c4c093201b5..c9b6bfe001d1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2176,7 +2176,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			   owner, offset, BTRFS_ADD_DELAYED_REF);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
+		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
 						 num_bytes, parent,
 						 root_objectid, (int)owner,
 						 BTRFS_ADD_DELAYED_REF, NULL,
@@ -7162,7 +7162,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 				   root->root_key.objectid,
 				   btrfs_header_level(buf), 0,
 				   BTRFS_DROP_DELAYED_REF);
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans, buf->start,
+		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
 						 buf->len, parent,
 						 root->root_key.objectid,
 						 btrfs_header_level(buf),
@@ -7241,7 +7241,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
+		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
 						 num_bytes, parent,
 						 root_objectid, (int)owner,
 						 BTRFS_DROP_DELAYED_REF, NULL,
@@ -8457,7 +8457,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
 				   root_objectid, level, 0,
 				   BTRFS_ADD_DELAYED_EXTENT);
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans, ins.objectid,
+		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
 						 ins.offset, parent,
 						 root_objectid, level,
 						 BTRFS_ADD_DELAYED_EXTENT,
-- 
2.7.4

