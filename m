From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/3] Btrfs: fix unclosed transaction handle in btrfs_cont_expand()
Date: Thu, 18 Aug 2011 16:14:58 +0800
Message-ID: <4E4CCA02.3070402@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The function - btrfs_cont_expand() forgot to close the transaction handle before
it jump out the while loop. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 634dd797..ee57b40 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3510,15 +3510,19 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			err = btrfs_drop_extents(trans, inode, cur_offset,
 						 cur_offset + hole_size,
 						 &hint_byte, 1);
-			if (err)
+			if (err) {
+				btrfs_end_transaction(trans, root);
 				break;
+			}
 
 			err = btrfs_insert_file_extent(trans, root,
 					btrfs_ino(inode), cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
-			if (err)
+			if (err) {
+				btrfs_end_transaction(trans, root);
 				break;
+			}
 
 			btrfs_drop_extent_cache(inode, hole_start,
 					last_byte - 1, 0);
-- 
1.7.4
