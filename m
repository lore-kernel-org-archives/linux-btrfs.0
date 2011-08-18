From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/3] Btrfs: fix wrong nbytes information of the inode
Date: Thu, 18 Aug 2011 16:11:31 +0800
Message-ID: <4E4CC933.6060601@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we write some data into the data hole of the file(no preallocation for this
hole), Btrfs will allocate some disk space, and update nbytes of the inode, but
the other element--disk_i_size needn't be updated. At this condition, we must
update inode metadata though disk_i_size is not changed(btrfs_ordered_update_i_size()
return 1).

 # mkfs.btrfs /dev/sdb1
 # mount /dev/sdb1 /mnt
 # touch /mnt/a
 # truncate -s 856002 /mnt/a
 # dd if=/dev/zero of=/mnt/a bs=4K count=1 conv=nocreat,notrunc
 # umount /mnt
 # btrfsck /dev/sdb1
 root 5 inode 257 errors 400
 found 32768 bytes used err is 1

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 18d08f4..634dd797 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1786,7 +1786,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			  &ordered_extent->list);
 
 	ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
-	if (!ret) {
+	if (!ret || !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
 	}
@@ -5788,7 +5788,7 @@ again:
 
 	add_pending_csums(trans, inode, ordered->file_offset, &ordered->list);
 	ret = btrfs_ordered_update_i_size(inode, 0, ordered);
-	if (!ret)
+	if (!ret || !test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags))
 		btrfs_update_inode(trans, root, inode);
 	ret = 0;
 out_unlock:
-- 
1.7.4
