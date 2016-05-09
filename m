Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbcEIMOM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 08:14:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D72E3AAEF
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 12:14:10 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: GFP_NOFS does not GFP_HIGHMEM
Date: Mon,  9 May 2016 14:13:49 +0200
Message-Id: <1462796029-24456-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Masking HIGHMEM out of NOFS does not make sense.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/delayed-inode.c | 2 +-
 fs/btrfs/disk-io.c       | 2 +-
 fs/btrfs/extent_io.c     | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6cef0062f929..61561c2a3f96 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -134,7 +134,7 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 	/* cached in the btrfs inode and can be accessed */
 	atomic_add(2, &node->refs);
 
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret) {
 		kmem_cache_free(delayed_node_cache, node);
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e47849d7427..7e062464a8bd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1640,7 +1640,7 @@ int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 {
 	int ret;
 
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d247fc0eea19..f64824810d78 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4822,7 +4822,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 		return NULL;
 	eb->fs_info = fs_info;
 again:
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		goto free_eb;
 	spin_lock(&fs_info->buffer_lock);
@@ -4923,7 +4923,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 again:
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		goto free_eb;
 
-- 
2.7.1

