From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: calc file extent num_bytes correctly in file clone
Date: Wed, 24 Aug 2011 14:13:16 +0800
Message-ID: <4E54967C.5020205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 # touch /mnt/dst
 # clone_range -s 8192 -l 4096 /mnt/src /mnt/dst
 # ls -l /mnt/dst
 -rw-r--r-- 1 root root  4096 dst
 # umount /mnt
 # btrfs-debug-tree /dev/sda7
 ...
         item 11 key (258 EXTENT_DATA 0) itemoff 3230 itemsize 53
                extent data disk byte 12582912 nr 49152
                extent data offset 8192 nr 12288 ram 49152
                extent compression 0

num_bytes should be 4096 not 12288.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 660a6c8..3351b1b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2331,14 +2331,21 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 			if (type == BTRFS_FILE_EXTENT_REG ||
 			    type == BTRFS_FILE_EXTENT_PREALLOC) {
+				/*
+				 *    a  | --- range to clone ---|  b
+				 * | ------------- extent ------------- |
+				 */
+
+				/* substract range b */
+				if (key.offset + datal > off + len)
+					datal = off + len - key.offset;
+
+				/* substract range a */
 				if (off > key.offset) {
 					datao += off - key.offset;
 					datal -= off - key.offset;
 				}
 
-				if (key.offset + datal > off + len)
-					datal = off + len - key.offset;
-
 				ret = btrfs_drop_extents(trans, inode,
 							 new_key.offset,
 							 new_key.offset + datal,
-- 
1.7.3.1
