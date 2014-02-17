Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21701 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbaBQKXW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 05:23:22 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2 4/4] btrfs-progs: fix fsck leaks on error returns
Date: Mon, 17 Feb 2014 18:19:49 +0800
Message-Id: <1392632389-5604-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add close_ctree()s before the "returns" on errors after open_ctree()
Also merge the err returns into the "goto + single return" pattern.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog:
    v1->v2: merge err returns into "goto + single return" pattern
---
 cmds-check.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index eef7c6c..c053126 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6444,18 +6444,21 @@ int cmd_check(int argc, char **argv)
 
 	if((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
-		return ret;
+		goto err_out;
 	} else if(ret) {
 		fprintf(stderr, "%s is currently mounted. Aborting.\n", argv[optind]);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_out;
 	}
 
 	info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
-		return -EIO;
+		ret = -EIO;
+		goto err_out;
 	}
 
+	root = info->fs_root;
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
@@ -6463,19 +6466,20 @@ int cmd_check(int argc, char **argv)
 	    !extent_buffer_uptodate(info->dev_root->node) ||
 	    !extent_buffer_uptodate(info->chunk_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
-		return -EIO;
+		ret = -EIO;
+		goto close_out;
 	}
 
-	root = info->fs_root;
 	if (init_extent_tree) {
 		printf("Creating a new extent tree\n");
 		ret = reinit_extent_tree(info);
 		if (ret)
-			return ret;
+			goto close_out;
 	}
 	if (!extent_buffer_uptodate(info->extent_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
-		return -EIO;
+		ret = -EIO;
+		goto close_out;
 	}
 
 	fprintf(stderr, "checking extents\n");
@@ -6486,13 +6490,15 @@ int cmd_check(int argc, char **argv)
 		trans = btrfs_start_transaction(info->csum_root, 1);
 		if (IS_ERR(trans)) {
 			fprintf(stderr, "Error starting transaction\n");
-			return PTR_ERR(trans);
+			ret = PTR_ERR(trans);
+			goto close_out;
 		}
 
 		ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
 		if (ret) {
 			fprintf(stderr, "crc root initialization failed\n");
-			return -EIO;
+			ret = -EIO;
+			goto close_out;
 		}
 
 		ret = btrfs_commit_transaction(trans, info->csum_root);
@@ -6562,9 +6568,6 @@ int cmd_check(int argc, char **argv)
 		ret = 1;
 	}
 out:
-	free_root_recs_tree(&root_cache);
-	close_ctree(root);
-
 	if (found_old_backref) { /*
 		 * there was a disk format change when mixed
 		 * backref was in testing tree. The old format
@@ -6591,5 +6594,10 @@ out:
 		(unsigned long long)data_bytes_allocated,
 		(unsigned long long)data_bytes_referenced);
 	printf("%s\n", BTRFS_BUILD_VERSION);
+
+	free_root_recs_tree(&root_cache);
+close_out:
+	close_ctree(root);
+err_out:
 	return ret;
 }
-- 
1.8.1.4

