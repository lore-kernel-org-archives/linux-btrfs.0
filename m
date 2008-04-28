From: "Zhu Yanhai" <piggestpig@gmail.com>
Subject: [PATCH] Fix btrfs-convert's large file support.
Date: Mon, 28 Apr 2008 14:03:57 +0800
Message-ID: <13c114d20804272303mf33127bs233b68c8c2244c9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
  This patch add ext2_inode.i_size_high into account when calculating
regular file's size in btrfs-convert,  which makes it deal with large files
 bigger than 4GB properly.

Regards,
Zhu Yanhai

----
diff -r 1c218a5b9784 convert.c
--- a/convert.c	Fri Apr 25 16:55:21 2008 -0400
+++ b/convert.c	Mon Apr 28 13:01:58 2008 +0800
@@ -928,6 +928,10 @@ static int copy_inode_item(struct btrfs_
 		btrfs_set_stack_inode_size(dst, 0);
 		btrfs_set_stack_inode_nlink(dst, 1);
 	}
+    if (S_ISREG(src->i_mode)) {
+        btrfs_set_stack_inode_size(dst, (u64)src->i_size_high << 32 |
+                                      (u64)src->i_size);
+    }
 	if (!S_ISREG(src->i_mode) && !S_ISDIR(src->i_mode) &&
 	    !S_ISLNK(src->i_mode)) {
 		if (src->i_block[0]) {
