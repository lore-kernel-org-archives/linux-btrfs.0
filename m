From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: add dummy extent if dst offset excceeds file end in
 file clone
Date: Wed, 24 Aug 2011 14:13:13 +0800
Message-ID: <4E549679.3010807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 # touch /mnt/dst
 # clone_range -d 4096 /mnt/src /mnt/dst
 # umount /mnt
 # btrfs-debug-tree /dev/sda7
 ...
        item 10 key (258 INODE_REF 256) itemoff 3283 itemsize 13
                inode ref index 3 namelen 3 name: tmp
        item 11 key (258 EXTENT_DATA 4096) itemoff 3230 itemsize 53
                extent data disk byte 12632064 nr 49152
                extent data offset 0 nr 49152 ram 49152
                extent compression 0

You can see there's no file extent with range [0, 4096]. Check this by
btrfsck:

 # btrfsck /dev/sda7
 root 5 inode 258 errors 100
 ...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..660a6c8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2220,6 +2220,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	    !IS_ALIGNED(destoff, bs))
 		goto out_unlock;
 
+	if (destoff > inode->i_size) {
+		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
+		if (ret)
+			goto out_unlock;
+	}
+
 	/* do any pending delalloc/csum calc on src, one way or
 	   another, and lock file content */
 	while (1) {
-- 
1.7.3.1
