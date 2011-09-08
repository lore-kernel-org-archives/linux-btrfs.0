From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix direct-io vs nodatacow
Date: Thu, 08 Sep 2011 10:26:51 +0800
Message-ID: <4E6827EB.2030907@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

To reproduce the bug:

  # mount -o nodatacow /dev/sda7 /mnt/
  # dd if=/dev/zero of=/mnt/tmp bs=4K count=1
  1+0 records in
  1+0 records out
  4096 bytes (4.1 kB) copied, 0.000136115 s, 30.1 MB/s
  # dd if=/dev/zero of=/mnt/tmp bs=4K count=1 conv=notrunc oflag=direct
  dd: writing `/mnt/tmp': Input/output error
  1+0 records in
  0+0 records out

btrfs_ordered_update_i_size() may return 1, but btrfs_endio_direct_write()
mistakenly takes it as an error.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..3bd35fe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5785,8 +5785,7 @@ again:
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered);
 		if (!ret)
-			ret = btrfs_update_inode(trans, root, inode);
-		err = ret;
+			err = btrfs_update_inode(trans, root, inode);
 		goto out;
 	}
 
-- 1.7.3.1 
