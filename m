From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 2/9] btrfs-convert: fix typo: 'all inode' -> 'all inodes'
Date: Sat,  4 Jun 2011 11:19:17 +0300
Message-ID: <1307175564-25355-3-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 convert.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/convert.c b/convert.c
index fbcf4a3..291dc27 100644
--- a/convert.c
+++ b/convert.c
@@ -1103,41 +1103,41 @@ static int copy_disk_extent(struct btrfs_root *root, u64 dst_bytenr,
 	char *buffer;
 	struct btrfs_fs_devices *fs_devs = root->fs_info->fs_devices;
 
 	buffer = malloc(num_bytes);
 	if (!buffer)
 		return -ENOMEM;
 	ret = pread(fs_devs->latest_bdev, buffer, num_bytes, src_bytenr);
 	if (ret != num_bytes)
 		goto fail;
 	ret = pwrite(fs_devs->latest_bdev, buffer, num_bytes, dst_bytenr);
 	if (ret != num_bytes)
 		goto fail;
 	ret = 0;
 fail:
 	free(buffer);
 	if (ret > 0)
 		ret = -1;
 	return ret;
 }
 /*
- * scan ext2's inode bitmap and copy all used inode.
+ * scan ext2's inode bitmap and copy all used inodes.
  */
 static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 		       int datacsum, int packing, int noxattr)
 {
 	int ret;
 	errcode_t err;
 	ext2_inode_scan ext2_scan;
 	struct ext2_inode ext2_inode;
 	ext2_ino_t ext2_ino;
 	u64 objectid;
 	struct btrfs_trans_handle *trans;
 
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans)
 		return -ENOMEM;
 	err = ext2fs_open_inode_scan(ext2_fs, 0, &ext2_scan);
 	if (err) {
 		fprintf(stderr, "ext2fs_open_inode_scan: %s\n", error_message(err));
 		return -1;
 	}
-- 
1.7.3.4

