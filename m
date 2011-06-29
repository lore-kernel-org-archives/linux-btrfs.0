From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v3 1/6] btrfs: add READAHEAD extent buffer flag
Date: Wed, 29 Jun 2011 18:32:17 +0200
Message-ID: <9f3fd310a7f4fe6282c7ad154b918e8c17b0849e.1309364964.git.sensille@gmx.net>
References: <cover.1309364964.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1309364964.git.sensille@gmx.net>
In-Reply-To: <cover.1309364964.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Add a READAHEAD extent buffer flag.
Add a function to trigger a read with this flag set.

Changes v2:
 - use extent buffer flags instead of extent state flags

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c   |   32 ++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.h   |    2 ++
 fs/btrfs/extent_io.h |    1 +
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0339cc0..0195172 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -945,6 +945,38 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	return ret;
 }
 
+int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
+			 int mirror_num, struct extent_buffer **eb)
+{
+	struct extent_buffer *buf = NULL;
+	struct inode *btree_inode = root->fs_info->btree_inode;
+	struct extent_io_tree *io_tree = &BTRFS_I(btree_inode)->io_tree;
+	int ret;
+
+	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
+	if (!buf)
+		return 0;
+
+	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
+
+	ret = read_extent_buffer_pages(io_tree, buf, 0, 0, 1, btree_get_extent,
+				 mirror_num);
+	if (ret) {
+		free_extent_buffer(buf);
+		return ret;
+	}
+
+	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
+		*eb = buf;
+		return -EIO;
+	} else if (extent_buffer_uptodate(io_tree, buf, NULL)) {
+		*eb = buf;
+	} else {
+		free_extent_buffer(buf);
+	}
+	return 0;
+}
+
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index a0b610a..fb35c4e 100644
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
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 118c30b..e0a09e8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -32,6 +32,7 @@
 #define EXTENT_BUFFER_BLOCKING 1
 #define EXTENT_BUFFER_DIRTY 2
 #define EXTENT_BUFFER_CORRUPT 3
+#define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead */
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
-- 
1.7.3.4

