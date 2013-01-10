Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab3AJMt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:49:57 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0ACntCn022140
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 20:49:55 +0800
Message-ID: <50EEB91A.4030605@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 20:50:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/11] Btrfs: use the inode own lock to protect its delalloc_bytes
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need not use a global lock to protect the delalloc_bytes of the inode, just
use its own lock. In this way, we can reduce the lock contention and
->delalloc_lock will just protect delalloc inode list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/disk-io.c     |  2 ++
 fs/btrfs/inode.c       | 47 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 2a8c242..c935a77 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -40,6 +40,7 @@
 #define BTRFS_INODE_HAS_ASYNC_EXTENT		6
 #define BTRFS_INODE_NEEDS_FULL_SYNC		7
 #define BTRFS_INODE_COPY_EVERYTHING		8
+#define BTRFS_INODE_IN_DELALLOC_LIST		9
 
 /* in memory btrfs inode */
 struct btrfs_inode {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 750afd4..748ce06 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3685,6 +3685,8 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 				    delalloc_inodes);
 
 		list_del_init(&btrfs_inode->delalloc_inodes);
+		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+			  &btrfs_inode->runtime_flags);
 
 		btrfs_invalidate_inodes(btrfs_inode->root);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c29299d..f28ddf1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1508,15 +1508,22 @@ static void btrfs_set_bit_hook(struct inode *inode,
 			spin_unlock(&BTRFS_I(inode)->lock);
 		}
 
-		spin_lock(&root->fs_info->delalloc_lock);
-		BTRFS_I(inode)->delalloc_bytes += len;
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, len,
 				     root->fs_info->delalloc_batch);
-		if (do_list && list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
-			list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
-				      &root->fs_info->delalloc_inodes);
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->delalloc_bytes += len;
+		if (do_list && !test_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+					 &BTRFS_I(inode)->runtime_flags)) {
+			spin_lock(&root->fs_info->delalloc_lock);
+			if (list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
+				list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
+					      &root->fs_info->delalloc_inodes);
+				set_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+					&BTRFS_I(inode)->runtime_flags);
+			}
+			spin_unlock(&root->fs_info->delalloc_lock);
 		}
-		spin_unlock(&root->fs_info->delalloc_lock);
+		spin_unlock(&BTRFS_I(inode)->lock);
 	}
 }
 
@@ -1551,16 +1558,22 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		    && do_list)
 			btrfs_free_reserved_data_space(inode, len);
 
-		spin_lock(&root->fs_info->delalloc_lock);
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, -len,
 				     root->fs_info->delalloc_batch);
+		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->delalloc_bytes -= len;
-
 		if (do_list && BTRFS_I(inode)->delalloc_bytes == 0 &&
-		    !list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
-			list_del_init(&BTRFS_I(inode)->delalloc_inodes);
+		    test_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+			     &BTRFS_I(inode)->runtime_flags)) {
+			spin_lock(&root->fs_info->delalloc_lock);
+			if (!list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
+				list_del_init(&BTRFS_I(inode)->delalloc_inodes);
+				clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+					  &BTRFS_I(inode)->runtime_flags);
+			}
+			spin_unlock(&root->fs_info->delalloc_lock);
 		}
-		spin_unlock(&root->fs_info->delalloc_lock);
+		spin_unlock(&BTRFS_I(inode)->lock);
 	}
 }
 
@@ -7279,14 +7292,19 @@ fail:
 static int btrfs_getattr(struct vfsmount *mnt,
 			 struct dentry *dentry, struct kstat *stat)
 {
+	u64 delalloc_bytes;
 	struct inode *inode = dentry->d_inode;
 	u32 blocksize = inode->i_sb->s_blocksize;
 
 	generic_fillattr(inode, stat);
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
 	stat->blksize = PAGE_CACHE_SIZE;
+
+	spin_lock(&BTRFS_I(inode)->lock);
+	delalloc_bytes = BTRFS_I(inode)->delalloc_bytes;
+	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_get_bytes(inode), blocksize) +
-		ALIGN(BTRFS_I(inode)->delalloc_bytes, blocksize)) >> 9;
+			ALIGN(delalloc_bytes, blocksize)) >> 9;
 	return 0;
 }
 
@@ -7569,8 +7587,11 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 		binode = list_entry(head->next, struct btrfs_inode,
 				    delalloc_inodes);
 		inode = igrab(&binode->vfs_inode);
-		if (!inode)
+		if (!inode) {
 			list_del_init(&binode->delalloc_inodes);
+			clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+				  &binode->runtime_flags);
+		}
 		spin_unlock(&root->fs_info->delalloc_lock);
 		if (inode) {
 			work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
-- 
1.7.11.7
