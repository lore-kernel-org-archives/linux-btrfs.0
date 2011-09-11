From: Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] btrfs: fix directory offsets for '.' and '..' entries
Date: Sun, 11 Sep 2011 23:33:36 +0300
Message-ID: <1315773216-8490-1-git-send-email-notasas@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently getdents syscall returns wrong offset for '.' directory entry,
which confuses some programs like wine. This can be observed with an
example program getdents(2) manpage:

$ ./a.out /testfs/
--------------- nread=96 ---------------
i-node#  file type  d_reclen  d_off   d_name
     256  directory    24          2  .
     256  directory    24          2  ..
     257  regular      24          3  a
     258  regular      24 2147483647  b

Fix this by passing correct offsets to filldir().

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 fs/btrfs/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..5e7460b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4125,7 +4125,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	/* special case for "." */
 	if (filp->f_pos == 0) {
-		over = filldir(dirent, ".", 1, 1, btrfs_ino(inode), DT_DIR);
+		over = filldir(dirent, ".", 1, 0, btrfs_ino(inode), DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 1;
@@ -4133,8 +4133,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	/* special case for .., just use the back ref */
 	if (filp->f_pos == 1) {
 		u64 pino = parent_ino(filp->f_path.dentry);
-		over = filldir(dirent, "..", 2,
-			       2, pino, DT_DIR);
+		over = filldir(dirent, "..", 2, 1, pino, DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 2;
-- 
1.7.0.4

