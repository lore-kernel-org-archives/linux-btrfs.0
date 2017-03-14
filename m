Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdCNL4d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 07:56:33 -0400
Date: Tue, 14 Mar 2017 12:55:54 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/7] convert: rollback rework
Message-ID: <20170314115554.GU14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
 <20170314115506.GT14605@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
In-Reply-To: <20170314115506.GT14605@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 14, 2017 at 12:55:06PM +0100, David Sterba wrote:
> On Tue, Mar 14, 2017 at 04:05:02PM +0800, Qu Wenruo wrote:
> > v2:
> >   Abstract the original code to read out data in one btrfs file to
> >   btrfs_read_file().
> >   Use simple_range and btrfs_reserved_ranges[] to cleanup open code.
> > v3:
> >   Rebased to v4.10.
> >   Squash modification in later commits to their previous owner.
> >   Fix a converity report, which doesn't exit when an error is found in
> >   check_convert_image()
> >   Fix a lot of check scripts warning
> 
> I did not mention that explicitly under v2, but the series has been
> merged to devel so incremental changes should be sent from now on. I
> went through the patches almost line by line and fixed things here and
> there. The patchset-to-patchset diff is not large (attached).

Now attached.

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="devel-to-v3.diff"

diff --git a/convert/common.h b/convert/common.h
index 28ca14617303..0d3adeaa96cc 100644
--- a/convert/common.h
+++ b/convert/common.h
@@ -26,33 +26,6 @@
 #include "common-defs.h"
 #include "extent-cache.h"
 
