Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:54874 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752898AbeGDTcD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 15:32:03 -0400
From: =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
Subject: [PATCH 2/2] btrfs-progs: check: enhanced progress indicator
Date: Wed,  4 Jul 2018 21:20:14 +0200
Message-Id: <1530732014-5449-3-git-send-email-stephane_btrfs@lesimple.fr>
In-Reply-To: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We reuse the task_position enum and task_ctx struct of the original progress
indicator, adding more values and fields for our needs.

Then add hooks in all steps of the check to properly record progress.

Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
---
 check/main.c        | 176 ++++++++++++++++++++++++++++++++++------------------
 check/mode-common.h |  20 ++++++
 check/mode-lowmem.c |   1 +
 convert/main.c      |   2 +-
 qgroup-verify.c     |   7 +++
 qgroup-verify.h     |   2 +
 task-utils.c        |   8 ++-
 task-utils.h        |   3 +-
 8 files changed, 154 insertions(+), 65 deletions(-)

diff --git a/check/main.c b/check/main.c
index 3190b5d..bb3ebea 100644
--- a/check/main.c
+++ b/check/main.c
@@ -25,6 +25,7 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
+#include <time.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "repair.h"
@@ -47,20 +48,6 @@
 #include "check/mode-original.h"
 #include "check/mode-lowmem.h"
 
-enum task_position {
-	TASK_EXTENTS,
-	TASK_FREE_SPACE,
-	TASK_FS_ROOTS,
-	TASK_NOTHING, /* have to be the last element */
-};
-
-struct task_ctx {
-	int progress_enabled;
-	enum task_position tp;
-
-	struct task_info *info;
-};
-
 u64 bytes_used = 0;
 u64 total_csum_bytes = 0;
 u64 total_btree_bytes = 0;
@@ -72,6 +59,7 @@ u64 data_bytes_referenced = 0;
 LIST_HEAD(duplicate_extents);
 LIST_HEAD(delete_items);
 int no_holes = 0;
+static int is_free_space_tree = 0;
 int init_extent_tree = 0;
 int check_data_csum = 0;
 struct btrfs_fs_info *global_info;
@@ -173,28 +161,48 @@ static int compare_extent_backref(struct rb_node *node1, struct rb_node *node2)
 		return compare_tree_backref(node1, node2);
 }
 
