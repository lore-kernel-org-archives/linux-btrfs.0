From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH] btrfs-progs: Improvement for making btrfs image from source directory.
Date: Tue, 21 Jun 2011 09:45:59 +0800
Message-ID: <1308620759-6009-1-git-send-email-xin.zhong@intel.com>
Cc: xin.zhong@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* Initialize ret in btrfs_csum_file_block
* Do not abort when xattr is not supported in the source directory
* Remove size limitation of 256M
* Alloc data chunk in a smaller size (8M) to make btrfs image smaller
* Let user specify the btrfs image name
Depends on below patch from samsung guys:
http://marc.info/?l=linux-btrfs&m=127858068226025&w=2


Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 file-item.c |    2 +-
 mkfs.c      |   31 ++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/file-item.c b/file-item.c
index 9732282..aed42c3 100644
--- a/file-item.c
+++ b/file-item.c
@@ -193,7 +193,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, u64 alloc_end,
 			  u64 bytenr, char *data, size_t len)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_key file_key;
 	struct btrfs_key found_key;
 	u64 next_offset = (u64)-1;
diff --git a/mkfs.c b/mkfs.c
index 1d403f6..0beafca 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -509,6 +509,8 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 
 	ret = llistxattr(file_name, xattr_list, XATTR_LIST_MAX);
 	if (ret < 0) {
+		if(errno == ENOTSUP)
+			return 0;
 		fprintf(stderr, "get a list of xattr failed for %s\n",
 			file_name);
 		return ret;
@@ -523,8 +525,11 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 
 		ret = getxattr(file_name, cur_name, cur_value, XATTR_SIZE_MAX);
 		if (ret < 0) {
-			fprintf(stderr, "get a xattr value failed for %s\n",
-				cur_name);
+			if(errno == ENOTSUP)
+				return 0;
+			fprintf(stderr, "get a xattr value failed for %s attr %s\n",
+				file_name, cur_name);
+			return ret;
 		}
 
 		ret = btrfs_insert_xattr_item(trans, root, cur_name,
@@ -540,7 +545,6 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 
 	return ret;
 }
-
 static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 			       u64 hint_byte, struct btrfs_key *ins)
 {
@@ -905,7 +909,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 					     cur_inum, cur_file->d_name);
 			if (ret) {
 				fprintf(stderr, "add_xattr_item failed\n");
-				goto fail;
+				if(ret != -ENOTSUP)
+					goto fail;
 			}
 
 			if (S_ISDIR(st.st_mode)) {
@@ -964,7 +969,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	u64 chunk_size;
 	u64 meta_type = BTRFS_BLOCK_GROUP_METADATA;
 	u64 data_type = BTRFS_BLOCK_GROUP_DATA;
-	u64 minimum_data_chunk_size = 64 * 1024 * 1024;
+	u64 minimum_data_chunk_size = 8 * 1024 * 1024;
 	u64 i;
 	int ret;
 
@@ -1039,7 +1044,6 @@ static u64 size_sourcedir(char *dir_name, u64 sectorsize,
 	char path[512];
 	char *file_name = "temp_file";
 	FILE *file;
-	u64 minimum_data_size = 256 * 1024 * 1024;	/* 256MB */
 	u64 default_chunk_size = 8 * 1024 * 1024;	/* 8MB */
 	u64 allocated_meta_size = 8 * 1024 * 1024;	/* 8MB */
 	u64 allocated_total_size = 20 * 1024 * 1024;	/* 20MB */
@@ -1078,9 +1082,6 @@ static u64 size_sourcedir(char *dir_name, u64 sectorsize,
 
 	*num_of_meta_chunks_ret = num_of_meta_chunks;
 
-	if (total_size < minimum_data_size)
-		total_size = minimum_data_size;
-
 	return total_size;
 }
 
@@ -1132,9 +1133,9 @@ int main(int ac, char **av)
 
 	char *source_dir = NULL;
 	int source_dir_set = 0;
-	char *output = "output.img";
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
+	u64 source_dir_size = 0;
 
 	while(1) {
 		int c;
@@ -1195,8 +1196,6 @@ int main(int ac, char **av)
 		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
-	if (source_dir_set)
-		ac++;
 	ac = ac - optind;
 	if (ac == 0)
 		print_usage();
@@ -1228,17 +1227,19 @@ int main(int ac, char **av)
 			block_count = dev_block_count;
 	} else {
 		ac = 0;
-		fd = open_target(output);
+		file = av[optind++];
+		fd = open_target(file);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open the %s\n", file);
 			exit(1);
 		}
 
-		file = output;
 		first_fd = fd;
 		first_file = file;
-		block_count = size_sourcedir(source_dir, sectorsize,
+		source_dir_size = size_sourcedir(source_dir, sectorsize,
 					     &num_of_meta_chunks, &size_of_data);
+		if(block_count < source_dir_size)
+			block_count = source_dir_size;
 		ret = zero_output_file(fd, block_count, sectorsize);
 		if (ret) {
 			fprintf(stderr, "unable to zero the output file\n");
-- 
1.7.0.4

