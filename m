Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59915 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3KOK3n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 05:29:43 -0500
Received: by mail-wi0-f172.google.com with SMTP id i19so768575wiw.11
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 02:29:41 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] Prefix with "ERROR:" the error messages of mkfs
Date: Fri, 15 Nov 2013 11:29:36 +0100
Message-Id: <1384511376-14740-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384511376-14740-1-git-send-email-kreijack@inwind.it>
References: <1384511376-14740-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the ERROR prefix to the error messages of mkfs, to align it
to the btrfs main utility style.

The patch increase the buffer size of test_dev_for_mkfs() and
test_num_disk_vs_raid() for the error message from 100 to 150
because the former become too small.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 cmds-replace.c |  2 +-
 mkfs.c         | 54 +++++++++++++++++++++++++++++-------------------------
 utils.c        | 10 +++++-----
 3 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index d9b0940..812c5d7 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -142,7 +142,7 @@ static int cmd_start_replace(int argc, char **argv)
 	int do_not_background = 0;
 	int mixed = 0;
 	DIR *dirstream = NULL;
-	char estr[100]; /* check test_dev_for_mkfs() for error string size*/
+	char estr[150]; /* check test_dev_for_mkfs() for error string size*/
 
 	while ((c = getopt(argc, argv, "Brf")) != -1) {
 		switch (c) {
diff --git a/mkfs.c b/mkfs.c
index ebd8bb5..7ea5a57 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -83,7 +83,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					BTRFS_BLOCK_GROUP_DATA);
 		if (ret == -ENOSPC) {
 			fprintf(stderr,
-				"no space to alloc data/metadata chunk\n");
+			     "ERROR: no space to alloc data/metadata chunk\n");
 			goto err;
 		}
 		BUG_ON(ret);
@@ -99,7 +99,8 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA);
 		if (ret == -ENOSPC) {
-			fprintf(stderr, "no space to alloc metadata chunk\n");
+			fprintf(stderr, 
+				"ERROR: no space to alloc metadata chunk\n");
 			goto err;
 		}
 		BUG_ON(ret);
@@ -195,7 +196,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 				&chunk_start, &chunk_size, type);
 	if (ret == -ENOSPC) {
-		fprintf(stderr, "not enough free space\n");
+		fprintf(stderr, "ERROR: not enough free space\n");
 		exit(1);
 	}
 	BUG_ON(ret);
@@ -328,7 +329,7 @@ static char *parse_label(char *input)
 	int len = strlen(input);
 
 	if (len >= BTRFS_LABEL_SIZE) {
-		fprintf(stderr, "Label %s is too long (max %d)\n", input,
+		fprintf(stderr, "ERROR: label %s is too long (max %d)\n", input,
 			BTRFS_LABEL_SIZE - 1);
 		exit(1);
 	}
@@ -1016,7 +1017,7 @@ static u64 size_sourcedir(char *dir_name, u64 sectorsize,
 	ret = ftw(dir_name, ftw_add_entry_size, 10);
 	dir_size = global_total_size;
 	if (ret < 0) {
-		fprintf(stderr, "ftw subdir walk of '%s' failed: %s\n",
+		fprintf(stderr, "ERROR: ftw subdir walk of '%s' failed: %s\n",
 			dir_name, strerror(errno));
 		exit(1);
 	}
@@ -1067,17 +1068,17 @@ static int check_leaf_or_node_size(u32 size, u32 sectorsize)
 {
 	if (size < sectorsize) {
 		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (smaller than %u)\n",
+			"ERROR: illegal leafsize (or nodesize) %u (smaller than %u)\n",
 			size, sectorsize);
 		return -1;
 	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
+			"ERROR: illegal leafsize (or nodesize) %u (larger than %u)\n",
 			size, BTRFS_MAX_METADATA_BLOCKSIZE);
 		return -1;
 	} else if (size & (sectorsize - 1)) {
 		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (not align to %u)\n",
+			"ERROR: illegal leafsize (or nodesize) %u (not align to %u)\n",
 			size, sectorsize);
 		return -1;
 	}
@@ -1259,7 +1260,8 @@ int main(int ac, char **av)
 	u64 source_dir_size = 0;
 	int dev_cnt = 0;
 	int saved_optind;
-	char estr[100];
+	char estr[150]; /*  check test_dev_for_mkfs() and 
+			    test_num_disk_vs_raid() for error string size */
 	u64 features = DEFAULT_MKFS_FEATURES;
 
 	while(1) {
@@ -1302,7 +1304,7 @@ int main(int ac, char **av)
 				tmp = parse_fs_features(tmp, &features);
 				if (tmp) {
 					fprintf(stderr,
-						"Unrecognized filesystem feature '%s'\n",
+						"ERROR: unrecognized filesystem feature '%s'\n",
 							tmp);
 					free(orig);
 					exit(1);
@@ -1352,14 +1354,14 @@ int main(int ac, char **av)
 
 	if (source_dir_set && dev_cnt > 1) {
 		fprintf(stderr,
-			"The -r option is limited to a single device\n");
+			"ERROR: the -r option is limited to a single device\n");
 		exit(1);
 	}
 	while (dev_cnt-- > 0) {
 		file = av[optind++];
 		if (is_block_device(file))
 			if (test_dev_for_mkfs(file, force_overwrite, estr)) {
-				fprintf(stderr, "Error: %s", estr);
+				fprintf(stderr, "ERROR: %s", estr);
 				exit(1);
 			}
 	}
@@ -1376,7 +1378,8 @@ int main(int ac, char **av)
 		if (metadata_profile != data_profile) {
 			if (metadata_profile_opt || data_profile_opt) {
 				fprintf(stderr,
-	"With mixed block groups data and metadata profiles must be the same\n");
+				     "ERROR: With mixed block groups data "
+				     "and metadata profiles must be the same\n");
 				exit(1);
 			}
 		}
@@ -1412,8 +1415,9 @@ int main(int ac, char **av)
 				exit(1);
 		}
 		if (leafsize != sectorsize) {
-			fprintf(stderr, "Error: mixed metadata/data block groups "
-				"require metadata blocksizes equal to the sectorsize\n");
+			fprintf(stderr, "ERROR: mixed metadata/data block "
+				"groups require metadata blocksizes equal "
+				"to the sectorsize\n");
 			exit(1);
 		}
 	}
