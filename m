Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754089AbeFTMt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:28 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BE63CAE90
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:27 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 28/34] btrfs: Remove fs_info from insert_inline_extent_backref
Date: Wed, 20 Jun 2018 15:49:10 +0300
Message-Id: <1529498956-4241-29-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle, since it'si
always valid.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d3d61e56b61a..08ad7572d025 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1954,7 +1954,6 @@ void update_inline_extent_backref(struct btrfs_path *path,
 
 static noinline_for_stack
 int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 u64 bytenr, u64 num_bytes, u64 parent,
 				 u64 root_objectid, u64 owner,
@@ -1972,7 +1971,7 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 		update_inline_extent_backref(path, iref, refs_to_add,
 					     extent_op, NULL);
 	} else if (ret == -ENOENT) {
-		setup_inline_extent_backref(fs_info, path, iref, parent,
+		setup_inline_extent_backref(trans->fs_info, path, iref, parent,
 					    root_objectid, owner, offset,
 					    refs_to_add, extent_op);
 		ret = 0;
@@ -2201,7 +2200,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  u64 owner, u64 offset, int refs_to_add,
 				  struct btrfs_delayed_extent_op *extent_op)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *item;
@@ -2218,10 +2216,9 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	/* this will setup the path even if it fails to insert the back ref */
-	ret = insert_inline_extent_backref(trans, fs_info, path, bytenr,
-					   num_bytes, parent, root_objectid,
-					   owner, offset,
-					   refs_to_add, extent_op);
+	ret = insert_inline_extent_backref(trans, path, bytenr, num_bytes,
+					   parent, root_objectid, owner,
+					   offset, refs_to_add, extent_op);
 	if ((ret < 0 && ret != -EAGAIN) || !ret)
 		goto out;
 
-- 
2.7.4

