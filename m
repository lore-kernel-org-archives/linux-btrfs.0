Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752930AbeFTMtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:21 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 165FBADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/34] btrfs: Remove fs_info from insert_extent_data_ref
Date: Wed, 20 Jun 2018 15:48:44 +0300
Message-Id: <1529498956-4241-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where fs_info can be referenced. So remove the redundant argument.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f0e40884a908..5fc44c2e3e18 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1304,13 +1304,12 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 }
 
 static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
-					   struct btrfs_fs_info *fs_info,
 					   struct btrfs_path *path,
 					   u64 bytenr, u64 parent,
 					   u64 root_objectid, u64 owner,
 					   u64 offset, int refs_to_add)
 {
-	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_root *root = trans->fs_info->extent_root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	u32 size;
@@ -2002,9 +2001,9 @@ static int insert_extent_backref(struct btrfs_trans_handle *trans,
 		ret = insert_tree_block_ref(trans, path, bytenr, parent,
 					    root_objectid);
 	} else {
-		ret = insert_extent_data_ref(trans, fs_info, path, bytenr,
-					     parent, root_objectid,
-					     owner, offset, refs_to_add);
+		ret = insert_extent_data_ref(trans, path, bytenr, parent,
+					     root_objectid, owner, offset,
+					     refs_to_add);
 	}
 	return ret;
 }
-- 
2.7.4

