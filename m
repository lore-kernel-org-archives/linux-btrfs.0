Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35862 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdJTB7R (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 21:59:17 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/7] btrfs-progs: mkfs/rootdir: Use over-reserve method to make size estimate easier
Date: Fri, 20 Oct 2017 09:59:02 +0800
Message-Id: <20171020015907.25430-3-wqu@suse.com>
In-Reply-To: <20171020015907.25430-1-wqu@suse.com>
References: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use an easier method to calculate the estimate device for mkfs.btrfs
--rootdir.

The new method will over-estimate, but should ensure we won't encounter
ENOSPC.

It relies on the following data to estimate:
1) number of inodes
   for metadata chunk size
2) rounded up data size of each regular inode
   for data chunk size.

Total meta chunk size = round_up(nr_inode * (PATH_MAX * 3 + sectorsize),
min_chunk_size) * profile_multiplier

PATH_MAX is the maximum size possible for INODE_REF/DIR_INDEX/DIR_ITEM.
Sectorsize is the maximum size possible for inline extent.
min_chunk_size is 8M for SINGLE, and 32M for DUP, get from
btrfs_alloc_chunk().
profile_multiplier is 1 for Single, 2 for DUP.

Total data chunk size is much easier.
Total data chunk size = round_up(total_data_usage, min_chunk_size) *
profile_multiplier

Total_data_usage is the sum of *rounded up* size of each regular inode
use.
min_chunk_size is 8M for SINGLE, 64M for DUP, get from
btrfS_alloc_chunk().
Same profile_multiplier for meta.

This over-estimate calculate is, of course, over-estimate.
But since we will later shrink the fs to its real usage, it doesn't
matter much now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c    | 109 ++++++++++++++++++++++++++--------------------------
 mkfs/rootdir.c | 119 +++++++++++++++++++++++++++++++++++++++------------------
 mkfs/rootdir.h |   4 +-
 3 files changed, 139 insertions(+), 93 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 5b8de6f690bb..1355089505ca 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -693,8 +693,6 @@ int main(int argc, char **argv)
 	int force_overwrite = 0;
 	char *source_dir = NULL;
 	int source_dir_set = 0;
-	u64 num_of_meta_chunks = 0;
-	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
 	u64 min_dev_size;
 	int dev_cnt = 0;
@@ -909,6 +907,34 @@ int main(int argc, char **argv)
 
 	min_dev_size = btrfs_min_dev_size(nodesize, mixed, metadata_profile,
 					  data_profile);
