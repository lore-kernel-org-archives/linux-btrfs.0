From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 6/6] debug-btrfs: Add print_inode command
Date: Thu,  4 Feb 2010 23:14:07 +0530
Message-ID: <1265305447-30780-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/cmds.c              |  191 ++++++++++++++++++++++++++++++++++++++++
 debugbtrfs/debug_btrfs_cmds.ct |    3 +
 lib/volumes.c                  |   16 ----
 lib/volumes.h                  |   12 +++
 4 files changed, 206 insertions(+), 16 deletions(-)

diff --git a/debugbtrfs/cmds.c b/debugbtrfs/cmds.c
index cd2901b..55a1ed7 100644
--- a/debugbtrfs/cmds.c
+++ b/debugbtrfs/cmds.c
@@ -20,10 +20,15 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <uuid/uuid.h>
+#include <time.h>
 
 #include "ctree.h"
 #include "disk-io.h"
+#include "extent_io.h"
+#include "transaction.h"
 #include "debug_btrfs.h"
+#include "volumes.h"
 
 void do_show_debugfs_params(int argc, char *argv[])
 {
@@ -48,3 +53,189 @@ void do_open_filesys(int argc, char *argv[])
 		return;
 	}
 }
+
+void dump_inode_details(FILE *out, u64 ino, struct extent_buffer *leaf,
+			struct btrfs_inode_item *inode_item)
+{
+	time_t t;
+	fprintf(out, "%-7s%-20llu", "Inode:", (unsigned long long)ino);
+	fprintf(out, "Generation: %llu\n",
+		btrfs_inode_generation(leaf, inode_item));
+
+	fprintf(out, "%-7s%-5o", "Mode:",
+		btrfs_inode_mode(leaf, inode_item) & 0777);
+
+	fprintf(out, "%-7s%-10d", "User:",
+		btrfs_inode_gid(leaf, inode_item));
+	fprintf(out, "%-7s%-10d\n", "Group:",
+		btrfs_inode_uid(leaf, inode_item));
+
+	fprintf(out, "%-7s%-20llu", "Size:", (unsigned long long)
+		btrfs_inode_size(leaf, inode_item));
+	fprintf(out, "%-7s%u\n", "Link:",
+		(unsigned int)btrfs_inode_nlink(leaf, inode_item));
+
+	t = (time_t)btrfs_timespec_sec(leaf,
+				btrfs_inode_atime(inode_item));
+	fprintf(out, "atime: %s", ctime(&t));
+	t = (time_t)btrfs_timespec_sec(leaf,
+				btrfs_inode_ctime(inode_item));
+	fprintf(out, "ctime: %s", ctime(&t));
+	t = (time_t)btrfs_timespec_sec(leaf,
+				btrfs_inode_mtime(inode_item));
+	fprintf(out, "mtime: %s", ctime(&t));
+	t = (time_t)btrfs_timespec_sec(leaf,
+				btrfs_inode_otime(inode_item));
+	fprintf(out, "otime: %s", ctime(&t));
+
+	return;
+}
+
+void dump_map_type(FILE *out, struct map_lookup *map)
+{
+	u64 type = map->type;
+
+	fprintf(out, "Raid type = ");
+
+	if (type & BTRFS_BLOCK_GROUP_RAID0)
+		fprintf(out, "Raid0");
+	else if (type & BTRFS_BLOCK_GROUP_RAID1)
+		fprintf(out, "Raid1");
+	else if (type & BTRFS_BLOCK_GROUP_RAID10)
+		fprintf(out, "Raid10");
+	else if (type & BTRFS_BLOCK_GROUP_DUP)
+		fprintf(out, "Duplicated data");
+	else
+		fprintf(out, "None");
+
+	fprintf(out, "\n");
+}
+
+void dump_chunk_details(FILE *out, u64 logical, u64 length)
+{
+	int ret, i;
+	char fs_uuid[37];
+	struct cache_extent *ce;
+        struct map_lookup *map;
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_mapping_tree *map_tree = &current_fs_root->fs_info->mapping_tree;
+
+	ret = btrfs_map_block(map_tree, WRITE, logical, &length, &multi, 0);
+	if (ret) {
+		fprintf(stderr, "Error in finding the chunk details \n");
+		return;
+	}
+	fprintf(out, "Number of devices = %d\n", multi->num_stripes);
+	ce = find_first_cache_extent(&map_tree->cache_tree, logical);
+	map = container_of(ce, struct map_lookup, ce);
+	dump_map_type(out, map);
+	for (i = 0; i < multi->num_stripes; i++) {
+		uuid_unparse(multi->stripes[i].dev->uuid , fs_uuid);
+		fprintf(out, "Device uuid = %s\n", fs_uuid);
+		fprintf(out, "Device = %s Offset = %llu \n",
+			multi->stripes[i].dev->name,
+			multi->stripes[i].physical);
+
+	}
+}
+
+void dump_file_extent(FILE *out, int count, u64 offset,
+		struct extent_buffer *leaf,
+		struct btrfs_file_extent_item *file_extent_item,
+		int print_chunk_details)
+{
+	fprintf(out, "\nExtent %d\n", count);
+	fprintf(out, "Logical offset = %llu Extent size = %llu\n",
+		(unsigned long long) offset,
+		btrfs_file_extent_num_bytes(leaf, file_extent_item));
+
+	fprintf(out, "Disk bytenr = %llu Actual disk size = %llu",
+		(unsigned long long)
+		btrfs_file_extent_disk_bytenr(leaf, file_extent_item),
+		btrfs_file_extent_disk_num_bytes(leaf, file_extent_item));
+
+	if (!btrfs_file_extent_disk_bytenr(leaf, file_extent_item))
+		fprintf(out, " (Hole)");
+	fprintf(out, "\n");
+	if (print_chunk_details)
+		dump_chunk_details(out, btrfs_file_extent_disk_bytenr(leaf, file_extent_item),
+				btrfs_file_extent_disk_num_bytes(leaf, file_extent_item));
+	return ;
+}
+
+void do_print_inode(int argc, char *argv[])
+{
+	FILE *out;
+	int c;
+	int print_chunk_details = 0;
+	int ret, count = 0;
+	u64 offset, inode_i_size;
+	struct btrfs_path *path;
+	struct btrfs_key inode_key;
+	struct extent_buffer *leaf;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_file_extent_item *file_extent_item;
+
+
+	reset_getopt();
+	while ((c = getopt (argc, argv, "ch")) != EOF) {
+                switch (c) {
+                case 'c':
+                        print_chunk_details = 1;
+                        break;
+                default:
+			fprintf(stderr, "Usage %s [-ch] inode number\n",
+				argv[0]);
+			return;
+                }
+        }
+	if (optind == argc) {
+		fprintf(stderr, "Usage %s [-ch] inode number\n",
+			argv[0]);
+		return;
+	}
+	out = open_pager();
+	inode_key.objectid = atoll(argv[optind]);
+	inode_key.type     = BTRFS_INODE_ITEM_KEY;
+	inode_key.offset   = 0;
+
+	path = btrfs_alloc_path();
+	btrfs_init_path(path);
+	trans = btrfs_start_transaction(current_fs_root, 1);
+
+	ret = btrfs_search_slot(trans, current_fs_root, &inode_key, path, 0, 0);
+	if (ret != 0) {
+		fprintf(stderr, "Failed get the inode details for %llu\n",
+			(unsigned long long)inode_key.objectid);
+		goto err_out;
+	}
+	leaf = path->nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_inode_item);
+	dump_inode_details(out, inode_key.objectid, leaf, inode_item);
+	inode_i_size = btrfs_inode_size(leaf, inode_item);
+	btrfs_release_path(current_fs_root, path);
+
+	/* get the file extent details */
+	offset = 0;
+	while (offset < inode_i_size) {
+		ret = btrfs_lookup_file_extent(trans, current_fs_root, path,
+					inode_key.objectid, offset, 0);
+		if (ret != 0) {
+			fprintf(stderr, "Not able to retrive extent information\n");
+			break;
+		}
+		leaf = path->nodes[0];
+		file_extent_item = btrfs_item_ptr(leaf, path->slots[0],
+						struct btrfs_file_extent_item);
+		dump_file_extent(out, count, offset,
+				leaf, file_extent_item, print_chunk_details);
+		offset += btrfs_file_extent_num_bytes(leaf, file_extent_item);
+		btrfs_release_path(current_fs_root, path);
+		count++;
+	}
+err_out:
+	btrfs_free_path(path);
+	btrfs_commit_transaction(trans, current_fs_root);
+	close_pager(out);
+}
diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
index cd40cf4..e6c5801 100644
--- a/debugbtrfs/debug_btrfs_cmds.ct
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -47,5 +47,8 @@ request do_dump_csum_tree, "Show btrfs checksum tree",
 request do_dump_log_tree, "Show btrfs log tree",
 	dump_log_tree;
 
