From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 5/7] speed classes (needed for profiles) for mkfs
Date: Tue,  1 Feb 2011 14:54:48 +0100
Message-ID: <1296568490-13264-6-git-send-email-list.btrfs@jan-o-sch.net>
References: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 extent-tree.c |   11 +++--
 mkfs.c        |  122 ++++++++++++++++++++++++++++++++++++++++++--------------
 utils.c       |    7 ++-
 utils.h       |    4 +-
 volumes.c     |   13 +++++-
 volumes.h     |    6 ++-
 6 files changed, 121 insertions(+), 42 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..b580b0c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1788,7 +1788,7 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 alloc_bytes,
-			  u64 flags)
+			  u64 flags, int seek_speed)
 {
 	struct btrfs_space_info *space_info;
 	u64 thresh;
@@ -1812,7 +1812,8 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	    thresh)
 		return 0;
 
-	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
+	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags,
+				seek_speed);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
 		return 0;
@@ -2513,11 +2514,13 @@ static int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 		if (!(data & BTRFS_BLOCK_GROUP_METADATA)) {
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     num_bytes,
-					     BTRFS_BLOCK_GROUP_METADATA);
+					     BTRFS_BLOCK_GROUP_METADATA,
+					     root->seek_speed);
 			BUG_ON(ret);
 		}
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     num_bytes + 2 * 1024 * 1024, data);
+				     num_bytes + 2 * 1024 * 1024, data,
+				     root->seek_speed);
 		BUG_ON(ret);
 	}
 
diff --git a/mkfs.c b/mkfs.c
index 0a80d1c..231448b 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -64,7 +64,8 @@ static int make_root_dir(struct btrfs_root *root)
 
 	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
 				&chunk_start, &chunk_size,
-				BTRFS_BLOCK_GROUP_METADATA);
+				BTRFS_BLOCK_GROUP_METADATA,
+				root->seek_speed);
 	BUG_ON(ret);
 	ret = btrfs_make_block_group(trans, root, 0,
 				     BTRFS_BLOCK_GROUP_METADATA,
@@ -77,16 +78,6 @@ static int make_root_dir(struct btrfs_root *root)
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
@@ -156,19 +147,19 @@ static int recow_roots(struct btrfs_trans_handle *trans,
 }
 
 static int create_one_raid_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root, u64 type)
+			      struct btrfs_root *root, u64 type, int seek_speed)
 {
 	u64 chunk_start;
 	u64 chunk_size;
 	int ret;
 
 	ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
-				&chunk_start, &chunk_size, type);
-	BUG_ON(ret);
+				&chunk_start, &chunk_size, type, seek_speed);
+	if (ret)
+		return ret;
 	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
 				     type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 				     chunk_start, chunk_size);
-	BUG_ON(ret);
 	return ret;
 }
 
@@ -191,12 +182,14 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	if (allowed & metadata_profile) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_SYSTEM |
-					    (allowed & metadata_profile));
+					    (allowed & metadata_profile),
+					    root->seek_speed);
 		BUG_ON(ret);
 
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_METADATA |
-					    (allowed & metadata_profile));
+					    (allowed & metadata_profile),
+					    root->seek_speed);
 		BUG_ON(ret);
 
 		ret = recow_roots(trans, root);
@@ -205,7 +198,8 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 	if (num_devices > 1 && (allowed & data_profile)) {
 		ret = create_one_raid_group(trans, root,
 					    BTRFS_BLOCK_GROUP_DATA |
-					    (allowed & data_profile));
+					    (allowed & data_profile),
+					    root->seek_speed);
 		BUG_ON(ret);
 	}
 	return 0;
@@ -244,6 +238,8 @@ static void print_usage(void)
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
+	fprintf(stderr, "\t -c --class {data|meta|log|all} valid until overridden by\n");
+	fprintf(stderr, "\t                                next -c, default: all\n");
 	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
