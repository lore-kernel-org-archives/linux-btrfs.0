Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbcFVCEQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 22:04:16 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id 9CBAF4056403
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 09:59:01 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix disk_i_size update bug when fallocate() fails
Date: Wed, 22 Jun 2016 09:57:01 +0800
Message-Id: <1466560621-18133-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing truncate operation, btrfs_setsize() will first call
truncate_setsize() to set new inode->i_size, but if later
btrfs_truncate() fails, btrfs_setsize() will call
"i_size_write(inode, BTRFS_I(inode)->disk_i_size)" to reset the
inmemory inode size, now bug occurs. It's because for truncate
case btrfs_ordered_update_i_size() directly uses inode->i_size
to update BTRFS_I(inode)->disk_i_size, indeed we should use the
"offset" argument to update disk_i_size. Here is the call graph:
==>btrfs_truncate()
====>btrfs_truncate_inode_items()
======>btrfs_ordered_update_i_size(inode, last_size, NULL);
Here btrfs_ordered_update_i_size()'s offset argument is last_size.

And below test case can reveal this bug:

dd if=/dev/zero of=fs.img bs=$((1024*1024)) count=100
dev=$(losetup --show -f fs.img)
mkdir -p /mnt/mntpoint
mkfs.btrfs  -f $dev
mount $dev /mnt/mntpoint
cd /mnt/mntpoint

echo "workdir is: /mnt/mntpoint"
blocksize=$((128 * 1024))
dd if=/dev/zero of=testfile bs=$blocksize count=1
sync
count=$((17*1024*1024*1024/blocksize))
echo "file size is:" $((count*blocksize))
for ((i = 1; i <= $count; i++)); do
	i=$((i + 1))
	dst_offset=$((blocksize * i))
	xfs_io -f -c "reflink testfile 0 $dst_offset $blocksize"\
		testfile > /dev/null
done
sync

truncate --size 0 testfile
ls -l testfile
du -sh testfile
exit

In this case, truncate operation will fail for enospc reason and
"du -sh testfile" returns value greater than 0, but testfile's
size is 0, we need to reflect correct inode->i_size.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e96634a..aca8264 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -968,6 +968,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	struct rb_node *prev = NULL;
 	struct btrfs_ordered_extent *test;
 	int ret = 1;
+	u64 orig_offset = offset;
 
 	spin_lock_irq(&tree->lock);
 	if (ordered) {
@@ -983,7 +984,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 
 	/* truncate file */
 	if (disk_i_size > i_size) {
-		BTRFS_I(inode)->disk_i_size = i_size;
+		BTRFS_I(inode)->disk_i_size = orig_offset;
 		ret = 0;
 		goto out;
 	}
-- 
1.8.3.1



