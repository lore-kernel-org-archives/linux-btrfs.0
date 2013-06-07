Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26050 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab3FGCZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Jun 2013 22:25:22 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r572PIMR020695
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Jun 2013 10:25:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH] btrfs-progs: Add chunk corrupt funtion to btrfs-corrupt-block
Date: Fri, 7 Jun 2013 10:25:59 +0800
Message-Id: <1370571959-13715-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add chunk corrupt function to btrfs-corrupt-block.
This funtion can be used to delete or corrupt a given chunk or the whole
chunk tree.

This funtion is useful to test the coming chunk recover funtion.

BTW, since the chunk recover funtion is based on whole partion scanning,
so the COW should be disabled and edit leaf without changing generation.
Which makes btrfs_commit_transation giving some ignorable warning.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 218 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 201 insertions(+), 17 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 8176fad..481b7b8 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -58,8 +58,9 @@ struct extent_buffer *debug_corrupt_block(struct btrfs_root *root, u64 bytenr,
 		device->total_ios++;
 		eb->dev_bytenr = multi->stripes[0].physical;
 
-		fprintf(stdout, "mirror %d logical %Lu physical %Lu "
-			"device %s\n", mirror_num, (unsigned long long)bytenr,
+		fprintf(stdout,
+			"mirror %d logical %llu physical %llu device %s\n",
+			mirror_num, (unsigned long long)bytenr,
 			(unsigned long long)eb->dev_bytenr, device->name);
 		kfree(multi);
 
@@ -92,7 +93,9 @@ static void print_usage(void)
 		" (usually 1 or 2, default: 0)\n");
 	fprintf(stderr, "\t-b Number of bytes to be corrupted\n");
 	fprintf(stderr, "\t-e Extent to be corrupted\n");
-	fprintf(stderr, "\t-E The whole extent free to be corrupted\n");
+	fprintf(stderr, "\t-E The whole extent tree to be corrupted\n");
+	fprintf(stderr, "\t-u Given chunk item to be corrupted\n");
+	fprintf(stderr, "\t-U The whole chunk tree to be corrupted\n");
 	exit(1);
 }
 
