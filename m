From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: [PATCH 3/4] btrfs-convert: permit support for non-ext2 FSs
Date: Sat, 20 Mar 2010 00:27:12 -0400
Message-ID: <20100320042712.GA17110@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Filesystems need to provide a function open_blah that fills a struct
convert_fs with some information and three function pointers.
The function pointers are:
- cache_free_extents, which takes a struct extent_io_tree and marks all
  extents not being used by the filesystem as DIRTY
- copy_inodes, which copies the contents of the filesystem into a
  btrfs_root using CoW.
- close
There's a void* in struct convert_fs for private use by the filesystem.

libblkid is used to determine the filesystem.
---
 Makefile  |    2 +-
 convert.c |  184 +++++++++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 126 insertions(+), 60 deletions(-)

diff --git a/Makefile b/Makefile
index 525676e..755cc24 100644
--- a/Makefile
+++ b/Makefile
@@ -75,7 +75,7 @@ quick-test: $(objects) quick-test.o
 	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
 convert: $(objects) convert.o
-	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
+	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lblkid $(LDFLAGS) $(LIBS)
 
 ioctl-test: $(objects) ioctl-test.o
 	gcc $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
diff --git a/convert.c b/convert.c
index bd91990..6dfcb97 100644
--- a/convert.c
+++ b/convert.c
@@ -31,6 +31,7 @@
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <linux/fs.h>
+#include <blkid/blkid.h>
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -42,9 +43,26 @@
 #include <ext2fs/ext2fs.h>
 #include <ext2fs/ext2_ext_attr.h>
 
+struct convert_fs {
+	u64 total_bytes;
+	u64 blocksize;
+	const char *label;
+
+	/* Close the FS */
+	int (*close)(struct convert_fs *fs);
+	/* Mark free extents as dirty */
+	int (*cache_free_extents)(struct convert_fs *fs,
+				  struct extent_io_tree *tree);
+	/* Copy everything over */
+	int (*copy_inodes)(struct convert_fs *fs, struct btrfs_root *root,
+			   int datacsum, int packing, int noxattr);
+
+	void *privdata;
+};
+
 #define INO_OFFSET (BTRFS_FIRST_FREE_OBJECTID - EXT2_ROOT_INO)
 #define STRIPE_LEN (64 * 1024)
-#define EXT2_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
+#define ORIG_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
 /*
  * Open Ext2fs in readonly mode, read block allocation bitmap and
@@ -89,15 +107,16 @@ fail:
 	return -1;
 }
 
-static int close_ext2fs(ext2_filsys fs)
+static int ext2_close(struct convert_fs *fs)
 {
-	ext2fs_close(fs);
+	ext2fs_close((ext2_filsys)fs->privdata);
 	return 0;
 }
 
-static int ext2_cache_free_extents(ext2_filsys ext2_fs,
+static int ext2_cache_free_extents(struct convert_fs *fs,
 				   struct extent_io_tree *free_tree)
 {
+	ext2_filsys ext2_fs = fs->privdata;
 	int ret = 0;
 	blk_t block;
 	u64 bytenr;
@@ -117,19 +136,18 @@ static int ext2_cache_free_extents(ext2_filsys ext2_fs,
 }
 
 /* mark btrfs-reserved blocks as used */