-/*
- * Presents one simple continuous range.
- *
- * For multiple or non-continuous ranges, use extent_cache_tree from
- * extent-cache.c
- */
-struct simple_range {
-	u64 start;
-	u64 len;
-};
-
-const static struct simple_range btrfs_reserved_ranges[] = {
-	{0, SZ_1M},
-	{BTRFS_SB_MIRROR_OFFSET(1), SZ_64K},
-	{BTRFS_SB_MIRROR_OFFSET(2), SZ_64K}
-};
-
-/*
- * Simple range functions
- *
- * Get range end (exclusive)
- */
-static inline u64 range_end(const struct simple_range *range)
-{
-	return (range->start + range->len);
-}
-
 struct btrfs_mkfs_config;
 
 struct btrfs_convert_context {
diff --git a/convert/main.c b/convert/main.c
index e81a1a29a755..73c9d889ac27 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -17,8 +17,10 @@
  */
 
 /*
- * btrfs convert design:
+ * Btrfs convert design:
+ *
  * The overall design of btrfs convert is like the following:
+ *
  * |<------------------Old fs----------------------------->|
  * |<- used ->| |<- used ->|                    |<- used ->|
  *                           ||
@@ -29,39 +31,43 @@
  *
  * ODC    = Old data chunk, btrfs chunks containing old fs data
  *          Mapped 1:1 (logical address == device offset)
- * Old-FE = file extents points to old fs.
+ * Old-FE = file extents pointing to old fs.
  *
  * So old fs used space is (mostly) kept as is, while btrfs will insert
- * its chunk(Data/Meta/Sys) into large enough free space.
- * In this way, we can create different profiles for meta/data for converted fs.
+ * its chunk (Data/Meta/Sys) into large enough free space.
+ * In this way, we can create different profiles for metadata/data for
+ * converted fs.
  *
- * The DIRTY work is, we must reserve and relocate 3 ranges for btrfs:
- * [0, 1M), [btrfs_sb_offset(1), +64K), [btrfs_sb_offset(2), +64K)
+ * We must reserve and relocate 3 ranges for btrfs:
+ * * [0, 1M)                    - area never used for any data except the first
+ *                                superblock
+ * * [btrfs_sb_offset(1), +64K) - 1st superblock backup copy
+ * * [btrfs_sb_offset(2), +64K) - 2nd, dtto
  *
- * Most work are spent handling corner cases around these reserved ranges.
+ * Most work is spent handling corner cases around these reserved ranges.
  *
  * Detailed workflow is:
  * 1)   Scan old fs used space and calculate data chunk layout
  * 1.1) Scan old fs
- *      We can a map of used space of old fs
+ *      We can a map used space of old fs
  *
- * 1.2) Calculate data chunk layout <<< Complex work
- *      New data chunks must meet 3 conditions using result from 1.1)
+ * 1.2) Calculate data chunk layout - this is the hard part
+ *      New data chunks must meet 3 conditions using result fomr 1.1
  *      a. Large enough to be a chunk
- *      b. Doesn't cover reserved ranges
+ *      b. Doesn't intersect reserved ranges
  *      c. Covers all the remaining old fs used space
  *
- *      XXX: This can be simplified if we don't need to handle backup supers
+ *      NOTE: This can be simplified if we don't need to handle backup supers
  *
- * 1.3) Calculate usable space for btrfs new chunks
- *      Btrfs chunk usable space must meet 3 conditions using result from 1.2)
+ * 1.3) Calculate usable space for new btrfs chunks
+ *      Btrfs chunk usable space must meet 3 conditions using result from 1.2
  *      a. Large enough to be a chunk
- *      b. Doesn't cover reserved ranges
- *      c. Doesn't cover any data chunks in 1.1)
+ *      b. Doesn't intersect reserved ranges
+ *      c. Doesn't cover any data chunks in 1.1
  *
- * 2)   Create basic btrfs
- *      Initial metadata and sys chunks are inserted in the first available
- *      space of result of 1.3)
+ * 2)   Create basic btrfs filesystem structure
+ *      Initial metadata and sys chunks are inserted in the first availabe
+ *      space found in step 1.3
  *      Then insert all data chunks into the basic btrfs
  *
  * 3)   Create convert image
@@ -70,7 +76,8 @@
  *      as reflink source to create old files
  *
  * 4)   Iterate old fs to create files
- *      We just reflink any offset in old fs to new file extents
+ *      We just reflink file extents from old fs to newly created files on
+ *      btrfs.
  */
 
 #include "kerncompat.h"
@@ -211,7 +218,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	 * migrate block will fail as there is already a file extent.
 	 */
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		const struct simple_range *reserved = &btrfs_reserved_ranges[i];
+		struct simple_range *reserved = &btrfs_reserved_ranges[i];
 
 		/*
 		 * |-- reserved --|
@@ -238,7 +245,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	/* Check if we are going to insert regular file extent or hole */
+	/* Check if we are going to insert regular file extent, or hole */
 	cache = search_cache_extent(used, bytenr);
 	if (cache) {
 		if (cache->start <= bytenr) {
@@ -246,7 +253,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 			 * |///////Used///////|
 			 *	|<--insert--->|
 			 *	bytenr
-			 * Regular file extent
+			 * Insert one real file extent
 			 */
 			len = min_t(u64, len, cache->start + cache->size -
 				    bytenr);
@@ -256,7 +263,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 			 *		|//Used//|
 			 *  |<-insert-->|
 			 *  bytenr
-			 * Hole
+			 *  Insert one hole
 			 */
 			len = min(len, cache->start - bytenr);
 			disk_bytenr = 0;
@@ -267,7 +274,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 		 * |//Used//|		|EOF
 		 *	    |<-insert-->|
 		 *	    bytenr
-		 * Hole
+		 * Insert one hole
 		 */
 		disk_bytenr = 0;
 		datacsum = 0;
@@ -313,7 +320,7 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct cache_tree *used,
 				      struct btrfs_inode_item *inode, int fd,
-				      u64 ino, const struct simple_range *range,
+				      u64 ino, struct simple_range *range,
 				      u32 convert_flags)
 {
 	u64 cur_off = range->start;
@@ -416,7 +423,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		const struct simple_range *range = &btrfs_reserved_ranges[i];
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (range->start > total_bytes)
 			return ret;
@@ -425,6 +432,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 		if (ret < 0)
 			return ret;
 	}
+
 	return ret;
 }
 
@@ -601,7 +609,7 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
 	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		const struct simple_range *range = &btrfs_reserved_ranges[i];
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		ret = wipe_one_reserved_range(tree, range->start, range->len,
 					      min_stripe_size, ensure_size);
@@ -1352,9 +1360,8 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 }
 
 /*
- * Read out data of convert image which is in btrfs reserved range.
- *
- * So rollback can just use these data to overwrite these ranges of btrfs
+ * Read out data of convert image which is in btrfs reserved ranges so we can
+ * use them to overwrite the ranges during rollback.
  */
 static int read_reserved_ranges(struct btrfs_root *root, u64 ino,
 				u64 total_bytes, char *reserved_ranges[])
