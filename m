Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2IZLiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 07:38:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8QBc4Oi026054
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 19:38:04 +0800
Message-ID: <5062E924.1040201@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 19:38:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC][PATCH V2 3/4] Btrfs: introduce extent buffer cache for delayed
 inode
References: <5062E563.7090105@cn.fujitsu.com>
In-Reply-To: <5062E563.7090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces extent buffer for the delayed inode, it can
reduce the search time and the contentions of the extent buffer's
lock when doing delayed inode operations.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 07d5eeb..5e116b6 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -21,6 +21,7 @@
 #include "delayed-inode.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "extent_io.h"
 
 #define BTRFS_DELAYED_WRITEBACK		400
 #define BTRFS_DELAYED_BACKGROUND	100
@@ -1122,6 +1123,7 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_node *curr_node, *prev_node;
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
+	struct extent_buffer_cache cache;
 	int ret = 0;
 	bool count = (nr > 0);
 
@@ -1133,6 +1135,9 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	extent_buffer_cache_init(&cache);
+	path->eb_cache = &cache;
+
 	block_rsv = trans->block_rsv;
 	trans->block_rsv = &root->fs_info->delayed_block_rsv;
 
@@ -1149,6 +1154,11 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 		if (!ret)
 			ret = btrfs_update_delayed_inode(trans, curr_root,
 						path, curr_node);
+
+		if (cache.cached_eb)
+			free_extent_buffer(cache.cached_eb);
+		extent_buffer_cache_init(&cache);
+
 		if (ret) {
 			btrfs_release_delayed_node(curr_node);
 			curr_node = NULL;
@@ -1186,6 +1196,7 @@ static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
+	struct extent_buffer_cache cache;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -1193,6 +1204,9 @@ static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	extent_buffer_cache_init(&cache);
+	path->eb_cache = &cache;
+
 	block_rsv = trans->block_rsv;
 	trans->block_rsv = &node->root->fs_info->delayed_block_rsv;
 
@@ -1203,6 +1217,9 @@ static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	btrfs_free_path(path);
 
+	if (cache.cached_eb)
+		free_extent_buffer(cache.cached_eb);
+
 	trans->block_rsv = block_rsv;
 	return ret;
 }
@@ -1255,6 +1272,7 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	struct btrfs_delayed_node *delayed_node = NULL;
 	struct btrfs_root *root;
 	struct btrfs_block_rsv *block_rsv;
+	struct extent_buffer_cache cache;
 	unsigned long nr = 0;
 	int need_requeue = 0;
 	int ret;
@@ -1266,6 +1284,9 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 		goto out;
 	path->leave_spinning = 1;
 
+	extent_buffer_cache_init(&cache);
+	path->eb_cache = &cache;
+
 	delayed_node = async_node->delayed_node;
 	root = delayed_node->root;
 
@@ -1284,6 +1305,8 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	if (!ret)
 		btrfs_update_delayed_inode(trans, root, path, delayed_node);
 
+	if (cache.cached_eb)
+		free_extent_buffer(cache.cached_eb);
 	/*
 	 * Maybe new delayed items have been inserted, so we need requeue
 	 * the work. Besides that, we must dequeue the empty delayed nodes
-- 
1.7.10.2

