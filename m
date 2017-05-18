Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932097AbdERDjW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 18/32] btrfs-progs: Refactor nodesize users in cmds-inspect-tree-stats.c
Date: Thu, 18 May 2017 11:38:43 +0800
Message-ID: <20170518033857.15002-19-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-inspect-tree-stats.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index 58dd29e1..ecb33ce2 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -105,7 +105,7 @@ static int walk_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	struct btrfs_key found_key;
 	int i;
 
-	stat->total_bytes += root->nodesize;
+	stat->total_bytes += root->fs_info->nodesize;
 	stat->total_leaves++;
 
 	if (!find_inline)
@@ -137,12 +137,13 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 		      struct root_stats *stat, int level, int find_inline)
 {
 	struct extent_buffer *b = path->nodes[level];
+	u32 nodesize = root->fs_info->nodesize;
 	u64 last_block;
-	u64 cluster_size = root->nodesize;
+	u64 cluster_size = nodesize;
 	int i;
 	int ret = 0;
 
-	stat->total_bytes += root->nodesize;
+	stat->total_bytes += nodesize;
 	stat->total_nodes++;
 
 	last_block = btrfs_header_bytenr(b);
@@ -153,7 +154,7 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 		path->slots[level] = i;
 		if ((level - 1) > 0 || find_inline) {
 			tmp = read_tree_block(root, cur_blocknr,
-					      root->nodesize,
+					      nodesize,
 					      btrfs_node_ptr_generation(b, i));
 			if (!extent_buffer_uptodate(tmp)) {
 				error("failed to read blocknr %llu",
@@ -167,9 +168,9 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 					 find_inline);
 		else
 			ret = walk_leaf(root, path, stat, find_inline);
-		if (last_block + root->nodesize != cur_blocknr) {
+		if (last_block + nodesize != cur_blocknr) {
 			u64 distance = calc_distance(last_block +
-						     root->nodesize,
+						     nodesize,
 						     cur_blocknr);
 			stat->total_seeks++;
 			stat->total_seek_len += distance;
@@ -186,7 +187,7 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 				stat->forward_seeks++;
 			else
 				stat->backward_seeks++;
-			if (cluster_size != root->nodesize) {
+			if (cluster_size != nodesize) {
 				stat->total_cluster_size += cluster_size;
 				stat->total_clusters++;
 				if (cluster_size < stat->min_cluster_size)
@@ -194,9 +195,9 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 				if (cluster_size > stat->max_cluster_size)
 					stat->max_cluster_size = cluster_size;
 			}
-			cluster_size = root->nodesize;
+			cluster_size = nodesize;
 		} else {
-			cluster_size += root->nodesize;
+			cluster_size += nodesize;
 		}
 		last_block = cur_blocknr;
 		if (cur_blocknr < stat->lowest_bytenr)
@@ -334,7 +335,7 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 	stat.lowest_bytenr = btrfs_header_bytenr(root->node);
 	stat.highest_bytenr = stat.lowest_bytenr;
 	stat.min_cluster_size = (u64)-1;
-	stat.max_cluster_size = root->nodesize;
+	stat.max_cluster_size = root->fs_info->nodesize;
 	path.nodes[level] = root->node;
 	if (gettimeofday(&start, NULL)) {
 		error("cannot get time: %s", strerror(errno));
-- 
2.13.0



