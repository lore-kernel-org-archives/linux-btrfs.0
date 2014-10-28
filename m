Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60537 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759998AbaJ1GmN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 02:42:13 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9S6g3Bh026592
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 14:42:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: corrupt-block: Add leaf corruption without transaction.
Date: Tue, 28 Oct 2014 14:42:07 +0800
Message-ID: <1414478528-4665-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In fact, a lot of btrfs corruption like byte corruption will cause the
tree block csum mismatch. However most of the corruption provided by
btrfs-corrupt-block will use btrfs transaction and recalculate the csum,
which is somewhat far away from the real world corruption.

This patch will add the leaf corruption without modifying the csum,
causing a more realistic corruption, for the incoming btrfs leaf repair
patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 135 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 133 insertions(+), 2 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 171c81d..80eec5b 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -91,7 +91,7 @@ struct extent_buffer *debug_corrupt_block(struct btrfs_root *root, u64 bytenr,
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-corrupt-block [options] device\n");
-	fprintf(stderr, "\t-l Logical extent to be corrupted\n");
+	fprintf(stderr, "\t-l <num> Logical extent to be corrupted\n");
 	fprintf(stderr, "\t-c Copy of the extent to be corrupted"
 		" (usually 1 or 2, default: 0)\n");
 	fprintf(stderr, "\t-b Number of bytes to be corrupted\n");
@@ -111,6 +111,8 @@ static void print_usage(void)
 	fprintf(stderr, "\t-I An item to corrupt (must also specify the field "
 		"to corrupt and a root+key for the item)\n");
 	fprintf(stderr, "\t-D Corrupt a dir item, must specify key and field\n");
+	fprintf(stderr, "\t-g <tree_num> Randomly corrupt a leaf in the given tree without changing the csum\n");
+	fprintf(stderr, "\t\t      can combine with -l to corrupt a given leaf\n");
 	exit(1);
 }
 
@@ -828,6 +830,7 @@ static struct option long_options[] = {
 	{ "key", 1, NULL, 'K'},
 	{ "item", 0, NULL, 'I'},
 	{ "dir-item", 0, NULL, 'D'},
+	{ "gernal-leaf", 0, NULL, 'g'},
 	{ 0, 0, 0, 0}
 };
 
@@ -973,6 +976,97 @@ out:
 	return ret;
 
 }
+
+struct extent_buffer *find_random_leaf(struct btrfs_root *root, u64 tree_num)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct extent_buffer *eb = NULL;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_path *path = NULL;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return ERR_PTR(-ENOMEM);
+	switch (tree_num) {
+	case BTRFS_ROOT_TREE_OBJECTID:
+		eb = fs_info->tree_root->node;
+		break;
+	case BTRFS_CHUNK_TREE_OBJECTID:
+		eb = fs_info->chunk_root->node;
+		break;
+	}
+	if (!eb) {
+		int slot;
+		struct extent_buffer *leaf;
+		struct btrfs_root_item *root_item;
+
+		key.objectid = tree_num;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = 0;
+		ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+		slot = path->slots[0];
+		leaf = path->nodes[0];
+		if (ret < 0)
+			goto out;
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if (found_key.type != BTRFS_ROOT_ITEM_KEY ||
+		    found_key.objectid != tree_num) {
+			ret = -ENOENT;
+			goto out;
+		}
+		root_item = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
+		eb = read_tree_block(tree_root,
+				     btrfs_disk_root_bytenr(leaf, root_item),
+				     tree_root->nodesize, 0);
+		if (IS_ERR(eb) || !eb) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+	while (btrfs_header_level(eb) > 0) {
+		struct extent_buffer *next;
+		int slot = rand() % btrfs_header_nritems(eb);
+
+		next = read_tree_block(tree_root,
+				       btrfs_node_blockptr(eb, slot),
+				       tree_root->nodesize, 0);
+		if (IS_ERR(next) || !next) {
+			ret = -ENOENT;
+			goto out;
+		}
+		free_extent_buffer(eb);
+		eb = next;
+	}
+	btrfs_free_path(path);
+	return eb;
+out:
+	free_extent_buffer(eb);
+	btrfs_free_path(path);
+	return ERR_PTR(ret);
+}
+
+int corrupt_eb_notrans(struct btrfs_root *root, struct extent_buffer *eb,
+			 int bytes)
+{
+	int i;
+	int ret = 0;
+	off_t pos;
+	char c;
+
+	for (i = 0; i < bytes; i ++) {
+		pos = rand() % eb->len;
+		c = rand() % 256;
+		ret = write_data_to_disk(root->fs_info, &c, pos + eb->start,
+					 sizeof(c), 0);
+		if (ret < 0)
+			return -errno;
+	}
+	return 0;
+}
+
 int main(int ac, char **av)
 {
 	struct cache_tree root_cache;
@@ -996,6 +1090,7 @@ int main(int ac, char **av)
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
+	u64 tree_num = 0;
 	char field[FIELD_BUF_LEN];
 
 	field[0] = '\0';
@@ -1004,7 +1099,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:ID", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDg:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1061,6 +1156,9 @@ int main(int ac, char **av)
 			case 'I':
 				corrupt_item = 1;
 				break;
+			case 'g':
+				tree_num = arg_strtou64(optarg);
+				break;
 			default:
 				print_usage();
 		}
@@ -1079,6 +1177,39 @@ int main(int ac, char **av)
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
 	}
+	if (tree_num) {
+		if (logical == (u64)-1) {
+			eb = find_random_leaf(root, tree_num);
+			if (IS_ERR(eb) || eb == NULL) {
+				if (eb == NULL)
+					ret = -ENOENT;
+				else
+					ret = PTR_ERR(eb);
+				fprintf(stderr, "Fail to find a leaf of given tree\n");
+				goto out_close;
+			}
+		} else {
+			eb = read_tree_block(root, logical, root->leafsize, 0);
+			if (IS_ERR(eb) || eb == NULL) {
+				if (eb == NULL)
+					ret = -ENOENT;
+				else
+					ret = PTR_ERR(eb);
+				fprintf(stderr, "Fail to read the given leaf at bytenr: %llu\n",
+					logical);
+				goto out_close;
+			}
+		}
+		ret = corrupt_eb_notrans(root, eb, bytes);
+		if (ret < 0)
+			fprintf(stderr, "fail to corrupt leaf at %llu: %s\n",
+				eb->start, strerror(-ret));
+		else
+			printf("Corrupted %llu bytes of the leaf at logical: %llu\n",
+			       bytes, eb->start);
+		free_extent_buffer(eb);
+		goto out_close;
+	}
 	if (extent_rec) {
 		struct btrfs_trans_handle *trans;
 
-- 
2.1.2