@@ -115,7 +118,8 @@ static void corrupt_keys(struct btrfs_trans_handle *trans,
 	if (bad_slot == slot)
 		return;
 
-	fprintf(stderr, "corrupting keys in block %llu slot %d swapping with %d\n",
+	fprintf(stderr,
+		"corrupting keys in block %llu slot %d swapping with %d\n",
 		(unsigned long long)eb->start, slot, bad_slot);
 
 	if (btrfs_header_level(eb) == 0) {
@@ -191,7 +195,8 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 			goto next;
 
 		if (should_del) {
-			fprintf(stderr, "deleting extent record: key %Lu %u %Lu\n",
+			fprintf(stderr,
+				"deleting extent record: key %llu %u %llu\n",
 				key.objectid, key.type, key.offset);
 
 			if (key.type == BTRFS_EXTENT_ITEM_KEY) {
@@ -203,7 +208,8 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 
 			btrfs_del_item(trans, root, path);
 		} else {
-			fprintf(stderr, "corrupting extent record: key %Lu %u %Lu\n",
+			fprintf(stderr,
+				"corrupting extent record: key %llu %u %llu\n",
 				key.objectid, key.type, key.offset);
 			ptr = btrfs_item_ptr_offset(leaf, slot);
 			item_size = btrfs_item_size_nr(leaf, slot);
@@ -224,7 +230,8 @@ next:
 }
 
 static void btrfs_corrupt_extent_leaf(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root, struct extent_buffer *eb)
+				      struct btrfs_root *root,
+				      struct extent_buffer *eb)
 {
 	u32 nr = btrfs_header_nritems(eb);
 	u32 victim = rand() % nr;
@@ -237,7 +244,8 @@ static void btrfs_corrupt_extent_leaf(struct btrfs_trans_handle *trans,
 }
 
 static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root, struct extent_buffer *eb)
+				      struct btrfs_root *root,
+				      struct extent_buffer *eb)
 {
 	int i;
 	u32 nr;
@@ -260,7 +268,8 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 		struct extent_buffer *next;
 
 		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
-				       root->leafsize, btrfs_node_ptr_generation(eb, i));
+				       root->leafsize,
+				       btrfs_node_ptr_generation(eb, i));
 		if (!next)
 			continue;
 		btrfs_corrupt_extent_tree(trans, root, next);
@@ -276,17 +285,159 @@ static struct option long_options[] = {
 	{ "extent-record", 0, NULL, 'e' },
 	{ "extent-tree", 0, NULL, 'E' },
 	{ "keys", 0, NULL, 'k' },
+	{ "chunk-record", 0, NULL, 'u' },
+	{ "chunk-tree", 0, NULL, 'U' },
 	{ 0, 0, 0, 0}
 };
 
+/* corrupt item using NO cow.
+ * Because chunk recover will recover based on whole partition scaning,
+ * If using COW, chunk recover will use the old item to recover,
+ * which is still OK but we want to check the ability to rebuild chunk
+ * not only restore the old ones */
+int corrupt_item_nocow(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       int del)
+{
+	int ret = 0;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	int slot;
+	u32 item_size;
 
+	leaf = path->nodes[0];
+	slot = path->slots[0];
+	/* Not deleting the first item of a leaf to keep leaf structure */
+	if (slot == 0)
+		del = 0;
+	/* Only accept valid eb */
+	BUG_ON(!leaf->data || slot >= btrfs_header_nritems(leaf));
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (del) {
+		fprintf(stdout, "Deleting key and data [%llu, %u, %llu].\n",
+			key.objectid, key.type, key.offset);
+		btrfs_del_item(trans, root, path);
+	} else {
+		fprintf(stdout, "Corrupting key and data [%llu, %u, %llu].\n",
+			key.objectid, key.type, key.offset);
+		ptr = btrfs_item_ptr_offset(leaf, slot);
+		item_size = btrfs_item_size_nr(leaf, slot);
+		memset_extent_buffer(leaf, 0, ptr, item_size);
+		btrfs_mark_buffer_dirty(leaf);
+	}
+	return ret;
+}
+int corrupt_chunk_tree(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root)
+{
+	int ret;
+	int del;
+	int slot;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct extent_buffer *leaf;
+
+	path = btrfs_alloc_path();
+	key.objectid = (u64)-1;
+	key.offset = (u64)-1;
+	key.type = (u8)-1;
+
+	/* Here, cow and ins_len must equals 0 for the following reasons:
+	 * 1) chunk recover is based on disk scanning, so COW should be
+	 *    disabled in case the original chunk being scanned and
+	 *    recovered using the old chunk.
+	 * 2) if cow = 0, ins_len must also be set to 0, or BUG_ON will be
+	 *    triggered.
+	 */
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+	BUG_ON(ret == 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error searching tree\n");
+		goto free_out;
+	}
+	/* corrupt/del dev_item first */
+	while (!btrfs_previous_item(root, path, 0, BTRFS_DEV_ITEM_KEY)) {
+		slot = path->slots[0];
+		leaf = path->nodes[0];
+		del = rand() % 3;
+		/* Never delete the first item to keep the leaf structure */
+		if (path->slots[0] == 0)
+			del = 0;
+		ret = corrupt_item_nocow(trans, root, path, del);
+		if (ret)
+			goto free_out;
+	}
+	btrfs_free_path(path);
+
+	/* Here, cow and ins_len must equals 0 for the following reasons:
+	 * 1) chunk recover is based on disk scanning, so COW should be
+	 *    disabled in case the original chunk being scanned and
+	 *    recovered using the old chunk.
+	 * 2) if cow = 0, ins_len must also be set to 0, or BUG_ON will be
+	 *    triggered.
+	 */
+	path = btrfs_alloc_path();
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+	BUG_ON(ret == 0);
+	if (ret < 0) {
+		fprintf(stderr, "Error searching tree\n");
+		goto free_out;
+	}
+	/* corrupt/del chunk then*/
+	while (!btrfs_previous_item(root, path, 0, BTRFS_CHUNK_ITEM_KEY)) {
+		slot = path->slots[0];
+		leaf = path->nodes[0];
+		del = rand() % 3;
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		ret = corrupt_item_nocow(trans, root, path, del);
+		if (ret)
+			goto free_out;
+	}
+free_out:
+	btrfs_free_path(path);
+	return ret;
+}
+int find_chunk_offset(struct btrfs_root *root,
+		      struct btrfs_path *path, u64 offset)
+{
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = offset;
+
+	/* Here, cow and ins_len must equals 0 for following reasons:
+	 * 1) chunk recover is based on disk scanning, so COW should
+	 *    be disabled in case the original chunk being scanned
+	 *    and recovered using the old chunk.
+	 * 2) if cow = 0, ins_len must also be set to 0, or BUG_ON
+	 *    will be triggered.
+	 */
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret > 0) {
+		fprintf(stderr, "Can't find chunk with given offset %llu\n",
+			offset);
+		goto out;
+	}
+	if (ret < 0) {
+		fprintf(stderr, "Error searching chunk");
+		goto out;
+	}
+out:
+	return ret;
+
+}
 int main(int ac, char **av)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
 	struct extent_buffer *eb;
 	char *dev;
-	u64 logical = 0;
+	/* chunk offset can be 0,so change to (u64)-1 */
+	u64 logical = (u64)-1;
 	int ret = 0;
 	int option_index = 0;
 	int copy = 0;
@@ -294,23 +445,20 @@ int main(int ac, char **av)
 	int extent_rec = 0;
 	int extent_tree = 0;
 	int corrupt_block_keys = 0;
+	int chunk_rec = 0;
+	int chunk_tree = 0;
 
 	srand(128);
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEk", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuU", long_options,
 				&option_index);
 		if (c < 0)
 			break;
 		switch(c) {
 			case 'l':
 				logical = atoll(optarg);
-				if (logical == 0) {
-					fprintf(stderr,
-						"invalid extent number\n");
-					print_usage();
-				}
 				break;
 			case 'c':
 				copy = atoi(optarg);
@@ -337,6 +485,12 @@ int main(int ac, char **av)
 			case 'k':
 				corrupt_block_keys = 1;
 				break;
+			case 'u':
+				chunk_rec = 1;
+				break;
+			case 'U':
+				chunk_tree = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -344,7 +498,7 @@ int main(int ac, char **av)
 	ac = ac - optind;
 	if (ac == 0)
 		print_usage();
-	if (logical == 0 && !extent_tree)
+	if (logical == (u64)-1 && !(extent_tree || chunk_tree))
 		print_usage();
 	if (copy < 0)
 		print_usage();
@@ -374,6 +528,36 @@ int main(int ac, char **av)
 		btrfs_commit_transaction(trans, root);
 		goto out_close;
 	}
+	if (chunk_rec) {
+		struct btrfs_trans_handle *trans;
+		struct btrfs_path *path;
+		int del;
+
+		del = rand() % 3;
+		path = btrfs_alloc_path();
+
+		if (find_chunk_offset(root->fs_info->chunk_root, path,
+				      logical) != 0) {
+			btrfs_free_path(path);
+			goto out_close;
+		}
+		trans = btrfs_start_transaction(root, 1);
+		ret = corrupt_item_nocow(trans, root->fs_info->chunk_root,
+					 path, del);
+		if (ret < 0)
+			fprintf(stderr, "Failed to corrupt chunk record\n");
+		btrfs_commit_transaction(trans, root);
+		goto out_close;
+	}
+	if (chunk_tree) {
+		struct btrfs_trans_handle *trans;
+		trans = btrfs_start_transaction(root, 1);
+		ret = corrupt_chunk_tree(trans, root->fs_info->chunk_root);
+		if (ret < 0)
+			fprintf(stderr, "Failed to corrupt chunk tree\n");
+		btrfs_commit_transaction(trans, root);
+		goto out_close;
+	}
 
 	if (bytes == 0)
 		bytes = root->sectorsize;
-- 
1.8.3

