Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbbANSgl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:36:41 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 758A4AB0E
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 18:36:40 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/5] btrfs: cleanup, remove inode_ref_info helper
Date: Wed, 14 Jan 2015 19:36:40 +0100
Message-Id: <bb5fcaa8ee2feb2fe7f06ce8b4b9b80be5e8684d.1421259762.git.dsterba@suse.cz>
In-Reply-To: <cover.1421259762.git.dsterba@suse.cz>
References: <cover.1421259762.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A simple wrapper around btrfs_find_item.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/backref.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 66554b3f7748..e715c16e9d07 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1246,14 +1246,6 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int inode_ref_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
-				struct btrfs_path *path,
-				struct btrfs_key *found_key)
-{
-	return btrfs_find_item(fs_root, path, inum, ioff,
-			BTRFS_INODE_REF_KEY, found_key);
-}
-
 int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
 			  u64 start_off, struct btrfs_path *path,
 			  struct btrfs_inode_extref **ret_extref,
@@ -1363,7 +1355,8 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
 		}
-		ret = inode_ref_info(parent, 0, fs_root, path, &found_key);
+		ret = btrfs_find_item(fs_root, path, parent, 0,
+				BTRFS_INODE_REF_KEY, &found_key);
 		if (ret > 0)
 			ret = -ENOENT;
 		if (ret)
@@ -1709,8 +1702,10 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 	struct btrfs_key found_key;
 
 	while (!ret) {
-		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
-				     &found_key);
+		ret = btrfs_find_item(fs_root, path, inum,
+				parent ? parent + 1 : 0, BTRFS_INODE_REF_KEY,
+				&found_key);
+
 		if (ret < 0)
 			break;
 		if (ret) {
-- 
1.8.4.5

