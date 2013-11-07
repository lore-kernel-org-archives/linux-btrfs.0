Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65474 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab3KGFvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:22 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pFI5008344
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 08/17] btrfs: Replace fs_info->flush_workers with btrfs_workqueue.
Date: Thu, 7 Nov 2013 13:51:58 +0800
Message-Id: <1383803527-23736-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace the fs_info->submit_workers with the newly created btrfs_workqueue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v1->v2:
  None
v2->v3:
  - Use the btrfs_workqueue_struct to replace submit_workers.
---
 fs/btrfs/ctree.h        |  4 ++--
 fs/btrfs/disk-io.c      | 10 +++++-----
 fs/btrfs/inode.c        |  7 ++++---
 fs/btrfs/ordered-data.c | 13 +++++++------
 fs/btrfs/ordered-data.h |  2 +-
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3edb9e6..c74f27e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1485,7 +1485,7 @@ struct btrfs_fs_info {
 	struct btrfs_workers generic_worker;
 	struct btrfs_workqueue_struct *workers;
 	struct btrfs_workqueue_struct *delalloc_workers;
-	struct btrfs_workers flush_workers;
+	struct btrfs_workqueue_struct *flush_workers;
 	struct btrfs_workers endio_workers;
 	struct btrfs_workers endio_meta_workers;
 	struct btrfs_workers endio_raid56_workers;
@@ -3625,7 +3625,7 @@ struct btrfs_delalloc_work {
 	int delay_iput;
 	struct completion completion;
 	struct list_head list;
-	struct btrfs_work work;
+	struct btrfs_work_struct work;
 };
 
 struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ec474c8..3e4adff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2007,7 +2007,7 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_stop_workers(&fs_info->delayed_workers);
 	btrfs_stop_workers(&fs_info->caching_workers);
 	btrfs_stop_workers(&fs_info->readahead_workers);
-	btrfs_stop_workers(&fs_info->flush_workers);
+	btrfs_destroy_workqueue(fs_info->flush_workers);
 	btrfs_stop_workers(&fs_info->qgroup_rescan_workers);
 }
 
@@ -2490,8 +2490,9 @@ int open_ctree(struct super_block *sb,
 							  NULL, flags,
 							  max_active, 2);
 
-	btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
-			   fs_info->thread_pool_size, NULL);
+	fs_info->flush_workers = btrfs_alloc_workqueue("flush_delalloc",
+							NULL, NULL, flags,
+							max_active, 0);
 
 	/* a higher idle thresh on the submit workers makes it much more
 	 * likely that bios will be send down in a sane order to the
@@ -2566,14 +2567,13 @@ int open_ctree(struct super_block *sb,
 	ret |= btrfs_start_workers(&fs_info->delayed_workers);
 	ret |= btrfs_start_workers(&fs_info->caching_workers);
 	ret |= btrfs_start_workers(&fs_info->readahead_workers);
-	ret |= btrfs_start_workers(&fs_info->flush_workers);
 	ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
 	if (ret) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
 	if (!(fs_info->workers && fs_info->delalloc_workers &&
-	      fs_info->submit_workers)) {
+	      fs_info->submit_workers && fs_info->flush_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 42e3f81..5e5fc7f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8138,7 +8138,7 @@ out_notrans:
 	return ret;
 }
 
-static void btrfs_run_delalloc_work(struct btrfs_work *work)
+static void btrfs_run_delalloc_work(struct btrfs_work_struct *work)
 {
 	struct btrfs_delalloc_work *delalloc_work;
 
@@ -8170,6 +8170,7 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
 	work->inode = inode;
 	work->wait = wait;
 	work->delay_iput = delay_iput;
+	btrfs_init_work(&work->work, btrfs_run_delalloc_work, NULL, NULL);
 	work->work.func = btrfs_run_delalloc_work;
 
 	return work;
@@ -8222,8 +8223,8 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 			goto out;
 		}
 		list_add_tail(&work->list, &works);
-		btrfs_queue_worker(&root->fs_info->flush_workers,
-				   &work->work);
+		btrfs_queue_work(root->fs_info->flush_workers,
+				 &work->work);
 
 		cond_resched();
 		spin_lock(&root->delalloc_lock);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c702cb6..08b30e5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -550,7 +550,7 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	wake_up(&entry->wait);
 }
 
-static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
+static void btrfs_run_ordered_extent_work(struct btrfs_work_struct *work)
 {
 	struct btrfs_ordered_extent *ordered;
 
@@ -582,10 +582,11 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root)
 		atomic_inc(&ordered->refs);
 		spin_unlock(&root->ordered_extent_lock);
 
-		ordered->flush_work.func = btrfs_run_ordered_extent_work;
+		btrfs_init_work(&ordered->flush_work,
+				btrfs_run_ordered_extent_work, NULL, NULL);
 		list_add_tail(&ordered->work_list, &works);
-		btrfs_queue_worker(&root->fs_info->flush_workers,
-				   &ordered->flush_work);
+		btrfs_queue_work(root->fs_info->flush_workers,
+				 &ordered->flush_work);
 
 		cond_resched();
 		spin_lock(&root->ordered_extent_lock);
@@ -686,8 +687,8 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 		list_add_tail(&work->list, &works);
-		btrfs_queue_worker(&root->fs_info->flush_workers,
-				   &work->work);
+		btrfs_queue_work(root->fs_info->flush_workers,
+				 &work->work);
 
 		cond_resched();
 		spin_lock(&root->fs_info->ordered_root_lock);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 0c0b356..7496866 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -133,7 +133,7 @@ struct btrfs_ordered_extent {
 	struct btrfs_work work;
 
 	struct completion completion;
-	struct btrfs_work flush_work;
+	struct btrfs_work_struct flush_work;
 	struct list_head work_list;
 };
 
-- 
1.8.4.2