@@ -305,10 +301,16 @@ static struct option long_options[] = {
 	{ "nodesize", 1, NULL, 'n' },
 	{ "sectorsize", 1, NULL, 's' },
 	{ "data", 1, NULL, 'd' },
+	{ "class", 1, NULL, 'c' },
 	{ "version", 0, NULL, 'V' },
 	{ 0, 0, 0, 0}
 };
 
+static const char opts_allowed_in_devlist[256] = {
+	[1] = 1,
+	['c'] = 1,
+};
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -326,23 +328,61 @@ int main(int ac, char **av)
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
+	int class = BTRFS_DEVCLASS_ALL;
 	int zero_end = 1;
 	int option_index = 0;
 	int fd;
 	int first_fd;
 	int ret;
 	int i;
+	int devcnt = 0;
+	int devind = 0;
+	int alloc_dev = 0;
+	int first_dev = -1;
+	int data_devs = 0;
+	int meta_devs = 0;
+	struct btrfs_class_dev *devs = NULL;
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:V", long_options,
+		c = getopt_long(ac, av, "-A:b:c:l:n:s:m:d:L:V", long_options,
 				&option_index);
 		if (c < 0)
 			break;
+		if (devcnt && !opts_allowed_in_devlist[c]) {
+			print_usage();
+		}
 		switch(c) {
+			case 1:
+				if (devcnt >= alloc_dev) {
+					alloc_dev += 10;
+					devs = realloc(devs,
+						alloc_dev*sizeof(*devs));
+				}
+				devs[devcnt].file = av[optind-1];
+				devs[devcnt].class = class;
+				if (BTRFS_DEVCLASS_ALLOW_DATA(class))
+					data_devs++;
+				if (BTRFS_DEVCLASS_ALLOW_META(class))
+					meta_devs++;
+
+				if ((first_dev < 0 ||
+				     devs[first_dev].class!=BTRFS_DEVCLASS_META)
+				    && BTRFS_DEVCLASS_ALLOW_META(class))
+					first_dev = devcnt;
+				devcnt++;
+				break;
 			case 'A':
 				alloc_start = parse_size(optarg);
 				break;
+			case 'c':
+				class = parse_class(optarg);
+				if (class == -1) {
+					fprintf(stderr, "Unknown class %s\n",
+						optarg);
+					print_usage();
+				}
+				break;
 			case 'd':
 				data_profile = parse_profile(optarg);
 				break;
@@ -388,14 +428,30 @@ int main(int ac, char **av)
 		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
-	ac = ac - optind;
-	if (ac == 0)
+	if (devcnt == 0)
 		print_usage();
+	if (meta_devs == 0 || data_devs == 0) {
+		fprintf(stderr, "Illegal setup. You will need space for data "
+		                "and space for metadata.\n\n");
+		print_usage();
+	}
 
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
-	file = av[optind++];
+	if (first_dev > 0) {
+		/*
+		 * bootstrap chunks (meta/system) will be created on the first
+		 * device during make_btrfs(). to create them on the preferred
+		 * metadata device bring that to the front of the list.
+		 */
+		struct btrfs_class_dev tmp;
+		tmp = devs[0];
+		devs[0] = devs[first_dev];
+		devs[first_dev] = tmp;
+	}
+
+	file = devs[0].file;
 	ret = check_mounted(file);
 	if (ret < 0) {
 		fprintf(stderr, "error checking %s mount status\n", file);
@@ -405,7 +461,6 @@ int main(int ac, char **av)
 		fprintf(stderr, "%s is mounted\n", file);
 		exit(1);
 	}
-	ac--;
 	fd = open(file, O_RDWR);
 	if (fd < 0) {
 		fprintf(stderr, "unable to open %s\n", file);
@@ -413,7 +468,8 @@ int main(int ac, char **av)
 	}
 	first_fd = fd;
 	first_file = file;
-	ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count);
+	ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
+	                           devs[0].class);
 	if (block_count == 0)
 		block_count = dev_block_count;
 
