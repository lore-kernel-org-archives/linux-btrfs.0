From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 2/5] btrfs: add droptree inode
Date: Thu, 12 Apr 2012 17:54:39 +0200
Message-ID: <c20f2504f5ecd6cd9622c79ecb84ed1443c9717a.1334241664.git.sensille@gmx.net>
References: <cover.1334241664.git.sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This adds a new special inode, the droptree inode. It is placed in
the tree root and is used to store the state of snapshot deletion.
Even if multiple snapshots are deleted at once, the full state is
stored within this one inode. After snapshot deletion completes,
the inode is left in place, but truncated to zero.
This patch also exports free_space_cache's io_ctl functions to
droptree and adds functions to store and read u8, u16, u32 and u64
values, as well as byte arrays of arbitrary length.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/btrfs_inode.h      |    4 +
 fs/btrfs/ctree.h            |    6 ++
 fs/btrfs/free-space-cache.c |  131 ++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/free-space-cache.h |   32 +++++++++++
 fs/btrfs/inode.c            |    3 +-
 5 files changed, 155 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9b9b15f..8abbed4 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -196,6 +196,10 @@ static inline void btrfs_i_size_write(struct inode *inode, u64 size)
 static inline bool btrfs_is_free_space_inode(struct btrfs_root *root,
 				       struct inode *inode)
 {
+	if (BTRFS_I(inode)->location.objectid == BTRFS_DROPTREE_INO_OBJECTID)
+		/* it also lives in the tree_root, but is no free space
+		 * inode */
+		return false;
 	if (root == root->fs_info->tree_root ||
 	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
 		return true;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 52b8a91..e187ab9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -116,6 +116,12 @@ struct btrfs_ordered_sum;
  */
 #define BTRFS_FREE_INO_OBJECTID -12ULL
 
+/*
+ * The inode number assigned to the special inode for storing
+ * snapshot deletion progress
+ */
+#define BTRFS_DROPTREE_INO_OBJECTID -13ULL
+
 /* dummy objectid represents multiple objectids */
 #define BTRFS_MULTIPLE_OBJECTIDS -255ULL
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b30242f..7e993b0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -259,19 +259,8 @@ static int readahead_cache(struct inode *inode)
 	return 0;
 }
 
-struct io_ctl {
-	void *cur, *orig;
-	struct page *page;
-	struct page **pages;
-	struct btrfs_root *root;
-	unsigned long size;
-	int index;
-	int num_pages;
-	unsigned check_crcs:1;
-};
-
-static int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
-		       struct btrfs_root *root)
+int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
+		struct btrfs_root *root)
 {
 	memset(io_ctl, 0, sizeof(struct io_ctl));
 	io_ctl->num_pages = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
@@ -286,12 +275,12 @@ static int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
 	return 0;
 }
 
-static void io_ctl_free(struct io_ctl *io_ctl)
+void io_ctl_free(struct io_ctl *io_ctl)
 {
 	kfree(io_ctl->pages);
 }
 
-static void io_ctl_unmap_page(struct io_ctl *io_ctl)
+void io_ctl_unmap_page(struct io_ctl *io_ctl)
 {
 	if (io_ctl->cur) {
 		kunmap(io_ctl->page);
@@ -300,7 +289,7 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
 	}
 }
 
-static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
+void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
 {
 	WARN_ON(io_ctl->cur);
 	BUG_ON(io_ctl->index >= io_ctl->num_pages);
@@ -312,7 +301,7 @@ static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
 		memset(io_ctl->cur, 0, PAGE_CACHE_SIZE);
 }
 
-static void io_ctl_drop_pages(struct io_ctl *io_ctl)
+void io_ctl_drop_pages(struct io_ctl *io_ctl)
 {
 	int i;
 
@@ -327,8 +316,8 @@ static void io_ctl_drop_pages(struct io_ctl *io_ctl)
 	}
 }
 
-static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
-				int uptodate)
+int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
+			 int uptodate)
 {
 	struct page *page;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
@@ -361,6 +350,108 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
 	return 0;
 }
 
