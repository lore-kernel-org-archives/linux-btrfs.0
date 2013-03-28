Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55944 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab3C1OSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 10:18:47 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E9C949A03E9
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 08:18:46 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id nG7R1eq07DtVifLy (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 08:18:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add an option to btrfs-image to walk the trees
Date: Thu, 28 Mar 2013 10:26:09 -0400
Message-ID: <1364480769-17193-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When working with a user with a broken file system I noticed I wasn't able to
read some of the blocks properly from the restored image.  This is because his
extent tree was corrupt and was missing references to some of the blocks, which
means they weren't copied into the image when he generated it.  So add a -w
option which will walk all of the trees manually and copy them into the image.
This way we can run fsck against a complete file system image and fix any bugs
in fsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-image.c        |  165 ++++++++++++++++++++++++++++++--------------------
 man/btrfs-image.8.in |    5 ++
 2 files changed, 104 insertions(+), 66 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index d22e4a6..a181288 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -940,9 +940,8 @@ static int is_tree_block(struct btrfs_root *extent_root,
 }
 #endif
 
-static int copy_log_blocks(struct btrfs_root *root, struct extent_buffer *eb,
-			   struct metadump_struct *metadump,
-			   int log_root_tree)
+static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
+			    struct metadump_struct *metadump, int root_tree)
 {
 	struct extent_buffer *tmp;
 	struct btrfs_root_item *ri;
@@ -959,7 +958,7 @@ static int copy_log_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 		return ret;
 	}
 
-	if (btrfs_header_level(eb) == 0 && !log_root_tree)
+	if (btrfs_header_level(eb) == 0 && !root_tree)
 		return 0;
 
 	level = btrfs_header_level(eb);
@@ -977,7 +976,7 @@ static int copy_log_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 					"block\n");
 				return -EIO;
 			}
-			ret = copy_log_blocks(root, tmp, metadump, 0);
+			ret = copy_tree_blocks(root, tmp, metadump, 0);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -988,8 +987,7 @@ static int copy_log_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 				fprintf(stderr, "Error reading log block\n");
 				return -EIO;
 			}
-			ret = copy_log_blocks(root, tmp, metadump,
-					      log_root_tree);
+			ret = copy_tree_blocks(root, tmp, metadump, root_tree);
 			free_extent_buffer(tmp);
 			if (ret)
 				return ret;
@@ -1014,8 +1012,8 @@ static int copy_log_trees(struct btrfs_root *root,
 		return -EIO;
 	}
 
