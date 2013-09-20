Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46936 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3ITPcp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 11:32:45 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id ACB457C034A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 09:32:44 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id yzae251BKGAZo7iy (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 09:32:43 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add a bunch of new statistics to btrfs-calc-size
Date: Fri, 20 Sep 2013 11:32:41 -0400
Message-ID: <1379691161-4125-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been wanting to get back to the allocator and make some changes to try and
fix our fragmenation woes with lots of metadata.  But in order to make these
changes I need to have something to tell me if my changes are making a real
measurable difference.  So this patch adds a bunch of new statistics to
btrfs-calc-size.  It will tell me how long it took to read in the trees, how
many seeks it had (both forward and backward).  It will tell me how far spread
out the tree is and spit out a nice histogram of the seeks.  Here is some sample
output

Calculating size of extent tree
        Total size: 60.74MB
                Inline data: 0.00
        Total seeks: 5020
                Forward seeks: 3691
                Backward seeks: 1329
                Avg seek len: 929.53MB
        Seek histogram
                      4096 -       4096:       1043 ####
                      8192 -      73728:        760 ###
                     81920 -   52527104:        753 ###
                  53518336 -  168009728:        753 ###
                 168591360 -  696045568:        753 ###
                 696238080 - 7560364032:        753 ###
                7560437760 - 8409739264:        178 |
        Total clusters: 1874
                Avg cluster size: 25.17KB
                Min cluster size: 8.00KB
                Max cluster size: 472.00KB
        Total disk spread: 7.90GB
        Total read time: 0 s 341670 us
        Levels: 4

This way we can have good numbers to back up any changes we make to the
allocator.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-calc-size.c | 284 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 274 insertions(+), 10 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index c4adfb0..ab942c6 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -24,6 +24,8 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
 #include <zlib.h>
 #include "kerncompat.h"
 #include "ctree.h"
@@ -38,11 +40,29 @@
 static int verbose = 0;
 static int no_pretty = 0;
 
+struct seek {
+	u64 distance;
+	u64 count;
+	struct rb_node n;
+};
+
 struct root_stats {
 	u64 total_nodes;
 	u64 total_leaves;
 	u64 total_bytes;
 	u64 total_inline;
+	u64 total_seeks;
+	u64 forward_seeks;
+	u64 backward_seeks;
+	u64 total_seek_len;
+	u64 max_seek_len;
+	u64 total_clusters;
+	u64 total_cluster_size;
+	u64 min_cluster_size;
+	u64 max_cluster_size;
+	u64 lowest_bytenr;
+	u64 highest_bytenr;
+	struct rb_root seek_root;
 	int total_levels;
 };
 
@@ -51,6 +71,36 @@ struct fs_root {
 	struct btrfs_key *snaps;
 };
 
+static int add_seek(struct rb_root *root, u64 dist)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct seek *seek = NULL;
+
+	while (*p) {
+		parent = *p;
+		seek = rb_entry(parent, struct seek, n);
+
+		if (dist < seek->distance) {
+			p = &(*p)->rb_left;
+		} else if (dist > seek->distance) {
+			p = &(*p)->rb_right;
+		} else {
+			seek->count++;
+			return 0;
+		}
+	}
+
+	seek = malloc(sizeof(struct seek));
+	if (!seek)
+		return -ENOMEM;
+	seek->distance = dist;
+	seek->count = 1;
+	rb_link_node(&seek->n, parent, p);
+	rb_insert_color(&seek->n, root);
+	return 0;
+}
+
 static int walk_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		     struct root_stats *stat, int find_inline)
 {
@@ -80,22 +130,33 @@ static int walk_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	return 0;
 }
 
