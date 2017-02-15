Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752460AbdBOV2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA23FADA7
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:41 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 5/8] btrfs: btrfs_wait_cache_io_root doesn't use path argument
Date: Wed, 15 Feb 2017 16:28:31 -0500
Message-Id: <1487194114-12786-6-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/free-space-cache.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 61a72fb..a1e15f6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -42,10 +42,6 @@ static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
 static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info);
-static int btrfs_wait_cache_io_root(struct btrfs_root *root,
-			     struct btrfs_trans_handle *trans,
-			     struct btrfs_io_ctl *io_ctl,
-			     struct btrfs_path *path);
 
 static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 					       struct btrfs_path *path,
@@ -1234,8 +1230,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				   struct btrfs_free_space_ctl *ctl,
 				   struct btrfs_block_group_cache *block_group,
 				   struct btrfs_io_ctl *io_ctl,
-				   struct btrfs_trans_handle *trans,
-				   struct btrfs_path *path, u64 offset)
+				   struct btrfs_trans_handle *trans, u64 offset)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_state *cached_state = NULL;
@@ -1393,7 +1388,7 @@ int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 
 	ret = __btrfs_write_out_cache(fs_info->tree_root, inode, ctl,
 				      block_group, &block_group->io_ctl, trans,
-				      path, block_group->key.objectid);
+				      block_group->key.objectid);
 	if (ret) {
 #ifdef DEBUG
 		btrfs_err(fs_info,
@@ -3541,7 +3536,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 
 	memset(&io_ctl, 0, sizeof(io_ctl));
 	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
-				      trans, path, 0);
+				      trans, 0);
 	if (!ret) {
 		/*
 		 * At this point writepages() didn't error out, so our metadata
-- 
2.7.1

