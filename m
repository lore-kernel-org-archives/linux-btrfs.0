Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1161033Ab2JYJlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 05:41:14 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9P9fCO5031446
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 17:41:12 +0800
Message-ID: <50890950.9080708@cn.fujitsu.com>
Date: Thu, 25 Oct 2012 17:41:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: make ordered extent be flushed by multi-task
References: <5089045D.8050801@cn.fujitsu.com>
In-Reply-To: <5089045D.8050801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Though the process of the ordered extents is a bit different with the delalloc inode
flush, but we can see it as a subset of the delalloc inode flush, so we also handle
them by flush workers.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   41 +++++++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.h |    5 ++++-
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ab2a3c0..eecc20f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -211,6 +211,8 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	init_waitqueue_head(&entry->wait);
 	INIT_LIST_HEAD(&entry->list);
 	INIT_LIST_HEAD(&entry->root_extent_list);
+	INIT_LIST_HEAD(&entry->work_list);
+	init_completion(&entry->completion);
 
 	trace_btrfs_ordered_extent_add(inode, entry);
 
@@ -464,18 +466,28 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	wake_up(&entry->wait);
 }
 
+static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
+{
+	struct btrfs_ordered_extent *ordered;
+
+	ordered = container_of(work, struct btrfs_ordered_extent, flush_work);
+	btrfs_start_ordered_extent(ordered->inode, ordered, 1);
+	complete(&ordered->completion);
+}
+
 /*
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
 void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 {
-	struct list_head splice;
+	struct list_head splice, works;
 	struct list_head *cur;
-	struct btrfs_ordered_extent *ordered;
+	struct btrfs_ordered_extent *ordered, *next;
 	struct inode *inode;
 
 	INIT_LIST_HEAD(&splice);
+	INIT_LIST_HEAD(&works);
 
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_splice_init(&root->fs_info->ordered_extents, &splice);
@@ -494,19 +506,32 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 
 		if (inode) {
-			btrfs_start_ordered_extent(inode, ordered, 1);
-			btrfs_put_ordered_extent(ordered);
-			if (delay_iput)
-				btrfs_add_delayed_iput(inode);
-			else
-				iput(inode);
+			ordered->flush_work.func = btrfs_run_ordered_extent_work;
+			list_add_tail(&ordered->work_list, &works);
+			btrfs_queue_worker(&root->fs_info->flush_workers,
+					   &ordered->flush_work);
 		} else {
 			btrfs_put_ordered_extent(ordered);
 		}
 
+		cond_resched();
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
+
+	list_for_each_entry_safe(ordered, next, &works, work_list) {
+		list_del_init(&ordered->work_list);
+		wait_for_completion(&ordered->completion);
+
+		inode = ordered->inode;
+		btrfs_put_ordered_extent(ordered);
+		if (delay_iput)
+			btrfs_add_delayed_iput(inode);
+		else
+			iput(inode);
+
+		cond_resched();
+	}
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index e8dcec6..efc7c29 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -128,8 +128,11 @@ struct btrfs_ordered_extent {
 	struct list_head root_extent_list;
 
 	struct btrfs_work work;
-};
 
+	struct completion completion;
+	struct btrfs_work flush_work;
+	struct list_head work_list;
+};
 
 /*
  * calculates the total size you need to allocate for an ordered sum
-- 
1.6.5.2