@@ -423,9 +479,11 @@ int main(int ac, char **av)
 			leafsize * i;
 	}
 
+	printf("creating fs on %s, id 1\n", file);
+
 	ret = make_btrfs(fd, file, label, blocks, block_count,
 			 nodesize, leafsize,
-			 sectorsize, stripesize);
+			 sectorsize, stripesize, devs[0].class);
 	if (ret) {
 		fprintf(stderr, "error during mkfs %d\n", ret);
 		exit(1);
@@ -438,6 +496,7 @@ int main(int ac, char **av)
 	}
 
 	root->fs_info->alloc_start = alloc_start;
+	root->seek_speed = devs[0].class;
 
 	ret = make_root_dir(root);
 	if (ret) {
@@ -447,14 +506,14 @@ int main(int ac, char **av)
 
 	trans = btrfs_start_transaction(root, 1);
 
-	if (ac == 0)
+	if (devcnt == 1)
 		goto raid_groups;
 
 	btrfs_register_one_device(file);
 
 	zero_end = 1;
-	while(ac-- > 0) {
-		file = av[optind++];
+	while(++devind < devcnt) {
+		file = devs[devind].file;
 		ret = check_mounted(file);
 		if (ret < 0) {
 			fprintf(stderr, "error checking %s mount status\n",
@@ -478,13 +537,14 @@ int main(int ac, char **av)
 			close(fd);
 			continue;
 		}
-		ret = btrfs_prepare_device(fd, file, zero_end,
-					   &dev_block_count);
+		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
+		                           devs[devind].class);
 
 		BUG_ON(ret);
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
-					sectorsize, sectorsize, sectorsize);
+					sectorsize, sectorsize, sectorsize,
+					devs[devind].class);
 		BUG_ON(ret);
 		btrfs_register_one_device(file);
 	}
diff --git a/utils.c b/utils.c
index f1477f3..7134f03 100644
--- a/utils.c
+++ b/utils.c
@@ -62,7 +62,7 @@ static u64 reference_root_table[] = {
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[7], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize)
+	       u32 leafsize, u32 sectorsize, u32 stripesize, int seek_speed)
 {
 	struct btrfs_super_block super;
 	struct extent_buffer *buf;
@@ -269,6 +269,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_device_io_width(buf, dev_item, sectorsize);
 	btrfs_set_device_sector_size(buf, dev_item, sectorsize);
 	btrfs_set_device_type(buf, dev_item, 0);
+	btrfs_set_device_seek_speed(buf, dev_item, seek_speed);
 
 	write_extent_buffer(buf, super.dev_item.uuid,
 			    (unsigned long)btrfs_device_uuid(dev_item),
@@ -451,7 +452,7 @@ static int zero_dev_end(int fd, u64 dev_size)
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-		      u32 sectorsize)
+		      u32 sectorsize, int seek_speed)
 {
 	struct btrfs_super_block *disk_super;
 	struct btrfs_super_block *super = &root->fs_info->super_copy;
@@ -487,6 +488,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->total_bytes = block_count;
 	device->bytes_used = 0;
 	device->total_ios = 0;
+	device->seek_speed = seek_speed;
 	device->dev_root = root->fs_info->dev_root;
 
 	ret = btrfs_add_device(trans, root, device);
@@ -511,6 +513,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_device_sector_size(dev_item, device->sector_size);
 	btrfs_set_stack_device_total_bytes(dev_item, device->total_bytes);
 	btrfs_set_stack_device_bytes_used(dev_item, device->bytes_used);
+	btrfs_set_stack_device_seek_speed(dev_item, device->seek_speed);
 	memcpy(&dev_item->uuid, device->uuid, BTRFS_UUID_SIZE);
 
 	ret = pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
diff --git a/utils.h b/utils.h
index 981ffdb..6542f39 100644
--- a/utils.h
+++ b/utils.h
@@ -23,7 +23,7 @@
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize);
+	       u32 leafsize, u32 sectorsize, u32 stripesize, int seek_speed);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end,
@@ -31,7 +31,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end,
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
-		      u32 sectorsize);
+		      u32 sectorsize, int seek_speed);
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
 			int run_ioctls);
 void btrfs_register_one_device(char *fname);
