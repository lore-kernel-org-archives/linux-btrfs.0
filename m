From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V3 2/6] btrfs: try to reclaim some space when chunk allocation
 fails
Date: Wed, 05 Jan 2011 18:07:18 +0800
Message-ID: <4D2442D6.6060206@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We cannot write data into files when when there is tiny space in the filesystem.

Reproduce steps:
 # mkfs.btrfs /dev/sda1
 # mount /dev/sda1 /mnt
 # dd if=/dev/zero of=/mnt/tmpfile0 bs=4K count=1
 # dd if=/dev/zero of=/mnt/tmpfile1 bs=4K count=99999999999999
   (fill the filesystem)
 # umount /mnt
 # mount /dev/sda1 /mnt
 # rm -f /mnt/tmpfile0
 # dd if=/dev/zero of=/mnt/tmpfile0 bs=4K count=1
   (failed with nospec)

But if we do the last step again, we can write data successfully. The reason of
the problem is that btrfs didn't try to commit the current transaction and
reclaim some space when chunk allocation failed.

This patch fixes it by committing the current transaction to reclaim some
space when chunk allocation fails.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7e5162e..4bcd875 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3162,8 +3162,12 @@ alloc:
 					     bytes + 2 * 1024 * 1024,
 					     alloc_target, 0);
 			btrfs_end_transaction(trans, root);
-			if (ret < 0)
-				return ret;
+			if (ret < 0) {
+				if (ret != -ENOSPC)
+					return ret;
+				else
+					goto commit_trans;
+			}
 
 			if (!data_sinfo) {
 				btrfs_set_inode_space_info(root, inode);
@@ -3174,6 +3178,7 @@ alloc:
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
+commit_trans:
 		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
-- 
1.7.2.3
