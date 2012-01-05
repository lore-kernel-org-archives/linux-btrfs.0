From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/3] Btrfs: fix btrfsck error 400 when truncating a compressed
 file extent
Date: Thu, 05 Jan 2012 16:32:35 +0800
Message-ID: <4F056023.4010302@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce steps:
 # mkfs.btrfs /dev/sdb5
 # mount /dev/sdb5 -o compress=lzo /mnt
 # dd if=/dev/zero of=/mnt/tmpfile bs=128K count=1
 # sync
 # truncate -s 64K /mnt/tmpfile
 root 5 inode 257 errors 400

This is because of the wrong if condition, which is used to check if we should
subtract the bytes of the dropped range from i_blocks/i_bytes of i-node or not.
When we truncate a compressed extent, btrfs substracts the bytes of the whole
extent, it's wrong. We should substract the real size that we truncate, no
matter it is a compressed extent or not. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13b0542..85e2312 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3009,7 +3009,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	int pending_del_nr = 0;
 	int pending_del_slot = 0;
 	int extent_type = -1;
-	int encoding;
 	int ret;
 	int err = 0;
 	u64 ino = btrfs_ino(inode);
@@ -3059,7 +3058,6 @@ search_again:
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		found_type = btrfs_key_type(&found_key);
-		encoding = 0;
 
 		if (found_key.objectid != ino)
 			break;
@@ -3072,10 +3070,6 @@ search_again:
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
 			extent_type = btrfs_file_extent_type(leaf, fi);
-			encoding = btrfs_file_extent_compression(leaf, fi);
-			encoding |= btrfs_file_extent_encryption(leaf, fi);
-			encoding |= btrfs_file_extent_other_encoding(leaf, fi);
-
 			if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
 				item_end +=
 				    btrfs_file_extent_num_bytes(leaf, fi);
@@ -3103,7 +3097,7 @@ search_again:
 		if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
 			u64 num_dec;
 			extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
-			if (!del_item && !encoding) {
+			if (!del_item) {
 				u64 orig_num_bytes =
 					btrfs_file_extent_num_bytes(leaf, fi);
 				extent_num_bytes = new_size -
-- 
1.7.6.4
