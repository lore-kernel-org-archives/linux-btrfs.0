Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754011AbeFTMtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:22 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC405AE90
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/34] btrfs: Remove fs_info argument from lookup_tree_block_ref
Date: Wed, 20 Jun 2018 15:48:50 +0300
Message-Id: <1529498956-4241-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle from
where the fs_info can be referenced. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1bbe6d403763..1bac81f4f77f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1487,12 +1487,11 @@ static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 }
 
 static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
-					  struct btrfs_fs_info *fs_info,
 					  struct btrfs_path *path,
 					  u64 bytenr, u64 parent,
 					  u64 root_objectid)
 {
-	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_root *root = trans->fs_info->extent_root;
 	struct btrfs_key key;
 	int ret;
 
@@ -1878,8 +1877,8 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
 	*ref_ret = NULL;
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = lookup_tree_block_ref(trans, fs_info, path, bytenr,
-					    parent, root_objectid);
+		ret = lookup_tree_block_ref(trans, path, bytenr, parent,
+					    root_objectid);
 	} else {
 		ret = lookup_extent_data_ref(trans, fs_info, path, bytenr,
 					     parent, root_objectid, owner,
-- 
2.7.4

