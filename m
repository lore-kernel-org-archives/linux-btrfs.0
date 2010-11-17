From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: restructure btrfs_merge_bio_hook()
Date: Wed, 17 Nov 2010 12:23:31 +0800
Message-ID: <4CE358C3.7070903@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We restructured btrfs_merge_bio_hook(). And the new function will be used to
fix a panic problem that caused by direct IO.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3906e48..32b68fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1353,6 +1353,22 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 	return 0;
 }
 
+static int __btrfs_can_merge_page_to_bio(struct btrfs_mapping_tree *map_tree,
+					 size_t size, struct bio *bio)
+{
+	u64 logical = (u64)bio->bi_sector << 9;
+	u64 map_length;
+	int ret;
+
+	map_length = bio->bi_size;
+	ret = btrfs_map_block(map_tree, READ, logical,
+			      &map_length, NULL, 0);
+
+	if (map_length < bio->bi_size + size)
+		return 1;
+	return ret;
+}
+
 /*
  * extent_io.c merge_bio_hook, this must check the chunk tree to make sure
  * we don't create bios that span stripes or chunks
@@ -1363,23 +1379,12 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 {
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	struct btrfs_mapping_tree *map_tree;
-	u64 logical = (u64)bio->bi_sector << 9;
-	u64 length = 0;
-	u64 map_length;
-	int ret;
 
 	if (bio_flags & EXTENT_BIO_COMPRESSED)
 		return 0;
 
-	length = bio->bi_size;
 	map_tree = &root->fs_info->mapping_tree;
-	map_length = length;
-	ret = btrfs_map_block(map_tree, READ, logical,
-			      &map_length, NULL, 0);
-
-	if (map_length < length + size)
-		return 1;
-	return ret;
+	return __btrfs_can_merge_page_to_bio(map_tree, size, bio);
 }
 
 /*
-- 
1.7.0.1
