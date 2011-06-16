From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: fix 'ls -lis' mismatch
Date: Thu, 16 Jun 2011 17:41:11 +0800
Message-ID: <1308217271-13259-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1308217271-13259-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <t-itoh@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308217271-13259-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

As btrfs uses delay allocation mechanism and data=order mode, there can be
a period window, during which we sub delalloc_bytes and add_inode_bytes,
and we may get a value of '0' referred to inode's blocks via 'ls -lis'.

ino:291 blocks:198656 i_blocks:0 i_bytes:0 delalloc_bytes:101711872
ino:291 blocks:198656 i_blocks:0 i_bytes:0 delalloc_bytes:101711872
                                                       <---------
ino:291 blocks:0 i_blocks:0 i_bytes:0 delalloc_bytes:0 |  THE
ino:291 blocks:0 i_blocks:0 i_bytes:0 delalloc_bytes:0 |  WINDOW
                                                       <---------
ino:291 blocks:819200 i_blocks:819200 i_bytes:0 delalloc_bytes:0

This may make btrfs's users confused.

Hence, we use anther counter for the number of delalloc bytes in flight
that are accounted for in coordination with inode_add_bytes to ensure
correct output results.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    8 ++++++--
 fs/btrfs/inode.c       |   15 ++++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 31337df..1e0dc82 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -93,9 +93,13 @@ struct btrfs_inode {
 	 */
 	u64 logged_trans;
 
-	/* total number of bytes pending delalloc, used by stat to calc the
-	 * real block usage of the file
+	/*
+	 * total number of bytes pending delalloc, used by stat to
+	 * calc the real block usage of the file.
 	 */
+	u64 pending_bytes;
+
+	/* total number of bytes pending delalloc */
 	u64 delalloc_bytes;
 
 	/* total number of bytes that may be used for this inode for
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e01a084..70bd01d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -106,6 +106,13 @@ static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 	return err;
 }
 
+static void btrfs_inode_add_bytes(struct inode *inode, loff_t bytes)
+{
+	if (BTRFS_I(inode)->pending_bytes >= bytes)
+		BTRFS_I(inode)->pending_bytes -= bytes;
+	inode_add_bytes(inode, bytes);
+}
+
 /*
  * this does all the hard work for inserting an inline extent into
  * the btree.  The caller should have done a btrfs_drop_extents so that
@@ -144,7 +151,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
 	datasize = btrfs_file_extent_calc_inline_size(cur_size);
 
-	inode_add_bytes(inode, size);
+	btrfs_inode_add_bytes(inode, size);
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      datasize);
 	BUG_ON(ret);
@@ -1346,6 +1353,7 @@ static int btrfs_set_bit_hook(struct inode *inode,
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
+		BTRFS_I(inode)->pending_bytes += len;
 		root->fs_info->delalloc_bytes += len;
 		if (do_list && list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
 			list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
@@ -1685,7 +1693,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_mark_buffer_dirty(leaf);
 
-	inode_add_bytes(inode, num_bytes);
+	btrfs_inode_add_bytes(inode, num_bytes);
 
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
@@ -6726,6 +6734,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->last_trans = 0;
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
+	ei->pending_bytes = 0;
 	ei->delalloc_bytes = 0;
 	ei->reserved_bytes = 0;
 	ei->disk_i_size = 0;
@@ -6901,7 +6910,7 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	stat->dev = BTRFS_I(inode)->root->anon_super.s_dev;
 	stat->blksize = PAGE_CACHE_SIZE;
 	stat->blocks = (inode_get_bytes(inode) +
-			BTRFS_I(inode)->delalloc_bytes) >> 9;
+			BTRFS_I(inode)->pending_bytes) >> 9;
 	return 0;
 }
 
-- 
1.6.5.2

