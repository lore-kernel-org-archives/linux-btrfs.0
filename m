Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48941 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752838AbeFTMtU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:20 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C73C6AEC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:19 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/34] btrfs: Remove fs_info from insert_tree_block_ref
Date: Wed, 20 Jun 2018 15:48:43 +0300
Message-Id: <1529498956-4241-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction so there is no
need to duplicate the fs_info, we can reference it directly from the
trans handle. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..f0e40884a908 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1523,7 +1523,6 @@ static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
 }
 
 static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
-					  struct btrfs_fs_info *fs_info,
 					  struct btrfs_path *path,
 					  u64 bytenr, u64 parent,
 					  u64 root_objectid)
@@ -1540,7 +1539,7 @@ static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
 		key.offset = root_objectid;
 	}
 
-	ret = btrfs_insert_empty_item(trans, fs_info->extent_root,
+	ret = btrfs_insert_empty_item(trans, trans->fs_info->extent_root,
 				      path, &key, 0);
 	btrfs_release_path(path);
 	return ret;
@@ -2000,8 +1999,8 @@ static int insert_extent_backref(struct btrfs_trans_handle *trans,
 	int ret;
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		BUG_ON(refs_to_add != 1);
-		ret = insert_tree_block_ref(trans, fs_info, path, bytenr,
-					    parent, root_objectid);
+		ret = insert_tree_block_ref(trans, path, bytenr, parent,
+					    root_objectid);
 	} else {
 		ret = insert_extent_data_ref(trans, fs_info, path, bytenr,
 					     parent, root_objectid,
-- 
2.7.4

