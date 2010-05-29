From: Dan Carpenter <error27@gmail.com>
Subject: [patch 9/11] btrfs: silence sparse warnings in ioctl.c
Date: Sat, 29 May 2010 11:48:01 +0200
Message-ID: <20100529094801.GJ5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I fixed the following sparse warnings:

fs/btrfs/ioctl.c:1936:22: warning: cast removes address space of expression
fs/btrfs/ioctl.c:1939:26: warning: incorrect type in argument 1 (different address spaces)
fs/btrfs/ioctl.c:1939:26:    expected void [noderef] <asn:1>*to
fs/btrfs/ioctl.c:1939:26:    got struct btrfs_ioctl_space_info *[assigned] user_dest
fs/btrfs/ioctl.c:1872:6: warning: symbol 'btrfs_ioctl_space_info' was not declared. Should it be static?

Also I noticed that a related cast of "arg" could be removed so I did
that.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4dbaf89..a945a66 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1869,21 +1869,19 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	return 0;
 }
 
-long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_space_args space_args;
 	struct btrfs_ioctl_space_info space;
 	struct btrfs_ioctl_space_info *dest;
 	struct btrfs_ioctl_space_info *dest_orig;
-	struct btrfs_ioctl_space_info *user_dest;
+	struct btrfs_ioctl_space_info __user *user_dest;
 	struct btrfs_space_info *info;
 	int alloc_size;
 	int ret = 0;
 	int slot_count = 0;
 
-	if (copy_from_user(&space_args,
-			   (struct btrfs_ioctl_space_args __user *)arg,
-			   sizeof(space_args)))
+	if (copy_from_user(&space_args, arg, sizeof(space_args)))
 		return -EFAULT;
 
 	/* first we count slots */
@@ -1933,7 +1931,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	}
 	rcu_read_unlock();
 
-	user_dest = (struct btrfs_ioctl_space_info *)
+	user_dest = (struct btrfs_ioctl_space_info __user *)
 		(arg + sizeof(struct btrfs_ioctl_space_args));
 
 	if (copy_to_user(user_dest, dest_orig, alloc_size))

