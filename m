Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52461 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751581AbdF1Fns (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 01:43:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <ahferroin7@gmail.com>, <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v4 5/6] btrfs: Cleanup num_tolerated_disk_barrier_failures
Date: Wed, 28 Jun 2017 13:43:34 +0800
Message-ID: <20170628054335.18806-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
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
 fs/btrfs/disk-io.c | 54 ------------------------------------------------------
 fs/btrfs/disk-io.h |  2 --
 fs/btrfs/volumes.c | 17 -----------------
 4 files changed, 75 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5bdd36664421..99c55580ddeb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1072,8 +1072,6 @@ struct btrfs_fs_info {
 	/* next backup root to be overwritten */
 	int backup_root_index;
 
-	int num_tolerated_disk_barrier_failures;
-
 	/* device replace state */
 	struct btrfs_dev_replace dev_replace;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7ec766d8510f..1a2e0b43ef2a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3610,60 +3610,6 @@ int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
 	return min_tolerated;
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
 int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 {
 	struct list_head *head;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4654d129aa76..6c39d969c84e 100644
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
index 7a72fbdb8262..2cc68c74f701 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1987,9 +1987,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		free_fs_devices(cur_devices);
 	}
 
-	fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
-
 out:
 	mutex_unlock(&uuid_mutex);
 	return ret;
@@ -2487,8 +2484,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				   "sysfs: failed to create fsid for sprout");
 	}
 
-	fs_info->num_tolerated_disk_barrier_failures =
-		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
 	ret = btrfs_commit_transaction(trans);
 
 	if (seeding_dev) {
@@ -3898,13 +3893,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 			   meta_target, data_target);
 	}
 
-	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-		fs_info->num_tolerated_disk_barrier_failures = min(
-			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
-			btrfs_get_num_tolerated_disk_barrier_failures(
-				bctl->sys.target));
-	}
-
 	ret = insert_balance_item(fs_info, bctl);
 	if (ret && ret != -EEXIST)
 		goto out;
@@ -3927,11 +3915,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
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
2.13.1



