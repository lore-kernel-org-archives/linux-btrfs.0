Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933225AbdKFTc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:57 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 24789ABFC
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/10] btrfs: sink get_extent parameter to read_extent_buffer_pages
Date: Mon,  6 Nov 2017 20:31:05 +0100
Message-Id: <be2018bb4720e0e5df1f6ab3a62d088208904950.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass btree_get_extent, which needs to be exported.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 8 ++++----
 fs/btrfs/disk-io.h   | 3 +++
 fs/btrfs/extent_io.c | 6 +++---
 fs/btrfs/extent_io.h | 2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5713c50959e0..149be7c5d237 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -220,7 +220,7 @@ void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
  * extents on the btree inode are pretty simple, there's one extent
  * that covers the entire device
  */
-static struct extent_map *btree_get_extent(struct btrfs_inode *inode,
+struct extent_map *btree_get_extent(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start, u64 len,
 		int create)
 {
@@ -455,7 +455,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 	io_tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
 	while (1) {
 		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
-					       btree_get_extent, mirror_num);
+					       mirror_num);
 		if (!ret) {
 			if (!verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
@@ -1012,7 +1012,7 @@ void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr)
 	if (IS_ERR(buf))
 		return;
 	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, WAIT_NONE, btree_get_extent, 0);
+				 buf, WAIT_NONE, 0);
 	free_extent_buffer(buf);
 }
 
@@ -1031,7 +1031,7 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
 
 	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
-				       btree_get_extent, mirror_num);
+				       mirror_num);
 	if (ret) {
 		free_extent_buffer(buf);
 		return ret;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 7f7c35d6347a..301151a50ac1 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -149,6 +149,9 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 				     u64 objectid);
 int btree_lock_page_hook(struct page *page, void *data,
 				void (*flush_fn)(void *));
+struct extent_map *btree_get_extent(struct btrfs_inode *inode,
+		struct page *page, size_t pg_offset, u64 start, u64 len,
+		int create);
 int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags);
 int __init btrfs_end_io_wq_init(void);
 void btrfs_end_io_wq_exit(void);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 72620cf41423..2f6a977442c3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -20,6 +20,7 @@
 #include "locking.h"
 #include "rcu-string.h"
 #include "backref.h"
+#include "disk-io.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -5258,8 +5259,7 @@ int extent_buffer_uptodate(struct extent_buffer *eb)
 }
 
 int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, int wait,
-			     get_extent_t *get_extent, int mirror_num)
+			     struct extent_buffer *eb, int wait, int mirror_num)
 {
 	unsigned long i;
 	struct page *page;
@@ -5319,7 +5319,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 
 			ClearPageError(page);
 			err = __extent_read_full_page(tree, page,
-						      get_extent, &bio,
+						      btree_get_extent, &bio,
 						      mirror_num, &bio_flags,
 						      REQ_META);
 			if (err) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5295deb8a153..40291e27782c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -431,7 +431,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 #define WAIT_PAGE_LOCK	2
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, int wait,
-			     get_extent_t *get_extent, int mirror_num);
+			     int mirror_num);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
 static inline unsigned long num_extent_pages(u64 start, u64 len)
-- 
2.14.3

