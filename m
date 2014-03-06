Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaCFFxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:49 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rRfW009842
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 09/10] Btrfs: fix possible empty list access when flushing the delalloc inodes
Date: Thu, 6 Mar 2014 13:55:03 +0800
Message-Id: <1394085304-32589-9-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We didn't have a lock to protect the access to the delalloc inodes list, that is
we might access a empty delalloc inodes list if someone start flushing delalloc
inodes because the delalloc inodes were moved into a other list temporarily.
Fix it by wrapping the access with a lock.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch.
---
 fs/btrfs/ctree.h   | 2 ++
 fs/btrfs/disk-io.c | 2 ++
 fs/btrfs/inode.c   | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7bae97e..ec47aa9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1490,6 +1490,7 @@ struct btrfs_fs_info {
 	 */
 	struct list_head ordered_roots;
 
+	struct mutex delalloc_root_mutex;
 	spinlock_t delalloc_root_lock;
 	/* all fs/file tree roots that have delalloc inodes. */
 	struct list_head delalloc_roots;
@@ -1797,6 +1798,7 @@ struct btrfs_root {
 	spinlock_t root_item_lock;
 	atomic_t refs;
 
+	struct mutex delalloc_mutex;
 	spinlock_t delalloc_lock;
 	/*
 	 * all of the inodes that have delalloc bytes.  It is possible for
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 65fe26e..2bb0bbd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1198,6 +1198,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
 	mutex_init(&root->ordered_extent_mutex);
+	mutex_init(&root->delalloc_mutex);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
@@ -2169,6 +2170,7 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->buffer_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->reloc_mutex);
+	mutex_init(&fs_info->delalloc_root_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 
 	init_completion(&fs_info->kobj_unregister);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f64216..34c484c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8429,6 +8429,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 	INIT_LIST_HEAD(&works);
 	INIT_LIST_HEAD(&splice);
 
+	mutex_lock(&root->delalloc_mutex);
 	spin_lock(&root->delalloc_lock);
 	list_splice_init(&root->delalloc_inodes, &splice);
 	while (!list_empty(&splice)) {
@@ -8474,6 +8475,7 @@ static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput,
 		list_splice_tail(&splice, &root->delalloc_inodes);
 		spin_unlock(&root->delalloc_lock);
 	}
+	mutex_unlock(&root->delalloc_mutex);
 	return ret;
 }
 
@@ -8515,6 +8517,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 
 	INIT_LIST_HEAD(&splice);
 
+	mutex_lock(&fs_info->delalloc_root_mutex);
 	spin_lock(&fs_info->delalloc_root_lock);
 	list_splice_init(&fs_info->delalloc_roots, &splice);
 	while (!list_empty(&splice) && nr) {
@@ -8554,6 +8557,7 @@ out:
 		list_splice_tail(&splice, &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
 	}
+	mutex_unlock(&fs_info->delalloc_root_mutex);
 	return ret;
 }
 
-- 
1.8.1.4

