From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 1/5] btrfs: add READAHEAD extent state
Date: Mon, 23 May 2011 14:59:04 +0200
Message-ID: <ca295bb395f561e16cb80a78feb901db7e484e0c.1306154794.git.sensille@gmx.net>
References: <cover.1306154794.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1306154794.git.sensille@gmx.net>
In-Reply-To: <cover.1306154794.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add a READAHEAD extent state flag.
Add a function to trigger a read with this flag set.
Reset the flag in the end_io hook

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c   |   36 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.h   |    2 ++
 fs/btrfs/extent_io.c |   10 +++++++++-
 fs/btrfs/extent_io.h |    1 +
 4 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fe5aec9..7753eb9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -958,6 +958,42 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	return ret;
 }
 
+int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
+			 int mirror_num, struct extent_buffer **eb)
+{
+	struct extent_buffer *buf = NULL;
+	struct inode *btree_inode = root->fs_info->btree_inode;
+	int ret;
+
+	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
+	if (!buf)
+		return 0;
+
+	ret = set_extent_bits(&BTRFS_I(btree_inode)->io_tree,
+			      bytenr, bytenr+blocksize-1,
+			      EXTENT_READAHEAD, GFP_NOFS);
+	if (ret) {
+		printk(KERN_ERR "set_extent_bits failed with %d\n", ret);
+		free_extent_buffer(buf);
+		return ret;
+	}
+
+	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
+				 buf, 0, 0, btree_get_extent, mirror_num);
+
+	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
+		*eb = buf;
+		ret = -EIO;
+	} else if (extent_buffer_uptodate(
+			&BTRFS_I(buf->first_page->mapping->host)->io_tree,
+			buf, NULL)) {
+		*eb = buf;
+	} else {
+		free_extent_buffer(buf);
+	}
+	return ret;
+}
+
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 07b20dc..0c47d57 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -40,6 +40,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 u64 parent_transid);
+int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
+			 int mirror_num, struct extent_buffer **eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 int clean_tree_block(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0d1196d..df0bc46 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1021,6 +1021,14 @@ int unlock_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
 				mask);
 }
 
+int unlock_ra_extent_cached(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached, gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end,
+				EXTENT_READAHEAD | EXTENT_LOCKED, 1, 0, cached,
+				mask);
+}
+
 int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end, gfp_t mask)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
@@ -1795,7 +1803,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			set_extent_uptodate(tree, start, end, &cached,
 					    GFP_ATOMIC);
 		}
-		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+		unlock_ra_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 
 		if (whole_page) {
 			if (uptodate) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index af2d717..6317c78 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -17,6 +17,7 @@
 #define EXTENT_NODATASUM (1 << 10)
 #define EXTENT_DO_ACCOUNTING (1 << 11)
 #define EXTENT_FIRST_DELALLOC (1 << 12)
+#define EXTENT_READAHEAD (1 << 13)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
-- 
1.7.3.4

