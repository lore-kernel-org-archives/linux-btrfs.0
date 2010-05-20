From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 07/10] btrfs: fix wrong ctime when adding link
Date: Thu, 20 May 2010 15:22:30 +0800
Message-ID: <4BF4E336.40603@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

the ctime of file has not been updated when I create a link for it.

Steps to reproduce:
 # touch file1
 # stat -c %Z file1
 1273592239
 # link flink1 file1
 # stat -c %Z file1
 1273592239             <-- have not been updated

This patch fix this problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85b90c..5271887 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4218,8 +4218,12 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 		btrfs_i_size_write(parent_inode, parent_inode->i_size +
 				   name_len * 2);
-		parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
-		ret = btrfs_update_inode(trans, root, parent_inode);
+		parent_inode->i_mtime = parent_inode->i_ctime = inode->i_ctime
+				      = CURRENT_TIME;
+
+		ret = btrfs_update_inode(trans, root, inode);
+		if (!ret)
+			ret = btrfs_update_inode(trans, root, parent_inode);
 	}
 	return ret;
 }
-- 
1.6.5.2


