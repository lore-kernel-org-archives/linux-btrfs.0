Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbdIKGgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 02:36:24 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/7] btrfs-progs: mkfs: Rework rootdir option to avoid custom chunk layout
Date: Mon, 11 Sep 2017 15:36:08 +0900
Message-Id: <20170911063612.32114-4-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs --rootdir uses its own custom chunk layout.
This provides the possibility to limit the filesystem to a minimal size.

However this custom chunk allocation has several problems.
The most obvious problem is that it will allocate chunk from device offset
0.
Both kernel and normal mkfs will reserve 0~1M range for each device.

This rework will remove all related custom chunk allocation and size
calculation.
Less code to maintain is always a good thing, especially for minor or
less maintained code.

So all --rootdir operation will result the same result as mkfs.btrfs +
mount + cp. (Same result as mkfs.ext4 -d)

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 mkfs/main.c | 236 +++++++++---------------------------------------------------
 1 file changed, 34 insertions(+), 202 deletions(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index 7592c1fb..0ce1ae26 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -991,53 +991,6 @@ fail_no_dir:
 	goto out;
 }
 
-static int create_chunks(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root, u64 num_of_meta_chunks,
-			 u64 size_of_data,
-			 struct mkfs_allocation *allocation)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 chunk_start;
-	u64 chunk_size;
-	u64 meta_type = BTRFS_BLOCK_GROUP_METADATA;
-	u64 data_type = BTRFS_BLOCK_GROUP_DATA;
-	u64 minimum_data_chunk_size = SZ_8M;
-	u64 i;
-	int ret;
-
-	for (i = 0; i < num_of_meta_chunks; i++) {
-		ret = btrfs_alloc_chunk(trans, fs_info,
-					&chunk_start, &chunk_size, meta_type);
-		if (ret)
-			return ret;
-		ret = btrfs_make_block_group(trans, fs_info, 0,
-					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-					     chunk_start, chunk_size);
-		allocation->metadata += chunk_size;
-		if (ret)
-			return ret;
-		set_extent_dirty(&root->fs_info->free_space_cache,
-				 chunk_start, chunk_start + chunk_size - 1);
-	}
-
-	if (size_of_data < minimum_data_chunk_size)
-		size_of_data = minimum_data_chunk_size;
-
-	ret = btrfs_alloc_data_chunk(trans, fs_info,
-				     &chunk_start, size_of_data, data_type, 0);
-	if (ret)
-		return ret;
-	ret = btrfs_make_block_group(trans, fs_info, 0,
-				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     chunk_start, size_of_data);
-	allocation->data += size_of_data;
-	if (ret)
-		return ret;
-	set_extent_dirty(&root->fs_info->free_space_cache,
-			 chunk_start, chunk_start + size_of_data - 1);
-	return ret;
-}
-
 static int make_image(const char *source_dir, struct btrfs_root *root)
 {
 	int ret;
@@ -1082,86 +1035,6 @@ out:
 	return ret;
 }
 
