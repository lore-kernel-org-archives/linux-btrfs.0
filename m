From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] don't rename file into dummy directory
Date: Thu, 24 Sep 2009 17:08:17 +0800
Message-ID: <4ABB3701.5090104@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A recently change enforces there is only one access point to
each subvolume. The first directory entry (the one added when
the subvolume/snapshot was created) is treated as valid access
point, all other subvolume links are linked to dummy empty
directories. The dummy directories are temporary inodes that
only in memory, so we can not rename file into them.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2009-09-23 05:49:42.007477065 +0800
+++ 2/fs/btrfs/inode.c	2009-09-23 09:46:22.451357089 +0800
@@ -5057,6 +5057,9 @@ static int btrfs_rename(struct inode *ol
 	u64 root_objectid;
 	int ret;
 
+	if (new_dir->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+		return -EPERM;
+
 	/* we only allow rename subvolume link between subvolumes */
 	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
 		return -EXDEV;
