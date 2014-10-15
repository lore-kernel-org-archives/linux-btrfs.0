Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36644 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJOXOx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:14:53 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi2so42283wib.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:14:52 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/4] btrfs-progs: fix csum root copy-n-paste error
Date: Wed, 15 Oct 2014 16:14:21 -0700
Message-Id: <1413414861-28097-5-git-send-email-zab@zabbo.net>
In-Reply-To: <1413414861-28097-1-git-send-email-zab@zabbo.net>
References: <1413414861-28097-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_setup_all_roots() had some copy and pasted code for trying to
setup a root and then creating a blank node if that failed.  The copy
for the csum_root created the blank node in the extent_root.

So we create a function to use a consistent root.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 disk-io.c | 66 ++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index f9dbc85..b89bb29 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -831,6 +831,34 @@ static int find_best_backup_root(struct btrfs_super_block *super)
 	return best_index;
 }
 
+static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
+				      enum btrfs_open_ctree_flags flags,
+				      struct btrfs_root *info_root,
+				      u64 objectid, char *str)
+{
+	struct btrfs_super_block *sb = fs_info->super_copy;
+	struct btrfs_root *root = fs_info->tree_root;
+	u32 leafsize = btrfs_super_leafsize(sb);
+	int ret;
+
+	ret = find_and_setup_root(root, fs_info, objectid, info_root);
+	if (ret) {
+		printk("Couldn't setup %s tree\n", str);
+		if (!(flags & OPEN_CTREE_PARTIAL))
+			return -EIO;
+		/* Need a blank node here just so we don't screw up in the
+		 * million of places that assume a root has a valid ->node
+		 */
+		info_root->node =
+			btrfs_find_create_tree_block(info_root, 0, leafsize);
+		if (!info_root->node)
+			return -ENOMEM;
+		clear_extent_buffer_uptodate(NULL, info_root->node);
+	}
+
+	return 0;
+}
+
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 			  enum btrfs_open_ctree_flags flags)
 {
@@ -877,22 +905,10 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		return -EIO;
 	}
 
-	ret = find_and_setup_root(root, fs_info, BTRFS_EXTENT_TREE_OBJECTID,
-				  fs_info->extent_root);
-	if (ret) {
-		printk("Couldn't setup extent tree\n");
-		if (!(flags & OPEN_CTREE_PARTIAL))
-			return -EIO;
-		/* Need a blank node here just so we don't screw up in the
-		 * million of places that assume a root has a valid ->node
-		 */
-		fs_info->extent_root->node =
-			btrfs_find_create_tree_block(fs_info->extent_root, 0,
-						     leafsize);
-		if (!fs_info->extent_root->node)
-			return -ENOMEM;
-		clear_extent_buffer_uptodate(NULL, fs_info->extent_root->node);
-	}
+	ret = setup_root_or_create_block(fs_info, flags, fs_info->extent_root,
+					 BTRFS_EXTENT_TREE_OBJECTID, "extent");
+	if (ret)
+		return ret;
 	fs_info->extent_root->track_dirty = 1;
 
 	ret = find_and_setup_root(root, fs_info, BTRFS_DEV_TREE_OBJECTID,
@@ -903,20 +919,10 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 	}
 	fs_info->dev_root->track_dirty = 1;
 
-	ret = find_and_setup_root(root, fs_info, BTRFS_CSUM_TREE_OBJECTID,
-				  fs_info->csum_root);
-	if (ret) {
-		printk("Couldn't setup csum tree\n");
-		if (!(flags & OPEN_CTREE_PARTIAL))
-			return -EIO;
-		/* do the same thing as extent tree rebuilding */
-		fs_info->csum_root->node =
-			btrfs_find_create_tree_block(fs_info->extent_root, 0,
-						     leafsize);
-		if (!fs_info->csum_root->node)
-			return -ENOMEM;
-		clear_extent_buffer_uptodate(NULL, fs_info->csum_root->node);
-	}
+	ret = setup_root_or_create_block(fs_info, flags, fs_info->csum_root,
+					 BTRFS_CSUM_TREE_OBJECTID, "csum");
+	if (ret)
+		return ret;
 	fs_info->csum_root->track_dirty = 1;
 
 	ret = find_and_setup_root(root, fs_info, BTRFS_QUOTA_TREE_OBJECTID,
-- 
1.9.3

