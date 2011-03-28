From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: Fix oops for defrag with compression turned on
Date: Mon, 28 Mar 2011 16:30:38 +0800
Message-ID: <4D90472E.8070000@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel Blueman <daniel.blueman@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we defrag a file, whose size can be fit into an inline extent,
with compression enabled, the compress type is set to be
fs_info->compress_type, which is 0 if the btrfs filesystem is mounted
without compress option. This leads to oops.

Reported-by: Daniel Blueman <daniel.blueman@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db67821..fa9fd5e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -108,6 +108,7 @@ static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root, struct inode *inode,
 				u64 start, size_t size, size_t compressed_size,
+				int compress_type,
 				struct page **compressed_pages)
 {
 	struct btrfs_key key;
@@ -122,12 +123,9 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	size_t cur_size = size;
 	size_t datasize;
 	unsigned long offset;
-	int compress_type = BTRFS_COMPRESS_NONE;
 
-	if (compressed_size && compressed_pages) {
-		compress_type = root->fs_info->compress_type;
+	if (compressed_size && compressed_pages)
 		cur_size = compressed_size;
-	}
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -217,7 +215,7 @@ fail:
 static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode, u64 start, u64 end,
-				 size_t compressed_size,
+				 size_t compressed_size, int compress_type,
 				 struct page **compressed_pages)
 {
 	u64 isize = i_size_read(inode);
@@ -250,7 +248,7 @@ static noinline int cow_file_range_inline(struct btrfs_trans_handle *trans,
 		inline_len = min_t(u64, isize, actual_end);
 	ret = insert_inline_extent(trans, root, inode, start,
 				   inline_len, compressed_size,
-				   compressed_pages);
+				   compress_type, compressed_pages);
 	BUG_ON(ret);
 	btrfs_delalloc_release_metadata(inode, end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
@@ -426,12 +424,13 @@ again:
 			 * to make an uncompressed inline extent.
 			 */
 			ret = cow_file_range_inline(trans, root, inode,
-						    start, end, 0, NULL);
+						    start, end, 0, 0, NULL);
 		} else {
 			/* try making a compressed inline extent */
 			ret = cow_file_range_inline(trans, root, inode,
 						    start, end,
-						    total_compressed, pages);
+						    total_compressed,
+						    compress_type, pages);
 		}
 		if (ret == 0) {
 			/*
@@ -785,7 +784,7 @@ static noinline int cow_file_range(struct inode *inode,
 	if (start == 0) {
 		/* lets try to make an inline extent */
 		ret = cow_file_range_inline(trans, root, inode,
-					    start, end, 0, NULL);
+					    start, end, 0, 0, NULL);
 		if (ret == 0) {
 			extent_clear_unlock_delalloc(inode,
 				     &BTRFS_I(inode)->io_tree,
-- 
1.7.3.1
