Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753335AbeGEHhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:37:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BFC2DAD6C
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:37:37 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: check/original: Avoid infinite loop when failed to repair inode
Date: Thu,  5 Jul 2018 15:37:30 +0800
Message-Id: <20180705073731.18459-4-wqu@suse.com>
In-Reply-To: <20180705073731.18459-1-wqu@suse.com>
References: <20180705073731.18459-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Exposed by fuzz-tests/003-multi-check-unmounted/ on fuzzed image
bko-161811.raw.xz.

It's caused by the fact when check_fs_roots() finds tree root is
modified, it re-search tree root by goto again: tag.
However again: tag will also reset root objectid to 0.
If we failed to repair one fs root but still modified tree root, we will
go into such infinite loop.

Fix it by record which root we should skip for repair mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/check/main.c b/check/main.c
index c8c347236543..2b5abb2d025b 100644
--- a/check/main.c
+++ b/check/main.c
@@ -3380,6 +3380,7 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *leaf, *tree_node;
 	struct btrfs_root *tmp_root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
+	u64 skip_root = 0;
 	int ret;
 	int err = 0;
 
@@ -3400,7 +3401,10 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
 
 again:
 	key.offset = 0;
-	key.objectid = 0;
+	if (skip_root)
+		key.objectid = skip_root + 1;
+	else
+		key.objectid = 0;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
 	if (ret < 0) {
@@ -3409,6 +3413,7 @@ again:
 	}
 	tree_node = tree_root->node;
 	while (1) {
+
 		if (tree_node != tree_root->node) {
 			free_root_recs_tree(root_cache);
 			btrfs_release_path(&path);
@@ -3445,8 +3450,18 @@ again:
 				btrfs_release_path(&path);
 				goto again;
 			}
-			if (ret)
+			if (ret) {
 				err = 1;
+
+				/*
+				 * We failed to repair this root but modified tree
+				 * root, after again: tag we will still hit this
+				 * root and fail to repair, must skip this root to
+				 * avoid infinite loop
+				 */
+				if (repair)
+					skip_root = key.objectid;
+			}
 			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
 				btrfs_free_fs_root(tmp_root);
 		} else if (key.type == BTRFS_ROOT_REF_KEY ||
-- 
2.18.0

