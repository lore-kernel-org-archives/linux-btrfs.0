From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] btrfs: fix cast address space annotation in ioctl.c
Date: Thu, 23 Jun 2011 22:49:35 +0800
Message-ID: <BANLkTike4U+GDkPmk2z7xiQ3ktWBEHe1SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

One of the casts in ioctl.c loses the __user annotation; cast so it is
correctly maintained.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..79c32d8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2708,7 +2708,7 @@ long btrfs_ioctl_space_info(struct btrfs_root
*root, void __user *arg)
 		up_read(&info->groups_sem);
 	}

-	user_dest = (struct btrfs_ioctl_space_info *)
+	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));

 	if (copy_to_user(user_dest, dest_orig, alloc_size))
-- 
Daniel J Blueman
