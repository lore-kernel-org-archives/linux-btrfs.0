Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45852 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLOUCv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:02:51 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so10259376wiw.9
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:02:50 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/7] Print the summary
Date: Mon, 15 Dec 2014 21:02:59 +0100
Message-Id: <1418673780-22000-7-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch print the summary of the filesystem after the creation.
The main fileds printed are:
- devices list with their uuid, devid, path and size
- raid profile (dup,single,raid0...)
- leafsize/nodesize/sectorsize
- filesystem features (raid56, extref, mixed-bg)

If the '-v' switched is passed, the output is more verbose; if the '-q'
switched is passed, only the errors are printed.


Below an example:

# mkfs.btrfs -L btrfs-test -f -m raid5 -d raid5 /dev/vd[b-k]"
BTRFS filesystem summary:
  Label:		btrfs-test
  UUID:			1073cb19-b675-423d-9aba-caad7f1508a8

  Node size:		16384
  Leaf size:		16384
  Sector size:		4096
  Initial chunks:
    Data:		9.01GiB
    Metadata:		3.61GiB
    System:		18.06MiB
  Metadata profile:	RAID5
  Data profile:		RAID5
  Mixed mode:		NO
  SSD detected:		NO
  Features:		extref, raid56
  Number of devices:	10
    UUID                                  ID    SIZE    PATH
    ------------------------------------  --  --------- -----------
    62121322-5666-4ecf-bc8e-c9b3d9f60db9   1   50.00GiB /dev/vdb
    6158cb13-3ae8-42b6-8603-660f1e5c8a7a   2   50.00GiB /dev/vdc
    b49516db-ddf5-4f54-8831-a4babc79e901   3   50.00GiB /dev/vdd
    00b03d81-7d29-4894-8050-9dd205f97c41   4   50.00GiB /dev/vde
    f119a2ec-5ef0-436c-805e-c1b0612b05ca   5   50.00GiB /dev/vdf
    adee4f58-e094-4bd4-8c56-941527524f8d   6   50.00GiB /dev/vdg
    a8299171-2024-4057-ba56-1f83bf6d7e2e   7   50.00GiB /dev/vdh
    b694e275-e454-4dbd-beb0-e33c388cffa2   8    2.00GiB /dev/vdi
    7cbe04b5-36cd-4ea7-be82-206d5487914e   9    2.00GiB /dev/vdj
    7c320654-675e-456b-ac23-cfb148b8ea57  10    2.00GiB /dev/vdk

  Total disks size:                           356.01GiB


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 mkfs.c | 170 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 142 insertions(+), 28 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 26f8041..e956903 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -26,6 +26,7 @@
 #include "ioctl.h"
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/dir.h>
@@ -57,7 +58,16 @@ struct directory_name_entry {
 	struct list_head list;
 };
 
-static int make_root_dir(struct btrfs_root *root, int mixed)
+struct block_group_allocation {
+	u64 data;
+	u64 metadata;
+	u64 mixed;
+	u64 system;
+};
+
+
+static int make_root_dir(struct btrfs_root *root, int mixed,
+				struct block_group_allocation *allocation)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key location;
@@ -74,6 +84,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 				     BTRFS_BLOCK_GROUP_SYSTEM,
 				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
+	allocation->system += BTRFS_MKFS_SYSTEM_GROUP_SIZE;
 	BUG_ON(ret);
 
 	if (mixed) {
@@ -92,8 +103,8 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->mixed += chunk_size;
 		BUG_ON(ret);
-		printf("Created a data/metadata chunk of size %llu\n", chunk_size);
 	} else {
 		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 					&chunk_start, &chunk_size,
@@ -107,6 +118,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					     BTRFS_BLOCK_GROUP_METADATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->metadata += chunk_size;
 		BUG_ON(ret);
 	}
 
@@ -128,6 +140,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 					     BTRFS_BLOCK_GROUP_DATA,
 					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->data += chunk_size;
 		BUG_ON(ret);
 	}
 
@@ -187,7 +200,9 @@ static void recow_roots(struct btrfs_trans_handle *trans,
 }
 
 static int create_one_raid_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 type)
+			      struct btrfs_root *root, u64 type,
+			      struct block_group_allocation *allocation)
+
 {
 	u64 chunk_start;
 	u64 chunk_size;
@@ -203,6 +218,18 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, chunk_size);
+	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_DATA)
+		allocation->data += chunk_size;
+	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_METADATA)
+		allocation->metadata += chunk_size;
+	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == BTRFS_BLOCK_GROUP_SYSTEM)
+		allocation->system += chunk_size;
+	else if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+			(BTRFS_BLOCK_GROUP_METADATA|BTRFS_BLOCK_GROUP_DATA))
+		allocation->mixed += chunk_size;
+	else
+		BUG_ON(1);
+
 	BUG_ON(ret);
 	return ret;
 }
