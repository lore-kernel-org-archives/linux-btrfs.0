Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:40227 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeC3FgL (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 01:36:11 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: extent_io: Refactor alloc_extent_buffer() to follow kernel parameters
Date: Fri, 30 Mar 2018 13:35:51 +0800
Message-Id: <20180330053553.30316-3-wqu@suse.com>
In-Reply-To: <20180330053553.30316-1-wqu@suse.com>
References: <20180330053553.30316-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of using the internal struct extent_io_tree, use struct fs_info.

This does not only unify the interface between kernel and btrfs-progs,
but also makes later btrfs_print_tree() use less parameters.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c   |  3 +--
 extent_io.c | 14 +++++++++-----
 extent_io.h |  3 ++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 76958aef239e..610963357675 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -184,8 +184,7 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 struct extent_buffer* btrfs_find_create_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr)
 {
-	return alloc_extent_buffer(&fs_info->extent_cache, bytenr,
-			fs_info->nodesize);
+	return alloc_extent_buffer(fs_info, bytenr, fs_info->nodesize);
 }
 
 void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
diff --git a/extent_io.c b/extent_io.c
index 3117782335ab..198492699438 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -545,7 +545,7 @@ out:
 	return ret;
 }
 
-static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
+static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *info,
 						   u64 bytenr, u32 blocksize)
 {
 	struct extent_buffer *eb;
@@ -558,11 +558,12 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->len = blocksize;
 	eb->refs = 1;
 	eb->flags = 0;
-	eb->tree = tree;
 	eb->fd = -1;
 	eb->dev_bytenr = (u64)-1;
 	eb->cache_node.start = bytenr;
 	eb->cache_node.size = blocksize;
+	eb->fs_info = info;
+	eb->tree = &info->extent_cache;
 	INIT_LIST_HEAD(&eb->recow);
 	INIT_LIST_HEAD(&eb->lru);
 
@@ -573,9 +574,11 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 {
 	struct extent_buffer *new;
 
-	new = __alloc_extent_buffer(NULL, src->start, src->len);
+	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
 	if (!new)
 		return NULL;
+	/* cloned eb is not linked into fs_info->extent_cache */
+	new->tree = NULL;
 
 	copy_extent_buffer(new, src, 0, 0, src->len);
 	new->flags |= EXTENT_BUFFER_DUMMY;
@@ -665,10 +668,11 @@ static void trim_extent_buffer_cache(struct extent_io_tree *tree)
 	}
 }
 
-struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 bytenr, u32 blocksize)
 {
 	struct extent_buffer *eb;
+	struct extent_io_tree *tree = &fs_info->extent_cache;
 	struct cache_extent *cache;
 
 	cache = lookup_cache_extent(&tree->cache, bytenr, blocksize);
@@ -685,7 +689,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  cache_node);
 			free_extent_buffer(eb);
 		}
-		eb = __alloc_extent_buffer(tree, bytenr, blocksize);
+		eb = __alloc_extent_buffer(fs_info, bytenr, blocksize);
 		if (!eb)
 			return NULL;
 		ret = insert_cache_extent(&tree->cache, &eb->cache_node);
diff --git a/extent_io.h b/extent_io.h
index 17a4a8298635..f8f73089ab40 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -98,6 +98,7 @@ struct extent_buffer {
 	int refs;
 	u32 flags;
 	int fd;
+	struct btrfs_fs_info *fs_info;
 	char data[] __attribute__((aligned(8)));
 };
 
@@ -145,7 +146,7 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 bytenr, u32 blocksize);
 struct extent_buffer *find_first_extent_buffer(struct extent_io_tree *tree,
 					       u64 start);
-struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 bytenr, u32 blocksize);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
 void free_extent_buffer(struct extent_buffer *eb);
-- 
2.16.3

