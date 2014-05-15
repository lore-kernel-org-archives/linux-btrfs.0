Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56665 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752002AbaEOBdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 21:33:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4F1Xn7J007574
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 09:33:49 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: cleanup btrfs-rescue output msgs
Date: Thu, 15 May 2014 09:29:07 +0800
Message-ID: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use enum defined error codes to represent different kinds of errs
for super-recover and chunk-recover.
---
 chunk-recover.c | 35 ++++++++++++++++++++++++++---
 cmds-rescue.c   | 36 ++++++++++++++++++++----------
 super-recover.c | 69 ++++++++++++++++++++++++++++-----------------------------
 3 files changed, 90 insertions(+), 50 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 613d715..84fd8b7 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -82,6 +82,27 @@ struct device_scan {
 	int fd;
 };
 
+enum chunk_recover_err_code {
+	cr_notused,
+	ERR_CR_NO_RECOVER,
+	ERR_CR_FAILED_TO_RECOVER,
+	ERR_CR_ABORTED_TO_RECOVER,
+};
+
+char *chunk_recover_err_str(int err)
+{
+	switch (err) {
+	case ERR_CR_NO_RECOVER:
+		return "All chunks are good, no need to recover\n";
+	case ERR_CR_FAILED_TO_RECOVER:
+		return "Failed to recover the chunk tree\n";
+	case ERR_CR_ABORTED_TO_RECOVER:
+		return "Aborted to recover bad superblocks\n";
+	default:
+		return "Unkown recover result\n";
+	}
+}
+
 static struct extent_record *btrfs_new_extent_record(struct extent_buffer *eb)
 {
 	struct extent_record *rec;
@@ -2092,12 +2113,14 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 	ret = recover_prepare(&rc, path);
 	if (ret) {
 		fprintf(stderr, "recover prepare error\n");
+		ret = ERR_CR_FAILED_TO_RECOVER;
 		return ret;
 	}
 
 	ret = scan_devices(&rc);
 	if (ret) {
 		fprintf(stderr, "scan chunk headers error\n");
+		ret = ERR_CR_FAILED_TO_RECOVER;
 		goto fail_rc;
 	}
 
@@ -2105,6 +2128,7 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 	    cache_tree_empty(&rc.bg.tree) &&
 	    cache_tree_empty(&rc.devext.tree)) {
 		fprintf(stderr, "no recoverable chunk\n");
+		ret = ERR_CR_NO_RECOVER;
 		goto fail_rc;
 	}
 
@@ -2117,8 +2141,10 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 		if (!list_empty(&rc.bg.block_groups) ||
 		    !list_empty(&rc.devext.no_chunk_orphans)) {
 			ret = btrfs_recover_chunks(&rc);
-			if (ret)
+			if (ret) {
+				ret = ERR_CR_FAILED_TO_RECOVER;
 				goto fail_rc;
+			}
 		}
 		/*
 		 * If the chunk is healthy, its block group item and device
@@ -2129,32 +2155,35 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 		 */
 	} else {
 		fprintf(stderr, "Check chunks successfully with no orphans\n");
+		ret = ERR_CR_NO_RECOVER;
 		goto fail_rc;
 	}
 
 	root = open_ctree_with_broken_chunk(&rc);
 	if (IS_ERR(root)) {
 		fprintf(stderr, "open with broken chunk error\n");
-		ret = PTR_ERR(root);
+		ret = ERR_CR_FAILED_TO_RECOVER;
 		goto fail_rc;
 	}
 
 	ret = check_all_chunks_by_metadata(&rc, root);
 	if (ret) {
 		fprintf(stderr, "The chunks in memory can not match the metadata of the fs. Repair failed.\n");
+		ret = ERR_CR_FAILED_TO_RECOVER;
 		goto fail_close_ctree;
 	}
 
 	ret = btrfs_rebuild_ordered_data_chunk_stripes(&rc, root);
 	if (ret) {
 		fprintf(stderr, "Failed to rebuild ordered chunk stripes.\n");
+		ret = ERR_CR_FAILED_TO_RECOVER;
 		goto fail_close_ctree;
 	}
 
 	if (!rc.yes) {
 		ret = ask_user("We are going to rebuild the chunk tree on disk, it might destroy the old metadata on the disk, Are you sure?");
 		if (!ret) {
-			ret = 1;
+			ret = ERR_CR_ABORTED_TO_RECOVER;
 			goto fail_close_ctree;
 		}
 	}
diff --git a/cmds-rescue.c b/cmds-rescue.c
index f20a206..7e0687e 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -30,6 +30,9 @@ static const char * const rescue_cmd_group_usage[] = {
 int btrfs_recover_chunk_tree(char *path, int verbose, int yes);
 int btrfs_recover_superblocks(char *path, int verbose, int yes);
 
+char *chunk_recover_err_str(int err);
+char *super_recover_err_str(int err);
+
 const char * const cmd_chunk_recover_usage[] = {
 	"btrfs rescue chunk-recover [options] <device>",
 	"Recover the chunk tree by scanning the devices one by one.",
@@ -49,6 +52,13 @@ const char * const cmd_super_recover_usage[] = {
 	NULL
 };
 
+/*
+ * return codes:
+ *   0 : Chunk recover successfully
+ *   1 : All chunks are good, no need to recover
+ *   2 : Fail to recover the chunk tree
+ *   3 : Abort to recover the on-disk chunk tree
+ */
 int cmd_chunk_recover(int argc, char *argv[])
 {
 	int ret = 0;
@@ -90,23 +100,20 @@ int cmd_chunk_recover(int argc, char *argv[])
 	}
 
 	ret = btrfs_recover_chunk_tree(file, verbose, yes);
-	if (!ret) {
-		fprintf(stdout, "Recover the chunk tree successfully.\n");
-	} else if (ret > 0) {
-		ret = 0;
-		fprintf(stdout, "Abort to rebuild the on-disk chunk tree.\n");
-	} else {
-		fprintf(stdout, "Fail to recover the chunk tree.\n");
-	}
+	if (!ret)
+		printf("Chunk recover successfully\n");
+	else if (ret > 0)
+		fprintf(stderr, "%s", chunk_recover_err_str(ret));
+
 	return ret;
 }
 
 /*
  * return codes:
- *   0 : All superblocks are valid, no need to recover
- *   1 : Usage or syntax error
- *   2 : Recover all bad superblocks successfully
- *   3 : Fail to Recover bad supeblocks
+ *   0 : Super recover successfully
+ *   1 : All superblocks are good, no need to recover
+ *   2 : Usage or syntax error
+ *   3 : Fail to recover bad supeblocks
  *   4 : Abort to recover bad superblocks
  */
 int cmd_super_recover(int argc, char **argv)
@@ -146,6 +153,11 @@ int cmd_super_recover(int argc, char **argv)
 		return 1;
 	}
 	ret = btrfs_recover_superblocks(dname, verbose, yes);
