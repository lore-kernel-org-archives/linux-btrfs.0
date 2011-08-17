From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] btrfs: fix d_off in the first dirent
Date: Wed, 17 Aug 2011 18:23:25 +0900
Message-ID: <4E4B888D.6070904@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since the d_off in the first dirent for "." (that originates from
the 4th argument "offset" of filldir() for the 2nd dirent for "..")
is wrongly assigned in btrfs_real_readdir(), telldir returns same
offset for different locations.

 | # mkfs.btrfs /dev/sdb1
 | # mount /dev/sdb1 fs0
 | # cd fs0
 | # touch file0 file1
 | # ../test
 | telldir: 0
 | readdir: d_off = 2, d_name = "."
 | telldir: 2
 | readdir: d_off = 2, d_name = ".."
 | telldir: 2
 | readdir: d_off = 3, d_name = "file0"
 | telldir: 3
 | readdir: d_off = 2147483647, d_name = "file1"
 | telldir: 2147483647

To fix this problem, pass filp->f_pos (which is loff_t) instead of
the wrong constant value.

 | # ../test
 | telldir: 0
 | readdir: d_off = 1, d_name = "."
 | telldir: 1
 | readdir: d_off = 2, d_name = ".."
 | telldir: 2
 | readdir: d_off = 3, d_name = "file0"
 :

At the moment the "offset" for "." is unused because there is no
preceding dirent, however it is better to pass filp->f_pos to follow
grammatical usage.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/btrfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15fceef..9c1297b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4125,7 +4125,8 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	/* special case for "." */
 	if (filp->f_pos == 0) {
-		over = filldir(dirent, ".", 1, 1, btrfs_ino(inode), DT_DIR);
+		over = filldir(dirent, ".", 1,
+			       filp->f_pos, inode->i_ino, DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 1;
@@ -4134,7 +4135,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	if (filp->f_pos == 1) {
 		u64 pino = parent_ino(filp->f_path.dentry);
 		over = filldir(dirent, "..", 2,
-			       2, pino, DT_DIR);
+			       filp->f_pos, pino, DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 2;
-- 
1.7.6


