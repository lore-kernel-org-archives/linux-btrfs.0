From: jim owens <owens6336@gmail.com>
Subject: [PATCH] Btrfs: fix direct I/O handling of extent map errors.
Date: Sun, 21 Mar 2010 22:31:25 -0400
Message-ID: <4BA6D67D.4050200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/dio.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index b76b227..b6934be 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -486,8 +486,13 @@ getlock:
 
 		em = btrfs_get_extent(diocb->inode, NULL, 0,
 					diocb->start, len, 0);
-		if (!em) {
-			err = -EIO;
+		if (IS_ERR(em)) {
+			err = PTR_ERR(em);
+			printk(KERN_ERR
+				"btrfs directIO fail btrfs_get_extent ino %lu "
+				"extent start %llu len %llu error %d\n",
+				diocb->inode->i_ino, diocb->start,
+				data_len, err);
 			goto fail;
 		}
 
@@ -1432,8 +1437,8 @@ static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len)
 	}
 fail:
 	unlock_extent(&BTRFS_I(diocb->inode)->io_tree, diocb->lockstart,
-			diocb->lockstart + hole_len - 1, GFP_NOFS);
-	diocb->lockstart += hole_len;
+			diocb->start - 1, GFP_NOFS);
+	diocb->lockstart = diocb->start;
 	return err;
 }
 
@@ -1577,8 +1582,8 @@ notfound:
 	btrfs_free_path(path);
 	if (!err && *data_len) {
 		unlock_extent(&BTRFS_I(diocb->inode)->io_tree, diocb->lockstart,
-				diocb->lockstart + *data_len - 1, GFP_NOFS);
-		diocb->lockstart += *data_len;
+				diocb->start - 1, GFP_NOFS);
+		diocb->lockstart = diocb->start;
 	}
 	return err;
 }
@@ -1601,8 +1606,9 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 
 	if (extcb->iolen & (blocksize - 1)) {
 		printk(KERN_WARNING
-			"btrfs directIO unaligned checksum for ino %lu\n",
-			extcb->diocb->inode->i_ino);
+			"btrfs directIO unaligned checksum for ino %lu "
+			"start %lld len %d\n", extcb->diocb->inode->i_ino,
+			extcb->iostart, extcb->iolen);
 		extcb->iolen &= ~(blocksize - 1);
 	}
 
-- 
1.6.3.3
