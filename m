Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:59029 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaFYSf7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 14:35:59 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] FS/BTRFS: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:35:43 +0200
Message-Id: <1403721343-19383-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kcalloc manages count*sizeof overflow.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/compression.c      | 2 +-
 fs/btrfs/ctree.c            | 8 ++++----
 fs/btrfs/disk-io.c          | 2 +-
 fs/btrfs/free-space-cache.c | 2 +-
 fs/btrfs/inode.c            | 2 +-
 fs/btrfs/raid56.c           | 2 +-
 fs/btrfs/volumes.c          | 4 ++--
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 92371c4..382430b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -617,7 +617,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	nr_pages = (compressed_len + PAGE_CACHE_SIZE - 1) /
 				 PAGE_CACHE_SIZE;
-	cb->compressed_pages = kzalloc(sizeof(struct page *) * nr_pages,
+	cb->compressed_pages = kcalloc(nr_pages, sizeof(struct page *),
 				       GFP_NOFS);
 	if (!cb->compressed_pages)
 		goto fail1;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index aeab453..7473399 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -581,7 +581,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	if (!tree_mod_need_log(fs_info, eb))
 		return 0;
 
-	tm_list = kzalloc(nr_items * sizeof(struct tree_mod_elem *), flags);
+	tm_list = kcalloc(nr_items, sizeof(struct tree_mod_elem *), flags);
 	if (!tm_list)
 		return -ENOMEM;
 
@@ -680,7 +680,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 
 	if (log_removal && btrfs_header_level(old_root) > 0) {
 		nritems = btrfs_header_nritems(old_root);
-		tm_list = kzalloc(nritems * sizeof(struct tree_mod_elem *),
+		tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *),
 				  flags);
 		if (!tm_list) {
 			ret = -ENOMEM;
@@ -817,7 +817,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 	if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0)
 		return 0;
 
-	tm_list = kzalloc(nr_items * 2 * sizeof(struct tree_mod_elem *),
+	tm_list = kcalloc(nr_items * 2, sizeof(struct tree_mod_elem *),
 			  GFP_NOFS);
 	if (!tm_list)
 		return -ENOMEM;
@@ -908,7 +908,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 		return 0;
 
 	nritems = btrfs_header_nritems(eb);
-	tm_list = kzalloc(nritems * sizeof(struct tree_mod_elem *),
+	tm_list = kcalloc(nritems, sizeof(struct tree_mod_elem *),
 			  GFP_NOFS);
 	if (!tm_list)
 		return -ENOMEM;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8bb4aa1..1af81f5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -285,7 +285,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		offset += cur_len;
 	}
 	if (csum_size > sizeof(inline_result)) {
-		result = kzalloc(csum_size * sizeof(char), GFP_NOFS);
+		result = kcalloc(csum_size, sizeof(char), GFP_NOFS);
 		if (!result)
 			return 1;
 	} else {
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2b0a627..ec77b84 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -292,7 +292,7 @@ static int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
 
 	memset(io_ctl, 0, sizeof(struct io_ctl));
 
-	io_ctl->pages = kzalloc(sizeof(struct page *) * num_pages, GFP_NOFS);
+	io_ctl->pages = kcalloc(num_pages, sizeof(struct page *), GFP_NOFS);
 	if (!io_ctl->pages)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..549755a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -449,7 +449,7 @@ again:
 	     (BTRFS_I(inode)->force_compress) ||
 	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
 		WARN_ON(pages);
-		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
+		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
 			/* just bail out to the uncompressed code */
 			goto cont;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 4055291..e8ab002 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1727,7 +1727,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	int err;
 	int i;
 
-	pointers = kzalloc(rbio->bbio->num_stripes * sizeof(void *),
+	pointers = kcalloc(rbio->bbio->num_stripes, sizeof(void *),
 			   GFP_NOFS);
 	if (!pointers) {
 		err = -ENOMEM;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c83b242..784a820 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4140,7 +4140,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
 			     max_chunk_size);
 
-	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
+	devices_info = kcalloc(fs_devices->rw_devices, sizeof(*devices_info),
 			       GFP_NOFS);
 	if (!devices_info)
 		return -ENOMEM;
@@ -5317,7 +5317,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		rmap_len = map->stripe_len * nr_data_stripes(map);
 	}
 
-	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
+	buf = kcalloc(map->num_stripes, sizeof(u64), GFP_NOFS);
 	BUG_ON(!buf); /* -ENOMEM */
 
 	for (i = 0; i < map->num_stripes; i++) {
-- 
1.9.1

