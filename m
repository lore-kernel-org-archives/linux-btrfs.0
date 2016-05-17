Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbcEQDse (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 23:48:34 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/4] btrfs-progs: corrupt-block: Add ability to corrupt free space cache file
Date: Tue, 17 May 2016 11:47:55 +0800
Message-Id: <1463456878-17550-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One user in mail list reported free space cache error where clear_cache
mount option failes to fix.

To reproduce such problem, add support to corrupt free space cache
file(old free space cache implement, or space_cache=v1).

With this patch, we can reproduce the problem quite easily:
Not suitable for a btrfs-progs or xfstest test case, as btrfsck won't
treat it as an error.

======
$ fallocate  test.img -l 2G
$ mkfs.btrfs test.img
$ sudo mount test.img  /mnt/btrfs/
$ sudo xfs_io  -f -c "pwrite 0 16M" /mnt/btrfs/tmp
$ sudo umount /mnt/btrfs
$ ./btrfs-corrupt-block -s content -l 136708096 ../test.img
  Here 136708096 is the second data chunk bytenr.
  (The first data chunk is the 8M one from mkfs, which doesn't have free
   space cache)

$ ./btrfsck test.img
Checking filesystem on ../test.img
UUID: 9542051b-8150-42e5-a9e6-95829656485c
checking extents
checking free space cache
btrfs: csum mismatch on free space cache  <<< Found space cache problem
failed to load free space cache for block group 136708096
checking fs roots
checking csums
checking root refs
found 16941058 bytes used err is 0
total csum bytes: 16384
total tree bytes: 163840
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 139567
file data blocks allocated: 16908288
 referenced 16908288

$ sudo mount -o clear_cache test.img /mnt/btrfs
$ sudo umount /mnt/btrfs
$ ./btrfsck test.img
Checking filesystem on ../test.img
UUID: 9542051b-8150-42e5-a9e6-95829656485c
checking extents
checking free space cache
btrfs: csum mismatch on free space cache <<< Problem not fixed by kernel
failed to load free space cache for block group 136708096
checking fs roots
checking csums
checking root refs
found 16941058 bytes used err is 0
total csum bytes: 16384
total tree bytes: 163840
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 139567
file data blocks allocated: 16908288
 referenced 16908288
======

Btrfs-progs fix will follow soon.

Reported-by: Ivan P <chrnosphered@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 123 insertions(+), 1 deletion(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index d331f96..eb27265 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -115,6 +115,9 @@ static void print_usage(int ret)
 	fprintf(stderr, "\t-C Delete a csum for the specified bytenr.  When "
 		"used with -b it'll delete that many bytes, otherwise it's "
 		"just sectorsize\n");
+	fprintf(stderr, "\t-s <method>\n");
+	fprintf(stderr, "\t   Corrupt free space cache file(space_cache v1), must also specify -l for blockgroup bytenr\n");
+	fprintf(stderr, "\t   <method> can be 'zero_gen','rand_gen' or 'content'\n");
 	exit(ret);
 }
 
@@ -1012,6 +1015,100 @@ out:
 	return ret;
 
 }
