From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix incompat flags setting
Date: Tue, 17 Jan 2012 15:00:41 +0800
Message-ID: <4F151C99.9000503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andi Kleen <andi@firstfloor.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The new snappy code reveals this old bug in btrfs, which happened to
work for LZO.

	# mkfs.btrfs /dev/loop2
	# mount /dev/loop2
	# umount /mnt
	# btrfsck /dev/loop2
	couldn't open because of unsupported option features (10).

The corresponding incompat flag was set, though we didn't mount with
snappy enabled.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

This patch is for the snappy branch.

---
 fs/btrfs/disk-io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5924163..27101e4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2115,9 +2115,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	features = btrfs_super_incompat_flags(disk_super);
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-	if (tree_root->fs_info->compress_type & BTRFS_COMPRESS_LZO)
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-	if (tree_root->fs_info->compress_type & BTRFS_COMPRESS_SNAPPY)
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_SNAPPY)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_SNAPPY;
 	btrfs_set_super_incompat_flags(disk_super, features);
 
-- 
1.7.3.1

