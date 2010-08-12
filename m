From: bchociej@gmail.com
Subject: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Thu, 12 Aug 2010 17:29:37 -0500
Message-ID: <1281652177-23562-3-git-send-email-bchociej@gmail.com>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
	conscott@vt.edu
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bchociej@gmail.com>

Modified mkfs.btrfs to add hot data relocation option (-h) which
preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
relocation code.  Also added a userspace function to detect whether a
block device is an SSD by reading the sysfs block queue rotational flag.

Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Tested-by: Conor Scott <conscott@vt.edu>
---
 ctree.h       |    2 +
 extent-tree.c |    2 +-
 mkfs.c        |  131 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 utils.c       |    1 +
 volumes.c     |   73 +++++++++++++++++++++++++++++++-
 volumes.h     |    3 +-
 6 files changed, 190 insertions(+), 22 deletions(-)

diff --git a/ctree.h b/ctree.h
index 64ecf12..8c29122 100644
--- a/ctree.h
+++ b/ctree.h
@@ -640,6 +640,8 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID1    (1 << 4)
 #define BTRFS_BLOCK_GROUP_DUP	   (1 << 5)
 #define BTRFS_BLOCK_GROUP_RAID10   (1 << 6)
+#define BTRFS_BLOCK_GROUP_DATA_SSD (1 << 7)
+#define BTRFS_BLOCK_GROUP_METADATA_SSD (1 << 8)
 
 struct btrfs_block_group_item {
 	__le64 used;
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..a6b2beb 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1812,7 +1812,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	    thresh)
 		return 0;
 
-	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
+	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags, 0);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
 		return 0;
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..f45cfc3 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -69,7 +69,61 @@ static u64 parse_size(char *s)
 	return atol(s) * mult;
 }
 
-static int make_root_dir(struct btrfs_root *root)
+static int make_root_dir2(struct btrfs_root *root, int hotdata)
+{
+	struct btrfs_trans_handle *trans;
+	u64 chunk_start = 0;
+	u64 chunk_size = 0;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+
+	/*
+	 * If hotdata option is set, preallocate a metadata SSD block group
+	 * (not currently used)
+	 */
+	if (hotdata) {
+		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+				&chunk_start, &chunk_size,
+				BTRFS_BLOCK_GROUP_METADATA_SSD, hotdata);
+		BUG_ON(ret);
+		ret = btrfs_make_block_group(trans, root, 0,
+				     BTRFS_BLOCK_GROUP_METADATA_SSD,
+				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				     chunk_start, chunk_size);
+		BUG_ON(ret);
+	}
+
+	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+				&chunk_start, &chunk_size,
+				BTRFS_BLOCK_GROUP_DATA, hotdata);
+	BUG_ON(ret);
+	ret = btrfs_make_block_group(trans, root, 0,
+				     BTRFS_BLOCK_GROUP_DATA,
+				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				     chunk_start, chunk_size);
+	BUG_ON(ret);
+
+	/*
+	 * If hotdata option is set, preallocate a data SSD block group
+	 */
+	if (hotdata) {
+		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+				&chunk_start, &chunk_size,
+				BTRFS_BLOCK_GROUP_DATA_SSD, hotdata);
+		BUG_ON(ret);
+		ret = btrfs_make_block_group(trans, root, 0,
+				     BTRFS_BLOCK_GROUP_DATA_SSD,
+				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				     chunk_start, chunk_size);
+		BUG_ON(ret);
+	}
+
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
+static int make_root_dir(struct btrfs_root *root, int hotdata)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key location;
@@ -90,7 +144,7 @@ static int make_root_dir(struct btrfs_root *root)
 
 	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 				&chunk_start, &chunk_size,
-				BTRFS_BLOCK_GROUP_METADATA);
+				BTRFS_BLOCK_GROUP_METADATA, hotdata);
 	BUG_ON(ret);
 	ret = btrfs_make_block_group(trans, root, 0,
 				     BTRFS_BLOCK_GROUP_METADATA,
@@ -103,16 +157,6 @@ static int make_root_dir(struct btrfs_root *root)
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
 
-	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
-				&chunk_start, &chunk_size,
-				BTRFS_BLOCK_GROUP_DATA);
-	BUG_ON(ret);
-	ret = btrfs_make_block_group(trans, root, 0,
-				     BTRFS_BLOCK_GROUP_DATA,
-				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     chunk_start, chunk_size);
-	BUG_ON(ret);
-
 	ret = btrfs_make_root_dir(trans, root->fs_info->tree_root,
 			      BTRFS_ROOT_TREE_DIR_OBJECTID);
 	if (ret)
