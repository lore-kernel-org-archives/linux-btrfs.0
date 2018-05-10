Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964881AbeEJMpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E8D7FAEED
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/17] btrfs: Remove fs_info argument from modify_free_space_bitmap
Date: Thu, 10 May 2018 15:44:50 +0300
Message-Id: <1525956296-32118-12-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction which has a reference to the
fs_info. So use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 4f36016b2476..e314daeb5072 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -577,12 +577,11 @@ static int free_space_next_bitmap(struct btrfs_trans_handle *trans,
  * the bitmap.
  */
 static int modify_free_space_bitmap(struct btrfs_trans_handle *trans,
-				    struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_group_cache *block_group,
 				    struct btrfs_path *path,
 				    u64 start, u64 size, int remove)
 {
-	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_root *root = block_group->fs_info->free_space_root;
 	struct btrfs_key key;
 	u64 end = start + size;
 	u64 cur_start, cur_size;
@@ -799,8 +798,8 @@ int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
-		return modify_free_space_bitmap(trans, fs_info, block_group,
-						path, start, size, 1);
+		return modify_free_space_bitmap(trans, block_group, path,
+						start, size, 1);
 	} else {
 		return remove_free_space_extent(trans, fs_info, block_group,
 						path, start, size);
@@ -994,8 +993,8 @@ int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
-		return modify_free_space_bitmap(trans, fs_info, block_group,
-						path, start, size, 0);
+		return modify_free_space_bitmap(trans, block_group, path,
+						start, size, 0);
 	} else {
 		return add_free_space_extent(trans, fs_info, block_group, path,
 					     start, size);
-- 
2.7.4