+request do_print_inode, "Print inode details",
+	print_inode;
+
 end;
 
diff --git a/lib/volumes.c b/lib/volumes.c
index 7671855..08b75bb 100644
--- a/lib/volumes.c
+++ b/lib/volumes.c
@@ -30,22 +30,6 @@
 #include "print-tree.h"
 #include "volumes.h"
 
-struct stripe {
-	struct btrfs_device *dev;
-	u64 physical;
-};
-
-struct map_lookup {
-	struct cache_extent ce;
-	u64 type;
-	int io_align;
-	int io_width;
-	int stripe_len;
-	int sector_size;
-	int num_stripes;
-	int sub_stripes;
-	struct btrfs_bio_stripe stripes[];
-};
 
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
diff --git a/lib/volumes.h b/lib/volumes.h
index bb78751..4c35b7a 100644
--- a/lib/volumes.h
+++ b/lib/volumes.h
@@ -88,6 +88,18 @@ struct btrfs_multi_bio {
 	struct btrfs_bio_stripe stripes[];
 };
 
+struct map_lookup {
+	struct cache_extent ce;
+	u64 type;
+	int io_align;
+	int io_width;
+	int stripe_len;
+	int sector_size;
+	int num_stripes;
+	int sub_stripes;
+	struct btrfs_bio_stripe stripes[];
+};
+
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
-- 
1.7.0.rc0.48.gdace5

