From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: remove dead code block
Date: Thu, 13 Oct 2011 00:21:37 +0300
Message-ID: <1318454497-25244-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This has been effectively unreachable for years, btrfs_read_dev_super()
implements this check earlier in the mount sequence.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/disk-io.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..ebf99ee 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1910,12 +1910,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (strncmp((char *)(&disk_super->magic), BTRFS_MAGIC,
-		    sizeof(disk_super->magic))) {
-		printk(KERN_INFO "btrfs: valid FS not found on %s\n", sb->s_id);
-		goto fail_sb_buffer;
-	}
-
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
-- 
1.7.5.4