+
+u64 rand_u64(void)
+{
+	u64 ret = 0;
+	int n;
+
+	for (n = 0; n < sizeof(ret) / sizeof(RAND_MAX); n++)
+		ret += rand() << (n * sizeof(RAND_MAX) * 8);
+	return ret;
+}
+
+#define CORRUPT_SC_FILE_ZERO_GEN	1
+#define CORRUPT_SC_FILE_RAND_GEN	2
+#define CORRUPT_SC_FILE_CONTENT		3
+int corrupt_space_cache_file(struct btrfs_fs_info *fs_info, u64 block_group,
+			     int method)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_disk_key location;
+	struct btrfs_free_space_header *sc_header;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *node;
+	struct extent_buffer *corrupted_node;
+	u64 disk_bytenr;
+	int slot;
+	int ret;
+
+	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
+	key.type = 0;
+	key.offset = block_group;
+
+	btrfs_init_path(&path);
+
+	/* Don't start trans, as this will cause generation different */
+	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
+	if (ret) {
+		error("failed to find free space cahce file for block group %llu, ret: %d\n",
+		      block_group, ret);
+		goto out;
+	}
+	slot = path.slots[0];
+	node = path.nodes[0];
+	sc_header = btrfs_item_ptr(node, slot, struct btrfs_free_space_header);
+	if (method == CORRUPT_SC_FILE_ZERO_GEN ||
+	    method == CORRUPT_SC_FILE_RAND_GEN) {
+		u64 dst_gen;
+
+		if (method == CORRUPT_SC_FILE_ZERO_GEN)
+			dst_gen = 0;
+		else
+			dst_gen = rand_u64();
+
+		btrfs_set_free_space_generation(node, sc_header, dst_gen);
+		/* Manually re-calc csum and write to disk */
+		ret = write_tree_block(NULL, tree_root, node);
+		goto out;
+	}
+
+	btrfs_free_space_key(node, sc_header, &location);
+	btrfs_disk_key_to_cpu(&key, &location);
+	btrfs_release_path(&path);
+
+	/* Change to type and offset to search file extent */
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
+	if (ret) {
+		error("failed to find free space cache extent data for blockgroup %llu, ret: %d\n",
+		      block_group, ret);
+		goto out;
+	}
+
+	slot = path.slots[0];
+	node = path.nodes[0];
+	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
+	disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
+
+	/*
+	 * Directly write random data into
+	 * [disk_bytenr, disk_bytenr + sectorsize) as free space cache inode
+	 * doesn't have csum
+	 */
+	corrupted_node = debug_corrupt_block(tree_root, disk_bytenr,
+					     tree_root->sectorsize, 0);
+	free_extent_buffer(corrupted_node);
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
 int main(int argc, char **argv)
 {
 	struct cache_tree root_cache;
@@ -1032,6 +1129,7 @@ int main(int argc, char **argv)
 	int corrupt_item = 0;
 	int corrupt_di = 0;
 	int delete = 0;
+	int corrupt_sc_file = 0;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -1065,11 +1163,12 @@ int main(int argc, char **argv)
 			{ "delete", no_argument, NULL, 'd'},
 			{ "root", no_argument, NULL, 'r'},
 			{ "csum", required_argument, NULL, 'C'},
+			{ "space-cache-file", required_argument, NULL, 's'},
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP},
 			{ NULL, 0, NULL, 0 }
 		};
 
-		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:IDdr:C:",
+		c = getopt_long(argc, argv, "l:c:b:eEkuUi:f:x:m:K:IDdr:C:s:",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -1136,6 +1235,22 @@ int main(int argc, char **argv)
 			case 'C':
 				csum_bytenr = arg_strtou64(optarg);
 				break;
+			case 's':
+				if (!strncmp(optarg, "zero_gen",
+					     sizeof("zero_gen")))
+					corrupt_sc_file =
+						CORRUPT_SC_FILE_ZERO_GEN;
+				else if (!strncmp(optarg, "rand_gen",
+						  sizeof("rand_gen")))
+					corrupt_sc_file =
+						CORRUPT_SC_FILE_RAND_GEN;
+				else if (!strncmp(optarg, "content",
+						  sizeof("content")))
+					corrupt_sc_file =
+						CORRUPT_SC_FILE_CONTENT;
+				else
+					print_usage(1);
+				break;
 			case GETOPT_VAL_HELP:
 			default:
 				print_usage(c != GETOPT_VAL_HELP);
@@ -1154,6 +1269,13 @@ int main(int argc, char **argv)
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
 	}
+	if (corrupt_sc_file) {
+		if (logical == (u64)-1)
+			print_usage(1);
+		ret = corrupt_space_cache_file(root->fs_info, logical,
+					       corrupt_sc_file);
+		goto out_close;
+	}
 	if (extent_rec) {
 		struct btrfs_trans_handle *trans;
 
-- 
2.8.2