diff --git a/volumes.c b/volumes.c
index 7671855..8507a84 100644
--- a/volumes.c
+++ b/volumes.c
@@ -29,6 +29,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "volumes.h"
+#include "utils.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -522,7 +523,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	btrfs_set_device_total_bytes(leaf, dev_item, device->total_bytes);
 	btrfs_set_device_bytes_used(leaf, dev_item, device->bytes_used);
 	btrfs_set_device_group(leaf, dev_item, 0);
-	btrfs_set_device_seek_speed(leaf, dev_item, 0);
+	btrfs_set_device_seek_speed(leaf, dev_item, device->seek_speed);
 	btrfs_set_device_bandwidth(leaf, dev_item, 0);
 	btrfs_set_device_start_offset(leaf, dev_item, 0);
 
@@ -577,6 +578,8 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 	btrfs_set_device_sector_size(leaf, dev_item, device->sector_size);
 	btrfs_set_device_total_bytes(leaf, dev_item, device->total_bytes);
 	btrfs_set_device_bytes_used(leaf, dev_item, device->bytes_used);
+	btrfs_set_device_seek_speed(leaf, dev_item, device->seek_speed);
+	btrfs_set_device_bandwidth(leaf, dev_item, 0);
 	btrfs_mark_buffer_dirty(leaf);
 
 out:
@@ -630,7 +633,7 @@ static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
 
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
-		      u64 *num_bytes, u64 type)
+		      u64 *num_bytes, u64 type, int seek_speed)
 {
 	u64 dev_offset;
 	struct btrfs_fs_info *info = extent_root->fs_info;
@@ -659,6 +662,8 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int stripe_len = 64 * 1024;
 	struct btrfs_key key;
 
+	BUG_ON(seek_speed <= 1);
+
 	if (list_empty(dev_list)) {
 		return -ENOSPC;
 	}
@@ -735,6 +740,8 @@ again:
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		avail = device->total_bytes - device->bytes_used;
 		cur = cur->next;
+		if (device->seek_speed != seek_speed)
+			goto next;
 		if (avail >= min_free) {
 			list_move_tail(&device->dev_list, &private_devs);
 			index++;
@@ -742,6 +749,7 @@ again:
 				index++;
 		} else if (avail > max_avail)
 			max_avail = avail;
+next:
 		if (cur == dev_list)
 			break;
 	}
@@ -1233,6 +1241,7 @@ static int fill_device_from_item(struct extent_buffer *leaf,
 	device->io_align = btrfs_device_io_align(leaf, dev_item);
 	device->io_width = btrfs_device_io_width(leaf, dev_item);
 	device->sector_size = btrfs_device_sector_size(leaf, dev_item);
+	device->seek_speed = btrfs_device_seek_speed(leaf, dev_item);
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	read_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
diff --git a/volumes.h b/volumes.h
index bb78751..2ba9a24 100644
--- a/volumes.h
+++ b/volumes.h
@@ -57,6 +57,10 @@ struct btrfs_device {
 	/* type and info about this device */
 	u64 type;
 
+	/* the speed is used to determine if the device should be a preferred
+	 * log device */
+	u8 seek_speed;
+
 	/* physical drive uuid (or lvm uuid) */
 	u8 uuid[BTRFS_UUID_SIZE];
 };
@@ -106,7 +110,7 @@ int btrfs_read_sys_array(struct btrfs_root *root);
 int btrfs_read_chunk_tree(struct btrfs_root *root);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 *start,
-		      u64 *num_bytes, u64 type);
+		      u64 *num_bytes, u64 type, int seek_speed);
 int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
-- 
1.7.2.2