@@ -210,7 +237,8 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
 			      int data_profile_opt, u64 metadata_profile,
-			      int mixed)
+			      int mixed,
+			      struct block_group_allocation *allocation)
 {
 	u64 num_devices = btrfs_super_num_devices(root->fs_info->super_copy);
 	int ret;
@@ -220,21 +248,21 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_SYSTEM |
-					    metadata_profile);
+					    metadata_profile, allocation);
 		BUG_ON(ret);
 
 		if (mixed)
 			meta_flags |= BTRFS_BLOCK_GROUP_DATA;
 
 		ret = create_one_raid_group(trans, root, meta_flags |
-					    metadata_profile);
+					    metadata_profile, allocation);
 		BUG_ON(ret);
 
 	}
 	if (!mixed && num_devices > 1 && data_profile) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_DATA |
-					    data_profile);
+					    data_profile, allocation);
 		BUG_ON(ret);
 	}
 	recow_roots(trans, root);
@@ -920,7 +948,8 @@ static int open_target(char *output_name)
 
 static int create_chunks(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 num_of_meta_chunks,
-			 u64 size_of_data)
+			 u64 size_of_data,
+			 struct block_group_allocation *allocation)
 {
 	u64 chunk_start;
 	u64 chunk_size;
@@ -937,6 +966,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 		ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 					     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_start, chunk_size);
+		allocation->metadata += chunk_size;
 		BUG_ON(ret);
 		set_extent_dirty(&root->fs_info->free_space_cache,
 				 chunk_start, chunk_start + chunk_size - 1, 0);
@@ -951,6 +981,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, size_of_data);
+	allocation->data += size_of_data;
 	BUG_ON(ret);
 	set_extent_dirty(&root->fs_info->free_space_cache,
 			 chunk_start, chunk_start + size_of_data - 1, 0);
@@ -1221,6 +1252,21 @@ static void process_fs_features(u64 flags)
 	}
 }
 
+static void print_fs_features(u64 flags)
+{
+	int i;
+	int first = 1;
+
+	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
+		if (flags & mkfs_features[i].flag) {
+			if (!first)
+				printf(", %s",mkfs_features[i].name);
+			else
+				printf("%s",mkfs_features[i].name);
+			first=0;
+		}
+	}
+}
 
 /*
  * Return NULL if all features were parsed fine, otherwise return the name of
@@ -1241,13 +1287,43 @@ static char* parse_fs_features(char *namelist, u64 *flags)
 	return NULL;
 }
 
+static void list_all_devices(struct btrfs_root *root)
+{
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	int number_of_disks = 0;
+	u64 total_block_count = 0;
+
+	fs_devices = root->fs_info->fs_devices;
+
+	list_for_each_entry(device, &fs_devices->devices, dev_list)
+		number_of_disks++;
+
+	printf("  Number of devices:\t%d\n", number_of_disks);
+	printf("    UUID                                  ID    SIZE    PATH\n");
+	printf("    ------------------------------------  --  --------- -----------\n");
+	list_for_each_entry_reverse(device, &fs_devices->devices, dev_list) {
+		char dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
+
+		uuid_unparse(device->uuid, dev_uuid);
+		printf("    %s %3llu %10s %s\n",
+			dev_uuid, device->devid,
+			pretty_size(device->total_bytes),
+			device->name);
+		total_block_count += device->total_bytes;
+	}
+
+	printf("\n");
+	printf("  Total disks size:                          %10s\n",
+		pretty_size(total_block_count));
+}
+
 int main(int ac, char **av)
 {
 	char *file;
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 	char *label = NULL;
-	char *first_file;
 	u64 block_count = 0;
 	u64 dev_block_count = 0;
 	u64 blocks[7];
@@ -1281,12 +1357,13 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
-	char *fs_uuid = NULL;
+	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = DEFAULT_MKFS_FEATURES;
+	struct block_group_allocation allocation = { 0 };
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:U:VMK",
+		c = getopt_long(ac, av, "A:b:fl:n:s:m:d:L:O:r:U:VMKqv",
 				long_options, &option_index);
 		if (c < 0)
 			break;
@@ -1356,7 +1433,8 @@ int main(int ac, char **av)
 				source_dir_set = 1;
 				break;
 			case 'U':
-				fs_uuid = optarg;
+				strncpy(fs_uuid,optarg,
+					BTRFS_UUID_UNPARSED_SIZE - 1);
 				break;
 			case 'K':
 				discard = 0;
@@ -1387,7 +1465,7 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	if (fs_uuid) {
+	if (*fs_uuid) {
 		uuid_t dummy_uuid;
 
 		if (uuid_parse(fs_uuid, dummy_uuid) != 0) {
@@ -1500,9 +1578,11 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	/* if we are here that means all devs are good to btrfsify */
-	printf("%s\n", BTRFS_BUILD_VERSION);
-	printf("See http://btrfs.wiki.kernel.org for more information.\n\n");
+	if (verbose) {
+		/* if we are here that means all devs are good to btrfsify */
+		printf("%s\n", BTRFS_BUILD_VERSION);
+		printf("See http://btrfs.wiki.kernel.org for more information.\n\n");
+	}
 
 	dev_cnt--;
 
