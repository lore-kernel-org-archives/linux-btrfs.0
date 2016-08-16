Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcHPGVd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 02:21:33 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id 98F7C4056401
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Aug 2016 14:21:22 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: eliminate some unnecessary btrfs_lookup_extent_info() calls in walk_down_tree()
Date: Tue, 16 Aug 2016 14:17:57 +0800
Message-Id: <20160816061757.9319-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In walk_down_tree(), we may call btrfs_lookup_extent_info() for same tree
block many times, obviously unnecessary. Here we define a simple struct to
record whether we already have gotten tree block's refs:
        struct node_refs {
                u64 bytenr[BTRFS_MAX_LEVEL];
                u64 refs[BTRFS_MAX_LEVEL];
        };

I fill a disk partition with linux kernel source codes and use below
test script to have performance test.
	#!/bin/bash

	echo 3 > /proc/sys/vm/drop_caches
	for ((i = 0; i < 20; i++)); do
		time ./btrfsck  /dev/sdc5
	done 2>&1 | grep real | awk -F "[ms]" '{run_time += $2} END{print run_time / 20}'

Before this patch, it averagely took 0.8447s for every btrfsck execution,
and with this patch, it averagely took 0.7807s.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 cmds-check.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index fbeb3a4..394f838 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1953,8 +1953,14 @@ static int check_child_node(struct btrfs_root *root,
 	return ret;
 }
 
+struct node_refs {
+	u64 bytenr[BTRFS_MAX_LEVEL];
+	u64 refs[BTRFS_MAX_LEVEL];
+};
+
 static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
-			  struct walk_control *wc, int *level)
+			  struct walk_control *wc, int *level,
+			  struct node_refs *nrefs)
 {
 	enum btrfs_tree_block_status status;
 	u64 bytenr;
@@ -1967,12 +1973,20 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 
 	WARN_ON(*level < 0);
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
-	ret = btrfs_lookup_extent_info(NULL, root,
+
+	if (path->nodes[*level]->start == nrefs->bytenr[*level]) {
+		refs = nrefs->refs[*level];
+		ret = 0;
+	} else {
+		ret = btrfs_lookup_extent_info(NULL, root,
 				       path->nodes[*level]->start,
 				       *level, 1, &refs, NULL);
-	if (ret < 0) {
-		err = ret;
-		goto out;
+		if (ret < 0) {
+			err = ret;
+			goto out;
+		}
+		nrefs->bytenr[*level] = path->nodes[*level]->start;
+		nrefs->refs[*level] = refs;
 	}
 
 	if (refs > 1) {
@@ -2003,10 +2017,19 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
 		blocksize = root->nodesize;
-		ret = btrfs_lookup_extent_info(NULL, root, bytenr, *level - 1,
-					       1, &refs, NULL);
-		if (ret < 0)
-			refs = 0;
+
+		if (bytenr == nrefs->bytenr[*level - 1]) {
+			refs = nrefs->refs[*level - 1];
+		} else {
+			ret = btrfs_lookup_extent_info(NULL, root, bytenr,
+					*level - 1, 1, &refs, NULL);
+			if (ret < 0) {
+				refs = 0;
+			} else {
+				nrefs->bytenr[*level - 1] = bytenr;
+				nrefs->refs[*level - 1] = refs;
+			}
+		}
 
 		if (refs > 1) {
 			ret = enter_shared_node(root, bytenr, refs,
@@ -3619,6 +3642,7 @@ static int check_fs_root(struct btrfs_root *root,
 	struct orphan_data_extent *orphan;
 	struct orphan_data_extent *tmp;
 	enum btrfs_tree_block_status status;
+	struct node_refs nrefs;
 
 	/*
 	 * Reuse the corrupt_block cache tree to record corrupted tree block
@@ -3640,6 +3664,7 @@ static int check_fs_root(struct btrfs_root *root,
 	memset(&root_node, 0, sizeof(root_node));
 	cache_tree_init(&root_node.root_cache);
 	cache_tree_init(&root_node.inode_cache);
+	memset(&nrefs, 0, sizeof(nrefs));
 
 	/* Move the orphan extent record to corresponding inode_record */
 	list_for_each_entry_safe(orphan, tmp,
@@ -3689,7 +3714,7 @@ static int check_fs_root(struct btrfs_root *root,
 	}
 
 	while (1) {
-		wret = walk_down_tree(root, &path, wc, &level);
+		wret = walk_down_tree(root, &path, wc, &level, &nrefs);
 		if (wret < 0)
 			ret = wret;
 		if (wret != 0)
-- 
2.9.0



