From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 09/10] btrfs: fix some problem in btrfs_link()
Date: Thu, 20 May 2010 15:24:42 +0800
Message-ID: <4BF4E3BA.8030607@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- add check for btrfs_start_transaction()'s return value

- fix no drop the nlink of the inode if btrfs_set_inode_index() fails,.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1cef510..1392a09 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4418,15 +4418,18 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (err)
 		return err;
 
-	btrfs_inc_nlink(inode);
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans) {
+		err = -ENOMEM;
+		goto fail;
+	}
 
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
 		goto fail;
 
-	trans = btrfs_start_transaction(root, 1);
-
 	btrfs_set_trans_block_group(trans, dir);
+	btrfs_inc_nlink(inode);
 	atomic_inc(&inode->i_count);
 
 	err = btrfs_add_nondir(trans, dentry, inode, 1, index);
-- 
1.6.5.2


