Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaBYLu4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 06:50:56 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1PBon6q016049
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 19:50:50 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs-progs: fsck: avoid overwritting existed space when initting csum tree
Date: Tue, 25 Feb 2014 19:48:56 +0800
Message-Id: <1393328937-26171-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda9
 # btrfs check /dev/sda9 --init-extent-tree --init-csum-tree
 # btrfs check /dev/sda9

During reinitting extent tree, we will pin all metadata blocks to
avoid overwritting existing metadata space. However, those space will
be unpinned after committing transaction.

If we try to reinit csum tree after reiniting extent tree, we may
overwrite existing space. Fix this problem by making reinit extent tree
and csum tree in same transaction.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 74 ++++++++++++++++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 42 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 253569f..4cdeac8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6179,9 +6179,9 @@ out:
 	return ret;
 }
 
-static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
+static int reinit_extent_tree(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_trans_handle *trans;
 	u64 start = 0;
 	int ret;
 
@@ -6200,12 +6200,6 @@ static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
 		return -EINVAL;
 	}
 
-	trans = btrfs_start_transaction(fs_info->extent_root, 1);
-	if (IS_ERR(trans)) {
-		fprintf(stderr, "Error starting transaction\n");
-		return PTR_ERR(trans);
-	}
-
 	/*
 	 * first we need to walk all of the trees except the extent tree and pin
 	 * down the bytes that are in use so we don't overwrite any existing
@@ -6268,11 +6262,7 @@ static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
 		btrfs_extent_post_op(trans, fs_info->extent_root);
 	}
 
-	/*
-	 * Ok now we commit and run the normal fsck, which will add extent
-	 * entries for all of the items it finds.
-	 */
-	return btrfs_commit_transaction(trans, fs_info->extent_root);
+	return 0;
 }
 
 static int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb)
@@ -6475,47 +6465,47 @@ int cmd_check(int argc, char **argv)
 		goto close_out;
 	}
 
-	if (init_extent_tree) {
-		printf("Creating a new extent tree\n");
-		ret = reinit_extent_tree(info);
-		if (ret)
-			goto close_out;
-	}
-	if (!extent_buffer_uptodate(info->extent_root->node)) {
-		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
-		ret = -EIO;
-		goto close_out;
-	}
-
-	fprintf(stderr, "checking extents\n");
-	if (init_csum_tree) {
+	if (init_extent_tree || init_csum_tree) {
 		struct btrfs_trans_handle *trans;
 
-		fprintf(stderr, "Reinit crc root\n");
-		trans = btrfs_start_transaction(info->csum_root, 1);
+		trans = btrfs_start_transaction(info->extent_root, 0);
 		if (IS_ERR(trans)) {
 			fprintf(stderr, "Error starting transaction\n");
 			ret = PTR_ERR(trans);
 			goto close_out;
 		}
 
-		ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
-		if (ret) {
-			fprintf(stderr, "crc root initialization failed\n");
-			ret = -EIO;
-			goto close_out;
+		if (init_extent_tree) {
+			printf("Creating a new extent tree\n");
+			ret = reinit_extent_tree(trans, info);
+			if (ret)
+				goto close_out;
 		}
 
-		ret = btrfs_commit_transaction(trans, info->csum_root);
-		if (ret)
-			exit(1);
-
-		ret = check_chunks_and_extents(root);
+		if (init_csum_tree) {
+			fprintf(stderr, "Reinit crc root\n");
+			ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
+			if (ret) {
+				fprintf(stderr, "crc root initialization failed\n");
+				ret = -EIO;
+				goto close_out;
+			}
+		}
+		/*
+		 * Ok now we commit and run the normal fsck, which will add
+		 * extent entries for all of the items it finds.
+		 */
+		ret = btrfs_commit_transaction(trans, info->extent_root);
 		if (ret)
-			fprintf(stderr,
-				"Errors found in extent allocation tree or chunk allocation\n");
-		goto out;
+			goto close_out;
+	}
+	if (!extent_buffer_uptodate(info->extent_root->node)) {
+		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
+		ret = -EIO;
+		goto close_out;
 	}
+
+	fprintf(stderr, "checking extents\n");
 	ret = check_chunks_and_extents(root);
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
-- 
1.9.0

