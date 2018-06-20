Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbeFTMtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:22 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86F87ADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/34] btrfs: Remove fs_info argument from update_inline_extent_backref
Date: Wed, 20 Jun 2018 15:48:49 +0300
Message-Id: <1529498956-4241-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always uses the leaf's extent_buffer which already
contains a reference to the fs_info. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 211a9d0a94dd..1bbe6d403763 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1892,14 +1892,14 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
  * helper to update/remove inline back ref
  */
 static noinline_for_stack
-void update_inline_extent_backref(struct btrfs_fs_info *fs_info,
-				  struct btrfs_path *path,
+void update_inline_extent_backref(struct btrfs_path *path,
 				  struct btrfs_extent_inline_ref *iref,
 				  int refs_to_mod,
 				  struct btrfs_delayed_extent_op *extent_op,
 				  int *last_ref)
 {
-	struct extent_buffer *leaf;
+	struct extent_buffer *leaf = path->nodes[0];
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_data_ref *dref = NULL;
 	struct btrfs_shared_data_ref *sref = NULL;
@@ -1910,7 +1910,6 @@ void update_inline_extent_backref(struct btrfs_fs_info *fs_info,
 	int type;
 	u64 refs;
 
-	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
 	WARN_ON(refs_to_mod < 0 && refs + refs_to_mod <= 0);
@@ -1977,8 +1976,8 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 					   owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
-		update_inline_extent_backref(fs_info, path, iref,
-					     refs_to_add, extent_op, NULL);
+		update_inline_extent_backref(path, iref, refs_to_add,
+					     extent_op, NULL);
 	} else if (ret == -ENOENT) {
 		setup_inline_extent_backref(fs_info, path, iref, parent,
 					    root_objectid, owner, offset,
@@ -2016,8 +2015,8 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
-		update_inline_extent_backref(fs_info, path, iref,
-					     -refs_to_drop, NULL, last_ref);
+		update_inline_extent_backref(path, iref, -refs_to_drop, NULL,
+					     last_ref);
 	} else if (is_data) {
 		ret = remove_extent_data_ref(trans, path, refs_to_drop,
 					     last_ref);
-- 
2.7.4

