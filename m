Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:44382 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:15 -0400
Received: by mail-qt0-f194.google.com with SMTP id k38-v6so11283492qtk.11
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:59 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id p5-v6sm4147494qkd.81.2018.08.30.10.42.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:58 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 17/35] btrfs: move the dio_sem higher up the callchain
Date: Thu, 30 Aug 2018 13:42:07 -0400
Message-Id: <20180830174225.2200-18-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're getting a lockdep splat because we take the dio_sem under the
log_mutex.  What we really need is to protect fsync() from logging an
extent map for an extent we never waited on higher up, so just guard the
whole thing with dio_sem.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/file.c     | 12 ++++++++++++
 fs/btrfs/tree-log.c |  2 --
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 095f0bb86bb7..c07110edb9de 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2079,6 +2079,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		goto out;
 
 	inode_lock(inode);
+
+	/*
+	 * We take the dio_sem here because the tree log stuff can race with
+	 * lockless dio writes and get an extent map logged for an extent we
+	 * never waited on.  We need it this high up for lockdep reasons.
+	 */
+	down_write(&BTRFS_I(inode)->dio_sem);
+
 	atomic_inc(&root->log_batch);
 
 	/*
@@ -2087,6 +2095,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	ret = btrfs_wait_ordered_range(inode, start, len);
 	if (ret) {
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2110,6 +2119,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		 * checked called fsync.
 		 */
 		ret = filemap_check_wb_err(inode->i_mapping, file->f_wb_err);
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2128,6 +2138,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
 		goto out;
 	}
@@ -2149,6 +2160,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * file again, but that will end up using the synchronization
 	 * inside btrfs_sync_log to keep things safe.
 	 */
+	up_write(&BTRFS_I(inode)->dio_sem);
 	inode_unlock(inode);
 
 	/*
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1650dc44a5e3..66b7e059b765 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4374,7 +4374,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&extents);
 
-	down_write(&inode->dio_sem);
 	write_lock(&tree->lock);
 	test_gen = root->fs_info->last_trans_committed;
 	logged_start = start;
@@ -4440,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
-	up_write(&inode->dio_sem);
 
 	btrfs_release_path(path);
 	if (!ret)
-- 
2.14.3
