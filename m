Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGJAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Sep 2012 05:00:55 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 4ED5BA24CA
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2012 11:00:54 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: polish names of kmem caches
Date: Fri,  7 Sep 2012 11:00:48 +0200
Message-Id: <1347008448-30683-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Usecase:

  watch 'grep btrfs < /proc/slabinfo'

easy to watch all caches in one go.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/delayed-inode.c |    2 +-
 fs/btrfs/extent_io.c     |    4 ++--
 fs/btrfs/extent_map.c    |    2 +-
 fs/btrfs/inode.c         |   10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index eb768c4..b26d2f9 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -29,7 +29,7 @@ static struct kmem_cache *delayed_node_cache;
 
 int __init btrfs_delayed_inode_init(void)
 {
-	delayed_node_cache = kmem_cache_create("delayed_node",
+	delayed_node_cache = kmem_cache_create("btrfs_delayed_node",
 					sizeof(struct btrfs_delayed_node),
 					0,
 					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 604e404..fc8f156 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -64,13 +64,13 @@ tree_fs_info(struct extent_io_tree *tree)
 
 int __init extent_io_init(void)
 {
-	extent_state_cache = kmem_cache_create("extent_state",
+	extent_state_cache = kmem_cache_create("btrfs_extent_state",
 			sizeof(struct extent_state), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_state_cache)
 		return -ENOMEM;
 
-	extent_buffer_cache = kmem_cache_create("extent_buffers",
+	extent_buffer_cache = kmem_cache_create("btrfs_extent_buffer",
 			sizeof(struct extent_buffer), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_buffer_cache)
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index ac606f0..8d1364d 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -11,7 +11,7 @@ static struct kmem_cache *extent_map_cache;
 
 int __init extent_map_init(void)
 {
-	extent_map_cache = kmem_cache_create("extent_map",
+	extent_map_cache = kmem_cache_create("btrfs_extent_map",
 			sizeof(struct extent_map), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!extent_map_cache)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02ad1c6..5ce2a10 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7154,31 +7154,31 @@ void btrfs_destroy_cachep(void)
 
 int btrfs_init_cachep(void)
 {
-	btrfs_inode_cachep = kmem_cache_create("btrfs_inode_cache",
+	btrfs_inode_cachep = kmem_cache_create("btrfs_inode",
 			sizeof(struct btrfs_inode), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, init_once);
 	if (!btrfs_inode_cachep)
 		goto fail;
 
-	btrfs_trans_handle_cachep = kmem_cache_create("btrfs_trans_handle_cache",
+	btrfs_trans_handle_cachep = kmem_cache_create("btrfs_trans_handle",
 			sizeof(struct btrfs_trans_handle), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_trans_handle_cachep)
 		goto fail;
 
-	btrfs_transaction_cachep = kmem_cache_create("btrfs_transaction_cache",
+	btrfs_transaction_cachep = kmem_cache_create("btrfs_transaction",
 			sizeof(struct btrfs_transaction), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_transaction_cachep)
 		goto fail;
 
-	btrfs_path_cachep = kmem_cache_create("btrfs_path_cache",
+	btrfs_path_cachep = kmem_cache_create("btrfs_path",
 			sizeof(struct btrfs_path), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_path_cachep)
 		goto fail;
 
-	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space_cache",
+	btrfs_free_space_cachep = kmem_cache_create("btrfs_free_space",
 			sizeof(struct btrfs_free_space), 0,
 			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
 	if (!btrfs_free_space_cachep)
-- 
1.7.9

