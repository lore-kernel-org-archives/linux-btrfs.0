Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdBMJfW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:22 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 06FE1ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:35:16 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 28/29] btrfs: remove unused parameters from __btrfs_write_out_cache
Date: Mon, 13 Feb 2017 10:34:47 +0100
Message-Id: <77ed54d3725b1d4e2443e3fc6c55cb717d3b7ca1.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both unused after the call to update_cache_item has been moved to
__btrfs_wait_cache_io.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-cache.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0d02599d22bc..c169acef2a23 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1224,8 +1224,6 @@ int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
  * @ctl - the free space cache we are going to write out
  * @block_group - the block_group for this cache if it belongs to a block_group
  * @trans - the trans handle
- * @path - the path to use
- * @offset - the offset for the key we'll insert
  *
  * This function writes out a free space cache struct to disk for quick recovery
  * on mount.  This will return 0 if it was successful in writing the cache out,
@@ -1235,8 +1233,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				   struct btrfs_free_space_ctl *ctl,
 				   struct btrfs_block_group_cache *block_group,
 				   struct btrfs_io_ctl *io_ctl,
-				   struct btrfs_trans_handle *trans,
-				   struct btrfs_path *path, u64 offset)
+				   struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_state *cached_state = NULL;
@@ -1394,8 +1391,7 @@ int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	ret = __btrfs_write_out_cache(root, inode, ctl, block_group,
-				      &block_group->io_ctl, trans,
-				      path, block_group->key.objectid);
+				      &block_group->io_ctl, trans);
 	if (ret) {
 #ifdef DEBUG
 		btrfs_err(fs_info,
@@ -3542,8 +3538,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 		return 0;
 
 	memset(&io_ctl, 0, sizeof(io_ctl));
-	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl,
-				      trans, path, 0);
+	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl, trans);
 	if (!ret) {
 		/*
 		 * At this point writepages() didn't error out, so our metadata
-- 
2.10.1

