Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59108 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3CSNf4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 09:35:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 9428D9A0367
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 07:35:55 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id HB6uiM6oIWFt6sm2 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 07:35:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make btrfs-image grab the free space cache
Date: Tue, 19 Mar 2013 09:43:13 -0400
Message-ID: <1363700593-1882-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A lot of tree log replay bugs are because of strange space cache setups, so make
btrfs-image scrape the free space cache as well so we can better replicate what
a user is seeing if they have a tree log bug or anything related to free space
cache.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 151 insertions(+), 11 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index ad028de..b39174b 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -34,7 +34,7 @@
 #include "transaction.h"
 #include "utils.h"
 #include "version.h"
-
+#include "volumes.h"
 
 #define HEADER_MAGIC		0xbd5c25e27295668bULL
 #define MAX_PENDING_SIZE	(256 * 1024)
@@ -96,6 +96,7 @@ struct metadump_struct {
 
 	int compress_level;
 	int done;
+	int data;
 };
 
 struct mdrestore_struct {
@@ -409,6 +410,60 @@ out:
 	return err;
 }
 
+static int read_data_extent(struct metadump_struct *md,
+			    struct async_work *async)
+{
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_device *device;
+	u64 bytes_left = async->size;
+	u64 logical = async->start;
+	u64 offset = 0;
+	u64 bytenr;
+	u64 read_len;
+	ssize_t done;
+	int fd;
+	int ret;
+
+	while (bytes_left) {
+		read_len = bytes_left;
+		ret = btrfs_map_block(&md->root->fs_info->mapping_tree, READ,
+				      logical, &read_len, &multi, 0, NULL);
+		if (ret) {
+			fprintf(stderr, "Couldn't map data block %d\n", ret);
+			return ret;
+		}
+
+		device = multi->stripes[0].dev;
+
+		if (device->fd == 0) {
+			fprintf(stderr, "Device we need to read from is not "
+				"open\n");
+			free(multi);
+			return -EIO;
+		}
+		fd = device->fd;
+		bytenr = multi->stripes[0].physical;
+		free(multi);
+
+		read_len = min(read_len, bytes_left);
+		done = pread64(fd, async->buffer+offset, read_len, bytenr);
+		if (done < read_len) {
+			if (done < 0)
+				fprintf(stderr, "Error reading extent %d\n",
+					errno);
+			else
+				fprintf(stderr, "Short read\n");
+			return -EIO;
+		}
+
+		bytes_left -= done;
+		offset += done;
+		logical += done;
+	}
+
+	return 0;
+}
+
 static int flush_pending(struct metadump_struct *md, int done)
 {
 	struct async_work *async = NULL;
@@ -435,7 +490,17 @@ static int flush_pending(struct metadump_struct *md, int done)
 		offset = 0;
 		start = async->start;
 		size = async->size;
-		while (size > 0) {
+
+		if (md->data) {
+			ret = read_data_extent(md, async);
+			if (ret) {
+				free(async->buffer);
+				free(async);
+				return ret;
+			}
+		}
+
+		while (!md->data && size > 0) {
 			eb = read_tree_block(md->root, start, blocksize, 0);
 			if (!eb) {
 				free(async->buffer);
@@ -480,10 +545,12 @@ static int flush_pending(struct metadump_struct *md, int done)
 	return ret;
 }
 
-static int add_metadata(u64 start, u64 size, struct metadump_struct *md)
+static int add_extent(u64 start, u64 size, struct metadump_struct *md,
+		      int data)
 {
 	int ret;
-	if (md->pending_size + size > MAX_PENDING_SIZE ||
+	if (md->data != data ||
+	    md->pending_size + size > MAX_PENDING_SIZE ||
 	    md->pending_start + md->pending_size != start) {
 		ret = flush_pending(md, 0);
 		if (ret)
@@ -492,6 +559,7 @@ static int add_metadata(u64 start, u64 size, struct metadump_struct *md)
 	}
 	readahead_tree_block(md->root, start, size, 0);
 	md->pending_size += size;
+	md->data = data;
 	return 0;
 }
 
@@ -545,7 +613,7 @@ static int copy_log_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 	int i = 0;
 	int ret;
 
-	ret = add_metadata(btrfs_header_bytenr(eb), root->leafsize, metadump);
+	ret = add_extent(btrfs_header_bytenr(eb), root->leafsize, metadump, 0);
 	if (ret) {
 		fprintf(stderr, "Error adding metadata block\n");
 		return ret;
@@ -610,6 +678,72 @@ static int copy_log_trees(struct btrfs_root *root,
 			       metadump, 1);
 }
 
+static int copy_space_cache(struct btrfs_root *root,
+			    struct metadump_struct *metadump,
+			    struct btrfs_path *path)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 bytenr, num_bytes;
+	int ret;
+
+	root = root->fs_info->tree_root;
+
+	key.objectid = 0;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error searching for free space inode %d\n",
+			ret);
+		return ret;
+	}
+
+	while (1) {
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				fprintf(stderr, "Error going to next leaf "
+					"%d\n", ret);
+				return ret;
+			}
+			if (ret > 0)
+				break;
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.type != BTRFS_EXTENT_DATA_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, fi) !=
+		    BTRFS_FILE_EXTENT_REG) {
+			path->slots[0]++;
+			continue;
+		}
+
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+		ret = add_extent(bytenr, num_bytes, metadump, 1);
+		if (ret) {
+			fprintf(stderr, "Error adding space cache blocks %d\n",
+				ret);
+			btrfs_release_path(root, path);
+			return ret;
+		}
+		path->slots[0]++;
+	}
+
+	return 0;
+}
+
 static int create_metadump(const char *input, FILE *out, int num_threads,
 			   int compress_level)
 {
@@ -641,7 +775,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 		return ret;
 	}
 
-	ret = add_metadata(BTRFS_SUPER_INFO_OFFSET, 4096, &metadump);
+	ret = add_extent(BTRFS_SUPER_INFO_OFFSET, 4096, &metadump, 0);
 	if (ret) {
 		fprintf(stderr, "Error adding metadata %d\n", ret);
 		err = ret;
@@ -701,8 +835,8 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 					    struct btrfs_extent_item);
 			if (btrfs_extent_flags(leaf, ei) &
 			    BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-				ret = add_metadata(bytenr, num_bytes,
-						   &metadump);
+				ret = add_extent(bytenr, num_bytes, &metadump,
+						 0);
 				if (ret) {
 					fprintf(stderr, "Error adding block "
 						"%d\n", ret);
@@ -721,8 +855,8 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 			}
 
 			if (ret) {
-				ret = add_metadata(bytenr, num_bytes,
-						   &metadump);
+				ret = add_extent(bytenr, num_bytes, &metadump,
+						 0);
 				if (ret) {
 					fprintf(stderr, "Error adding block "
 						"%d\n", ret);
@@ -740,9 +874,15 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 		bytenr += num_bytes;
 	}
 
+	btrfs_release_path(root, path);
+
 	ret = copy_log_trees(root, &metadump, path);
-	if (ret)
+	if (ret) {
 		err = ret;
+		goto out;
+	}
+
+	ret = copy_space_cache(root, &metadump, path);
 out:
 	ret = flush_pending(&metadump, 1);
 	if (ret) {
-- 
1.7.7.6

