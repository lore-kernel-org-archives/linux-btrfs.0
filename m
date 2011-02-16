From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs: Fix BTRFS_IOC_SUBVOL_SETFLAGS ioctl
Date: Wed, 16 Feb 2011 14:06:34 +0800
Message-ID: <4D5B696A.5090700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

- Check user-specified flags correctly
- Check the inode owership
- Search root item in root tree but not fs tree

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 02d224e..858d4e7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1071,12 +1071,15 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	if (copy_from_user(&flags, arg, sizeof(flags)))
 		return -EFAULT;
 
-	if (flags & ~BTRFS_SUBVOL_CREATE_ASYNC)
+	if (flags & BTRFS_SUBVOL_CREATE_ASYNC)
 		return -EINVAL;
 
 	if (flags & ~BTRFS_SUBVOL_RDONLY)
 		return -EOPNOTSUPP;
 
+	if (!is_owner_or_cap(inode))
+		return -EACCES;
+
 	down_write(&root->fs_info->subvol_sem);
 
 	/* nothing to do */
@@ -1097,7 +1100,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_reset;
 	}
 
-	ret = btrfs_update_root(trans, root,
+	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&root->root_key, &root->root_item);
 
 	btrfs_commit_transaction(trans, root);
-- 
1.6.3
