Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3863 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753056AbaKLFvt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 00:51:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAC5pX5F008661
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 13:51:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] btrfs-progs: Enhance btrfs-find-root.
Date: Wed, 12 Nov 2014 13:52:12 +0800
Message-ID: <1415771534-7979-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance btrfs-find-root in the following way:
1. Use existing or lightly modified btrfs infrastructure
   Don't use btrfs-find-root local defined open_ctree or csum check.
   Slightly modify open_ctree() and csum_tree_block() to provide the
   chunk-only open_ctree and suprress error output for csum_tree_block()

2. Output the trees in an ascending order of generation
   Normally, end user running btrfs-find-root is hoping to find out a
   recently new old root.
   So output the search result in an ascending order of generation.

3. Hide the obviously not tree root node/leaf
   Only output the node/leaf with the highest level among its generation
   to simplify the output.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-find-root.txt |   2 +
 btrfs-find-root.c                 | 435 ++++++++++++++++++--------------------
 ctree.h                           |   2 +
 disk-io.c                         |  24 ++-
 disk-io.h                         |  15 +-
 5 files changed, 236 insertions(+), 242 deletions(-)

diff --git a/Documentation/btrfs-find-root.txt b/Documentation/btrfs-find-root.txt
index c934b4c..903cd63 100644
--- a/Documentation/btrfs-find-root.txt
+++ b/Documentation/btrfs-find-root.txt
@@ -22,6 +22,8 @@ Filter root tree by it's original transaction id, tree root's generation in defa
 Filter root tree by it's objectid,tree root's objectid in default.
 -l <level>::
 Filter root tree by B-+ tree's level, level 0 in default.
+-a::
+Search for all root even the desired root is already found.
 
 EXIT STATUS
 -----------
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 6fa61cc..d658989 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -35,266 +35,250 @@
 #include "utils.h"
 #include "crc32c.h"
 
-static u16 csum_size = 0;
-static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;
-static u64 search_generation = 0;
-static unsigned long search_level = 0;
+/*
+ * find root result is a list like the following:
+ *
+ * result_list
+ *    |
+ *    gen_list	<->	gen_list	<->	gen_list ...
+ *    gen:4		gen:5			gen:6
+ *    level:0		level:1			level:2
+ *    level_list	level_list		level_list
+ *    |-l 0's eb	|-l 1'eb(possible root)	|-l 2'eb(possible root)
+ *    |-l 0's eb
+ *    ...
+ *    level_list only contains the highest level's eb.
+ *    if level_list only contains 1 eb, that may be root.
+ *    if multiple, the root is already overwritten.
+ */
+struct eb_entry{
+	struct list_head list;
+	struct extent_buffer *eb;
+};
+
+struct generation_entry{
+	struct list_head gen_list;
+	struct list_head eb_list;
+	u64 generation;
+	u8 level;
+};
+
+struct search_filter {
+	u64 objectid;
+	u64 generation;
+	u64 level;
+	u64 super_gen;
+	int search_all;
+};
 
 static void usage(void)
 {
 	fprintf(stderr, "Usage: find-roots [-o search_objectid] "
-		"[ -g search_generation ] [ -l search_level ] <device>\n");
+		"[ -g search_generation ] [ -l search_level ] [ -a ] "
+		"[ -s [+-]{objectid|generation} ] <device>\n");
 }
 
-static int csum_block(void *buf, u32 len)
+static inline void print_message(struct eb_entry *ebe,
+				 struct btrfs_super_block *super)
 {
-	char *result;
-	u32 crc = ~(u32)0;
-	int ret = 0;
-
-	result = malloc(csum_size * sizeof(char));
-	if (!result) {
-		fprintf(stderr, "No memory\n");
-		return 1;
-	}
-
-	len -= BTRFS_CSUM_SIZE;
-	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len);
-	btrfs_csum_final(crc, result);
-
-	if (memcmp(buf, result, csum_size))
-		ret = 1;
-	free(result);
-	return ret;
+	u64 generation = btrfs_header_generation(ebe->eb);
+
+	if (generation != btrfs_super_generation(super))
+		printf("Well block %llu seems great, but generation doesn't match, have=%llu, want=%llu level %u\n",
+			btrfs_header_bytenr(ebe->eb),
+			btrfs_header_generation(ebe->eb),
+			btrfs_super_generation(super),
+			btrfs_header_level(ebe->eb));
+	else
+		printf("Found tree root at %llu gen %llu level %u\n",
+			btrfs_header_bytenr(ebe->eb),
+			btrfs_header_generation(ebe->eb),
+			btrfs_header_level(ebe->eb));
 }
 
