Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35099 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2IFGlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 02:41:19 -0400
Message-ID: <5048458A.1030604@gmail.com>
Date: Thu, 06 Sep 2012 14:41:14 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: PATCH 3/3] btrfs: set extent-tree.c/add_excluded_extent as void
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The memory allocation failure will be catched in set_extent_bits.
Always return 0 is useless for its callers.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent-tree.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b9a6fa..3a295ff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -209,7 +209,7 @@ block_group_cache_tree_search(struct btrfs_fs_info *info, u64 bytenr,
 	return ret;
 }
 
-static int add_excluded_extent(struct btrfs_root *root,
+static void add_excluded_extent(struct btrfs_root *root,
 			       u64 start, u64 num_bytes)
 {
 	u64 end = start + num_bytes - 1;
@@ -217,7 +217,6 @@ static int add_excluded_extent(struct btrfs_root *root,
 			start, end, EXTENT_UPTODATE, GFP_NOFS);
 	set_extent_bits(&root->fs_info->freed_extents[1],
 			start, end, EXTENT_UPTODATE, GFP_NOFS);
-	return 0;
 }
 
 static void free_excluded_extents(struct btrfs_root *root,
-- 
1.7.1
