From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 08/10] btrfs: fix memory leak of btrfs_new_inode()
Date: Thu, 20 May 2010 15:24:01 +0800
Message-ID: <4BF4E391.4070402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_new_inode() forgets to free path when it enters the error path.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5271887..1cef510 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4076,15 +4076,15 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BUG_ON(!path);
 
 	inode = new_inode(root->fs_info->sb);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
+	if (!inode) {
+		ret = -ENOMEM;
+		goto alloc_inode_fail;
+	}
 
 	if (dir) {
 		ret = btrfs_set_inode_index(dir, index);
-		if (ret) {
-			iput(inode);
-			return ERR_PTR(ret);
-		}
+		if (ret)
+			goto set_index_fail;
 	}
 	/*
 	 * index_cnt is ignored for everything but a dir,
@@ -4167,8 +4167,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 fail:
 	if (dir)
 		BTRFS_I(dir)->index_cnt--;
-	btrfs_free_path(path);
+set_index_fail:
 	iput(inode);
+alloc_inode_fail:
+	btrfs_free_path(path);
 	return ERR_PTR(ret);
 }
 
-- 
1.6.5.2