@@ -189,7 +233,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
-				&chunk_start, &chunk_size, type);
+				&chunk_start, &chunk_size, type, 0);
 	BUG_ON(ret);
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
@@ -198,14 +242,24 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * counters for SSD and HDD devices to determine which block group types are
+ * allowed when hotdata is enabled
+ */
+static int ssd_devices = 0;
+static int hdd_devices = 0;
+
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
-			      u64 metadata_profile)
+			      u64 metadata_profile, int hotdata)
 {
 	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
 	u64 allowed;
 	int ret;
 
+	if (hotdata)
+		num_devices = hdd_devices;
+
 	if (num_devices == 1)
 		allowed = BTRFS_BLOCK_GROUP_DUP;
 	else if (num_devices >= 4) {
@@ -271,6 +325,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
+	fprintf(stderr, "\t -h --hotdata allocate hot data block groups to SSD\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
@@ -325,6 +380,7 @@ static char *parse_label(char *input)
 static struct option long_options[] = {
 	{ "alloc-start", 1, NULL, 'A'},
 	{ "byte-count", 1, NULL, 'b' },
+	{ "hotdata", 0, NULL, 'h' },
 	{ "leafsize", 1, NULL, 'l' },
 	{ "label", 1, NULL, 'L'},
 	{ "metadata", 1, NULL, 'm' },
@@ -358,10 +414,11 @@ int main(int ac, char **av)
 	int first_fd;
 	int ret;
 	int i;
+	int hotdata = 0;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:V", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:hV", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -398,6 +455,9 @@ int main(int ac, char **av)
 				}
 				zero_end = 0;
 				break;
+			case 'h':
+				hotdata = 1;
+				break;
 			case 'V':
 				print_version();
 				break;
@@ -405,6 +465,7 @@ int main(int ac, char **av)
 				print_usage();
 		}
 	}
+
 	sectorsize = max(sectorsize, (u32)getpagesize());
 	if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
 		fprintf(stderr, "Illegal leafsize %u\n", leafsize);
@@ -414,7 +475,9 @@ int main(int ac, char **av)
 		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
+
 	ac = ac - optind;
+
 	if (ac == 0)
 		print_usage();
 
@@ -422,6 +485,20 @@ int main(int ac, char **av)
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
 	file = av[optind++];
+
+	/*
+	 * Setup for hot data relocation
+	 */
+	if (hotdata) {
+		if (btrfs_is_dev_ssd(file)) {
+			fprintf(stderr, "Hot data relocation mode requires "
+				"the first listed device NOT be a SSD (%s)\n",
+				file);
+			exit(1);
+		}
+		hdd_devices++;
+	}
+
 	ret = check_mounted(file);
 	if (ret < 0) {
 		fprintf(stderr, "error checking %s mount status\n", file);
@@ -459,7 +536,7 @@ int main(int ac, char **av)
 	root = open_ctree(file, 0, O_RDWR);
 	root->fs_info->alloc_start = alloc_start;
 
-	ret = make_root_dir(root);
+	ret = make_root_dir(root, hotdata);
 	if (ret) {
 		fprintf(stderr, "failed to setup the root directory\n");
 		exit(1);
@@ -479,6 +556,15 @@ int main(int ac, char **av)
 	zero_end = 1;
 	while(ac-- > 0) {
 		file = av[optind++];
+
+		if (hotdata) {
+			if (btrfs_is_dev_ssd(file)) {
+				ssd_devices++;
+			} else {
+				hdd_devices++;
+			}
+		}
+
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n",
@@ -504,7 +590,6 @@ int main(int ac, char **av)
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end,
 					   &dev_block_count);
-
 		BUG_ON(ret);
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
@@ -514,8 +599,18 @@ int main(int ac, char **av)
 	}
 
 raid_groups:
+	btrfs_commit_transaction(trans, root);
+
+	ret = make_root_dir2(root, hotdata);
+	if (ret) {
+		fprintf(stderr, "failed to setup the root directory\n");
+		exit(1);
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+
 	ret = create_raid_groups(trans, root, data_profile,
-				 metadata_profile);
+				 metadata_profile, hotdata);
 	BUG_ON(ret);
 
 	ret = create_data_reloc_tree(trans, root);
diff --git a/utils.c b/utils.c
index 2f4c6e1..852c5d6 100644
--- a/utils.c
+++ b/utils.c
@@ -473,6 +473,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->bytes_used = 0;
 	device->total_ios = 0;
 	device->dev_root = root->fs_info->dev_root;
+	device->name = path;
 
 	ret = btrfs_add_device(trans, root, device);
 	BUG_ON(ret);
diff --git a/volumes.c b/volumes.c
index 7671855..79d3871 100644
--- a/volumes.c
+++ b/volumes.c
@@ -19,6 +19,7 @@
 #define __USE_XOPEN2K
 #include <stdio.h>
 #include <stdlib.h>
+#include <ctype.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <uuid/uuid.h>
@@ -630,7 +631,7 @@ static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
 
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
-		      u64 *num_bytes, u64 type)
+		      u64 *num_bytes, u64 type, int hotdata)
 {
 	u64 dev_offset;
 	struct btrfs_fs_info *info = extent_root->fs_info;
@@ -733,8 +734,24 @@ again:
 	/* build a private list of devices we will allocate from */
 	while(index < num_stripes) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		avail = device->total_bytes - device->bytes_used;
 		cur = cur->next;
+		int is_ssd = btrfs_is_dev_ssd(device->name);
+
+		if (hotdata) {
+			if (type & BTRFS_BLOCK_GROUP_DATA &&
+				is_ssd)
+				goto skip_device;
+			if (type & BTRFS_BLOCK_GROUP_METADATA &&
+				is_ssd)
+					goto skip_device;
+			if (type & BTRFS_BLOCK_GROUP_DATA_SSD &&
+				!is_ssd)
+				goto skip_device;
+			if (type & BTRFS_BLOCK_GROUP_METADATA_SSD &&
+				!is_ssd)
+				goto skip_device;
+		}
+		avail = device->total_bytes - device->bytes_used;
 		if (avail >= min_free) {
 			list_move_tail(&device->dev_list, &private_devs);
 			index++;
@@ -742,6 +759,7 @@ again:
 				index++;
 		} else if (avail > max_avail)
 			max_avail = avail;
+skip_device:
 		if (cur == dev_list)
 			break;
 	}