-/*
- * This ignores symlinks with unreadable targets and subdirs that can't
- * be read.  It's a best-effort to give a rough estimate of the size of
- * a subdir.  It doesn't guarantee that prepopulating btrfs from this
- * tree won't still run out of space.
- */
-static u64 global_total_size;
-static u64 fs_block_size;
-static int ftw_add_entry_size(const char *fpath, const struct stat *st,
-			      int type)
-{
-	if (type == FTW_F || type == FTW_D)
-		global_total_size += round_up(st->st_size, fs_block_size);
-
-	return 0;
-}
-
-static u64 size_sourcedir(const char *dir_name, u64 sectorsize,
-			  u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret)
-{
-	u64 dir_size = 0;
-	u64 total_size = 0;
-	int ret;
-	u64 default_chunk_size = SZ_8M;
-	u64 allocated_meta_size = SZ_8M;
-	u64 allocated_total_size = 20 * SZ_1M;	/* 20MB */
-	u64 num_of_meta_chunks = 0;
-	u64 num_of_data_chunks = 0;
-	u64 num_of_allocated_meta_chunks =
-			allocated_meta_size / default_chunk_size;
-
-	global_total_size = 0;
-	fs_block_size = sectorsize;
-	ret = ftw(dir_name, ftw_add_entry_size, 10);
-	dir_size = global_total_size;
-	if (ret < 0) {
-		error("ftw subdir walk of %s failed: %s", dir_name,
-			strerror(errno));
-		exit(1);
-	}
-
-	num_of_data_chunks = (dir_size + default_chunk_size - 1) /
-		default_chunk_size;
-
-	num_of_meta_chunks = (dir_size / 2) / default_chunk_size;
-	if (((dir_size / 2) % default_chunk_size) != 0)
-		num_of_meta_chunks++;
-	if (num_of_meta_chunks <= num_of_allocated_meta_chunks)
-		num_of_meta_chunks = 0;
-	else
-		num_of_meta_chunks -= num_of_allocated_meta_chunks;
-
-	total_size = allocated_total_size +
-		     (num_of_data_chunks * default_chunk_size) +
-		     (num_of_meta_chunks * default_chunk_size);
-
-	*num_of_meta_chunks_ret = num_of_meta_chunks;
-	*size_of_data_ret = num_of_data_chunks * default_chunk_size;
-	return total_size;
-}
-
-static int zero_output_file(int out_fd, u64 size)
-{
-	int loop_num;
-	u64 location = 0;
-	char buf[4096];
-	int ret = 0, i;
-	ssize_t written;
-
-	memset(buf, 0, 4096);
-	loop_num = size / 4096;
-	for (i = 0; i < loop_num; i++) {
-		written = pwrite64(out_fd, buf, 4096, location);
-		if (written != 4096)
-			ret = -EIO;
-		location += 4096;
-	}
-	return ret;
-}
-
 static int is_ssd(const char *file)
 {
 	blkid_probe probe;
@@ -1432,9 +1305,6 @@ int main(int argc, char **argv)
 	int force_overwrite = 0;
 	char *source_dir = NULL;
 	int source_dir_set = 0;
-	u64 num_of_meta_chunks = 0;
-	u64 size_of_data = 0;
-	u64 source_dir_size = 0;
 	int dev_cnt = 0;
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
@@ -1678,51 +1548,29 @@ int main(int argc, char **argv)
 
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
-		source_dir_size = size_sourcedir(source_dir, sectorsize,
-					     &num_of_meta_chunks, &size_of_data);
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
+			file,
+			(unsigned long long)block_count,
+			(unsigned long long)dev_block_count);
+		goto error;
 	}
 
 	/* To create the first block group and chunk 0 in make_btrfs */
@@ -1848,13 +1696,11 @@ int main(int argc, char **argv)
 	}
 
 raid_groups:
-	if (!source_dir_set) {
-		ret = create_raid_groups(trans, root, data_profile,
+	ret = create_raid_groups(trans, root, data_profile,
 				 metadata_profile, mixed, &allocation);
-		if (ret) {
-			error("unable to create raid groups: %d", ret);
-			goto out;
-		}
+	if (ret) {
+		error("unable to create raid groups: %d", ret);
+		goto out;
 	}
 
 	ret = create_data_reloc_tree(trans, root);
@@ -1869,34 +1715,20 @@ raid_groups:
 		goto out;
 	}
 
-	if (source_dir_set) {
-		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(IS_ERR(trans));
-		ret = create_chunks(trans, root,
-				    num_of_meta_chunks, size_of_data,
-				    &allocation);
-		if (ret) {
-			error("unable to create chunks: %d", ret);
-			goto out;
-		}
-		ret = btrfs_commit_transaction(trans, root);
-		if (ret) {
-			error("transaction commit failed: %d", ret);
-			goto out;
-		}
+	ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
+				  metadata_profile, metadata_profile);
+	if (ret < 0) {
+		error("failed to cleanup temporary chunks: %d", ret);
+		goto out;
+	}
 
+	if (source_dir_set) {
 		ret = make_image(source_dir, root);
 		if (ret) {
 			error("error wihle filling filesystem: %d", ret);
 			goto out;
 		}
 	}
-	ret = cleanup_temp_chunks(fs_info, &allocation, data_profile,
-				  metadata_profile, metadata_profile);
-	if (ret < 0) {
-		error("failed to cleanup temporary chunks: %d", ret);
-		goto out;
-	}
 
 	if (verbose) {
 		char features_buf[64];
-- 
2.14.1

