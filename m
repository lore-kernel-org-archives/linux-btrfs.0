Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51019 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbbKIK5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:41 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9Ave6I014143
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Avemv011975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:40 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AveXY020368
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/15] btrfs: Cleanup num_tolerated_disk_barrier_failures
Date: Mon,  9 Nov 2015 18:56:20 +0800
Message-Id: <1447066589-3835-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

As we use per-chunk degradable check, now the global
num_tolerated_disk_barrier_failures is of no use. So cleanup it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

[Btrfs: resolve conflict to apply 'btrfs: Cleanup num_tolerated_disk_barrier_failures']
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h   |  2 --
 fs/btrfs/disk-io.c | 56 ------------------------------------------------------
 fs/btrfs/disk-io.h |  2 --
 fs/btrfs/volumes.c | 17 -----------------
 4 files changed, 77 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a86051e..dedd3e0 100644
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
index d3303f9..d10ef2e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2965,8 +2965,6 @@ retry_root_backup:
 		printk(KERN_ERR "BTRFS: Failed to read block groups: %d\n", ret);
 		goto fail_sysfs;
 	}
-	fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
@@ -3498,60 +3496,6 @@ int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
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
index adeb318..6dc5fd3 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -142,8 +142,6 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 int btree_lock_page_hook(struct page *page, void *data,
 				void (*flush_fn)(void *));
 int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags);
-int btrfs_calc_num_tolerated_disk_barrier_failures(
-	struct btrfs_fs_info *fs_info);
 int __init btrfs_end_io_wq_init(void);
 void btrfs_end_io_wq_exit(void);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a5262bf..33ad42e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1782,9 +1782,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 		free_fs_devices(cur_devices);
 	}
 
-	root->fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
-
 	/*
 	 * at this point, the device is zero sized.  We want to
 	 * remove it from the devices list and zero out the old super
@@ -2289,8 +2286,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		}
 	}
 
-	root->fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(root->fs_info);
 	ret = btrfs_commit_transaction(trans, root);
 
 	if (seeding_dev) {
@@ -3518,13 +3513,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
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
@@ -3547,11 +3535,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
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
2.4.1

