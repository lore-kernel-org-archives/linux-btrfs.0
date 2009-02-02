From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] btrfs: call mark_inode_dirty when i_size is updated
Date: Mon, 02 Feb 2009 20:00:48 +0900
Message-ID: <6.0.0.20.2.20090202183710.06cdb8e0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris.

I think it is needed to call mark_inode_dirty() when file size expands
in order to flush metadata updates to HDD through sync() syscall or
background_writeout().

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc3.org/fs/btrfs/file.c linux-2.6.29-rc3/fs/btrfs/file.c
--- linux-2.6.29-rc3.org/fs/btrfs/file.c	2009-02-02 16:53:18.000000000 +0900
+++ linux-2.6.29-rc3/fs/btrfs/file.c	2009-02-02 18:21:00.000000000 +0900
@@ -152,7 +152,7 @@ static noinline int dirty_and_release_pa
 	}
 	if (end_pos > isize) {
 		i_size_write(inode, end_pos);
-		btrfs_update_inode(trans, root, inode);
+		mark_inode_dirty(inode);
 	}
 	err = btrfs_end_transaction(trans, root);
 out_unlock:

