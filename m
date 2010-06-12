From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: fix CLONE ioctl destination file size expansion to block boundary
Date: Sat, 12 Jun 2010 15:31:14 -0700
Message-ID: <1276381874-2964-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The CLONE and CLONE_RANGE ioctls round up the range of extents being
cloned to the block size when the range to clone extends to the end of file
(this is always the case with CLONE).  It was then using that offset when
extending the destination file's i_size.  Fix this by not setting i_size
beyond the originally requested ending offset.

This bug was introduced by a22285a6 (2.6.35-rc1).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4cdb98c..a687f28 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1578,6 +1578,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			u64 disko = 0, diskl = 0;
 			u64 datao = 0, datal = 0;
 			u8 comp;
+			u64 endoff;
 
 			size = btrfs_item_size_nr(leaf, slot);
 			read_extent_buffer(leaf, buf,
@@ -1712,9 +1713,18 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			btrfs_release_path(root, path);
 
 			inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-			if (new_key.offset + datal > inode->i_size)
-				btrfs_i_size_write(inode,
-						   new_key.offset + datal);
+
+			/*
+			 * we round up to the block size at eof when
+			 * determining which extents to clone above,
+			 * but shouldn't round up the file size
+			 */
+			endoff = new_key.offset + datal;
+			if (endoff > off+olen)
+				endoff = off+olen;
+			if (endoff > inode->i_size)
+				btrfs_i_size_write(inode, endoff);
+
 			BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
 			ret = btrfs_update_inode(trans, root, inode);
 			BUG_ON(ret);
-- 
1.7.0