@@ -1363,7 +1370,7 @@ static int read_reserved_ranges(struct btrfs_root *root, u64 ino,
 	int ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		const struct simple_range *range = &btrfs_reserved_ranges[i];
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (range->start + range->len >= total_bytes)
 			break;
@@ -1371,7 +1378,7 @@ static int read_reserved_ranges(struct btrfs_root *root, u64 ino,
 				      reserved_ranges[i]);
 		if (ret < range->len) {
 			error(
-	"failed to read out data of convert image, offset=%llu len=%llu ret=%d",
+	"failed to read data of convert image, offset=%llu len=%llu ret=%d",
 			      range->start, range->len, ret);
 			if (ret >= 0)
 				ret = -EIO;
@@ -1388,7 +1395,7 @@ static bool is_subset_of_reserved_ranges(u64 start, u64 len)
 	bool ret = false;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		const struct simple_range *range = &btrfs_reserved_ranges[i];
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (start >= range->start && start + len <= range_end(range)) {
 			ret = true;
@@ -1427,8 +1434,8 @@ static bool is_chunk_direct_mapped(struct btrfs_fs_info *fs_info, u64 start)
 /*
  * Iterate all file extents of the convert image.
  *
- * All file extents except ones in btrfs_reserved_ranges[] must be mapped 1:1
- * on disk. (Means their file_offset must match their on disk bytenr)
+ * All file extents except ones in btrfs_reserved_ranges must be mapped 1:1
+ * on disk. (Means thier file_offset must match their on disk bytenr)
  *
  * File extents in reserved ranges can be relocated to other place, and in
  * that case we will read them out for later use.
@@ -1449,10 +1456,10 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
 	btrfs_init_path(&path);
 	ret = btrfs_search_slot(NULL, image_root, &key, &path, 0, 0);
 	/*
-	 * It's possible that some fs doesn't store any(including sb)
+	 * It's possible that some fs doesn't store any (including sb)
 	 * data into 0~1M range, and NO_HOLES is enabled.
 	 *
-	 * So only needs to check ret < 0 case
+	 * So we only need to check if ret < 0
 	 */
 	if (ret < 0) {
 		error("failed to iterate file extents at offset 0: %s",
@@ -1510,7 +1517,7 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
 			goto next;
 
 		/*
-		 * Most file extent must be 1:1 mapped, which means 2 things:
+		 * Most file extents must be 1:1 mapped, which means 2 things:
 		 * 1) File extent file offset == disk_bytenr
 		 * 2) That data chunk's logical == chunk's physical
 		 *
@@ -1522,8 +1529,8 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
 		if (file_offset != disk_bytenr ||
 		    !is_chunk_direct_mapped(fs_info, disk_bytenr)) {
 			/*
-			 * Only file extent in btrfs reserved ranges are allow
-			 * non-1:1 mapped
+			 * Only file extent in btrfs reserved ranges are
+			 * allowed to be non-1:1 mapped
 			 */
 			if (!is_subset_of_reserved_ranges(file_offset,
 							ram_bytes)) {
@@ -1549,13 +1556,13 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
 	 */
 	if (!ret && !btrfs_fs_incompat(fs_info, NO_HOLES)) {
 		if (checked_bytes != total_size) {
+			ret = -EINVAL;
 			error("inode %llu has some file extents not checked",
 				ino);
-			return -EINVAL;
 		}
 	}
 
-	/* So far so good, read out old data located in btrfs reserved ranges */
+	/* So far so good, read old data located in btrfs reserved ranges */
 	ret = read_reserved_ranges(image_root, ino, total_size,
 				   reserved_ranges);
 	return ret;
@@ -1578,7 +1585,7 @@ static int check_convert_image(struct btrfs_root *image_root, u64 ino,
  * |   RSV 1   |  | Old  |   |    RSV 2  | | Old  | |   RSV 3   |
  * |   0~1M    |  | Fs   |   | SB2 + 64K | | Fs   | | SB3 + 64K |
  *
- * On the other hande, the converted fs image in btrfs is a completely
+ * On the other hande, the converted fs image in btrfs is a completely 
  * valid old fs.
  *
  * |<-----------------Converted fs image in btrfs-------------------->|
@@ -1613,7 +1620,7 @@ static int do_rollback(const char *devname)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		const struct simple_range *range = &btrfs_reserved_ranges[i];
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		reserved_ranges[i] = calloc(1, range->len);
 		if (!reserved_ranges[i]) {
@@ -1636,16 +1643,14 @@ static int do_rollback(const char *devname)
 	}
 	fs_info = root->fs_info;
 
-
 	/*
 	 * Search root backref first, or after subvolume deletion (orphan),
 	 * we can still rollback the image.
 	 */
-	btrfs_init_path(&path);
-
 	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
 	key.type = BTRFS_ROOT_BACKREF_KEY;
 	key.offset = BTRFS_FS_TREE_OBJECTID;
+	btrfs_init_path(&path);
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, 0);
 	btrfs_release_path(&path);
 	if (ret > 0) {
@@ -1662,7 +1667,6 @@ static int do_rollback(const char *devname)
 	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = (u64)-1;
-
 	image_root = btrfs_read_fs_root(fs_info, &key);
 	if (IS_ERR(image_root)) {
 		ret = PTR_ERR(image_root);
@@ -1675,6 +1679,7 @@ static int do_rollback(const char *devname)
 	root_dir = btrfs_root_dirid(&image_root->root_item);
 	dir = btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
 			image_name, strlen(image_name), 0);
+
 	if (!dir || IS_ERR(dir)) {
 		btrfs_release_path(&path);
 		if (dir)
@@ -1692,6 +1697,7 @@ static int do_rollback(const char *devname)
 	ino = key.objectid;
 
 	ret = btrfs_lookup_inode(NULL, image_root, &path, &key, 0);
+
 	if (ret < 0) {
 		btrfs_release_path(&path);
 		error("unable to find inode %llu: %s", ino, strerror(-ret));
@@ -1703,8 +1709,7 @@ static int do_rollback(const char *devname)
 	btrfs_release_path(&path);
 
 	/* Check if we can rollback the image */
-	ret = check_convert_image(image_root, ino, total_bytes,
-				  reserved_ranges);
+	ret = check_convert_image(image_root, ino, total_bytes, reserved_ranges);
 	if (ret < 0) {
 		error("old fs image can't be rolled back");
 		goto close_fs;
@@ -1715,19 +1720,21 @@ static int do_rollback(const char *devname)
 	if (ret)
 		goto free_mem;
 
- 	/*
+	/*
 	 * Everything is OK, just write back old fs data into btrfs reserved
 	 * ranges
 	 *
 	 * Here, we starts from the backup blocks first, so if something goes
 	 * wrong, the fs is still mountable
 	 */
+
 	for (i = ARRAY_SIZE(btrfs_reserved_ranges) - 1; i >= 0; i--) {
 		u64 real_size;
-		const struct simple_range *range = &btrfs_reserved_ranges[i];
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (range_end(range) >= fsize)
 			continue;
+
 		real_size = min(range_end(range), fsize) - range->start;
 		ret = pwrite(fd, reserved_ranges[i], real_size, range->start);
 		if (ret < real_size) {
@@ -1741,6 +1748,7 @@ static int do_rollback(const char *devname)
 		}
 		ret = 0;
 	}
+
 free_mem:
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++)
 		free(reserved_ranges[i]);
diff --git a/convert/source-fs.c b/convert/source-fs.c
index 9268639d5d7e..7cf515b0325d 100644
--- a/convert/source-fs.c
+++ b/convert/source-fs.c
@@ -22,6 +22,12 @@
 #include "convert/common.h"
 #include "convert/source-fs.h"
 
+struct simple_range btrfs_reserved_ranges[3] = {
+	{ 0,			     SZ_1M },
+	{ BTRFS_SB_MIRROR_OFFSET(1), SZ_64K },
+	{ BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
+};
+
 static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 {
 	int i;
@@ -181,9 +187,6 @@ int read_disk_extent(struct btrfs_root *root, u64 bytenr,
  * The special point is, old disk_block can point to a reserved range.
  * So here, we don't use disk_block directly but search convert_root
  * to get the real disk_bytenr.
- *
- * TODO: Better extract this function to btrfs_reflink(), in fact we are just
- * reflinking from convert_image of convert_root.
  */
 int record_file_blocks(struct blk_iterate_data *data,
 			      u64 file_block, u64 disk_block, u64 num_blocks)
diff --git a/convert/source-fs.h b/convert/source-fs.h
index f3f96d07b9b8..9f611150e504 100644
--- a/convert/source-fs.h
+++ b/convert/source-fs.h
@@ -21,6 +21,19 @@
 
 #define CONV_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
+/*
+ * Reresents a simple contiguous range.
+ *
+ * For multiple or non-contiguous ranges, use extent_cache_tree from
+ * extent-cache.c
+ */
+struct simple_range {
+	u64 start;
+	u64 len;
+};
+
+extern struct simple_range btrfs_reserved_ranges[3];
+
 struct task_info;
 
 struct task_ctx {
@@ -89,4 +102,14 @@ int read_disk_extent(struct btrfs_root *root, u64 bytenr,
 int record_file_blocks(struct blk_iterate_data *data,
 			      u64 file_block, u64 disk_block, u64 num_blocks);
 
+/*
+ * Simple range functions
+ *
+ * Get range end (exclusive)
+ */
+static inline u64 range_end(struct simple_range *range)
+{
+	return (range->start + range->len);
+}
+
 #endif
diff --git a/ctree.h b/ctree.h
index 63d6d04704e9..91d55557f91c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2778,4 +2778,5 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
 		     u64 ino, u64 offset, u64 len);
 int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		    char *dest);
+
 #endif
diff --git a/file.c b/file.c
index 06c1e2dde49e..bf31cceffd97 100644
--- a/file.c
+++ b/file.c
@@ -173,12 +173,12 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
  * @dest:  where data will be stored
  *
  * NOTE:
- * 1) compression data is not supported yet.
+ * 1) compression data is not supported yet
  * 2) @start and @len must be aligned to sectorsize
  * 3) data read out is also aligned to sectorsize, not truncated to inode size
  *
  * Return < 0 for fatal error during read.
- * Otherwise return the number of suceeful read out data.
+ * Otherwise return the number of succesfully read data in bytes.
  */
 int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		    char *dest)
@@ -210,8 +210,7 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		goto out;
 
 	if (ret > 0) {
-		ret = btrfs_previous_item(root, &path, ino,
-					  BTRFS_EXTENT_DATA_KEY);
+		ret = btrfs_previous_item(root, &path, ino, BTRFS_EXTENT_DATA_KEY);
 		if (ret > 0) {
 			ret = -ENOENT;
 			goto out;
@@ -284,8 +283,8 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi) +
 			      btrfs_file_extent_offset(leaf, fi);
 		read_len_ret = read_len;
-		ret = read_extent_data(root, dest + read_start - start,
-					disk_bytenr, &read_len_ret, 0);
+		ret = read_extent_data(root, dest + read_start - start, disk_bytenr,
+				       &read_len_ret, 0);
 		if (ret < 0)
 			break;
 		/* Short read, something went wrong */

--mP3DRpeJDSE+ciuQ--
