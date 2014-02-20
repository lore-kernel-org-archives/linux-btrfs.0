Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbaBTKHj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 05:07:39 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1KA7XQd011821
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 18:07:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] Btrfs: use signed integer instead of unsigned long integer for log transid
Date: Thu, 20 Feb 2014 18:08:56 +0800
Message-Id: <1392890939-19044-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The log trans id is initialized to be 0 every time we create a log tree,
and the log tree need be re-created after a new transaction is started,
it means the log trans id is unlikely to be a huge number, so we can use
signed integer instead of unsigned long integer to save a bit space.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h | 14 +++++++-------
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/tree-log.c    |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 8fed212..c9a2444 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -109,14 +109,17 @@ struct btrfs_inode {
 	u64 last_trans;
 
 	/*
-	 * log transid when this inode was last modified
+	 * transid that last logged this inode
 	 */
-	u64 last_sub_trans;
+	u64 logged_trans;
 
 	/*
-	 * transid that last logged this inode
+	 * log transid when this inode was last modified
 	 */
-	u64 logged_trans;
+	int last_sub_trans;
+
+	/* a local copy of root's last_log_commit */
+	int last_log_commit;
 
 	/* total number of bytes pending delalloc, used by stat to calc the
 	 * real block usage of the file
@@ -155,9 +158,6 @@ struct btrfs_inode {
 	/* flags field from the on disk inode */
 	u32 flags;
 
-	/* a local copy of root's last_log_commit */
-	unsigned long last_log_commit;
-
 	/*
 	 * Counters to keep track of the number of extent item's we may use due
 	 * to delalloc and such.  outstanding_extents is the number of extent
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c45a10a..76b6bff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1742,8 +1742,8 @@ struct btrfs_root {
 	atomic_t log_writers;
 	atomic_t log_commit[2];
 	atomic_t log_batch;
-	unsigned long log_transid;
-	unsigned long last_log_commit;
+	int log_transid;
+	int last_log_commit;
 	pid_t log_start_pid;
 
 	u64 objectid;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c9f2479..c27e2c9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2362,7 +2362,7 @@ static int update_log_root(struct btrfs_trans_handle *trans,
 }
 
 static int wait_log_commit(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, unsigned long transid)
+			   struct btrfs_root *root, int transid)
 {
 	DEFINE_WAIT(wait);
 	int index = transid % 2;
@@ -2434,7 +2434,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = root->fs_info->log_root_tree;
-	unsigned long log_transid = 0;
+	int log_transid = 0;
 	struct blk_plug plug;
 
 	mutex_lock(&root->log_mutex);
-- 
1.8.1.4