@@ -1518,7 +1598,6 @@ int main(int ac, char **av)
 				strerror(errno));
 			exit(1);
 		}
-		first_file = file;
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
 					   block_count, &mixed, discard);
 		if (ret) {
@@ -1536,7 +1615,6 @@ int main(int ac, char **av)
 			exit(1);
 		}
 
-		first_file = file;
 		source_dir_size = size_sourcedir(source_dir, sectorsize,
 					     &num_of_meta_chunks, &size_of_data);
 		if(block_count < source_dir_size)
@@ -1574,7 +1652,8 @@ int main(int ac, char **av)
 		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
 	}
 
-	process_fs_features(features);
+	if (verbose)
+		process_fs_features(features);
 
 	ret = make_btrfs(fd, file, label, fs_uuid, blocks, dev_block_count,
 			 nodesize, leafsize,
@@ -1592,7 +1671,7 @@ int main(int ac, char **av)
 	}
 	root->fs_info->alloc_start = alloc_start;
 
-	ret = make_root_dir(root, mixed);
+	ret = make_root_dir(root, mixed, &allocation);
 	if (ret) {
 		fprintf(stderr, "failed to setup the root directory\n");
 		exit(1);
@@ -1605,6 +1684,7 @@ int main(int ac, char **av)
 	if (dev_cnt == 0)
 		goto raid_groups;
 
+
 	while (dev_cnt-- > 0) {
 		int old_mixed = mixed;
 
@@ -1631,6 +1711,7 @@ int main(int ac, char **av)
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
 					   block_count, &mixed, discard);
+
 		if (ret) {
 			close(fd);
 			exit(1);
@@ -1638,7 +1719,8 @@ int main(int ac, char **av)
 		mixed = old_mixed;
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
-					sectorsize, sectorsize, sectorsize);
+					sectorsize, sectorsize, sectorsize,
+					verbose);
 		BUG_ON(ret);
 		btrfs_register_one_device(file);
 	}
@@ -1647,24 +1729,20 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 data_profile_opt, metadata_profile,
-				 mixed);
+				 mixed, &allocation);
 		BUG_ON(ret);
 	}
 
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
-	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
-	    "sectorsize %u size %s\n",
-	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
-
 	btrfs_commit_transaction(trans, root);
 
 	if (source_dir_set) {
 		trans = btrfs_start_transaction(root, 1);
 		ret = create_chunks(trans, root,
-				    num_of_meta_chunks, size_of_data);
+				    num_of_meta_chunks, size_of_data,
+				    &allocation);
 		BUG_ON(ret);
 		btrfs_commit_transaction(trans, root);
 
@@ -1672,6 +1750,42 @@ raid_groups:
 		BUG_ON(ret);
 	}
 
+	if (!quiet) {
+		printf("BTRFS filesystem summary:\n");
+		printf("  Label:\t\t%s\n", label);
+		printf("  UUID:\t\t\t%s\n", fs_uuid);
+		printf("\n");
+
+		printf("  Node size:\t\t%u\n", nodesize);
+		printf("  Leaf size:\t\t%u\n", leafsize);
+		printf("  Sector size:\t\t%u\n", sectorsize);
+		printf("  Initial chunks:\n");
+		if (allocation.data)
+			printf("    Data:\t\t%s\n",
+				pretty_size(allocation.data));
+		if (allocation.metadata)
+			printf("    Metadata:\t\t%s\n",
+				pretty_size(allocation.metadata));
+		if (allocation.mixed)
+			printf("    Data+Metadata:\t%s\n",
+				pretty_size(allocation.mixed));
+		printf("    System:\t\t%s\n",
+			pretty_size(allocation.system));
+		printf("  Metadata profile:\t%s\n",
+			group_profile_str(metadata_profile));
+		printf("  Data profile:\t\t%s\n",
+			group_profile_str(data_profile));
+		printf("  Mixed mode:\t\t%s\n", mixed ? "YES" : "NO");
+		printf("  SSD detected:\t\t%s\n", ssd ? "YES" : "NO");
+		printf("  Features:\t\t");
+		print_fs_features(features);
+		printf("\n");
+
+		list_all_devices(root);
+
+	}
+
+
 	ret = close_ctree(root);
 	BUG_ON(ret);
 	free(label);
-- 
2.1.3