-static void adjust_free_extents(ext2_filsys ext2_fs,
+static void adjust_free_extents(struct convert_fs *fs,
 				struct extent_io_tree *free_tree)
 {
 	int i;
 	u64 bytenr;
-	u64 blocksize = ext2_fs->blocksize;
 
 	clear_extent_dirty(free_tree, 0, BTRFS_SUPER_INFO_OFFSET - 1, 0);
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		bytenr &= ~((u64)STRIPE_LEN - 1);
-		if (bytenr >= blocksize * ext2_fs->super->s_blocks_count)
+		if (bytenr >= fs->total_bytes)
 			break;
 		clear_extent_dirty(free_tree, bytenr, bytenr + STRIPE_LEN - 1,
 				   0);
@@ -1373,9 +1391,10 @@ fail:
 /*
  * scan ext2's inode bitmap and copy all used inode.
  */
-static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
-		       int datacsum, int packing, int noxattr)
+static int ext2_copy_inodes(struct convert_fs *fs, struct btrfs_root *root,
+			    int datacsum, int packing, int noxattr)
 {
+	ext2_filsys ext2_fs = fs->privdata;
 	int ret;
 	errcode_t err;
 	ext2_inode_scan ext2_scan;
@@ -1426,8 +1445,8 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 }
 
 /*
- * Construct a range of ext2fs image file.
- * scan block allocation bitmap, find all blocks used by the ext2fs
+ * Construct a range of the image file.
+ * scan block allocation bitmap, find all blocks used by the filesystem
  * in this range and create file extents that point to these blocks.
  *
  * Note: Before calling the function, no file extent points to blocks
@@ -1465,10 +1484,10 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	return ret;
 }
 /*
- * Create the ext2fs image file.
+ * Create the image file.
  */
-static int create_ext2_image(struct btrfs_root *root, const char *name,
-			     struct extent_io_tree *orig_free_tree)
+static int create_image(struct btrfs_root *root, const char *name,
+			struct extent_io_tree *orig_free_tree)
 {
 	int ret;
 	struct btrfs_key key;
@@ -1620,7 +1639,7 @@ next:
 	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
 	ret = btrfs_insert_dir_item(trans, root, name, strlen(name),
 				    btrfs_root_dirid(&root->root_item),
-				    &location, EXT2_FT_REG_FILE, objectid);
+				    &location, BTRFS_FT_REG_FILE, objectid);
 	if (ret)
 		goto fail;
 	ret = btrfs_insert_inode_ref(trans, root, name, strlen(name),
@@ -1996,8 +2015,8 @@ static int init_btrfs(struct btrfs_root *root)
 	btrfs_set_root_dirid(&fs_info->fs_root->root_item,
 			     BTRFS_FIRST_FREE_OBJECTID);
 
-	/* subvol for ext2 image file */
-	ret = create_subvol(trans, root, EXT2_IMAGE_SUBVOL_OBJECTID);
+	/* subvol for image file */
+	ret = create_subvol(trans, root, ORIG_IMAGE_SUBVOL_OBJECTID);
 	BUG_ON(ret);
 	/* subvol for data relocation */
 	ret = create_subvol(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
@@ -2273,7 +2292,7 @@ fail:
 }
 
 static int relocate_extents_range(struct btrfs_root *fs_root,
-				  struct btrfs_root *ext2_root,
+				  struct btrfs_root *image_root,
 				  u64 start_byte, u64 end_byte)
 {
 	struct btrfs_fs_info *info = fs_root->fs_info;
@@ -2320,7 +2339,7 @@ static int relocate_extents_range(struct btrfs_root *fs_root,
 	}
 	btrfs_release_path(extent_root, &path);
 again:
-	cur_root = (pass % 2 == 0) ? ext2_root : fs_root;
+	cur_root = (pass % 2 == 0) ? image_root : fs_root;
 	num_extents = 0;
 
 	trans = btrfs_start_transaction(cur_root, 1);
@@ -2428,7 +2447,7 @@ fail:
  * relocate data in system chunk
  */
 static int cleanup_sys_chunk(struct btrfs_root *fs_root,
-			     struct btrfs_root *ext2_root)
+			     struct btrfs_root *image_root)
 {
 	struct btrfs_block_group_cache *cache;
 	int i, ret = 0;
@@ -2442,7 +2461,7 @@ static int cleanup_sys_chunk(struct btrfs_root *fs_root,
 
 		end_byte = cache->key.objectid + cache->key.offset;
 		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
-			ret = relocate_extents_range(fs_root, ext2_root,
+			ret = relocate_extents_range(fs_root, image_root,
 						     cache->key.objectid,
 						     end_byte);
 			if (ret)
@@ -2454,7 +2473,7 @@ static int cleanup_sys_chunk(struct btrfs_root *fs_root,
 		offset = btrfs_sb_offset(i);
 		offset &= ~((u64)STRIPE_LEN - 1);
 
-		ret = relocate_extents_range(fs_root, ext2_root,
+		ret = relocate_extents_range(fs_root, image_root,
 					     offset, offset + STRIPE_LEN);
 		if (ret)
 			goto fail;
@@ -2567,6 +2586,55 @@ static int copy_dirtiness(struct extent_io_tree *out,
 	return 0;
 }
 
+int ext2_open(struct convert_fs *fs, const char *name)
+{
+	int ret;
+	ext2_filsys ext2_fs;
+	ret = open_ext2fs(name, &ext2_fs);
+	if (ret)
+		return ret;
+
+	fs->privdata = ext2_fs;
+	fs->blocksize = ext2_fs->blocksize;
+	fs->label = ext2_fs->super->s_volume_name;
+	fs->total_bytes = ext2_fs->super->s_blocks_count * fs->blocksize;
+
+	fs->cache_free_extents = ext2_cache_free_extents;
+	fs->close = ext2_close;
+	fs->copy_inodes = ext2_copy_inodes;
+
+	return 0;
+}
+
+static int open_fs(struct convert_fs *fs, const char *devname)
+{
+	static struct {
+		const char *name; /* must match libblkid */
+		int (*open)(struct convert_fs *fs, const char *name);
+	} convert_fs_types[] = {
+		{"ext2", ext2_open},
+		{"ext3", ext2_open},
+		{"ext4", ext2_open},
+		{"ext4dev", ext2_open},
+	};
+
+	int i;
+	char *type = blkid_get_tag_value(NULL, "TYPE", devname);
+	if (!type) {
+		fprintf(stderr, "unrecognized filesystem type\n");
+		return -1;
+	}
+	for (i = 0; i < ARRAY_SIZE(convert_fs_types); i++) {
+		if (!strcmp(type, convert_fs_types[i].name)) {
+			free(type);
+			return convert_fs_types[i].open(fs, devname);
+		}
+	}
+	fprintf(stderr, "%s filesystems are not supported\n", type);
+	free(type);
+	return -1;
+}
+
 int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 {
 	int fd, ret;
@@ -2574,31 +2642,27 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	u64 blocks[7];
 	u64 total_bytes;
 	u64 super_bytenr;
-	ext2_filsys ext2_fs;
+	struct convert_fs fs;
 	struct btrfs_root *root;
-	struct btrfs_root *ext2_root;
+	struct btrfs_root *image_root;
 	struct extent_io_tree free_tree;
 	struct extent_io_tree orig_free_tree;
 
 	extent_io_tree_init(&free_tree);
 	extent_io_tree_init(&orig_free_tree);
-	ret = open_ext2fs(devname, &ext2_fs);
+	fs.privdata = NULL;
+	ret = open_fs(&fs, devname);
 	if (ret) {
-		fprintf(stderr, "unable to open the Ext2fs\n");
+		fprintf(stderr, "unable to open the filesystem\n");
 		goto fail;
 	}
-	blocksize = ext2_fs->blocksize;
-	total_bytes = (u64)ext2_fs->super->s_blocks_count * blocksize;
+	blocksize = fs.blocksize;
+	total_bytes = fs.total_bytes;
 	if (blocksize < 4096) {
 		fprintf(stderr, "block size is too small\n");
 		goto fail;
 	}
-	if (!(ext2_fs->super->s_feature_incompat &
-	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
-		fprintf(stderr, "filetype feature is missing\n");
-		goto fail;
-	}
-	ret = ext2_cache_free_extents(ext2_fs, &orig_free_tree);
+	ret = fs.cache_free_extents(&fs, &orig_free_tree);
 	if (ret) {
 		fprintf(stderr, "error during cache_free_extents %d\n", ret);
 		goto fail;
@@ -2611,7 +2675,7 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "error during copy_dirtiness %d\n", ret);
 		goto fail;
 	}
-	adjust_free_extents(ext2_fs, &free_tree);
+	adjust_free_extents(&fs, &free_tree);
 	ret = alloc_blocks(&free_tree, blocks, 7, blocksize);
 	if (ret) {
 		goto fail;
@@ -2622,9 +2686,8 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
-	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 blocks, total_bytes, blocksize, blocksize,
-			 blocksize, blocksize);
+	ret = make_btrfs(fd, devname, fs.label, blocks, total_bytes, blocksize,
+			 blocksize, blocksize, blocksize);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree\n");
 		goto fail;
@@ -2649,25 +2712,25 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		goto fail;
 	}
 	printf("creating btrfs metadata.\n");
-	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr);
+	ret = fs.copy_inodes(&fs, root, datacsum, packing, noxattr);
 	if (ret) {
 		fprintf(stderr, "error during copy_inodes %d\n", ret);
 		goto fail;
 	}
-	printf("creating ext2fs image file.\n");
-	ext2_root = link_subvol(root, "ext2_saved", EXT2_IMAGE_SUBVOL_OBJECTID);
-	if (!ext2_root) {
+	printf("creating image file.\n");
+	image_root = link_subvol(root, "image_saved", ORIG_IMAGE_SUBVOL_OBJECTID);
+	if (!image_root) {
 		fprintf(stderr, "unable to create subvol\n");
 		goto fail;
 	}
-	ret = create_ext2_image(ext2_root, "image", &orig_free_tree);
+	ret = create_image(image_root, "image", &orig_free_tree);
 	if (ret) {
-		fprintf(stderr, "error during create_ext2_image %d\n", ret);
+		fprintf(stderr, "error during create_image %d\n", ret);
 		goto fail;
 	}
 	extent_io_tree_cleanup(&orig_free_tree);
 	printf("cleaning up system chunk.\n");
-	ret = cleanup_sys_chunk(root, ext2_root);
+	ret = cleanup_sys_chunk(root, image_root);
 	if (ret) {
 		fprintf(stderr, "error during cleanup_sys_chunk %d\n", ret);
 		goto fail;
@@ -2677,11 +2740,12 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "error during close_ctree %d\n", ret);
 		goto fail;
 	}
-	close_ext2fs(ext2_fs);
+	fs.close(&fs);
+	fs.privdata = NULL;
 
 	/*
 	 * If this step succeed, we get a mountable btrfs. Otherwise
-	 * the ext2fs is left unchanged.
+	 * the original filesystem is left unchanged.
 	 */
 	ret = migrate_super_block(fd, super_bytenr, blocksize);
 	if (ret) {
@@ -2706,6 +2770,8 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	printf("conversion complete.\n");
 	return 0;
 fail:
+	if (fs.privdata)
+		fs.close(&fs);
 	fprintf(stderr, "conversion aborted.\n");
 	return -1;
 }
@@ -2755,7 +2821,7 @@ int do_rollback(const char *devname, int force)
 	int ret;
 	int i;
 	struct btrfs_root *root;
-	struct btrfs_root *ext2_root;
+	struct btrfs_root *image_root;
 	struct btrfs_root *chunk_root;
 	struct btrfs_dir_item *dir;
 	struct btrfs_inode_item *inode;
@@ -2808,11 +2874,11 @@ int do_rollback(const char *devname, int force)
 
 	btrfs_init_path(&path);
 
-	key.objectid = EXT2_IMAGE_SUBVOL_OBJECTID;
+	key.objectid = ORIG_IMAGE_SUBVOL_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-	ext2_root = btrfs_read_fs_root(root->fs_info, &key);
-	if (!ext2_root || IS_ERR(ext2_root)) {
+	image_root = btrfs_read_fs_root(root->fs_info, &key);
+	if (!image_root || IS_ERR(image_root)) {
 		fprintf(stderr, "unable to open subvol %llu\n",
 			key.objectid);
 		goto fail;
@@ -2820,7 +2886,7 @@ int do_rollback(const char *devname, int force)
 
 	name = "image";
 	root_dir = btrfs_root_dirid(&root->root_item);
-	dir = btrfs_lookup_dir_item(NULL, ext2_root, &path,
+	dir = btrfs_lookup_dir_item(NULL, image_root, &path,
 				   root_dir, name, strlen(name), 0);
 	if (!dir || IS_ERR(dir)) {
 		fprintf(stderr, "unable to find file %s\n", name);
@@ -2828,11 +2894,11 @@ int do_rollback(const char *devname, int force)
 	}
 	leaf = path.nodes[0];
 	btrfs_dir_item_key_to_cpu(leaf, dir, &key);
-	btrfs_release_path(ext2_root, &path);
+	btrfs_release_path(image_root, &path);
 
 	objectid = key.objectid;
 
-	ret = btrfs_lookup_inode(NULL, ext2_root, &path, &key, 0);
+	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
 	if (ret) {
 		fprintf(stderr, "unable to find inode item\n");
 		goto fail;
@@ -2840,15 +2906,15 @@ int do_rollback(const char *devname, int force)
 	leaf = path.nodes[0];
 	inode = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_inode_item);
 	total_bytes = btrfs_inode_size(leaf, inode);
-	btrfs_release_path(ext2_root, &path);
+	btrfs_release_path(image_root, &path);
 
 	key.objectid = objectid;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
-	ret = btrfs_search_slot(NULL, ext2_root, &key, &path, 0, 0);
+	ret = btrfs_search_slot(NULL, image_root, &key, &path, 0, 0);
 	if (ret != 0) {
 		fprintf(stderr, "unable to find first file extent\n");
-		btrfs_release_path(ext2_root, &path);
+		btrfs_release_path(image_root, &path);
 		goto fail;
 	}
 
@@ -2899,7 +2965,7 @@ next_extent:
 		offset += btrfs_file_extent_num_bytes(leaf, fi);
 		path.slots[0]++;
 	}
-	btrfs_release_path(ext2_root, &path);
+	btrfs_release_path(image_root, &path);
 
 	if (offset < total_bytes) {
 		fprintf(stderr, "unable to build extent mapping\n");
@@ -3058,7 +3124,7 @@ static void print_usage(void)
 	printf("\t-d disable data checksum\n");
 	printf("\t-i ignore xattrs and ACLs\n");
 	printf("\t-n disable packing of small files\n");
-	printf("\t-r roll back to ext2fs\n");
+	printf("\t-r roll back to original filesystem\n");
 }
 
 int main(int argc, char *argv[])
-- 
1.6.4.4