+	/*
+	 * Enlarge the destination file or create new one, using the
+	 * size calculated from source dir.
+	 *
+	 * This must be done before minimal device size check.
+	 */
+	if (source_dir_set) {
+		fd = open(file, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR | S_IRGRP |
+			  S_IWGRP | S_IROTH);
+		if (fd < 0) {
+			error("unable to open %s: %s", file, strerror(errno));
+			goto error;
+		}
+
+		source_dir_size = btrfs_mkfs_size_dir(source_dir, sectorsize,
+				min_dev_size, metadata_profile, data_profile);
+		if (block_count < source_dir_size)
+			block_count = source_dir_size;
+		ret = zero_output_file(fd, block_count);
+		if (ret) {
+			error("unable to zero the output file");
+			close(fd);
+			goto error;
+		}
+		/* our "device" is the new image file */
+		dev_block_count = block_count;
+		close(fd);
+	}
 	/* Check device/block_count after the nodesize is determined */
 	if (block_count && block_count < min_dev_size) {
 		error("size %llu is too small to make a usable filesystem",
@@ -942,51 +968,28 @@ int main(int argc, char **argv)
 
 	dev_cnt--;
 
-	if (!source_dir_set) {
-		/*
-		 * open without O_EXCL so that the problem should not
-		 * occur by the following processing.
-		 * (btrfs_register_one_device() fails if O_EXCL is on)
-		 */
-		fd = open(file, O_RDWR);
-		if (fd < 0) {
-			error("unable to open %s: %s", file, strerror(errno));
-			goto error;
-		}
-		ret = btrfs_prepare_device(fd, file, &dev_block_count,
-				block_count,
-				(zero_end ? PREP_DEVICE_ZERO_END : 0) |
-				(discard ? PREP_DEVICE_DISCARD : 0) |
-				(verbose ? PREP_DEVICE_VERBOSE : 0));
-		if (ret) {
-			goto error;
-		}
-		if (block_count && block_count > dev_block_count) {
-			error("%s is smaller than requested size, expected %llu, found %llu",
-					file,
-					(unsigned long long)block_count,
-					(unsigned long long)dev_block_count);
-			goto error;
-		}
-	} else {
-		fd = open(file, O_CREAT | O_RDWR,
-				S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
-		if (fd < 0) {
-			error("unable to open %s: %s", file, strerror(errno));
-			goto error;
-		}
-
-		source_dir_size = btrfs_mkfs_size_dir(source_dir, sectorsize,
-					&num_of_meta_chunks, &size_of_data);
-		if(block_count < source_dir_size)
-			block_count = source_dir_size;
-		ret = zero_output_file(fd, block_count);
-		if (ret) {
-			error("unable to zero the output file");
-			goto error;
-		}
-		/* our "device" is the new image file */
-		dev_block_count = block_count;
+	/*
+	 * open without O_EXCL so that the problem should not
+	 * occur by the following processing.
+	 * (btrfs_register_one_device() fails if O_EXCL is on)
+	 */
+	fd = open(file, O_RDWR);
+	if (fd < 0) {
+		error("unable to open %s: %s", file, strerror(errno));
+		goto error;
+	}
+	ret = btrfs_prepare_device(fd, file, &dev_block_count,
+			block_count,
+			(zero_end ? PREP_DEVICE_ZERO_END : 0) |
+			(discard ? PREP_DEVICE_DISCARD : 0) |
+			(verbose ? PREP_DEVICE_VERBOSE : 0));
+	if (ret)
+		goto error;
+	if (block_count && block_count > dev_block_count) {
+		error("%s is smaller than requested size, expected %llu, found %llu",
+		      file, (unsigned long long)block_count,
+		      (unsigned long long)dev_block_count);
+		goto error;
 	}
 
 	/* To create the first block group and chunk 0 in make_btrfs */
@@ -1112,13 +1115,11 @@ int main(int argc, char **argv)
 	}
 
 raid_groups:
-	if (!source_dir_set) {
-		ret = create_raid_groups(trans, root, data_profile,
-				 metadata_profile, mixed, &allocation);
-		if (ret) {
-			error("unable to create raid groups: %d", ret);
-			goto out;
-		}
+	ret = create_raid_groups(trans, root, data_profile,
+			 metadata_profile, mixed, &allocation);
+	if (ret) {
+		error("unable to create raid groups: %d", ret);
+		goto out;
 	}
 
 	ret = create_tree(trans, root, BTRFS_DATA_RELOC_TREE_OBJECTID);
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 83a3191d2bd7..99022afaa030 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -32,19 +32,29 @@
 #include "transaction.h"
 #include "utils.h"
 #include "mkfs/rootdir.h"
+#include "mkfs/common.h"
 #include "send-utils.h"
 
-/*
- * This ignores symlinks with unreadable targets and subdirs that can't
- * be read.  It's a best-effort to give a rough estimate of the size of
- * a subdir.  It doesn't guarantee that prepopulating btrfs from this
- * tree won't still run out of space.
- */
-static u64 global_total_size;
-static u64 fs_block_size;
+static u32 fs_block_size;
 
 static u64 index_cnt = 2;
 
+/*
+ * Size estimate will be done using the following data:
+ * 1) Number of inodes
+ *    Since we will later shrink the fs, over-estimate is completely fine here
+ *    as long as our estimate ensure we can populate the image without ENOSPC.
+ *    So we only records how many inodes there is, and use the maximum space
+ *    usage for every inode.
+ *
+ * 2) Data space each (regular) inode uses
+ *    To estimate data chunk size.
+ *    Don't care if it can fit as inline extent.
+ *    Always round them up to sectorsize.
+ */
+static u64 ftw_meta_nr_inode;
+static u64 ftw_data_size;
+
 static int add_directory_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, u64 objectid,
 			       ino_t parent_inum, const char *name,
@@ -684,52 +694,87 @@ out:
 static int ftw_add_entry_size(const char *fpath, const struct stat *st,
 			      int type)
 {
-	if (type == FTW_F || type == FTW_D)
-		global_total_size += round_up(st->st_size, fs_block_size);
+	/*
+	 * Failed to read dir, mostly due to EPERM.
+	 * Abort ASAP, so we don't need to populate the fs
+	 */
+	if (type == FTW_DNR || type == FTW_NS)
+		return -EPERM;
+
+	if (S_ISREG(st->st_mode))
+		ftw_data_size += round_up(st->st_size, fs_block_size);
+	ftw_meta_nr_inode++;
 
 	return 0;
 }
 
-u64 btrfs_mkfs_size_dir(const char *dir_name, u64 sectorsize,
-			u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret)
+u64 btrfs_mkfs_size_dir(const char *dir_name, u32 sectorsize, u64 min_dev_size,
+			u64 meta_profile, u64 data_profile)
 {
-	u64 dir_size = 0;
 	u64 total_size = 0;
 	int ret;
-	u64 default_chunk_size = SZ_8M;
-	u64 allocated_meta_size = SZ_8M;
-	u64 allocated_total_size = 20 * SZ_1M;	/* 20MB */
-	u64 num_of_meta_chunks = 0;
-	u64 num_of_data_chunks = 0;
-	u64 num_of_allocated_meta_chunks =
-			allocated_meta_size / default_chunk_size;
-
-	global_total_size = 0;
+
+	u64 meta_size = 0;	/* Based on @ftw_meta_nr_inode */
+	u64 meta_chunk_size = 0;/* Based on @meta_size */
+	u64 data_chunk_size = 0;/* Based on @ftw_data_size */
+
+	u64 meta_threshold = SZ_8M;
+	u64 data_threshold = SZ_8M;
+
+	float data_multipler = 1;
+	float meta_multipler = 1;
+
 	fs_block_size = sectorsize;
+	ftw_data_size = 0;
+	ftw_meta_nr_inode = 0;
 	ret = ftw(dir_name, ftw_add_entry_size, 10);
-	dir_size = global_total_size;
 	if (ret < 0) {
 		error("ftw subdir walk of %s failed: %s", dir_name,
 			strerror(errno));
 		exit(1);
 	}
 
-	num_of_data_chunks = (dir_size + default_chunk_size - 1) /
-		default_chunk_size;
 
-	num_of_meta_chunks = (dir_size / 2) / default_chunk_size;
-	if (((dir_size / 2) % default_chunk_size) != 0)
-		num_of_meta_chunks++;
-	if (num_of_meta_chunks <= num_of_allocated_meta_chunks)
-		num_of_meta_chunks = 0;
-	else
-		num_of_meta_chunks -= num_of_allocated_meta_chunks;
+	/*
+	 * Maximum metadata useage for every inode, which will be PATH_MAX
+	 * for the following items:
+	 * 1) DIR_ITEM
+	 * 2) DIR_INDEX
+	 * 3) INODE_REF
+	 *
+	 * Plus possible inline extent size, which is sectorsize.
+	 *
+	 * And finally, allow metadata usage to increase with data size.
+	 * Follow the old kernel 8:1 data:meta ratio.
+	 * This is especially important for --rootdir, as the file extent size
+	 * up limit is 1M, instead of 128M in kernel.
+	 * This can bump meta usage easily.
+	 */
+	meta_size = ftw_meta_nr_inode * (PATH_MAX * 3 + sectorsize) +
+		    ftw_data_size / 8;
 
-	total_size = allocated_total_size +
-		     (num_of_data_chunks * default_chunk_size) +
-		     (num_of_meta_chunks * default_chunk_size);
+	/* Minimal chunk size from btrfs_alloc_chunk(). */
+	if (meta_profile & BTRFS_BLOCK_GROUP_DUP) {
+		meta_threshold = SZ_32M;
+		meta_multipler = 2;
+	}
+	if (data_profile & BTRFS_BLOCK_GROUP_DUP) {
+		data_threshold = SZ_64M;
+		data_multipler = 2;
+	}
 
-	*num_of_meta_chunks_ret = num_of_meta_chunks;
-	*size_of_data_ret = num_of_data_chunks * default_chunk_size;
+	/*
+	 * Only when the usage is larger than the minimal chunk size (threshold)
+	 * we need to allocate new chunk, or the initial chunk in the image is
+	 * large enough.
+	 */
+	if (meta_size > meta_threshold)
+		meta_chunk_size = (round_up(meta_size, meta_threshold) -
+				   meta_threshold) * meta_multipler;
+	if (ftw_data_size > data_threshold)
+		data_chunk_size = (round_up(ftw_data_size, data_threshold) -
+				   data_threshold) * data_multipler;
+
+	total_size = data_chunk_size + meta_chunk_size + min_dev_size;
 	return total_size;
 }
diff --git a/mkfs/rootdir.h b/mkfs/rootdir.h
index a557bd183f7b..75169f37e026 100644
--- a/mkfs/rootdir.h
+++ b/mkfs/rootdir.h
@@ -27,6 +27,6 @@ struct directory_name_entry {
 
 int btrfs_mkfs_fill_dir(const char *source_dir, struct btrfs_root *root,
 			bool verbose);
-u64 btrfs_mkfs_size_dir(const char *dir_name, u64 sectorsize,
-			u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret);
+u64 btrfs_mkfs_size_dir(const char *dir_name, u32 sectorsize, u64 min_dev_size,
+			u64 meta_profile, u64 data_profile);
 #endif
-- 
2.14.2