-static struct btrfs_root *open_ctree_broken(int fd, const char *device)
+static void print_result(struct btrfs_root *chunk_root,
+			 struct list_head *result_list)
 {
-	struct btrfs_fs_info *fs_info;
-	struct btrfs_super_block *disk_super;
-	struct btrfs_fs_devices *fs_devices = NULL;
-	struct extent_buffer *eb;
-	int ret;
-
-	fs_info = btrfs_new_fs_info(0, BTRFS_SUPER_INFO_OFFSET);
-	if (!fs_info) {
-		fprintf(stderr, "Failed to allocate memory for fs_info\n");
-		return NULL;
-	}
-
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1);
-	if (ret)
-		goto out;
-
-	fs_info->fs_devices = fs_devices;
-
-	ret = btrfs_open_devices(fs_devices, O_RDONLY);
-	if (ret)
-		goto out_devices;
-
-	disk_super = fs_info->super_copy;
-	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, fs_info->super_bytenr, 1);
-	if (ret) {
-		printk("No valid btrfs found\n");
-		goto out_devices;
-	}
-
-	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
-
-	ret = btrfs_check_fs_compatibility(disk_super, 0);
-	if (ret)
-		goto out_devices;
-
-	ret = btrfs_setup_chunk_tree_and_device_map(fs_info);
-	if (ret)
-		goto out_chunk;
-
-	eb = fs_info->chunk_root->node;
-	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
-			   btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
-
-	return fs_info->chunk_root;
-out_chunk:
-	free_extent_buffer(fs_info->chunk_root->node);
-	btrfs_cleanup_all_caches(fs_info);
-out_devices:
-	btrfs_close_devices(fs_info->fs_devices);
-out:
-	btrfs_free_fs_info(fs_info);
-	return NULL;
+	struct btrfs_super_block *super = chunk_root->fs_info->super_copy;
+	struct eb_entry *ebe;
+	struct generation_entry *gene;
+
+	printf("Super think's the tree root is at %llu, chunk root %llu\n",
+	       btrfs_super_root(super), btrfs_super_chunk_root(super));
+	list_for_each_entry(gene, result_list, gen_list)
+		list_for_each_entry(ebe, &gene->eb_list, list)
+			print_message(ebe, super);
 }
 
