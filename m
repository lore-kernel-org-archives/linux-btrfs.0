Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40489 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbeHUNnN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 09:43:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id e13-v6so8276771pff.7
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 03:23:38 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: task: add init_ctx and clean up arguments of task_start()
Date: Tue, 21 Aug 2018 18:23:11 +0000
Message-Id: <20180821182311.13997-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
References: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

Add a function init_ctx() to initialize time and count of ctx while
checking. Use it as prefn while calling task_init().
Arguments start_time and item_count of task_start() are useless,
remove them.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/main.c   | 26 ++++++++++++++++++--------
 convert/main.c |  2 +-
 task-utils.c   |  7 +------
 task-utils.h   |  2 +-
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/check/main.c b/check/main.c
index 087106d199eb..71baa64168b8 100644
--- a/check/main.c
+++ b/check/main.c
@@ -161,6 +161,16 @@ static int compare_extent_backref(struct rb_node *node1, struct rb_node *node2)
 		return compare_tree_backref(node1, node2);
 }
 
+static int init_ctx(void *p)
+{
+	struct task_ctx *priv = p;
+
+	priv->start_time = time(NULL);
+	priv->item_count = 0;
+
+	return 0;
+}
+
 static void print_status_check_line(void *p)
 {
 	struct task_ctx *priv = p;
@@ -9628,7 +9638,7 @@ int cmd_check(int argc, char **argv)
 
 	if (ctx.progress_enabled) {
 		ctx.tp = TASK_NOTHING;
-		ctx.info = task_init(print_status_check, NULL,
+		ctx.info = task_init(print_status_check, init_ctx,
 				     print_status_return, &ctx);
 	}
 
@@ -9823,7 +9833,7 @@ int cmd_check(int argc, char **argv)
 			fprintf(stderr, "[1/7] checking root items\n");
 		} else {
 			ctx.tp = TASK_ROOT_ITEMS;
-			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+			task_start(ctx.info);
 		}
 		ret = repair_root_items(info);
 		task_stop(ctx.info);
@@ -9853,7 +9863,7 @@ int cmd_check(int argc, char **argv)
 		fprintf(stderr, "[2/7] checking extents\n");
 	} else {
 		ctx.tp = TASK_EXTENTS;
-		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+		task_start(ctx.info);
 	}
 	ret = do_check_chunks_and_extents(info);
 	task_stop(ctx.info);
@@ -9874,7 +9884,7 @@ int cmd_check(int argc, char **argv)
 			fprintf(stderr, "[3/7] checking free space cache\n");
 	} else {
 		ctx.tp = TASK_FREE_SPACE;
-		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+		task_start(ctx.info);
 	}
 
 	ret = check_space_cache(root);
@@ -9899,7 +9909,7 @@ int cmd_check(int argc, char **argv)
 		fprintf(stderr, "[4/7] checking fs roots\n");
 	} else {
 		ctx.tp = TASK_FS_ROOTS;
-		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+		task_start(ctx.info);
 	}
 
 	ret = do_check_fs_roots(info, &root_cache);
@@ -9918,7 +9928,7 @@ int cmd_check(int argc, char **argv)
 		"[5/7] checking only csums items (without verifying data)\n");
 	} else {
 		ctx.tp = TASK_CSUMS;
-		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+		task_start(ctx.info);
 	}
 
 	ret = check_csums(root);
@@ -9937,7 +9947,7 @@ int cmd_check(int argc, char **argv)
 			fprintf(stderr, "[6/7] checking root refs\n");
 		} else {
 			ctx.tp = TASK_ROOT_REFS;
-			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+			task_start(ctx.info);
 		}
 
 		ret = check_root_refs(root, &root_cache);
@@ -9984,7 +9994,7 @@ int cmd_check(int argc, char **argv)
 			fprintf(stderr, "[7/7] checking quota groups\n");
 		} else {
 			ctx.tp = TASK_QGROUPS;
-			task_start(ctx.info, &ctx.start_time, &ctx.item_count);
+			task_start(ctx.info);
 		}
 		ret = qgroup_verify_all(info);
 		task_stop(ctx.info);
diff --git a/convert/main.c b/convert/main.c
index ee51390bb072..e4152a5741f5 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1182,7 +1182,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 	if (progress) {
 		ctx.info = task_init(print_copied_inodes, NULL,
 				     after_copied_inodes, &ctx);
-		task_start(ctx.info, NULL, NULL);
+		task_start(ctx.info);
 	}
 	ret = copy_inodes(&cctx, root, convert_flags, &ctx);
 	if (ret) {
diff --git a/task-utils.c b/task-utils.c
index e837812f57f7..74d21e8b1ead 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -39,7 +39,7 @@ struct task_info *task_init(void *(*threadfn)(void *), int (*prefn)(void *),
 	return info;
 }
 
-int task_start(struct task_info *info, time_t *start_time, u64 *item_count)
+int task_start(struct task_info *info)
 {
 	int ret;
 
@@ -49,11 +49,6 @@ int task_start(struct task_info *info, time_t *start_time, u64 *item_count)
 	if (!info->threadfn)
 		return -1;
 
-	if (start_time)
-		*start_time = time(NULL);
-	if (item_count)
-		*item_count = 0;
-
 	if (info->prefn) {
 		ret = info->prefn(info->private_data);
 		if (ret)
diff --git a/task-utils.h b/task-utils.h
index 06ee87defe24..c0673d2a94bf 100644
--- a/task-utils.h
+++ b/task-utils.h
@@ -37,7 +37,7 @@ struct task_info {
 /* task life cycle */
 struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
 			    int (*pretfn)(void *), void *thread_private);
-int task_start(struct task_info *info, time_t *start_time, u64 *item_count);
+int task_start(struct task_info *info);
 void task_stop(struct task_info *info);
 void task_deinit(struct task_info *info);
 
-- 
2.17.1
