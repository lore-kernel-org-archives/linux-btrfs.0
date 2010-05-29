From: Dan Carpenter <error27@gmail.com>
Subject: [patch 8/11] btrfs: btrfs_lookup_dir_item() can return ERR_PTR
Date: Sat, 29 May 2010 11:47:24 +0200
Message-ID: <20100529094724.GI5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_lookup_dir_item() can return either ERR_PTRs or null.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9f9a1d9..4dbaf89 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1845,7 +1845,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
 	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, path,
 				   dir_id, "default", 7, 1);
-	if (!di) {
+	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
 		btrfs_end_transaction(trans, root);
 		printk(KERN_ERR "Umm, you don't have the default dir item, "