+static void print_status_check_line(void *p)
+{
+	struct task_ctx *priv = p;
+	char *task_position_string[] = {
+		"[1/7] checking root items                     ",
+		"[2/7] checking extents                        ",
+		is_free_space_tree ?
+			"[3/7] checking free space tree                ":
+			"[3/7] checking free space cache               ",
+		"[4/7] checking fs roots                       ",
+		check_data_csum ?
+			"[5/7] checking csums against data             ":
+			"[5/7] checking csums (without verifying data) ",
+		"[6/7] checking root refs                      ",
+		"[7/7] checking quota groups                   ",
+	};
+
+	time_t elapsed = time(NULL) - priv->start_time;
+	int hours   = elapsed / 3600;
+	elapsed    -= hours   * 3600;
+	int minutes = elapsed / 60;
+	elapsed    -= minutes * 60;
+	int seconds = elapsed;
+	printf("%s (%d:%02d:%02d elapsed", task_position_string[priv->tp], hours, minutes, seconds);
+	if (priv->item_count > 0)
+		printf(", %llu items checked)\r", priv->item_count);
+	else
+		printf(")\r");
+	fflush(stdout);
+}
 
 static void *print_status_check(void *p)
 {
 	struct task_ctx *priv = p;
-	const char work_indicator[] = { '.', 'o', 'O', 'o' };
-	uint32_t count = 0;
-	static char *task_position_string[] = {
-		"checking extents",
-		"checking free space cache",
-		"checking fs roots",
-	};
 
-	task_period_start(priv->info, 1000 /* 1s */);
+	task_period_start(priv->info, 50);
 
 	if (priv->tp == TASK_NOTHING)
 		return NULL;
 
 	while (1) {
-		printf("%s [%c]\r", task_position_string[priv->tp],
-				work_indicator[count % 4]);
-		count++;
-		fflush(stdout);
+		print_status_check_line(p);
 		task_period_wait(priv->info);
 	}
 	return NULL;
@@ -202,6 +210,7 @@ static void *print_status_check(void *p)
 
 static int print_status_return(void *p)
 {
+	print_status_check_line(p);
 	printf("\n");
 	fflush(stdout);
 
@@ -2942,6 +2951,7 @@ static int check_root_refs(struct btrfs_root *root,
 		loop = 0;
 		cache = search_cache_extent(root_cache, 0);
 		while (1) {
+			ctx.item_count++;
 			if (!cache)
 				break;
 			rec = container_of(cache, struct root_record, cache);
@@ -3263,6 +3273,7 @@ static int check_fs_root(struct btrfs_root *root,
 	}
 
 	while (1) {
+		ctx.item_count++;
 		wret = walk_down_tree(root, &path, wc, &level, &nrefs);
 		if (wret < 0)
 			ret = wret;
@@ -3340,11 +3351,6 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
 	int ret;
 	int err = 0;
 
-	if (ctx.progress_enabled) {
-		ctx.tp = TASK_FS_ROOTS;
-		task_start(ctx.info);
-	}
-
 	/*
 	 * Just in case we made any changes to the extent tree that weren't
 	 * reflected into the free space cache yet.
@@ -3421,8 +3427,6 @@ out:
 	if (!cache_tree_empty(&wc.shared))
 		fprintf(stderr, "warning line %d\n", __LINE__);
 
-	task_stop(ctx.info);
-
 	return err;
 }
 
@@ -3491,8 +3495,6 @@ static int do_check_fs_roots(struct btrfs_fs_info *fs_info,
 {
 	int ret;
 
-	if (!ctx.progress_enabled)
-		fprintf(stderr, "checking fs roots\n");
 	if (check_mode == CHECK_MODE_LOWMEM)
 		ret = check_fs_roots_lowmem(fs_info);
 	else
@@ -5329,12 +5331,8 @@ static int check_space_cache(struct btrfs_root *root)
 		return 0;
 	}
 
-	if (ctx.progress_enabled) {
-		ctx.tp = TASK_FREE_SPACE;
-		task_start(ctx.info);
-	}
-
 	while (1) {
+		ctx.item_count++;
 		cache = btrfs_lookup_first_block_group(root->fs_info, start);
 		if (!cache)
 			break;
@@ -5383,8 +5381,6 @@ static int check_space_cache(struct btrfs_root *root)
 		}
 	}
 
-	task_stop(ctx.info);
-
 	return error ? -EINVAL : 0;
 }
 
@@ -5654,6 +5650,7 @@ static int check_csums(struct btrfs_root *root)
 	}
 
 	while (1) {
+		ctx.item_count++;
 		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
 			ret = btrfs_next_leaf(root, &path);
 			if (ret < 0) {
@@ -8047,6 +8044,7 @@ static int deal_root_from_list(struct list_head *list,
 		 * can maximize readahead.
 		 */
 		while (1) {
+			ctx.item_count++;
 			ret = run_next_block(root, bits, bits_nr, &last,
 					     pending, seen, reada, nodes,
 					     extent_cache, chunk_cache,
@@ -8134,11 +8132,6 @@ static int check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 		exit(1);
 	}
 
-	if (ctx.progress_enabled) {
-		ctx.tp = TASK_EXTENTS;
-		task_start(ctx.info);
-	}
-
 again:
 	root1 = fs_info->tree_root;
 	level = btrfs_header_level(root1->node);
@@ -8248,7 +8241,6 @@ again:
 		ret = err;
 
 out:
-	task_stop(ctx.info);
 	if (repair) {
 		free_corrupt_blocks_tree(fs_info->corrupt_blocks);
 		extent_io_tree_cleanup(&excluded_extents);
@@ -8290,8 +8282,6 @@ static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 
-	if (!ctx.progress_enabled)
-		fprintf(stderr, "checking extents\n");
 	if (check_mode == CHECK_MODE_LOWMEM)
 		ret = check_chunks_and_extents_lowmem(fs_info);
 	else
@@ -9021,6 +9011,7 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
 		struct cache_extent *entry;
 		struct root_item_info *rii;
 
+		ctx.item_count++;
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(info->extent_root, &path);
 			if (ret < 0) {
@@ -9559,6 +9550,8 @@ int cmd_check(int argc, char **argv)
 	if (repair && check_mode == CHECK_MODE_LOWMEM)
 		warning("low-memory mode repair support is only partial");
 
+	printf("Opening filesystem to check...\n");
+
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
@@ -9732,7 +9725,14 @@ int cmd_check(int argc, char **argv)
 	}
 
 	if (!init_extent_tree) {
+		if (!ctx.progress_enabled)
+			fprintf(stderr, "[1/7] checking root items\n");
+		else {
+			ctx.tp = TASK_ROOT_ITEMS;
+			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+		}
 		ret = repair_root_items(info);
+		task_stop(ctx.info);
 		if (ret < 0) {
 			err = !!ret;
 			error("failed to repair root items: %s", strerror(-ret));
@@ -9752,8 +9752,18 @@ int cmd_check(int argc, char **argv)
 			goto close_out;
 		}
 	}
+	else {
+		fprintf(stderr, "[1/7] checking root items... skipped\n");
+	}
 
+	if (!ctx.progress_enabled)
+		fprintf(stderr, "[2/7] checking extents\n");
+	else {
+		ctx.tp = TASK_EXTENTS;
+		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+	}
 	ret = do_check_chunks_and_extents(info);
+	task_stop(ctx.info);
 	err |= !!ret;
 	if (ret)
 		error(
@@ -9762,16 +9772,24 @@ int cmd_check(int argc, char **argv)
 	/* Only re-check super size after we checked and repaired the fs */
 	err |= !is_super_size_valid(info);
 
+	is_free_space_tree = btrfs_fs_compat_ro(info, FREE_SPACE_TREE);
+
 	if (!ctx.progress_enabled) {
-		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
-			fprintf(stderr, "checking free space tree\n");
+		if (is_free_space_tree)
+			fprintf(stderr, "[3/7] checking free space tree\n");
 		else
-			fprintf(stderr, "checking free space cache\n");
+			fprintf(stderr, "[3/7] checking free space cache\n");
 	}
+	else {
+		ctx.tp = TASK_FREE_SPACE;
+		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+	}
+
 	ret = check_space_cache(root);
+	task_stop(ctx.info);
 	err |= !!ret;
 	if (ret) {
-		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
+		if (is_free_space_tree)
 			error("errors found in free space tree");
 		else
 			error("errors found in free space cache");
@@ -9785,19 +9803,34 @@ int cmd_check(int argc, char **argv)
 	 * ignore it when this happens.
 	 */
 	no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
+	if (!ctx.progress_enabled)
+		fprintf(stderr, "[4/7] checking fs roots\n");
+	else {
+		ctx.tp = TASK_FS_ROOTS;
+		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+	}
+
 	ret = do_check_fs_roots(info, &root_cache);
+	task_stop(ctx.info);
 	err |= !!ret;
 	if (ret) {
 		error("errors found in fs roots");
 		goto out;
 	}
 
-	if (check_data_csum)
-		fprintf(stderr, "checking csums against data\n");
-	else
-		fprintf(stderr,
-			"checking only csum items (without verifying data)\n");
+	if (!ctx.progress_enabled) {
+		if (check_data_csum)
+			fprintf(stderr, "[5/7] checking csums against data\n");
+		else
+			fprintf(stderr, "[5/7] checking only csums items (without verifying data)\n");
+	}
+	else {
+		ctx.tp = TASK_CSUMS;
+		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+	}
+
 	ret = check_csums(root);
+	task_stop(ctx.info);
 	/*
 	 * Data csum error is not fatal, and it may indicate more serious
 	 * corruption, continue checking.
@@ -9806,16 +9839,26 @@ int cmd_check(int argc, char **argv)
 		error("errors found in csum tree");
 	err |= !!ret;
 
-	fprintf(stderr, "checking root refs\n");
 	/* For low memory mode, check_fs_roots_v2 handles root refs */
-	if (check_mode != CHECK_MODE_LOWMEM) {
+        if (check_mode != CHECK_MODE_LOWMEM) {
+		if (!ctx.progress_enabled)
+			fprintf(stderr, "[6/7] checking root refs\n");
+		else {
+			ctx.tp = TASK_ROOT_REFS;
+			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+		}
+
 		ret = check_root_refs(root, &root_cache);
+		task_stop(ctx.info);
 		err |= !!ret;
 		if (ret) {
 			error("errors found in root refs");
 			goto out;
 		}
 	}
+	else {
+		fprintf(stderr, "[6/7] checking root refs done with fs roots in lowmem mode, skipping\n");
+	}
 
 	while (repair && !list_empty(&root->fs_info->recow_ebs)) {
 		struct extent_buffer *eb;
@@ -9844,8 +9887,15 @@ int cmd_check(int argc, char **argv)
 	}
 
 	if (info->quota_enabled) {
-		fprintf(stderr, "checking quota groups\n");
+		if (!ctx.progress_enabled)
+			fprintf(stderr, "[7/7] checking quota groups\n");
+		else {
+			ctx.tp = TASK_QGROUPS;
+			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+			qgroup_set_item_count_ptr(&ctx.item_count);
+		}
 		ret = qgroup_verify_all(info);
+		task_stop(ctx.info);
 		err |= !!ret;
 		if (ret) {
 			error("failed to check quota groups");
@@ -9861,6 +9911,8 @@ int cmd_check(int argc, char **argv)
 			err |= qgroup_report_ret;
 		ret = 0;
 	}
+	else
+		fprintf(stderr, "[7/7] checking quota groups skipped (not enabled on this FS)\n");
 
 	if (!list_empty(&root->fs_info->recow_ebs)) {
 		error("transid errors in file system");
diff --git a/check/mode-common.h b/check/mode-common.h
index a474857..a11fa3d 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -38,6 +38,26 @@ struct node_refs {
 	int full_backref[BTRFS_MAX_LEVEL];
 };
 
+enum task_position {
+	TASK_ROOT_ITEMS,
+	TASK_EXTENTS,
+	TASK_FREE_SPACE,
+	TASK_FS_ROOTS,
+	TASK_CSUMS,
+	TASK_ROOT_REFS,
+	TASK_QGROUPS,
+	TASK_NOTHING, /* have to be the last element */
+};
+
+struct task_ctx {
+	int progress_enabled;
+	enum task_position tp;
+	time_t start_time;
+	u64 item_count;
+
+	struct task_info *info;
+};
+
 extern u64 bytes_used;
 extern u64 total_csum_bytes;
 extern u64 total_btree_bytes;
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 66da453..f849e85 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4719,6 +4719,7 @@ static int check_btrfs_root(struct btrfs_root *root, int check_all)
 	}
 
 	while (1) {
+		ctx.item_count++;
 		ret = walk_down_tree(root, &path, &level, &nrefs, check_all);
 
 		if (ret > 0)
diff --git a/convert/main.c b/convert/main.c
index 7077fcb..3736a14 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1182,7 +1182,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 	if (progress) {
 		ctx.info = task_init(print_copied_inodes, after_copied_inodes,
 				     &ctx);
-		task_start(ctx.info);
+		task_start(ctx.info, NULL, NULL);
 	}
 	ret = copy_inodes(&cctx, root, convert_flags, &ctx);
 	if (ret) {
diff --git a/qgroup-verify.c b/qgroup-verify.c
index e2332be..afaabf8 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -34,6 +34,12 @@
 
 #include "qgroup-verify.h"
 
+u64 *qgroup_item_count;
+void qgroup_set_item_count_ptr(u64 *item_count_ptr)
+{
+	qgroup_item_count = item_count_ptr;
+}
+
 /*#define QGROUP_VERIFY_DEBUG*/
 static unsigned long tot_extents_scanned = 0;
 
@@ -735,6 +741,7 @@ static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
 	 */
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
+		(*qgroup_item_count)++;
 		new_bytenr = btrfs_node_blockptr(eb, i);
 		new_num_bytes = info->nodesize;
 
diff --git a/qgroup-verify.h b/qgroup-verify.h
index 14d36bb..20e9370 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -30,4 +30,6 @@ int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
 
 void free_qgroup_counts(void);
 
+void qgroup_set_item_count_ptr(u64 *item_count_ptr);
+
 #endif
diff --git a/task-utils.c b/task-utils.c
index 284cbb3..a9bee8f 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -19,6 +19,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <time.h>
 
 #include "task-utils.h"
 
@@ -37,7 +38,7 @@ struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
 	return info;
 }
 
-int task_start(struct task_info *info)
+int task_start(struct task_info *info, time_t *start_time, u64 *item_count)
 {
 	int ret;
 
@@ -47,6 +48,11 @@ int task_start(struct task_info *info)
 	if (!info->threadfn)
 		return -1;
 
+	if (start_time)
+		*start_time = time(NULL);
+	if (item_count)
+		*item_count = 0;
+
 	ret = pthread_create(&info->id, NULL, info->threadfn,
 			     info->private_data);
 
diff --git a/task-utils.h b/task-utils.h
index 91d5a64..fa9839b 100644
--- a/task-utils.h
+++ b/task-utils.h
@@ -18,6 +18,7 @@
 #define __TASK_UTILS_H__
 
 #include <pthread.h>
+#include "kerncompat.h"
 
 struct periodic_info {
 	int timer_fd;
@@ -35,7 +36,7 @@ struct task_info {
 /* task life cycle */
 struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
 			    void *thread_private);
-int task_start(struct task_info *info);
+int task_start(struct task_info *info, time_t *start_time, u64 *item_count);
 void task_stop(struct task_info *info);
 void task_deinit(struct task_info *info);
 
-- 
2.7.4