+	if (!ret)
+		printf("Super recover successfully\n");
+	else if (ret > 0)
+		fprintf(stderr, "%s", super_recover_err_str(ret));
+
 	return ret;
 }
 
diff --git a/super-recover.c b/super-recover.c
index cd6ba37..72ad884 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -56,6 +56,30 @@ struct super_block_record {
 	u64 bytenr;
 };
 
+enum super_recover_err_code {
+	sr_notused,
+	ERR_SR_NO_RECOVER,
+	ERR_SR_USAGE_OR_SYNTAX,
+	ERR_SR_FAILED_TO_RECOVER,
+	ERR_SR_ABORTED_TO_RECOVER,
+};
+
+char *super_recover_err_str(int err)
+{
+	switch (err) {
+	case ERR_SR_NO_RECOVER:
+		return "All superblocks are good, no need to recover\n";
+	case ERR_SR_USAGE_OR_SYNTAX:
+		return "Usage or syntax error\n";
+	case ERR_SR_FAILED_TO_RECOVER:
+		return "Failed to recover the chunk tree\n";
+	case ERR_SR_ABORTED_TO_RECOVER:
+		return "Aborted to recover the on-disk chunk tree\n";
+	default:
+		return "Unkown recover result\n";
+	}
+}
+
 static
 void init_recover_superblock(struct btrfs_recover_superblock *recover)
 {
@@ -253,30 +277,6 @@ static void print_all_supers(struct btrfs_recover_superblock *recover)
 	printf("\n");
 }
 
-static void recover_err_str(int ret)
-{
-	switch (ret) {
-	case 0:
-		printf("All supers are valid, no need to recover\n");
-		break;
-	case 1:
-		printf("Usage or syntax errors\n");
-		break;
-	case 2:
-		printf("Recovered bad superblocks successful\n");
-		break;
-	case 3:
-		printf("Failed to recover bad superblocks\n");
-		break;
-	case 4:
-		printf("Aborted to recover bad superblocks\n");
-		break;
-	default:
-		printf("Unknown recover result\n");
-		break;
-	}
-}
-
 int btrfs_recover_superblocks(const char *dname,
 			int verbose, int yes)
 {
@@ -288,14 +288,14 @@ int btrfs_recover_superblocks(const char *dname,
 	fd = open(dname, O_RDONLY);
 	if (fd < 0) {
 		fprintf(stderr, "open %s error\n", dname);
-		return 1;
+		return ERR_SR_USAGE_OR_SYNTAX;
 	}
 	init_recover_superblock(&recover);
 
 	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 0);
 	close(fd);
 	if (ret) {
-		ret = 1;
+		ret = ERR_SR_USAGE_OR_SYNTAX;
 		goto no_recover;
 	}
 
@@ -304,7 +304,7 @@ int btrfs_recover_superblocks(const char *dname,
 
 	ret = read_fs_supers(&recover);
 	if (ret) {
-		ret = 1;
+		ret = ERR_SR_USAGE_OR_SYNTAX;
 		goto no_recover;
 	}
 	if (verbose) {
@@ -312,13 +312,15 @@ int btrfs_recover_superblocks(const char *dname,
 		print_all_supers(&recover);
 	}
 
-	if (list_empty(&recover.bad_supers))
+	if (list_empty(&recover.bad_supers)) {
+		ret = ERR_SR_NO_RECOVER;
 		goto no_recover;
+	}
 
 	if (!yes) {
 		ret = ask_user("Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure?");
 		if (!ret) {
-			ret = 4;
+			ret = ERR_SR_ABORTED_TO_RECOVER;
 			goto no_recover;
 		}
 	}
@@ -326,20 +328,17 @@ int btrfs_recover_superblocks(const char *dname,
 	root = open_ctree(record->device_name, record->bytenr,
 			  OPEN_CTREE_RECOVER_SUPER | OPEN_CTREE_WRITES);
 	if (!root) {
-		ret = 3;
+		ret = ERR_SR_FAILED_TO_RECOVER;
 		goto no_recover;
 	}
 	/* reset super_bytenr in order that we will rewite all supers */
 	root->fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
 	ret = write_all_supers(root);
-	if (!ret)
-		ret = 2;
-	else
-		ret = 3;
+	if (ret)
+		ret = ERR_SR_FAILED_TO_RECOVER;
 
 	close_ctree(root);
 no_recover:
-	recover_err_str(ret);
 	free_recover_superblock(&recover);
 	return ret;
 }
-- 
1.8.1.4

