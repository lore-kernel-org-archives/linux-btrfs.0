From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/ioctl.c: quiet sparse warnings
Date: Fri, 23 Sep 2011 11:07:53 -0700
Message-ID: <201109231107.54227.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the following sparse warnings:

warning: cast removes address space of expression
warning: incorrect type in assignment (different address spaces)
   expected struct btrfs_ioctl_space_info [noderef] <asn:1>*user_dest
   got struct btrfs_ioctl_space_info *<noident>
warning: symbol 'btrfs_ioctl_space_info' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com>

---

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..a001af4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2599,7 +2599,7 @@ static void get_block_group_info(struct list_head *groups_list,
 	}
 }
 
-long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_space_args space_args;
 	struct btrfs_ioctl_space_info space;
@@ -2705,7 +2705,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 		up_read(&info->groups_sem);
 	}
 
-	user_dest = (struct btrfs_ioctl_space_info *)
+	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));
 
 	if (copy_to_user(user_dest, dest_orig, alloc_size))
