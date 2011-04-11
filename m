From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] fix user annotation in ioctl.c
Date: Mon, 11 Apr 2011 23:56:31 +0800
Message-ID: <BANLkTi=AzkUgTeRgUa1QkQMBiZLoOyQS-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix address space annotation correct in ioctl.c.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cfc264f..0474ec3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2287,7 +2287,7 @@ long btrfs_ioctl_space_info(struct btrfs_root
*root, void __user *arg)
 	struct btrfs_ioctl_space_info space;
 	struct btrfs_ioctl_space_info *dest;
 	struct btrfs_ioctl_space_info *dest_orig;
-	struct btrfs_ioctl_space_info *user_dest;
+	struct btrfs_ioctl_space_info __user *user_dest;
 	struct btrfs_space_info *info;
 	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
 		       BTRFS_BLOCK_GROUP_SYSTEM,
@@ -2387,7 +2387,7 @@ long btrfs_ioctl_space_info(struct btrfs_root
*root, void __user *arg)
 		up_read(&info->groups_sem);
 	}

-	user_dest = (struct btrfs_ioctl_space_info *)
+	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));

 	if (copy_to_user(user_dest, dest_orig, alloc_size))
-- 
Daniel J Blueman