+static u64 calc_distance(u64 block1, u64 block2)
+{
+	if (block1 < block2)
+		return block2 - block1;
+	return block1 - block2;
+}
+
 static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 		      struct root_stats *stat, int level, int find_inline)
 {
 	struct extent_buffer *b = path->nodes[level];
+	u64 last_block;
+	u64 cluster_size = root->leafsize;
 	int i;
 	int ret = 0;
 
 	stat->total_bytes += root->nodesize;
 	stat->total_nodes++;
 
+	last_block = btrfs_header_bytenr(b);
 	for (i = 0; i < btrfs_header_nritems(b); i++) {
 		struct extent_buffer *tmp = NULL;
+		u64 cur_blocknr = btrfs_node_blockptr(b, i);
 
 		path->slots[level] = i;
 		if ((level - 1) > 0 || find_inline) {
-			tmp = read_tree_block(root, btrfs_node_blockptr(b, i),
+			tmp = read_tree_block(root, cur_blocknr,
 					      btrfs_level_size(root, level - 1),
 					      btrfs_node_ptr_generation(b, i));
 			if (!tmp) {
@@ -110,6 +171,41 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 					 find_inline);
 		else
 			ret = walk_leaf(root, path, stat, find_inline);
+		if (last_block + root->leafsize != cur_blocknr) {
+			u64 distance = calc_distance(last_block +
+						     root->leafsize,
+						     cur_blocknr);
+			stat->total_seeks++;
+			stat->total_seek_len += distance;
+			if (stat->max_seek_len < distance)
+				stat->max_seek_len = distance;
+			if (add_seek(&stat->seek_root, distance)) {
+				fprintf(stderr, "Error adding new seek\n");
+				ret = -ENOMEM;
+				break;
+			}
+
+			if (last_block < cur_blocknr)
+				stat->forward_seeks++;
+			else
+				stat->backward_seeks++;
+			if (cluster_size != root->leafsize) {
+				stat->total_cluster_size += cluster_size;
+				stat->total_clusters++;
+				if (cluster_size < stat->min_cluster_size)
+					stat->min_cluster_size = cluster_size;
+				if (cluster_size > stat->max_cluster_size)
+					stat->max_cluster_size = cluster_size;
+			}
+			cluster_size = root->leafsize;
+		} else {
+			cluster_size += root->leafsize;
+		}
+		last_block = cur_blocknr;
+		if (cur_blocknr < stat->lowest_bytenr)
+			stat->lowest_bytenr = cur_blocknr;
+		if (cur_blocknr > stat->highest_bytenr)
+			stat->highest_bytenr = cur_blocknr;
 		free_extent_buffer(tmp);
 		if (ret) {
 			fprintf(stderr, "Error walking down path\n");
@@ -120,11 +216,110 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 	return ret;
 }
 
+static void print_seek_histogram(struct root_stats *stat)
+{
+	struct rb_node *n = rb_first(&stat->seek_root);
+	struct seek *seek;
+	u64 tick_interval;
+	u64 group_start;
+	u64 group_count = 0;
+	u64 group_end;
+	u64 i;
+	u64 max_seek = stat->max_seek_len;
+	int digits = 1;
+
+	if (stat->total_seeks < 5)
+		return;
+
+	while ((max_seek /= 10))
+		digits++;
+
+	/* Make a tick count as 5% of the total seeks */
+	tick_interval = stat->total_seeks / 20;
+	printf("\tSeek histogram\n");
+	for (; n; n = rb_next(n)) {
+		u64 ticks, gticks = 0;
+
+		seek = rb_entry(n, struct seek, n);
+		ticks = seek->count / tick_interval;
+		if (group_count)
+			gticks = group_count / tick_interval;
+
+		if (ticks <= 2 && gticks <= 2) {
+			if (group_count == 0)
+				group_start = seek->distance;
+			group_end = seek->distance;
+			group_count += seek->count;
+			continue;
+		}
+
+		if (group_count) {
+
+			gticks = group_count / tick_interval;
+			printf("\t\t%*Lu - %*Lu: %*Lu ", digits, group_start,
+			       digits, group_end, digits, group_count);
+			if (gticks) {
+				for (i = 0; i < gticks; i++)
+					printf("#");
+				printf("\n");
+			} else {
+				printf("|\n");
+			}
+			group_count = 0;
+		}
+
+		if (ticks <= 2)
+			continue;
+
+		printf("\t\t%*Lu - %*Lu: %*Lu ", digits, seek->distance,
+		       digits, seek->distance, digits, seek->count);
+		for (i = 0; i < ticks; i++)
+			printf("#");
+		printf("\n");
+	}
+	if (group_count) {
+		u64 gticks;
+
+		gticks = group_count / tick_interval;
+		printf("\t\t%*Lu - %*Lu: %*Lu ", digits, group_start,
+		       digits, group_end, digits, group_count);
+		if (gticks) {
+			for (i = 0; i < gticks; i++)
+				printf("#");
+			printf("\n");
+		} else {
+			printf("|\n");
+		}
+		group_count = 0;
+	}
+}
+
+static void timeval_subtract(struct timeval *result,struct timeval *x,
+			     struct timeval *y)
+{
+	if (x->tv_usec < y->tv_usec) {
+		int nsec = (y->tv_usec - x->tv_usec) / 1000000 + 1;
+		y->tv_usec -= 1000000 * nsec;
+		y->tv_sec += nsec;
+	}
+
+	if (x->tv_usec - y->tv_usec > 1000000) {
+		int nsec = (x->tv_usec - y->tv_usec) / 1000000;
+		y->tv_usec += 1000000 * nsec;
+		y->tv_sec -= nsec;
+	}
+
+	result->tv_sec = x->tv_sec - y->tv_sec;
+	result->tv_usec = x->tv_usec - y->tv_usec;
+}
+
 static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 			  int find_inline)
 {
 	struct btrfs_root *root;
 	struct btrfs_path *path;
+	struct rb_node *n;
+	struct timeval start, end, diff = {0};
 	struct root_stats stat;
 	int level;
 	int ret = 0;
@@ -144,7 +339,15 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 
 	memset(&stat, 0, sizeof(stat));
 	level = btrfs_header_level(root->node);
+	stat.lowest_bytenr = btrfs_header_bytenr(root->node);
+	stat.highest_bytenr = stat.lowest_bytenr;
+	stat.min_cluster_size = (u64)-1;
+	stat.max_cluster_size = root->leafsize;
 	path->nodes[level] = root->node;
+	if (gettimeofday(&start, NULL)) {
+		fprintf(stderr, "Error getting time: %d\n", errno);
+		goto out;
+	}
 	if (!level) {
 		ret = walk_leaf(root, path, &stat, find_inline);
 		if (ret)
@@ -155,27 +358,88 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
 	ret = walk_nodes(root, path, &stat, level, find_inline);
 	if (ret)
 		goto out;
+	if (gettimeofday(&end, NULL)) {
+		fprintf(stderr, "Error getting time: %d\n", errno);
+		goto out;
+	}
+	timeval_subtract(&diff, &end, &start);
 out_print:
+	if (stat.min_cluster_size == (u64)-1) {
+		stat.min_cluster_size = 0;
+		stat.total_clusters = 1;
+	}
+
 	if (no_pretty || size_fail) {
-		printf("\t%Lu total bytes, %Lu inline data bytes, %Lu nodes, "
-		       "%Lu leaves, %d levels\n", stat.total_bytes,
-		       stat.total_inline, stat.total_nodes, stat.total_leaves,
-		       level + 1);
+		printf("\tTotal size: %Lu\n", stat.total_bytes);
+		printf("\t\tInline data: %Lu\n", stat.total_inline);
+		printf("\tTotal seeks: %Lu\n", stat.total_seeks);
+		printf("\t\tForward seeks: %Lu\n", stat.forward_seeks);
+		printf("\t\tBackward seeks: %Lu\n", stat.backward_seeks);
+		printf("\t\tAvg seek len: %Lu\n", stat.total_seek_len /
+		       stat.total_seeks);
+		print_seek_histogram(&stat);
+		printf("\tTotal clusters: %Lu\n", stat.total_clusters);
+		printf("\t\tAvg cluster size: %Lu\n", stat.total_cluster_size /
+		       stat.total_clusters);
+		printf("\t\tMin cluster size: %Lu\n", stat.min_cluster_size);
+		printf("\t\tMax cluster size: %Lu\n", stat.max_cluster_size);
+		printf("\tTotal disk spread: %Lu\n", stat.highest_bytenr -
+		       stat.lowest_bytenr);
+		printf("\tTotal read time: %d s %d us\n", (int)diff.tv_sec,
+		       (int)diff.tv_usec);
+		printf("\tLevels: %d\n", level + 1);
 	} else {
 		char *total_size;
 		char *inline_size;
+		char *avg_seek_len;
+		char *total_disk_spread;
+		char *avg_cluster_size;
+		char *min_cluster_size;
+		char *max_cluster_size;
 
 		total_size = pretty_sizes(stat.total_bytes);
 		inline_size = pretty_sizes(stat.total_inline);
-
-		printf("\t%s total size, %s inline data, %Lu nodes, "
-		       "%Lu leaves, %d levels\n",
-		       total_size, inline_size, stat.total_nodes,
-		       stat.total_leaves, level + 1);
+		if (stat.total_seeks)
+			avg_seek_len = pretty_sizes(stat.total_seek_len /
+						    stat.total_seeks);
+		else
+			avg_seek_len = pretty_sizes(0);
+		total_disk_spread = pretty_sizes(stat.highest_bytenr -
+						 stat.lowest_bytenr);
+		avg_cluster_size = pretty_sizes(stat.total_cluster_size /
+						stat.total_clusters);
+		min_cluster_size = pretty_sizes(stat.min_cluster_size);
+		max_cluster_size = pretty_sizes(stat.max_cluster_size);
+
+		printf("\tTotal size: %s\n", total_size);
+		printf("\t\tInline data: %s\n", inline_size);
+		printf("\tTotal seeks: %Lu\n", stat.total_seeks);
+		printf("\t\tForward seeks: %Lu\n", stat.forward_seeks);
+		printf("\t\tBackward seeks: %Lu\n", stat.backward_seeks);
+		printf("\t\tAvg seek len: %s\n", avg_seek_len);
+		print_seek_histogram(&stat);
+		printf("\tTotal clusters: %Lu\n", stat.total_clusters);
+		printf("\t\tAvg cluster size: %s\n", avg_cluster_size);
+		printf("\t\tMin cluster size: %s\n", min_cluster_size);
+		printf("\t\tMax cluster size: %s\n", max_cluster_size);
+		printf("\tTotal disk spread: %s\n", total_disk_spread);
+		printf("\tTotal read time: %d s %d us\n", (int)diff.tv_sec,
+		       (int)diff.tv_usec);
+		printf("\tLevels: %d\n", level + 1);
+		free(avg_cluster_size);
+		free(min_cluster_size);
+		free(max_cluster_size);
+		free(avg_seek_len);
+		free(total_disk_spread);
 		free(total_size);
 		free(inline_size);
 	}
 out:
+	while ((n = rb_first(&stat.seek_root)) != NULL) {
+		struct seek *seek = rb_entry(n, struct seek, n);
+		rb_erase(n, &stat.seek_root);
+		free(seek);
+	}
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.8.3.1