@@ -1421,7 +1425,7 @@ int main(int ac, char **av)
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
 			dev_cnt, mixed, estr);
 	if (ret) {
-		fprintf(stderr, "Error: %s\n", estr);
+		fprintf(stderr, "ERROR: %s\n", estr);
 		exit(1);
 	}
 
@@ -1439,7 +1443,7 @@ int main(int ac, char **av)
 		 */
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
-			fprintf(stderr, "unable to open %s: %s\n", file,
+			fprintf(stderr, "ERROR: unable to open %s: %s\n", file,
 				strerror(errno));
 			exit(1);
 		}
@@ -1447,13 +1451,13 @@ int main(int ac, char **av)
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
 					   block_count, &mixed, discard);
 		if (block_count && block_count > dev_block_count) {
-			fprintf(stderr, "%s is smaller than requested size\n", file);
+			fprintf(stderr, "ERROR: %s is smaller than requested size\n", file);
 			exit(1);
 		}
 	} else {
 		fd = open_target(file);
 		if (fd < 0) {
-			fprintf(stderr, "unable to open the %s\n", file);
+			fprintf(stderr, "ERROR: unable to open the %s\n", file);
 			exit(1);
 		}
 
@@ -1464,7 +1468,7 @@ int main(int ac, char **av)
 			block_count = source_dir_size;
 		ret = zero_output_file(fd, block_count, sectorsize);
 		if (ret) {
-			fprintf(stderr, "unable to zero the output file\n");
+			fprintf(stderr, "ERROR: unable to zero the output file\n");
 			exit(1);
 		}
 		/* our "device" is the new image file */
@@ -1473,7 +1477,7 @@ int main(int ac, char **av)
 
 	/* To create the first block group and chunk 0 in make_btrfs */
 	if (dev_block_count < BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
-		fprintf(stderr, "device is too small to make filesystem\n");
+		fprintf(stderr, "ERROR: device is too small to make filesystem\n");
 		exit(1);
 	}
 
@@ -1501,13 +1505,13 @@ int main(int ac, char **av)
 			 nodesize, leafsize,
 			 sectorsize, stripesize, features);
 	if (ret) {
-		fprintf(stderr, "error during mkfs: %s\n", strerror(-ret));
+		fprintf(stderr, "ERROR: error during mkfs: %s\n", strerror(-ret));
 		exit(1);
 	}
 
 	root = open_ctree(file, 0, OPEN_CTREE_WRITES);
 	if (!root) {
-		fprintf(stderr, "Open ctree failed\n");
+		fprintf(stderr, "ERROR: open ctree failed\n");
 		close(fd);
 		exit(1);
 	}
@@ -1515,7 +1519,7 @@ int main(int ac, char **av)
 
 	ret = make_root_dir(root, mixed);
 	if (ret) {
-		fprintf(stderr, "failed to setup the root directory\n");
+		fprintf(stderr, "ERROR: failed to setup the root directory\n");
 		exit(1);
 	}
 
@@ -1539,7 +1543,7 @@ int main(int ac, char **av)
 		 */
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
-			fprintf(stderr, "unable to open %s: %s\n", file,
+			fprintf(stderr, "ERROR: unable to open %s: %s\n", file,
 				strerror(errno));
 			exit(1);
 		}
diff --git a/utils.c b/utils.c
index f499023..c9253e3 100644
--- a/utils.c
+++ b/utils.c
@@ -1851,7 +1851,7 @@ out:
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr)
 {
-	size_t sz = 100;
+	size_t sz = 150;
 	u64 allowed = 0;
 
 	switch (dev_cnt) {
@@ -1869,13 +1869,13 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	}
 
 	if (metadata_profile & ~allowed) {
-		snprintf(estr, sz, "unable to create FS with metadata "
+		snprintf(estr, sz, "ERROR: unable to create FS with metadata" 
 			"profile %llu (have %llu devices)\n",
 			metadata_profile, dev_cnt);
 		return 1;
 	}
 	if (data_profile & ~allowed) {
-		snprintf(estr, sz, "unable to create FS with data "
+		snprintf(estr, sz, "ERROR: unable to create FS with data "
 			"profile %llu (have %llu devices)\n",
 			metadata_profile, dev_cnt);
 		return 1;
@@ -1883,7 +1883,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 
 	if (!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP)) {
 		snprintf(estr, sz,
-			"dup for data is allowed only in mixed mode");
+			"ERROR: dup for data is allowed only in mixed mode");
 		return 1;
 	}
 	return 0;
@@ -1897,7 +1897,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 {
 	int ret, fd;
-	size_t sz = 100;
+	size_t sz = 150;
 	struct stat st;
 
 	ret = is_swap_device(file);
-- 
1.8.4.3

