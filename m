From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: remove BUG_ON() due to mounting bad filesystem
Date: Tue, 02 Feb 2010 16:46:44 +0800
Message-ID: <4B67E674.2080505@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mounting a bad filesystem caused a BUG_ON(). The following is steps to
reproduce it.
 # mkfs.btrfs /dev/sda2
 # mount /dev/sda2 /mnt
 # mkfs.btrfs /dev/sda1 /dev/sda2
 (the program says that /dev/sda2 was mounted, and then exits. )
 # umount /mnt
 # mount /dev/sda1 /mnt

At the third step, mkfs.btrfs exited in the way of make filesystem. So the
initialization of the filesystem didn't finish. So the filesystem was bad, and
it caused BUG_ON() when mounting it. But BUG_ON() should be called by the wrong
code, not user's operation, so I think it is a bug of btrfs.

This patch fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c    |    7 ++++++-
 fs/btrfs/relocation.c |    3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 87b2554..2b59201 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1982,7 +1982,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_recover_relocation(tree_root);
-		BUG_ON(ret);
+		if (ret < 0) {
+			printk(KERN_WARNING
+			       "btrfs: failed to recover relocation\n");
+			err = -EINVAL;
+			goto fail_trans_kthread;
+		}
 	}
 
 	location.objectid = BTRFS_FS_TREE_OBJECTID;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ed3e4a2..ab7ab53 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3764,7 +3764,8 @@ out:
 				       BTRFS_DATA_RELOC_TREE_OBJECTID);
 		if (IS_ERR(fs_root))
 			err = PTR_ERR(fs_root);
-		btrfs_orphan_cleanup(fs_root);
+		else
+			btrfs_orphan_cleanup(fs_root);
 	}
 	return err;
 }
-- 
1.6.5.2