@@ -853,6 +871,7 @@ again:
 		BUG_ON(ret);
 	}
 
+
 	kfree(chunk);
 	return ret;
 }
@@ -1448,3 +1467,53 @@ struct list_head *btrfs_scanned_uuids(void)
 {
 	return &fs_uuids;
 }
+
+/*
+ * A userspace function for determining whether a device is
+ * an SSD
+ */
+int btrfs_is_dev_ssd(char *device_path)
+{
+	int fd;
+	int ret = 0;
+	char *deva = "/sys/block/";
+	char *devb = "/queue/rotational";
+	char dev_string[256] = "";
+	char dev[256];
+	size_t dev_name_len;
+	char rot_flag[2];
+	int index;
+
+	memset(rot_flag, 0, 2);
+
+	dev_name_len = strlen(device_path);
+	memcpy(dev, device_path + 5, dev_name_len - 4);
+
+	/* remove partition numbers from device name */
+	index = strlen(dev) - 1;
+	while (isdigit(dev[index]))
+		dev[index--] = '\0';
+
+	strcat(dev_string, deva);
+	strcat(dev_string, dev);
+	strcat(dev_string, devb);
+
+	fd = open(dev_string, O_RDONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "unable to open %s\n", dev_string);
+		return 0;
+	}
+
+	ret = read(fd, rot_flag, 1);
+	if (ret < 1) {
+		fprintf(stderr, "unable to read rotational flag for %s\n",
+			device_path);
+		return 0;
+	}
+
+	close(fd);
+
+	return !atoi(rot_flag);
+}
+
diff --git a/volumes.h b/volumes.h
index bb78751..bb26580 100644
--- a/volumes.h
+++ b/volumes.h
@@ -106,7 +106,7 @@ int btrfs_read_sys_array(struct btrfs_root *root);
 int btrfs_read_chunk_tree(struct btrfs_root *root);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
-		      u64 *num_bytes, u64 type);
+		      u64 *num_bytes, u64 type, int hotdata);
 int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
@@ -130,4 +130,5 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
+int btrfs_is_dev_ssd(char *device_path);
 #endif
-- 
1.7.1
