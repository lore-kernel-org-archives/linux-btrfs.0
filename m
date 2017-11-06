Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49889 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753350AbdKFSZ4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 13:25:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B98D1AC9D
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 18:25:54 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: switch uuid tree semaphore to mutex
Date: Mon,  6 Nov 2017 19:24:02 +0100
Message-Id: <20171106182402.11500-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The uuid_tree_rescan_sem is used as a mutex (initialized with value 1
and with at most one active user), no reason to obscure that as a
semaphore.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   |  6 +++++-
 fs/btrfs/disk-io.c |  6 +++---
 fs/btrfs/super.c   |  4 ++--
 fs/btrfs/volumes.c | 12 ++++++------
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cab2f3607040..a643ff0fa0f0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1073,7 +1073,11 @@ struct btrfs_fs_info {
 	struct percpu_counter bio_counter;
 	wait_queue_head_t replace_wait;
 
-	struct semaphore uuid_tree_rescan_sem;
+	/*
+	 * Protect updating of uuid_tree, can be used to wait for the task
+	 * completion
+	 */
+	struct mutex uuid_tree_mutex;
 
 	/* Used to reclaim the metadata space in the background. */
 	struct work_struct async_reclaim_work;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 53c9145a56e9..8330226234f2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2542,10 +2542,10 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
 	mutex_init(&fs_info->ro_block_group_mutex);
+	mutex_init(&fs_info->uuid_tree_mutex);
 	init_rwsem(&fs_info->commit_root_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
-	sema_init(&fs_info->uuid_tree_rescan_sem, 1);
 
 	btrfs_init_dev_replace_locks(fs_info);
 	btrfs_init_qgroup(fs_info);
@@ -3696,9 +3696,9 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
 	/* wait for the uuid_scan task to finish */
-	down(&fs_info->uuid_tree_rescan_sem);
+	mutex_lock(&fs_info->uuid_tree_mutex);
 	/* avoid complains from lockdep et al., set sem back to initial state */
-	up(&fs_info->uuid_tree_rescan_sem);
+	mutex_unlock(&fs_info->uuid_tree_mutex);
 
 	/* pause restriper - we want to resume on mount */
 	btrfs_pause_balance(fs_info);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 713f899bae81..5d0686c18bad 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1777,9 +1777,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		cancel_work_sync(&fs_info->async_reclaim_work);
 
 		/* wait for the uuid_scan task to finish */
-		down(&fs_info->uuid_tree_rescan_sem);
+		mutex_lock(&fs_info->uuid_tree_mutex);
 		/* avoid complains from lockdep et al. */
-		up(&fs_info->uuid_tree_rescan_sem);
+		mutex_unlock(&fs_info->uuid_tree_mutex);
 
 		sb->s_flags |= MS_RDONLY;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1b43f762906f..b2949232ba52 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4202,7 +4202,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 		btrfs_warn(fs_info, "btrfs_uuid_scan_kthread failed %d", ret);
 	else
 		set_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags);
-	up(&fs_info->uuid_tree_rescan_sem);
+	mutex_unlock(&fs_info->uuid_tree_mutex);
 	return 0;
 }
 
@@ -4264,7 +4264,7 @@ static int btrfs_uuid_rescan_kthread(void *data)
 	ret = btrfs_uuid_tree_iterate(fs_info, btrfs_check_uuid_tree_entry);
 	if (ret < 0) {
 		btrfs_warn(fs_info, "iterating uuid_tree failed %d", ret);
-		up(&fs_info->uuid_tree_rescan_sem);
+		mutex_unlock(&fs_info->uuid_tree_mutex);
 		return ret;
 	}
 	return btrfs_uuid_scan_kthread(data);
@@ -4301,12 +4301,12 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	if (ret)
 		return ret;
 
-	down(&fs_info->uuid_tree_rescan_sem);
+	mutex_lock(&fs_info->uuid_tree_mutex);
 	task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
 	if (IS_ERR(task)) {
 		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
 		btrfs_warn(fs_info, "failed to start uuid_scan task");
-		up(&fs_info->uuid_tree_rescan_sem);
+		mutex_unlock(&fs_info->uuid_tree_mutex);
 		return PTR_ERR(task);
 	}
 
@@ -4317,12 +4317,12 @@ int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info)
 {
 	struct task_struct *task;
 
-	down(&fs_info->uuid_tree_rescan_sem);
+	mutex_lock(&fs_info->uuid_tree_mutex);
 	task = kthread_run(btrfs_uuid_rescan_kthread, fs_info, "btrfs-uuid");
 	if (IS_ERR(task)) {
 		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
 		btrfs_warn(fs_info, "failed to start uuid_rescan task");
-		up(&fs_info->uuid_tree_rescan_sem);
+		mutex_unlock(&fs_info->uuid_tree_mutex);
 		return PTR_ERR(task);
 	}
 
-- 
2.14.3

