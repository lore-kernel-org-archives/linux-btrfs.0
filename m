Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36785 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3JYSBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 14:01:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8CB239A03DC
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 12:01:42 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id ZZNRODarPoES71D4 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 12:01:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent tree is borked
Date: Fri, 25 Oct 2013 14:01:40 -0400
Message-ID: <1382724100-5276-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately you can't run --init-extent-tree if you can't actually read the
extent root.  Fix this by allowing partial starts with no extent root and then
have fsck only check to see if the extent root is uptodate _after_ the check to
see if we are init'ing the extent tree.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |  9 ++++++---
 disk-io.c    | 16 ++++++++++++++--
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 69b0327..8ed7baa 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5932,7 +5932,7 @@ static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
 	}
 
 	/* Ok we can allocate now, reinit the extent root */
-	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root, 1);
+	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root, 0);
 	if (ret) {
 		fprintf(stderr, "extent root initialization failed\n");
 		/*
@@ -6118,20 +6118,23 @@ int cmd_check(int argc, char **argv)
 
 	if (!extent_buffer_uptodate(info->tree_root->node) ||
 	    !extent_buffer_uptodate(info->dev_root->node) ||
-	    !extent_buffer_uptodate(info->extent_root->node) ||
 	    !extent_buffer_uptodate(info->chunk_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
 		return -EIO;
 	}
 
 	root = info->fs_root;
-
 	if (init_extent_tree) {
 		printf("Creating a new extent tree\n");
 		ret = reinit_extent_tree(info);
 		if (ret)
 			return ret;
 	}
+	if (!extent_buffer_uptodate(info->extent_root->node)) {
+		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
+		return -EIO;
+	}
+
 	fprintf(stderr, "checking extents\n");
 	if (init_csum_tree) {
 		struct btrfs_trans_handle *trans;
diff --git a/disk-io.c b/disk-io.c
index 733714d..c5ee33a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -877,7 +877,17 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 				  fs_info->extent_root);
 	if (ret) {
 		printk("Couldn't setup extent tree\n");
-		return -EIO;
+		if (!partial)
+			return -EIO;
+		/* Need a blank node here just so we don't screw up in the
+		 * million of places that assume a root has a valid ->node
+		 */
+		fs_info->extent_root->node =
+			btrfs_find_create_tree_block(fs_info->extent_root, 0,
+						     leafsize);
+		if (!fs_info->extent_root->node)
+			return -ENOMEM;
+		clear_extent_buffer_uptodate(NULL, fs_info->extent_root->node);
 	}
 	fs_info->extent_root->track_dirty = 1;
 
@@ -906,7 +916,9 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
-	btrfs_read_block_groups(fs_info->tree_root);
+
+	if (extent_buffer_uptodate(fs_info->extent_root->node))
+		btrfs_read_block_groups(fs_info->tree_root);
 
 	key.objectid = BTRFS_FS_TREE_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
-- 
1.8.3.1

