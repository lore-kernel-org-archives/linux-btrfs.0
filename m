From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 04/16] Btrfs: check the nodatasum flag when writing compressed
 files
Date: Thu, 14 Jul 2011 11:16:47 +0800
Message-ID: <4E1E5F9F.5020105@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If mounting with nodatasum option, we won't csum file data for
general write or direct-io write, and this rule should also be
applied when writing compressed files.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/compression.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bfe42b0..8ec5d86 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -338,6 +338,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	u64 first_byte = disk_start;
 	struct block_device *bdev;
 	int ret;
+	int skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
@@ -392,8 +393,11 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
 			BUG_ON(ret);
 
-			ret = btrfs_csum_one_bio(root, inode, bio, start, 1);
-			BUG_ON(ret);
+			if (!skip_sum) {
+				ret = btrfs_csum_one_bio(root, inode, bio,
+							 start, 1);
+				BUG_ON(ret);
+			}
 
 			ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
 			BUG_ON(ret);
@@ -418,8 +422,10 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
 	BUG_ON(ret);
 
-	ret = btrfs_csum_one_bio(root, inode, bio, start, 1);
-	BUG_ON(ret);
+	if (!skip_sum) {
+		ret = btrfs_csum_one_bio(root, inode, bio, start, 1);
+		BUG_ON(ret);
+	}
 
 	ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
 	BUG_ON(ret);
-- 
1.7.3.1