-static int search_iobuf(struct btrfs_root *root, void *iobuf,
-			size_t iobuf_size, off_t offset)
+static int add_eb_to_gen(struct extent_buffer *eb,
+			 struct generation_entry *gene)
 {
-	u64 gen = search_generation;
-	u64 objectid = search_objectid;
-	u32 size = btrfs_super_nodesize(root->fs_info->super_copy);
-	u8 level = search_level;
-	size_t block_off = 0;
-
-	while (block_off < iobuf_size) {
-		void *block = iobuf + block_off;
-		struct btrfs_header *header = block;
-		u64 h_byte, h_level, h_gen, h_owner;
-
-//		printf("searching %Lu\n", offset + block_off);
-		h_byte = btrfs_stack_header_bytenr(header);
-		h_owner = btrfs_stack_header_owner(header);
-		h_level = header->level;
-		h_gen = btrfs_stack_header_generation(header);
-
-		if (h_owner != objectid)
-			goto next;
-		if (h_byte != (offset + block_off))
-			goto next;
-		if (h_level < level)
-			goto next;
-		level = h_level;
-		if (csum_block(block, size)) {
-			fprintf(stderr, "Well block %Lu seems good, "
-				"but the csum doesn't match\n",
-				h_byte);
-			goto next;
+	struct list_head *pos;
+	struct eb_entry *ebe;
+	struct eb_entry *n;
+	struct eb_entry *new;
+	u8 level = btrfs_header_level(eb);
+	u64 bytenr = btrfs_header_bytenr(eb);
+
+	if (level < gene->level)
+		goto free_out;
+
+	new = malloc(sizeof(*new));
+	if (!new)
+		return -ENOMEM;
+	new->eb = eb;
+
+	if (level > gene->level) {
+		gene->level = level;
+		list_for_each_entry_safe(ebe, n, &gene->eb_list, list) {
+			list_del(&ebe->list);
+			free_extent_buffer(ebe->eb);
+			free(ebe);
 		}
-		if (h_gen != gen) {
-			fprintf(stderr, "Well block %Lu seems great, "
-				"but generation doesn't match, "
-				"have=%Lu, want=%Lu level %Lu\n", h_byte,
-				h_gen, gen, h_level);
-			goto next;
-		}
-		printf("Found tree root at %Lu gen %Lu level %Lu\n", h_byte,
-		       h_gen, h_level);
+		list_add(&new->list, &gene->eb_list);
 		return 0;
-next:
-		block_off += size;
 	}
-
-	return 1;
+	list_for_each(pos, &gene->eb_list) {
+		ebe = list_entry(pos, struct eb_entry, list);
+		if (btrfs_header_bytenr(ebe->eb) > bytenr) {
+			pos = pos->prev;
+			break;
+		}
+	}
+	list_add_tail(&new->list, pos);
+	return 0;
+free_out:
+	free_extent_buffer(eb);
+	return 0;
 }
 
-static int read_physical(struct btrfs_root *root, int fd, u64 offset,
-			 u64 bytenr, u64 len)
+static int add_eb_to_result(struct extent_buffer *eb,
+			    struct list_head *result_list,
+			    struct search_filter *search)
 {
-	char *iobuf = malloc(len);
-	ssize_t done;
-	size_t total_read = 0;
-	int ret = 1;
+	struct list_head *pos;
+	struct generation_entry *gene;
+	struct generation_entry *new;
+	u64 generation = btrfs_header_generation(eb);
+	u64 level = btrfs_header_level(eb);
+	u64 owner = btrfs_header_owner(eb);
+	int found = 0;
+	int ret = 0;
 
-	if (!iobuf) {
-		fprintf(stderr, "No memory\n");
-		return -1;
-	}
+	if (owner != search->objectid || level < search->level ||
+	    generation < search->generation)
+		goto free_out;
 
-	while (total_read < len) {
-		done = pread64(fd, iobuf + total_read, len - total_read,
-			       bytenr + total_read);
-		if (done < 0) {
-			fprintf(stderr, "Failed to read: %s\n",
-				strerror(errno));
-			ret = -1;
-			goto out;
+	list_for_each(pos, result_list) {
+		gene = list_entry(pos, struct generation_entry, gen_list);
+		if (gene->generation == generation) {
+			found = 1;
+			break;
+		}
+		if (gene->generation > generation) {
+			pos = pos->prev;
+			break;
 		}
-		total_read += done;
 	}
-
-	ret = search_iobuf(root, iobuf, total_read, offset);
-out:
-	free(iobuf);
+	if (found) {
+		ret = add_eb_to_gen(eb, gene);
+	} else {
+		new = malloc(sizeof(*new));
+		if (!new) {
+			ret = -ENOMEM;
+			goto free_out;
+		}
+		new->generation = generation;
+		new->level = 0;
+		INIT_LIST_HEAD(&new->gen_list);
+		INIT_LIST_HEAD(&new->eb_list);
+		list_add_tail(&new->gen_list, pos);
+		ret = add_eb_to_gen(eb, new);
+	}
+	if (ret)
+		goto free_out;
+	if (generation == search->super_gen && !search->search_all)
+		ret = 1;
+	return ret;
+free_out:
+	free_extent_buffer(eb);
 	return ret;
 }
-
-static int find_root(struct btrfs_root *root)
+static int find_root(struct btrfs_root *chunk_root,
+		     struct list_head *result_list,
+		     struct search_filter *search)
 {
-	struct btrfs_multi_bio *multi = NULL;
-	struct btrfs_device *device;
-	u64 metadata_offset = 0, metadata_size = 0;
-	off_t offset = 0;
-	off_t bytenr;
-	int fd;
-	int err;
-	int ret = 1;
-
-	printf("Super think's the tree root is at %Lu, chunk root %Lu\n",
-	       btrfs_super_root(root->fs_info->super_copy),
-	       btrfs_super_chunk_root(root->fs_info->super_copy));
-
-	err = btrfs_next_metadata(&root->fs_info->mapping_tree,
-				  &metadata_offset, &metadata_size);
-	if (err)
-		return ret;
+	struct extent_buffer *eb;
+	struct btrfs_fs_info *fs_info = chunk_root->fs_info;
+	u64 metadata_offset = 0;
+	u64 metadata_size = 0;
+	u64 offset;
+	u64 leafsize = btrfs_super_leafsize(fs_info->super_copy);
+	int ret = 0;
 
-	offset = metadata_offset;
 	while (1) {
-		u64 map_length = 4096;
-		u64 type;
-
-		if (offset >
-		    btrfs_super_total_bytes(root->fs_info->super_copy)) {
-			printf("Went past the fs size, exiting");
+		ret = btrfs_next_metadata(&chunk_root->fs_info->mapping_tree,
+					  &metadata_offset, &metadata_size);
+		if (ret) {
+			if (ret == -ENOENT)
+				ret = 0;
 			break;
 		}
-		if (offset >= (metadata_offset + metadata_size)) {
-			err = btrfs_next_metadata(&root->fs_info->mapping_tree,
-						  &metadata_offset,
-						  &metadata_size);
-			if (err) {
-				printf("No more metdata to scan, exiting\n");
-				break;
+		for (offset = metadata_offset;
+		     offset < metadata_offset + metadata_size;
+		     offset += leafsize) {
+			eb = read_tree_block(chunk_root, offset, leafsize, 0);
+			if (!eb || IS_ERR(eb))
+				continue;
+			ret = add_eb_to_result(eb, result_list, search);
+			if (ret) {
+				ret = ret > 0 ? 0 : ret;
+				return ret;
 			}
-			offset = metadata_offset;
-		}
-		err = __btrfs_map_block(&root->fs_info->mapping_tree, READ,
-				      offset, &map_length, &type,
-				      &multi, 0, NULL);
-		if (err) {
-			offset += map_length;
-			continue;
 		}
+	}
+	return ret;
+}
 
-		if (!(type & BTRFS_BLOCK_GROUP_METADATA)) {
-			offset += map_length;
-			kfree(multi);
-			continue;
-		}
-
-		device = multi->stripes[0].dev;
-		fd = device->fd;
-		bytenr = multi->stripes[0].physical;
-		kfree(multi);
-
-		err = read_physical(root, fd, offset, bytenr, map_length);
-		if (!err) {
-			ret = 0;
-			break;
-		} else if (err < 0) {
-			ret = err;
-			break;
+static void free_result_list(struct list_head *result_list)
+{
+	struct eb_entry *ebe;
+	struct eb_entry *ebtmp;
+	struct generation_entry *gene;
+	struct generation_entry *gentmp;
+
+	list_for_each_entry_safe(gene, gentmp, result_list, gen_list) {
+		list_for_each_entry_safe(ebe, ebtmp,&gene->eb_list, list) {
+			list_del(&ebe->list);
+			free_extent_buffer(ebe->eb);
+			free(ebe);
 		}
-		offset += map_length;
+		list_del(&gene->gen_list);
+		free(gene);
 	}
-	return ret;
 }
 
 int main(int argc, char **argv)
 {
-	struct btrfs_root *root;
-	int dev_fd;
+	struct btrfs_root *chunk_root;
+	struct list_head result_list;
+	struct search_filter search = {BTRFS_ROOT_TREE_OBJECTID, 0 ,0, 0};
 	int opt;
 	int ret;
 
-	while ((opt = getopt(argc, argv, "l:o:g:")) != -1) {
+	while ((opt = getopt(argc, argv, "l:o:g:a")) != -1) {
 		switch(opt) {
 			case 'o':
-				search_objectid = arg_strtou64(optarg);
+				search.objectid = arg_strtou64(optarg);
 				break;
 			case 'g':
-				search_generation = arg_strtou64(optarg);
+				search.generation = arg_strtou64(optarg);
 				break;
 			case 'l':
-				search_level = arg_strtou64(optarg);
+				search.level = arg_strtou64(optarg);
+				break;
+			case 'a':
+				search.search_all = 1;
 				break;
 			default:
 				usage();
@@ -304,30 +288,23 @@ int main(int argc, char **argv)
 
 	set_argv0(argv);
 	argc = argc - optind;
-	if (check_argc_min(argc, 1)) {
+	if (check_argc_exact(argc, 1)) {
 		usage();
 		exit(1);
 	}
 
-	dev_fd = open(argv[optind], O_RDONLY);
-	if (dev_fd < 0) {
-		fprintf(stderr, "Failed to open device %s\n", argv[optind]);
-		exit(1);
-	}
-
-	root = open_ctree_broken(dev_fd, argv[optind]);
-	close(dev_fd);
-
-	if (!root) {
+	chunk_root = open_ctree(argv[optind], 0, OPEN_CTREE_CHUNK_ONLY);
+	if (!chunk_root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
 	}
 
-	if (search_generation == 0)
-		search_generation = btrfs_super_generation(root->fs_info->super_copy);
-
-	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-	ret = find_root(root);
-	close_ctree(root);
+	search.super_gen =
+		btrfs_super_generation(chunk_root->fs_info->super_copy);
+	INIT_LIST_HEAD(&result_list);
+	ret = find_root(chunk_root, &result_list, &search);
+	print_result(chunk_root, &result_list);
+	free_result_list(&result_list);
+	close_ctree(chunk_root);
 	return ret;
 }
diff --git a/ctree.h b/ctree.h
index 89036de..ee67404 100644
--- a/ctree.h
+++ b/ctree.h
@@ -995,6 +995,7 @@ struct btrfs_fs_info {
 	unsigned int on_restoring:1;
 	unsigned int is_chunk_recover:1;
 	unsigned int quota_enabled:1;
+	unsigned int suppress_error:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -1003,6 +1004,7 @@ struct btrfs_fs_info {
 				int refs_to_drop);
 	struct cache_tree *fsck_extent_cache;
 	struct cache_tree *corrupt_blocks;
+
 };
 
 /*
diff --git a/disk-io.c b/disk-io.c
index d2599b5..45fd58a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -42,7 +42,8 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	struct btrfs_fs_devices *fs_devices;
 	int ret = 1;
 
-	if (buf->start != btrfs_header_bytenr(buf)) {
+	if (buf->start != btrfs_header_bytenr(buf) &&
+	    !root->fs_info->suppress_error) {
 		printk("Check tree block failed, want=%Lu, have=%Lu\n",
 		       buf->start, btrfs_header_bytenr(buf));
 		return ret;
@@ -118,6 +119,8 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 {
 	u16 csum_size =
 		btrfs_super_csum_size(root->fs_info->super_copy);
+	if (root->fs_info->suppress_error)
+		return verify_tree_block_csum_silent(buf, csum_size);
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
@@ -282,10 +285,13 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 			return eb;
 		}
 		if (ignore) {
-			if (check_tree_block(root, eb))
-				printk("read block failed check_tree_block\n");
-			else
-				printk("Csum didn't match\n");
+			if (check_tree_block(root, eb)) {
+				if (!root->fs_info->suppress_error)
+					printk("read block failed check_tree_block\n");
+			} else {
+				if (!root->fs_info->suppress_error)
+					printk("Csum didn't match\n");
+			}
 			break;
 		}
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
@@ -1101,6 +1107,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 	if (flags & OPEN_CTREE_RESTORE)
 		fs_info->on_restoring = 1;
+	if (flags & OPEN_CTREE_CHUNK_ONLY)
+		fs_info->suppress_error = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
 				    (flags & OPEN_CTREE_RECOVER_SUPER));
@@ -1148,7 +1156,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 			   BTRFS_UUID_SIZE);
 
 	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, flags);
-	if (ret)
+	if (ret && !(flags & OPEN_CTREE_CHUNK_ONLY))
 		goto out_chunk;
 
 	return fs_info;
@@ -1193,6 +1201,8 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 	info = open_ctree_fs_info(filename, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
+	if (flags & OPEN_CTREE_CHUNK_ONLY)
+		return info->chunk_root;
 	return info->fs_root;
 }
 
@@ -1203,6 +1213,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	info = __open_ctree_fd(fp, path, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
+	if (flags & OPEN_CTREE_CHUNK_ONLY)
+		return info->chunk_root;
 	return info->fs_root;
 }
 
diff --git a/disk-io.h b/disk-io.h
index 4818109..7506a5a 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -26,13 +26,14 @@
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
 enum btrfs_open_ctree_flags {
-	OPEN_CTREE_WRITES		= 1,
-	OPEN_CTREE_PARTIAL		= 2,
-	OPEN_CTREE_BACKUP_ROOT		= 4,
-	OPEN_CTREE_RECOVER_SUPER	= 8,
-	OPEN_CTREE_RESTORE		= 16,
-	OPEN_CTREE_NO_BLOCK_GROUPS	= 32,
-	OPEN_CTREE_EXCLUSIVE		= 64,
+	OPEN_CTREE_WRITES		= (1 << 0),
+	OPEN_CTREE_PARTIAL		= (1 << 1),
+	OPEN_CTREE_BACKUP_ROOT		= (1 << 2),
+	OPEN_CTREE_RECOVER_SUPER	= (1 << 3),
+	OPEN_CTREE_RESTORE		= (1 << 4),
+	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
+	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
+	OPEN_CTREE_CHUNK_ONLY		= (1 << 7),
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.1.3

