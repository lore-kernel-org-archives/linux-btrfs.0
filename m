Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33544 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbbJMQNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 12:13:35 -0400
Received: by pabrc13 with SMTP id rc13so25568481pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 09:13:34 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id eg5sm4712242pac.30.2015.10.13.09.13.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Oct 2015 09:13:34 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: compress: put variables defined per compress type in struct to make cache friendly
Date: Wed, 14 Oct 2015 01:13:26 +0900
Message-Id: <1444752806-3549-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Below variables are defined per compress type.
 - struct list_head comp_idle_workspace[BTRFS_COMPRESS_TYPES]
 - spinlock_t comp_workspace_lock[BTRFS_COMPRESS_TYPES]
 - int comp_num_workspace[BTRFS_COMPRESS_TYPES]
 - atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES]
 - wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES]

BTW, while accessing one compress type of these variables, the next or
before address is other compress types of it.
So this patch puts these variables in a struct to make cache friendly.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 fs/btrfs/compression.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ce62324c78e7..85a80931ae3f 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -744,11 +744,13 @@ out:
 	return ret;
 }
 
-static struct list_head comp_idle_workspace[BTRFS_COMPRESS_TYPES];
-static spinlock_t comp_workspace_lock[BTRFS_COMPRESS_TYPES];
-static int comp_num_workspace[BTRFS_COMPRESS_TYPES];
-static atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES];
-static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
+static struct {
+	struct list_head idle_workspace;
+	spinlock_t workspace_lock;
+	int num_workspace;
+	atomic_t alloc_workspace;
+	wait_queue_head_t workspace_wait;
+} comp[BTRFS_COMPRESS_TYPES];
 
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
@@ -760,10 +762,10 @@ void __init btrfs_init_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		INIT_LIST_HEAD(&comp_idle_workspace[i]);
-		spin_lock_init(&comp_workspace_lock[i]);
-		atomic_set(&comp_alloc_workspace[i], 0);
-		init_waitqueue_head(&comp_workspace_wait[i]);
+		INIT_LIST_HEAD(&comp[i].idle_workspace);
+		spin_lock_init(&comp[i].workspace_lock);
+		atomic_set(&comp[i].alloc_workspace, 0);
+		init_waitqueue_head(&comp[i].workspace_wait);
 	}
 }
 
@@ -777,11 +779,11 @@ static struct list_head *find_workspace(int type)
 	int cpus = num_online_cpus();
 	int idx = type - 1;
 
-	struct list_head *idle_workspace	= &comp_idle_workspace[idx];
-	spinlock_t *workspace_lock		= &comp_workspace_lock[idx];
-	atomic_t *alloc_workspace		= &comp_alloc_workspace[idx];
-	wait_queue_head_t *workspace_wait	= &comp_workspace_wait[idx];
-	int *num_workspace			= &comp_num_workspace[idx];
+	struct list_head *idle_workspace	= &comp[idx].idle_workspace;
+	spinlock_t *workspace_lock		= &comp[idx].workspace_lock;
+	atomic_t *alloc_workspace		= &comp[idx].alloc_workspace;
+	wait_queue_head_t *workspace_wait	= &comp[idx].workspace_wait;
+	int *num_workspace			= &comp[idx].num_workspace;
 again:
 	spin_lock(workspace_lock);
 	if (!list_empty(idle_workspace)) {
@@ -820,11 +822,11 @@ again:
 static void free_workspace(int type, struct list_head *workspace)
 {
 	int idx = type - 1;
-	struct list_head *idle_workspace	= &comp_idle_workspace[idx];
-	spinlock_t *workspace_lock		= &comp_workspace_lock[idx];
-	atomic_t *alloc_workspace		= &comp_alloc_workspace[idx];
-	wait_queue_head_t *workspace_wait	= &comp_workspace_wait[idx];
-	int *num_workspace			= &comp_num_workspace[idx];
+	struct list_head *idle_workspace	= &comp[idx].idle_workspace;
+	spinlock_t *workspace_lock		= &comp[idx].workspace_lock;
+	atomic_t *alloc_workspace		= &comp[idx].alloc_workspace;
+	wait_queue_head_t *workspace_wait	= &comp[idx].workspace_wait;
+	int *num_workspace			= &comp[idx].num_workspace;
 
 	spin_lock(workspace_lock);
 	if (*num_workspace < num_online_cpus()) {
@@ -852,11 +854,11 @@ static void free_workspaces(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		while (!list_empty(&comp_idle_workspace[i])) {
-			workspace = comp_idle_workspace[i].next;
+		while (!list_empty(&comp[i].idle_workspace)) {
+			workspace = comp[i].idle_workspace.next;
 			list_del(workspace);
 			btrfs_compress_op[i]->free_workspace(workspace);
-			atomic_dec(&comp_alloc_workspace[i]);
+			atomic_dec(&comp[i].alloc_workspace);
 		}
 	}
 }
-- 
2.6.1

