Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42358 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbeHUNnJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 09:43:09 -0400
Received: by mail-pl0-f67.google.com with SMTP id g23-v6so5629005plq.9
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 03:23:34 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: task: add prefn() into struct task_info
Date: Tue, 21 Aug 2018 18:23:10 +0000
Message-Id: <20180821182311.13997-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
References: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

Previously, everytime task_start is called, arguments to be initialized
(start_time and item_count) are passed manually.

For scalability, add a member prefn() to struct task_info.
prefn() will be called before pthread_create() in task_start().

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/main.c   |  3 ++-
 convert/main.c |  4 ++--
 task-utils.c   | 12 +++++++++---
 task-utils.h   |  3 ++-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/check/main.c b/check/main.c
index bc2ee22f7943..087106d199eb 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9628,7 +9628,8 @@ int cmd_check(int argc, char **argv)
 
 	if (ctx.progress_enabled) {
 		ctx.tp = TASK_NOTHING;
-		ctx.info = task_init(print_status_check, print_status_return, &ctx);
+		ctx.info = task_init(print_status_check, NULL,
+				     print_status_return, &ctx);
 	}
 
 	/* This check is the only reason for --readonly to exist */
diff --git a/convert/main.c b/convert/main.c
index 3736a14955d1..ee51390bb072 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1180,8 +1180,8 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 	ctx.cur_copy_inodes = 0;
 
 	if (progress) {
-		ctx.info = task_init(print_copied_inodes, after_copied_inodes,
-				     &ctx);
+		ctx.info = task_init(print_copied_inodes, NULL,
+				     after_copied_inodes, &ctx);
 		task_start(ctx.info, NULL, NULL);
 	}
 	ret = copy_inodes(&cctx, root, convert_flags, &ctx);
diff --git a/task-utils.c b/task-utils.c
index a9bee8f4486d..e837812f57f7 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -23,8 +23,8 @@
 
 #include "task-utils.h"
 
-struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
-			    void *thread_private)
+struct task_info *task_init(void *(*threadfn)(void *), int (*prefn)(void *),
+			    int (*postfn)(void *), void *thread_private)
 {
 	struct task_info *info = calloc(1, sizeof(struct task_info));
 
@@ -33,6 +33,7 @@ struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
 
 	info->private_data = thread_private;
 	info->threadfn = threadfn;
+	info->prefn = prefn;
 	info->postfn = postfn;
 
 	return info;
@@ -53,9 +54,14 @@ int task_start(struct task_info *info, time_t *start_time, u64 *item_count)
 	if (item_count)
 		*item_count = 0;
 
+	if (info->prefn) {
+		ret = info->prefn(info->private_data);
+		if (ret)
+			return ret;
+	}
+
 	ret = pthread_create(&info->id, NULL, info->threadfn,
 			     info->private_data);
-
 	if (ret)
 		info->id = 0;
 
diff --git a/task-utils.h b/task-utils.h
index bbb0f1fd9ff6..06ee87defe24 100644
--- a/task-utils.h
+++ b/task-utils.h
@@ -30,12 +30,13 @@ struct task_info {
 	pthread_t id;
 	void *private_data;
 	void *(*threadfn)(void *);
+	int (*prefn)(void *);
 	int (*postfn)(void *);
 };
 
 /* task life cycle */
 struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
-			    void *thread_private);
+			    int (*pretfn)(void *), void *thread_private);
 int task_start(struct task_info *info, time_t *start_time, u64 *item_count);
 void task_stop(struct task_info *info);
 void task_deinit(struct task_info *info);
-- 
2.17.1
