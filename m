Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbbANSgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 13:36:38 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3F5F9AB0E
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 18:36:37 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/5] btrfs: cleanup, remove inode_item_info helper
Date: Wed, 14 Jan 2015 19:36:37 +0100
Message-Id: <587f109b377be30fecb69508c3efdd8eea94aed1.1421259762.git.dsterba@suse.cz>
In-Reply-To: <cover.1421259762.git.dsterba@suse.cz>
References: <cover.1421259762.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's only a simple wrapper around btrfs_find_item, the locally defined
key is not used.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/backref.c | 11 -----------
 fs/btrfs/backref.h |  3 ---
 fs/btrfs/scrub.c   |  6 +++++-
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 2d3e32ebfd15..66554b3f7748 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1246,17 +1246,6 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * this makes the path point to (inum INODE_ITEM ioff)
- */
-int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
-			struct btrfs_path *path)
-{
-	struct btrfs_key key;
-	return btrfs_find_item(fs_root, path, inum, ioff,
-			BTRFS_INODE_ITEM_KEY, &key);
-}
-
 static int inode_ref_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
 				struct btrfs_path *path,
 				struct btrfs_key *found_key)
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 2a1ac6bfc724..9c41fbac3009 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -32,9 +32,6 @@ struct inode_fs_paths {
 typedef int (iterate_extent_inodes_t)(u64 inum, u64 offset, u64 root,
 		void *ctx);
 
-int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
-			struct btrfs_path *path);
-
 int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 			struct btrfs_path *path, struct btrfs_key *found_key,
 			u64 *flags);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2bb13a23f86..8bfe3b6fd471 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -530,7 +530,11 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 		goto err;
 	}
 
-	ret = inode_item_info(inum, 0, local_root, swarn->path);
+	/*
+	 * this makes the path point to (inum INODE_ITEM ioff)
+	 */
+	ret = btrfs_find_item(local_root, swarn->path, inum, 0,
+			BTRFS_INODE_ITEM_KEY, NULL);
 	if (ret) {
 		btrfs_release_path(swarn->path);
 		goto err;
-- 
1.8.4.5

