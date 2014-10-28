Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8534 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756631AbaJ1Gmk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 02:42:40 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9S6g4VD026595
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 14:42:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: corrupt-block: Add node corruption without transaction.
Date: Tue, 28 Oct 2014 14:42:08 +0800
Message-ID: <1414478528-4665-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1414478528-4665-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1414478528-4665-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like leaf corruption without using transaction, this patch will
corrupt node, doing much more damage to the filesystem, for later
leaf/node repair patches.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 80eec5b..94c3f12 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -112,7 +112,8 @@ static void print_usage(void)
 		"to corrupt and a root+key for the item)\n");
 	fprintf(stderr, "\t-D Corrupt a dir item, must specify key and field\n");
 	fprintf(stderr, "\t-g <tree_num> Randomly corrupt a leaf in the given tree without changing the csum\n");
-	fprintf(stderr, "\t\t      can combine with -l to corrupt a given leaf\n");
+	fprintf(stderr, "\t-G <tree_num> Randomly corrupt a node in the given tree without changing the csum\n");
+	fprintf(stderr, "\t\t      '-g/G'can combine with -l to corrupt a given leaf/node\n");
 	exit(1);
 }
 
@@ -977,7 +978,8 @@ out:
 
 }
 
-struct extent_buffer *find_random_leaf(struct btrfs_root *root, u64 tree_num)
+struct extent_buffer *find_random_eb(struct btrfs_root *root, u64 tree_num,
+				     int leaf)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -985,6 +987,7 @@ struct extent_buffer *find_random_leaf(struct btrfs_root *root, u64 tree_num)
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path = NULL;
+	int target_level = -1;
 	int ret = 0;
 
 	path = btrfs_alloc_path();
@@ -1026,10 +1029,22 @@ struct extent_buffer *find_random_leaf(struct btrfs_root *root, u64 tree_num)
 			goto out;
 		}
 	}
+	if (!leaf) {
+		if (btrfs_header_level(eb) == 0) {
+			fprintf(stderr, "There is no node for the tree %llu\n",
+				tree_num);
+			ret = -ENOENT;
+			goto out;
+		}
+		target_level = 1 + rand() % btrfs_header_level(eb);
+	}
 	while (btrfs_header_level(eb) > 0) {
 		struct extent_buffer *next;
 		int slot = rand() % btrfs_header_nritems(eb);
 
+		if (!leaf && btrfs_header_level(eb) == target_level)
+			goto found;
+
 		next = read_tree_block(tree_root,
 				       btrfs_node_blockptr(eb, slot),
 				       tree_root->nodesize, 0);
@@ -1040,6 +1055,7 @@ struct extent_buffer *find_random_leaf(struct btrfs_root *root, u64 tree_num)
 		free_extent_buffer(eb);
 		eb = next;
 	}
+found:
 	btrfs_free_path(path);
 	return eb;
 out:
@@ -1087,6 +1103,7 @@ int main(int ac, char **av)
 	int chunk_tree = 0;
 	int corrupt_item = 0;
 	int corrupt_di = 0;
+	int corrupt_leaf_notrans = 1;
 	u64 metadata_block = 0;
 	u64 inode = 0;
 	u64 file_extent = (u64)-1;
@@ -1099,7 +1116,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDg:", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:IDg:G:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -1157,6 +1174,11 @@ int main(int ac, char **av)
 				corrupt_item = 1;
 				break;
 			case 'g':
+				corrupt_leaf_notrans = 1;
+				tree_num = arg_strtou64(optarg);
+				break;
+			case 'G':
+				corrupt_leaf_notrans = 0;
 				tree_num = arg_strtou64(optarg);
 				break;
 			default:
@@ -1179,13 +1201,15 @@ int main(int ac, char **av)
 	}
 	if (tree_num) {
 		if (logical == (u64)-1) {
-			eb = find_random_leaf(root, tree_num);
+			eb = find_random_eb(root, tree_num,
+					    corrupt_leaf_notrans);
 			if (IS_ERR(eb) || eb == NULL) {
 				if (eb == NULL)
 					ret = -ENOENT;
 				else
 					ret = PTR_ERR(eb);
-				fprintf(stderr, "Fail to find a leaf of given tree\n");
+				fprintf(stderr, "Fail to find a %s of given tree\n",
+					corrupt_leaf_notrans ? "leaf" : "node");
 				goto out_close;
 			}
 		} else {
@@ -1195,18 +1219,21 @@ int main(int ac, char **av)
 					ret = -ENOENT;
 				else
 					ret = PTR_ERR(eb);
-				fprintf(stderr, "Fail to read the given leaf at bytenr: %llu\n",
+				fprintf(stderr, "Fail to read the given %s at bytenr: %llu\n",
+					corrupt_leaf_notrans ? "leaf" : "node",
 					logical);
 				goto out_close;
 			}
 		}
 		ret = corrupt_eb_notrans(root, eb, bytes);
 		if (ret < 0)
-			fprintf(stderr, "fail to corrupt leaf at %llu: %s\n",
+			fprintf(stderr, "fail to corrupt %s at %llu: %s\n",
+				corrupt_leaf_notrans ? "leaf" : "node",
 				eb->start, strerror(-ret));
 		else
-			printf("Corrupted %llu bytes of the leaf at logical: %llu\n",
-			       bytes, eb->start);
+			printf("Corrupted %llu bytes of the %s at logical: %llu\n",
+			       bytes, corrupt_leaf_notrans ? "leaf" : "node",
+			       eb->start);
 		free_extent_buffer(eb);
 		goto out_close;
 	}
-- 
2.1.2