-	return copy_log_blocks(root, root->fs_info->log_root_tree->node,
-			       metadump, 1);
+	return copy_tree_blocks(root, root->fs_info->log_root_tree->node,
+				metadump, 1);
 }
 
 static int copy_space_cache(struct btrfs_root *root,
@@ -1084,51 +1082,18 @@ static int copy_space_cache(struct btrfs_root *root,
 	return 0;
 }
 
-static int create_metadump(const char *input, FILE *out, int num_threads,
-			   int compress_level, int sanitize)
+static int copy_from_extent_tree(struct metadump_struct *metadump,
+				 struct btrfs_path *path)
 {
-	struct btrfs_root *root;
 	struct btrfs_root *extent_root;
-	struct btrfs_path *path = NULL;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
-	struct metadump_struct metadump;
 	u64 bytenr;
 	u64 num_bytes;
 	int ret;
-	int err = 0;
-
-	root = open_ctree(input, 0, 0);
-	if (!root) {
-		fprintf(stderr, "Open ctree failed\n");
-		return -EIO;
-	}
-
-	BUG_ON(root->nodesize != root->leafsize);
-
-	ret = metadump_init(&metadump, root, out, num_threads,
-			    compress_level, sanitize);
-	if (ret) {
-		fprintf(stderr, "Error initing metadump %d\n", ret);
-		close_ctree(root);
-		return ret;
-	}
-
-	ret = add_extent(BTRFS_SUPER_INFO_OFFSET, 4096, &metadump, 0);
-	if (ret) {
-		fprintf(stderr, "Error adding metadata %d\n", ret);
-		err = ret;
-		goto out;
-	}
 
-	extent_root = root->fs_info->extent_root;
-	path = btrfs_alloc_path();
-	if (!path) {
-		fprintf(stderr, "Out of memory allocing path\n");
-		err = -ENOMEM;
-		goto out;
-	}
+	extent_root = metadump->root->fs_info->extent_root;
 	bytenr = BTRFS_SUPER_INFO_OFFSET + 4096;
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -1137,9 +1102,9 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0) {
 		fprintf(stderr, "Error searching extent root %d\n", ret);
-		err = ret;
-		goto out;
+		return ret;
 	}
+	ret = 0;
 
 	while (1) {
 		leaf = path->nodes[0];
@@ -1148,11 +1113,12 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 			if (ret < 0) {
 				fprintf(stderr, "Error going to next leaf %d"
 					"\n", ret);
-				err = ret;
-				goto out;
+				break;
 			}
-			if (ret > 0)
+			if (ret > 0) {
+				ret = 0;
 				break;
+			}
 			leaf = path->nodes[0];
 		}
 
@@ -1168,20 +1134,19 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 		if (key.type == BTRFS_METADATA_ITEM_KEY)
 			num_bytes = key.offset;
 		else
-			num_bytes = root->leafsize;
+			num_bytes = extent_root->leafsize;
 
 		if (btrfs_item_size_nr(leaf, path->slots[0]) > sizeof(*ei)) {
 			ei = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_extent_item);
 			if (btrfs_extent_flags(leaf, ei) &
 			    BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-				ret = add_extent(bytenr, num_bytes, &metadump,
+				ret = add_extent(bytenr, num_bytes, metadump,
 						 0);
 				if (ret) {
 					fprintf(stderr, "Error adding block "
 						"%d\n", ret);
-					err = ret;
-					goto out;
+					break;
 				}
 			}
 		} else {
@@ -1190,31 +1155,94 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 			if (ret < 0) {
 				fprintf(stderr, "Error checking tree block "
 					"%d\n", ret);
-				err = ret;
-				goto out;
+				break;
 			}
 
 			if (ret) {
-				ret = add_extent(bytenr, num_bytes, &metadump,
+				ret = add_extent(bytenr, num_bytes, metadump,
 						 0);
 				if (ret) {
 					fprintf(stderr, "Error adding block "
 						"%d\n", ret);
-					err = ret;
-					goto out;
+					break;
 				}
 			}
+			ret = 0;
 #else
 			fprintf(stderr, "Either extent tree corruption or "
 				"you haven't built with V0 support\n");
-			err = -EIO;
-			goto out;
+			ret = -EIO;
+			break;
 #endif
 		}
 		bytenr += num_bytes;
 	}
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(extent_root, path);
+
+	return ret;
+}
+
+static int create_metadump(const char *input, FILE *out, int num_threads,
+			   int compress_level, int sanitize, int walk_trees)
+{
+	struct btrfs_root *root;
+	struct btrfs_path *path = NULL;
+	struct metadump_struct metadump;
+	int ret;
+	int err = 0;
+
+	root = open_ctree(input, 0, 0);
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return -EIO;
+	}
+
+	BUG_ON(root->nodesize != root->leafsize);
+
+	ret = metadump_init(&metadump, root, out, num_threads,
+			    compress_level, sanitize);
+	if (ret) {
+		fprintf(stderr, "Error initing metadump %d\n", ret);
+		close_ctree(root);
+		return ret;
+	}
+
+	ret = add_extent(BTRFS_SUPER_INFO_OFFSET, 4096, &metadump, 0);
+	if (ret) {
+		fprintf(stderr, "Error adding metadata %d\n", ret);
+		err = ret;
+		goto out;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		fprintf(stderr, "Out of memory allocing path\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	if (walk_trees) {
+		ret = copy_tree_blocks(root, root->fs_info->chunk_root->node,
+				       &metadump, 1);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
+
+		ret = copy_tree_blocks(root, root->fs_info->tree_root->node,
+				       &metadump, 1);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
+	} else {
+		ret = copy_from_extent_tree(&metadump, path);
+		if (ret) {
+			err = ret;
+			goto out;
+		}
+	}
 
 	ret = copy_log_trees(root, &metadump, path);
 	if (ret) {
@@ -1227,7 +1255,7 @@ out:
 	ret = flush_pending(&metadump, 1);
 	if (ret) {
 		if (!err)
-			ret = err;
+			err = ret;
 		fprintf(stderr, "Error flushing pending %d\n", ret);
 	}
 
@@ -1833,7 +1861,8 @@ static void print_usage(void)
 	fprintf(stderr, "\t-c value\tcompression level (0 ~ 9)\n");
 	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
 	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
-	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions");
+	fprintf(stderr, "\t-s      \tsanitize file names, use once to just use garbage, use twice if you want crc collisions\n");
+	fprintf(stderr, "\t-w      \twalk all trees instead of using extent tree, do this if your extent tree is broken\n");
 	exit(1);
 }
 
@@ -1845,12 +1874,13 @@ int main(int argc, char *argv[])
 	int compress_level = 0;
 	int create = 1;
 	int old_restore = 0;
+	int walk_trees = 0;
 	int ret;
 	int sanitize = 0;
 	FILE *out;
 
 	while (1) {
-		int c = getopt(argc, argv, "rc:t:os");
+		int c = getopt(argc, argv, "rc:t:osw");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -1873,6 +1903,9 @@ int main(int argc, char *argv[])
 		case 's':
 			sanitize++;
 			break;
+		case 'w':
+			walk_trees = 1;
+			break;
 		default:
 			print_usage();
 		}
@@ -1905,7 +1938,7 @@ int main(int argc, char *argv[])
 
 	if (create)
 		ret = create_metadump(source, out, num_threads,
-				      compress_level, sanitize);
+				      compress_level, sanitize, walk_trees);
 	else
 		ret = restore_metadump(source, out, old_restore, 1);
 
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
index f8fed15..3c40eaf 100644
--- a/man/btrfs-image.8.in
+++ b/man/btrfs-image.8.in
@@ -37,6 +37,11 @@ calculate a collision for the filename so that the hashes match, and if it
 can't calculate a collision then it will just generate garbage.  The collision
 calculator is very time and CPU intensive so only use it if you are having
 problems with your file system tree and need to have it mostly working.
+.TP
+\fB\-w\fP
+Walk all the trees manually and copy any blocks that are referenced. Use this
+option if your extent tree is corrupted to make sure that all of the metadata is
+captured.
 .SH AVAILABILITY
 .B btrfs-image
 is part of btrfs-progs. Btrfs is currently under heavy development,
-- 
1.7.7.6

