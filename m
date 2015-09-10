Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33247 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754338AbbIJCgY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 22:36:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 1/5] btrfs-progs: fsck: Add check for extent and parent chunk type
Date: Thu, 10 Sep 2015 10:34:14 +0800
Message-ID: <1441852458-10289-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a bug in btrfs-convert in 4.1.2, even we don't allow mixed
block group for converted image, btrfs-convert will still create image
with data and metadata inside one chunk.

And further more, the chunk type is still DATA or METADATA, not
DATA|METADATA (not mixed).

So add btrfsck check for it right now.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 0694a3b..c818bec 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -55,6 +55,7 @@ static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
 static int check_data_csum = 0;
+static struct btrfs_fs_info *global_info;
 
 struct extent_backref {
 	struct list_head list;
@@ -127,6 +128,7 @@ struct extent_record {
 	unsigned int metadata:1;
 	unsigned int bad_full_backref:1;
 	unsigned int crossing_stripes:1;
+	unsigned int wrong_chunk_type:1;
 };
 
 struct inode_backref {
@@ -3749,7 +3751,8 @@ static int maybe_free_extent_rec(struct cache_tree *extent_cache,
 	if (rec->content_checked && rec->owner_ref_checked &&
 	    rec->extent_item_refs == rec->refs && rec->refs > 0 &&
 	    rec->num_duplicates == 0 && !all_backpointers_checked(rec, 0) &&
-	    !rec->bad_full_backref && !rec->crossing_stripes) {
+	    !rec->bad_full_backref && !rec->crossing_stripes &&
+	    !rec->wrong_chunk_type) {
 		remove_cache_extent(extent_cache, &rec->cache);
 		free_all_extent_backrefs(rec);
 		list_del_init(&rec->list);
@@ -4313,6 +4316,56 @@ static struct data_backref *alloc_data_backref(struct extent_record *rec,
 	return ref;
 }
 
+/* Check if the type of extent matches with its chunk */
+static void check_extent_type(struct extent_record *rec)
+{
+	struct btrfs_block_group_cache *bg_cache;
+
+	bg_cache = btrfs_lookup_first_block_group(global_info, rec->start);
+	if (!bg_cache)
+		return;
+
+	/* data extent, check chunk directly*/
+	if (!rec->metadata) {
+		if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_DATA))
+			rec->wrong_chunk_type = 1;
+		return;
+	}
+
+	/* metadata extent, check the obvious case first */
+	if (!(bg_cache->flags & (BTRFS_BLOCK_GROUP_SYSTEM |
+				 BTRFS_BLOCK_GROUP_METADATA))) {
+		rec->wrong_chunk_type = 1;
+		return;
+	}
+
+	/*
+	 * Check SYSTEM extent, as it's also marked as metadata, we can only
+	 * make sure it's a SYSTEM extent by its backref
+	 */
+	if (!list_empty(&rec->backrefs)) {
+		struct extent_backref *node;
+		struct tree_backref *tback;
+		u64 bg_type;
+
+		node = list_entry(rec->backrefs.next, struct extent_backref,
+				  list);
+		if (node->is_data) {
+			/* tree block shouldn't have data backref */
+			rec->wrong_chunk_type = 1;
+			return;
+		}
+		tback = container_of(node, struct tree_backref, node);
+
+		if (tback->root == BTRFS_CHUNK_TREE_OBJECTID)
+			bg_type = BTRFS_BLOCK_GROUP_SYSTEM;
+		else
+			bg_type = BTRFS_BLOCK_GROUP_METADATA;
+		if (!(bg_cache->flags & bg_type))
+			rec->wrong_chunk_type = 1;
+	}
+}
+
 static int add_extent_rec(struct cache_tree *extent_cache,
 			  struct btrfs_key *parent_key, u64 parent_gen,
 			  u64 start, u64 nr, u64 extent_item_refs,
@@ -4405,6 +4458,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		if (metadata && check_crossing_stripes(rec->start,
 						       rec->max_size))
 				rec->crossing_stripes = 1;
+		check_extent_type(rec);
 		maybe_free_extent_rec(extent_cache, rec);
 		return ret;
 	}
@@ -4420,6 +4474,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->flag_block_full_backref = -1;
 	rec->bad_full_backref = 0;
 	rec->crossing_stripes = 0;
+	rec->wrong_chunk_type = 0;
 	INIT_LIST_HEAD(&rec->backrefs);
 	INIT_LIST_HEAD(&rec->dups);
 	INIT_LIST_HEAD(&rec->list);
@@ -4462,6 +4517,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	if (metadata)
 		if (check_crossing_stripes(rec->start, rec->max_size))
 			rec->crossing_stripes = 1;
+	check_extent_type(rec);
 	return ret;
 }
 
@@ -4509,6 +4565,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		}
 		back->node.found_extent_tree = 1;
 	}
+	check_extent_type(rec);
 	maybe_free_extent_rec(extent_cache, rec);
 	return 0;
 }
@@ -7520,6 +7577,14 @@ static int check_extent_refs(struct btrfs_root *root,
 			cur_err = 1;
 		}
 
+		if (rec->wrong_chunk_type) {
+			fprintf(stderr,
+				"bad extent [%llu, %llu), type dismatch with chunk\n",
+				rec->start, rec->start + rec->max_size);
+			err = 1;
+			cur_err = 1;
+		}
+
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
 		if (!init_extent_tree && repair && (!cur_err || fixed))
@@ -9378,6 +9443,7 @@ int cmd_check(int argc, char **argv)
 		goto err_out;
 	}
 
+	global_info = info;
 	root = info->fs_root;
 
 	/*
-- 
2.5.1

