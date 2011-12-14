From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: fix wrong i_size when truncating a file to a larger
 size
Date: Wed, 14 Dec 2011 15:15:53 +0800
Message-ID: <4EE84D29.5070601@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfsck report error 100 after the 83th case of xfstests was run, it means
the i_size of the file is wrong.

The reason of this bug is that:
Btrfs increased i_size of the file at the beginning, but it failed to expand
the file, and failed to update the i_size to the old size because there is no
enough space in the file system, so we found a wrong i_size.

This patch fixes this bug by updating the i_size just when we pass the file
expanding and get enough space to update i-node.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 960818b..f1c4bce 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3373,6 +3373,8 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 static int btrfs_setsize(struct inode *inode, loff_t newsize)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
 	loff_t oldsize = i_size_read(inode);
 	int ret;
 
@@ -3380,16 +3382,20 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 		return 0;
 
 	if (newsize > oldsize) {
-		i_size_write(inode, newsize);
-		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
 		truncate_pagecache(inode, oldsize, newsize);
 		ret = btrfs_cont_expand(inode, oldsize, newsize);
-		if (ret) {
-			btrfs_setsize(inode, oldsize);
+		if (ret)
 			return ret;
-		}
 
-		mark_inode_dirty(inode);
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
+		i_size_write(inode, newsize);
+		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
+		ret = btrfs_update_inode(trans, root, inode);
+
+		btrfs_end_transaction_throttle(trans, root);
 	} else {
 
 		/*
-- 
1.7.6.4
