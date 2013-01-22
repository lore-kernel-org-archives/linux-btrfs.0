Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8976 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3AVKsX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 05:48:23 -0500
Message-ID: <50FE6E9C.2040803@cn.fujitsu.com>
Date: Tue, 22 Jan 2013 18:49:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_start_delalloc_inodes() locks the delalloc_inodes list, fetches the
first inode, unlocks the list, triggers btrfs_alloc_delalloc_work/
btrfs_queue_worker for this inode, and then it locks the list, checks the
head of the list again. But because we don't delete the first inode that it
deals with before, it will fetch the same inode. As a result, this function
allocates a huge amount of btrfs_delalloc_work structures, and OOM happens.

Fix this problem by splice this delalloc list.

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   55 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 67ed24a..86f1d25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7545,41 +7545,61 @@ void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work)
  */
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 {
-	struct list_head *head = &root->fs_info->delalloc_inodes;
 	struct btrfs_inode *binode;
 	struct inode *inode;
 	struct btrfs_delalloc_work *work, *next;
 	struct list_head works;
+	struct list_head splice;
 	int ret = 0;
 
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
 	INIT_LIST_HEAD(&works);
-
+	INIT_LIST_HEAD(&splice);
+again:
 	spin_lock(&root->fs_info->delalloc_lock);
-	while (!list_empty(head)) {
-		binode = list_entry(head->next, struct btrfs_inode,
+	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
+	while (!list_empty(&splice)) {
+		binode = list_entry(splice.next, struct btrfs_inode,
 				    delalloc_inodes);
+
+		list_del_init(&binode->delalloc_inodes);
+
 		inode = igrab(&binode->vfs_inode);
 		if (!inode)
-			list_del_init(&binode->delalloc_inodes);
+			continue;
+
+		list_add_tail(&binode->delalloc_inodes,
+			      &root->fs_info->delalloc_inodes);
 		spin_unlock(&root->fs_info->delalloc_lock);
-		if (inode) {
-			work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
-			if (!work) {
-				ret = -ENOMEM;
-				goto out;
-			}
-			list_add_tail(&work->list, &works);
-			btrfs_queue_worker(&root->fs_info->flush_workers,
-					   &work->work);
+
+		work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
+		if (unlikely(!work)) {
+			ret = -ENOMEM;
+			goto out;
 		}
+		list_add_tail(&work->list, &works);
+		btrfs_queue_worker(&root->fs_info->flush_workers,
+				   &work->work);
+
 		cond_resched();
 		spin_lock(&root->fs_info->delalloc_lock);
 	}
 	spin_unlock(&root->fs_info->delalloc_lock);
 
+	list_for_each_entry_safe(work, next, &works, list) {
+		list_del_init(&work->list);
+		btrfs_wait_and_free_delalloc_work(work);
+	}
+
+	spin_lock(&root->fs_info->delalloc_lock);
+	if (!list_empty(&root->fs_info->delalloc_inodes)) {
+		spin_unlock(&root->fs_info->delalloc_lock);
+		goto again;
+	}
+	spin_unlock(&root->fs_info->delalloc_lock);
+
 	/* the filemap_flush will queue IO into the worker threads, but
 	 * we have to make sure the IO is actually started and that
 	 * ordered extents get created before we return
@@ -7592,11 +7612,18 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 		    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
 	}
 	atomic_dec(&root->fs_info->async_submit_draining);
+	return 0;
 out:
 	list_for_each_entry_safe(work, next, &works, list) {
 		list_del_init(&work->list);
 		btrfs_wait_and_free_delalloc_work(work);
 	}
+
+	if (!list_empty_careful(&splice)) {
+		spin_lock(&root->fs_info->delalloc_lock);
+		list_splice_tail(&splice, &root->fs_info->delalloc_inodes);
+		spin_unlock(&root->fs_info->delalloc_lock);
+	}
 	return ret;
 }
 
-- 
1.6.5.2
