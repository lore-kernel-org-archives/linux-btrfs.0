From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] Fix address space annotation (fixed)
Date: Thu, 14 Apr 2011 14:47:30 +0800
Message-ID: <1302763650-22551-1-git-send-email-daniel.blueman@gmail.com>
References: <BANLkTi=AzkUgTeRgUa1QkQMBiZLoOyQS-g@mail.gmail.com>
Cc: Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=AzkUgTeRgUa1QkQMBiZLoOyQS-g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Fix address space annotation.

---
 fs/btrfs/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index de76a6d..2b1e53e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2287,7 +2287,7 @@ static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_ioctl_space_info space;
 	struct btrfs_ioctl_space_info *dest;
 	struct btrfs_ioctl_space_info *dest_orig;
-	struct btrfs_ioctl_space_info *user_dest;
+	struct btrfs_ioctl_space_info __user *user_dest;
 	struct btrfs_space_info *info;
 	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
 		       BTRFS_BLOCK_GROUP_SYSTEM,
@@ -2387,7 +2387,7 @@ static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 		up_read(&info->groups_sem);
 	}
 
-	user_dest = (struct btrfs_ioctl_space_info *)
+	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));
 
 	if (copy_to_user(user_dest, dest_orig, alloc_size))
-- 
1.7.1

