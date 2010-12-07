From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: Fix a crash when mounting a subvolume
Date: Tue, 07 Dec 2010 09:51:26 +0800
Message-ID: <4CFD931E.6050503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Michael Niederle <mniederle@gmx.at>,
	C Anthony Risinger <anthony@extof.me>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We should drop dentry before deactivating the superblock, otherwise
we can hit this bug:

BUG: Dentry f349a690{i=100,n=/} still in use (1) [unmount of btrfs loop1]
...

Steps to reproduce the bug:

  # mount /dev/loop1 /mnt
  # mkdir save
  # btrfs subvolume snapshot /mnt save/snap1
  # umount /mnt
  # mount -o subvol=save/snap1 /dev/loop1 /mnt
  (crash)

Reported-by: Michael Niederle <mniederle@gmx.at>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 47bf67c..61bd79a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -685,9 +685,9 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 		mutex_unlock(&root->d_inode->i_mutex);
 
 		if (IS_ERR(new_root)) {
+			dput(root);
 			deactivate_locked_super(s);
 			error = PTR_ERR(new_root);
-			dput(root);
 			goto error_free_subvol_name;
 		}
 		if (!new_root->d_inode) {
-- 
1.6.3

