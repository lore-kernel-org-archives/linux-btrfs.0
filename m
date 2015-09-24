Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:14497 "EHLO
	mail2.data-modul.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752978AbbIXGST (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 02:18:19 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 2/2] btrfs-progs: check: add progress indicator
Date: Thu, 24 Sep 2015 08:13:05 +0200
Message-Id: <977cc21ccbf3c2a96cdfb29021c96f4e3286fe23.1443074502.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443074502.git.silvio.fricke@gmail.com>
References: <cover.1443074502.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443074502.git.silvio.fricke@gmail.com>
References: <cover.1443012156.git.silvio.fricke@gmail.com> <cover.1443074502.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 cmds-check.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 89 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index fe3f782..00423af 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -30,6 +30,7 @@
 #include "repair.h"
 #include "disk-io.h"
 #include "print-tree.h"
+#include "task-utils.h"
 #include "transaction.h"
 #include "utils.h"
 #include "commands.h"
@@ -40,6 +41,20 @@
 #include "backref.h"
 #include "ulist.h"
 
+enum task_position {
+	TASK_EXTENTS,
+	TASK_FREE_SPACE,
+	TASK_FS_ROOTS,
+	TASK_NOTHING, /* have to be the last element */
+};
+
+struct task_ctx {
+	uint8_t progress_enabled;
+	enum task_position tp;
+
+	struct task_info *info;
+};
+
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
 static u64 total_btree_bytes = 0;
@@ -55,6 +70,40 @@ static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
 static int check_data_csum = 0;
+static struct task_ctx ctx = { 0 };
+
+static void *print_status_check(void *p) {
+	struct task_ctx *priv = p;
+	const char work_indicator[] = { '.', 'o', 'O', 'o' };
+	uint32_t count = 0;
+	static char *task_position_string[] = {
+		"checking extents",
+		"checking free space cache",
+		"checking fs roots",
+	};
+
+	task_period_start(priv->info, 1000 /* 1s */);
+
+	if (priv->tp == TASK_NOTHING) {
+		return NULL;
+	}
+
+	while(1) {
+		printf("%s [%c]\r", task_position_string[priv->tp],
+				work_indicator[count % 4]);
+		count++;
+		fflush(stdout);
+		task_period_wait(priv->info);
+	}
+	return NULL;
+}
+
+static int print_status_return(void *p) {
+	printf("\n");
+	fflush(stdout);
+
+	return 0;
+}
 
 struct extent_backref {
 	struct list_head list;
@@ -3520,6 +3569,11 @@ static int check_fs_roots(struct btrfs_root *root,
 	int ret;
 	int err = 0;
 
+	if (ctx.progress_enabled) {
+		ctx.tp = TASK_FS_ROOTS;
+		task_start(ctx.info);
+	}
+
 	/*
 	 * Just in case we made any changes to the extent tree that weren't
 	 * reflected into the free space cache yet.
@@ -3596,6 +3650,8 @@ out:
 	if (!cache_tree_empty(&wc.shared))
 		fprintf(stderr, "warning line %d\n", __LINE__);
 
+	task_stop(ctx.info);
+
 	return err;
 }
 
@@ -5269,6 +5325,11 @@ static int check_space_cache(struct btrfs_root *root)
 		return 0;
 	}
 
+	if (ctx.progress_enabled) {
+		ctx.tp = TASK_FREE_SPACE;
+		task_start(ctx.info);
+	}
+
 	while (1) {
 		cache = btrfs_lookup_first_block_group(root->fs_info, start);
 		if (!cache)
@@ -5297,6 +5358,8 @@ static int check_space_cache(struct btrfs_root *root)
 		}
 	}
 
+	task_stop(ctx.info);
+
 	return error ? -EINVAL : 0;
 }
 
@@ -7971,6 +8034,11 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 		exit(1);
 	}
 
+	if (ctx.progress_enabled) {
+		ctx.tp = TASK_EXTENTS;
+		task_start(ctx.info);
+	}
+
 again:
 	root1 = root->fs_info->tree_root;
 	level = btrfs_header_level(root1->node);
@@ -8087,6 +8155,7 @@ again:
 		ret = err;
 
 out:
+	task_stop(ctx.info);
 	if (repair) {
 		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
 		extent_io_tree_cleanup(&excluded_extents);
@@ -9249,6 +9318,7 @@ const char * const cmd_check_usage[] = {
 	"--qgroup-report             print a report on qgroup consistency",
 	"--subvol-extents <subvolid> print subvolume extents and sharing state",
 	"--tree-root <bytenr>        use the given bytenr for the tree root",
+	"-p|--progress               progressbar",
 	NULL
 };
 
@@ -9283,10 +9353,11 @@ int cmd_check(int argc, char **argv)
 			{ "subvol-extents", required_argument, NULL, 'E' },
 			{ "qgroup-report", no_argument, NULL, 'Q' },
 			{ "tree-root", required_argument, NULL, 'r' },
+			{ "progress", no_argument, NULL, 'p' },
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "as:br:", long_options, NULL);
+		c = getopt_long(argc, argv, "as:br:p", long_options, NULL);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -9315,6 +9386,9 @@ int cmd_check(int argc, char **argv)
 			case 'r':
 				tree_root_bytenr = arg_strtou64(optarg);
 				break;
+			case 'p':
+				ctx.progress_enabled = 1;
+				break;
 			case '?':
 			case 'h':
 				usage(cmd_check_usage);
@@ -9348,6 +9422,11 @@ int cmd_check(int argc, char **argv)
 	if (check_argc_exact(argc, 1))
 		usage(cmd_check_usage);
 
+	if (ctx.progress_enabled) {
+		ctx.tp = TASK_NOTHING;
+		ctx.info = task_init(print_status_check, print_status_return, &ctx);
+	}
+
 	/* This check is the only reason for --readonly to exist */
 	if (readonly && repair) {
 		fprintf(stderr, "Repair options are not compatible with --readonly\n");
@@ -9474,7 +9553,8 @@ int cmd_check(int argc, char **argv)
 		goto close_out;
 	}
 
-	fprintf(stderr, "checking extents\n");
+	if (!ctx.progress_enabled)
+		fprintf(stderr, "checking extents\n");
 	ret = check_chunks_and_extents(root);
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
@@ -9495,7 +9575,8 @@ int cmd_check(int argc, char **argv)
 		goto close_out;
 	}
 
-	fprintf(stderr, "checking free space cache\n");
+	if (!ctx.progress_enabled)
+		fprintf(stderr, "checking free space cache\n");
 	ret = check_space_cache(root);
 	if (ret)
 		goto out;
@@ -9508,7 +9589,8 @@ int cmd_check(int argc, char **argv)
 	 */
 	no_holes = btrfs_fs_incompat(root->fs_info,
 				     BTRFS_FEATURE_INCOMPAT_NO_HOLES);
-	fprintf(stderr, "checking fs roots\n");
+	if (!ctx.progress_enabled)
+		fprintf(stderr, "checking fs roots\n");
 	ret = check_fs_roots(root, &root_cache);
 	if (ret)
 		goto out;
@@ -9590,5 +9672,8 @@ close_out:
 	close_ctree(root);
 	btrfs_close_all_devices();
 err_out:
+	if (ctx.progress_enabled)
+		task_deinit(ctx.info);
+
 	return ret;
 }
-- 
2.5.3

