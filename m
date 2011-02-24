From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix return value of setflags ioctl
Date: Thu, 24 Feb 2011 17:38:16 +0800
Message-ID: <4D662708.2020700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


setflags ioctl should return error when any checks fail.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 02d224e..e397da4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -213,9 +213,11 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	btrfs_end_transaction(trans, root);
 
 	mnt_drop_write(file->f_path.mnt);
+
+	ret = 0;
  out_unlock:
 	mutex_unlock(&inode->i_mutex);
-	return 0;
+	return ret;
 }
 
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
-- 
1.6.5.2
