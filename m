Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755853AbbIUCMx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:12:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8L2CWbT003288
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 10:12:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs: Cleanup num_tolerated_disk_barrier_failures
Date: Mon, 21 Sep 2015 10:10:43 +0800
Message-ID: <1442801443-5132-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we use per-chunk degradable check, now the global
num_tolerated_disk_barrier_failures is of no use.

So cleanup it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |  2 --
 fs/btrfs/disk-io.c | 56 ------------------------------------------------------
 fs/btrfs/disk-io.h |  2 --
 fs/btrfs/volumes.c | 17 -----------------
 4 files changed, 77 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..3a4d779 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1753,8 +1753,6 @@ struct btrfs_fs_info {
 	/* next backup root to be overwritten */
 	int backup_root_index;
 
-	int num_tolerated_disk_barrier_failures;
-
 	/* device replace state */
 	struct btrfs_dev_replace dev_replace;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cd94e7..93304cb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2955,8 +2955,6 @@ retry_root_backup:
 		printk(KERN_ERR "BTRFS: Failed to read block groups: %d\n", ret);
 		goto fail_sysfs;
 	}
-	fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
@@ -3459,60 +3457,6 @@ int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
 	return 0;
 }
 
-int btrfs_calc_num_tolerated_disk_barrier_failures(
-	struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_ioctl_space_info space;
-	struct btrfs_space_info *sinfo;
-	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
-		       BTRFS_BLOCK_GROUP_SYSTEM,
-		       BTRFS_BLOCK_GROUP_METADATA,
-		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA};
-	int i;
-	int c;
-	int num_tolerated_disk_barrier_failures =
-		(int)fs_info->fs_devices->num_devices;
-
-	for (i = 0; i < ARRAY_SIZE(types); i++) {
-		struct btrfs_space_info *tmp;
-
-		sinfo = NULL;
-		rcu_read_lock();
-		list_for_each_entry_rcu(tmp, &fs_info->space_info, list) {
-			if (tmp->flags == types[i]) {
-				sinfo = tmp;
-				break;
-			}
-		}
-		rcu_read_unlock();
-
-		if (!sinfo)
-			continue;
-
-		down_read(&sinfo->groups_sem);
-		for (c = 0; c < BTRFS_NR_RAID_TYPES; c++) {
-			u64 flags;
-
-			if (list_empty(&sinfo->block_groups[c]))
-				continue;
-
-			btrfs_get_block_group_info(&sinfo->block_groups[c],
-						   &space);
-			if (space.total_bytes == 0 || space.used_bytes == 0)
-				continue;
-			flags = space.flags;
-
-			num_tolerated_disk_barrier_failures = min(
-				num_tolerated_disk_barrier_failures,
-				btrfs_get_num_tolerated_disk_barrier_failures(
-					flags));
-		}
-		up_read(&sinfo->groups_sem);
-	}
-
-	return num_tolerated_disk_barrier_failures;
-}
-
 static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 {
 	struct list_head *head;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index bdfb479..487fd4a0 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -140,8 +140,6 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 int btree_lock_page_hook(struct page *page, void *data,
 				void (*flush_fn)(void *));
 int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags);
-int btrfs_calc_num_tolerated_disk_barrier_failures(
-	struct btrfs_fs_info *fs_info);
 int __init btrfs_end_io_wq_init(void);
 void btrfs_end_io_wq_exit(void);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 88266fa..6bda203 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1825,9 +1825,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		free_fs_devices(cur_devices);
 	}
 
-	root->fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
-
 	/*
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
@@ -2355,8 +2352,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 			pr_warn("BTRFS: sysfs: failed to create fsid for sprout\n");
 	}
 
-	root->fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
 	ret = btrfs_commit_transaction(trans, root);
 
 	if (seeding_dev) {
@@ -3584,13 +3579,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
-	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-		fs_info->num_tolerated_disk_barrier_failures = min(
-			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
-			btrfs_get_num_tolerated_disk_barrier_failures(
-				bctl->sys.target));
-	}
-
 	ret = insert_balance_item(fs_info->tree_root, bctl);
 	if (ret && ret != -EEXIST)
 		goto out;
@@ -3613,11 +3601,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	mutex_lock(&fs_info->balance_mutex);
 	atomic_dec(&fs_info->balance_running);
 
-	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-		fs_info->num_tolerated_disk_barrier_failures =
-			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
-	}
-
 	if (bargs) {
 		memset(bargs, 0, sizeof(*bargs));
 		update_ioctl_balance_args(fs_info, 0, bargs);
-- 
2.5.2

