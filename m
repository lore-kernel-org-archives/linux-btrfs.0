From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix problem of wrong jump after the error occured
Date: Thu, 11 Feb 2010 16:06:58 +0800
Message-ID: <4B73BAA2.1050106@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_mkdir() must jump to the place of ending transaction after
btrfs_find_free_objectid() failed. Or this transaction can't end.

This patch fixes this problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4deb280..4f230e4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4501,7 +4501,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
 	if (err) {
 		err = -ENOSPC;
-		goto out_unlock;
+		goto out_fail;
 	}
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-- 
1.6.5.2

