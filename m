From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V2 2/2] Btrfs: fix wrong i_size when truncating a file to
 a larger size
Date: Thu, 15 Dec 2011 17:55:36 +0800
Message-ID: <4EE9C418.4070800@cn.fujitsu.com>
References: <4EE84D29.5070601@cn.fujitsu.com> <20111214165147.GF31158@shiny>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111214165147.GF31158@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfsck report error 100 after the 83th case of xfstests was run, it means
the i_size of the file is wrong.

The reason of this bug is that:
Btrfs increased i_size of the file at the beginning, but it failed to expand
the file, and failed to update the i_size to the old size because there is no
enough space in the file system, so we found a wrong i_size.

This patch fixes this bug by updating the i_size just when we pass the file
expanding.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changes v1 -> v2:
- make i_size be accurate before truncate_pagecache() is called
  (use truncate_setsize())
---
 fs/btrfs/inode.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 960818b..21051fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3373,6 +3373,8 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 static int btrfs_setsize(struct inode *inode, loff_t newsize)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
 	loff_t oldsize = i_size_read(inode);
 	int ret;
 
@@ -3380,16 +3382,22 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 		return 0;
 
 	if (newsize > oldsize) {
-		i_size_write(inode, newsize);
-		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
-		truncate_pagecache(inode, oldsize, newsize);
 		ret = btrfs_cont_expand(inode, oldsize, newsize);
-		if (ret) {
-			btrfs_setsize(inode, oldsize);
+		if (ret)
 			return ret;
+
+		truncate_setsize(inode, newsize);
+
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			truncate_setsize(inode, oldsize);
+			return PTR_ERR(trans);
 		}
 
-		mark_inode_dirty(inode);
+		btrfs_ordered_update_i_size(inode, i_size_read(inode), NULL);
+		ret = btrfs_update_inode(trans, root, inode);
+
+		btrfs_end_transaction_throttle(trans, root);
 	} else {
 
 		/*
-- 
1.7.6.4