+void io_ctl_set_bytes(struct io_ctl *io_ctl, void *data, unsigned long len)
+{
+	unsigned long l;
+
+	while (len) {
+		if (io_ctl->cur == NULL)
+			io_ctl_map_page(io_ctl, 1);
+		l = min(len, io_ctl->size);
+		memcpy(io_ctl->cur, data, l);
+		if (len != l) {
+			io_ctl_unmap_page(io_ctl);
+		} else {
+			io_ctl->cur += l;
+			io_ctl->size -= l;
+		}
+		data += l;
+		len -= l;
+	}
+}
+
+void io_ctl_get_bytes(struct io_ctl *io_ctl, void *data, unsigned long len)
+{
+	unsigned long l;
+
+	while (len) {
+		if (io_ctl->cur == NULL)
+			io_ctl_map_page(io_ctl, 0);
+		l = min(len, io_ctl->size);
+		memcpy(data, io_ctl->cur, l);
+		if (len != l) {
+			io_ctl_unmap_page(io_ctl);
+		} else {
+			io_ctl->cur += l;
+			io_ctl->size -= l;
+		}
+		data += l;
+		len -= l;
+	}
+}
+
+void io_ctl_set_u64(struct io_ctl *io_ctl, u64 val)
+{
+	u64 v = cpu_to_le64(val);
+
+	io_ctl_set_bytes(io_ctl, &v, sizeof(u64));
+}
+
+u64 io_ctl_get_u64(struct io_ctl *io_ctl)
+{
+	u64 v;
+
+	io_ctl_get_bytes(io_ctl, &v, sizeof(u64));
+
+	return le64_to_cpu(v);
+}
+
+void io_ctl_set_u32(struct io_ctl *io_ctl, u32 val)
+{
+	u32 v = cpu_to_le32(val);
+
+	io_ctl_set_bytes(io_ctl, &v, sizeof(u32));
+}
+
+u32 io_ctl_get_u32(struct io_ctl *io_ctl)
+{
+	u32 v;
+
+	io_ctl_get_bytes(io_ctl, &v, sizeof(u32));
+
+	return le32_to_cpu(v);
+}
+
+void io_ctl_set_u16(struct io_ctl *io_ctl, u16 val)
+{
+	u16 v = cpu_to_le16(val);
+
+	io_ctl_set_bytes(io_ctl, &v, sizeof(u16));
+}
+
+u16 io_ctl_get_u16(struct io_ctl *io_ctl)
+{
+	u16 v;
+
+	io_ctl_get_bytes(io_ctl, &v, sizeof(u16));
+
+	return le16_to_cpu(v);
+}
+
+void io_ctl_set_u8(struct io_ctl *io_ctl, u8 val)
+{
+	io_ctl_set_bytes(io_ctl, &val, sizeof(u8));
+}
+
+u8 io_ctl_get_u8(struct io_ctl *io_ctl)
+{
+	u8 v;
+
+	io_ctl_get_bytes(io_ctl, &v, sizeof(u8));
+
+	return v;
+}
+
 static void io_ctl_set_generation(struct io_ctl *io_ctl, u64 generation)
 {
 	u64 *val;
@@ -523,7 +614,7 @@ static int io_ctl_add_bitmap(struct io_ctl *io_ctl, void *bitmap)
 	return 0;
 }
 
-static void io_ctl_zero_remaining_pages(struct io_ctl *io_ctl)
+void io_ctl_zero_remaining_pages(struct io_ctl *io_ctl)
 {
 	/*
 	 * If we're not on the boundary we know we've modified the page and we
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 8f2613f..7fdb2c3 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -110,4 +110,36 @@ int btrfs_return_cluster_to_free_space(
 			       struct btrfs_free_cluster *cluster);
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			   u64 *trimmed, u64 start, u64 end, u64 minlen);
+
+struct io_ctl {
+	void *cur, *orig;
+	struct page *page;
+	struct page **pages;
+	struct btrfs_root *root;
+	unsigned long size;
+	int index;
+	int num_pages;
+	unsigned check_crcs:1;
+};
+
+int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
+		struct btrfs_root *root);
+void io_ctl_free(struct io_ctl *io_ctl);
+void io_ctl_unmap_page(struct io_ctl *io_ctl);
+void io_ctl_map_page(struct io_ctl *io_ctl, int clear);
+void io_ctl_drop_pages(struct io_ctl *io_ctl);
+int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
+			 int uptodate);
+void io_ctl_set_bytes(struct io_ctl *io_ctl, void *data, unsigned long len);
+void io_ctl_get_bytes(struct io_ctl *io_ctl, void *data, unsigned long len);
+void io_ctl_set_u64(struct io_ctl *io_ctl, u64 val);
+u64 io_ctl_get_u64(struct io_ctl *io_ctl);
+void io_ctl_set_u32(struct io_ctl *io_ctl, u32 val);
+u32 io_ctl_get_u32(struct io_ctl *io_ctl);
+void io_ctl_set_u16(struct io_ctl *io_ctl, u16 val);
+u16 io_ctl_get_u16(struct io_ctl *io_ctl);
+void io_ctl_set_u8(struct io_ctl *io_ctl, u8 val);
+u8 io_ctl_get_u8(struct io_ctl *io_ctl);
+void io_ctl_zero_remaining_pages(struct io_ctl *io_ctl);
+
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cbeb2e3..b5d82da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1809,7 +1809,8 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	}
 	ret = 0;
 out:
-	if (root != root->fs_info->tree_root)
+	if (root != root->fs_info->tree_root ||
+	    inode->i_ino == BTRFS_DROPTREE_INO_OBJECTID)
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (trans) {
 		if (nolock)
-- 
1.7.3.4

