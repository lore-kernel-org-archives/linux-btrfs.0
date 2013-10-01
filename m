Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54186 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3JANAV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 09:00:21 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9DCE97C069E
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Oct 2013 07:00:21 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id psqyD6hpHlyKaDhK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 07:00:20 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: keep track of transid failures and fix them if possible
Date: Tue, 1 Oct 2013 09:00:19 -0400
Message-ID: <1380632419-1297-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user was reporting an issue with bad transid errors on his blocks.  The thing
is that btrfs-progs will ignore transid failures for things like restore and
fsck so we can do a best effort to fix a users file system.  So fsck can put
together a coherent view of the file system with stale blocks.  So if everything
else is ok in the mind of fsck then we can recow these blocks to fix the
generation and the user can get their file system back.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.c      |  7 ++++++-
 ctree.h      |  1 +
 disk-io.c    | 15 +++++++++++++++
 extent_io.c  |  2 ++
 extent_io.h  |  2 ++
 6 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6da35ea..ec6669c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5954,6 +5954,47 @@ static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
 	return btrfs_commit_transaction(trans, fs_info->extent_root);
 }
 
+static int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	int ret;
+
+	printf("Recowing metadata block %llu\n", eb->start);
+	key.objectid = btrfs_header_owner(eb);
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(root->fs_info, &key);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "Couldn't find owner root %llu\n",
+			key.objectid);
+		return PTR_ERR(root);
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	path->lowest_level = btrfs_header_level(eb);
+	if (path->lowest_level)
+		btrfs_node_key_to_cpu(eb, &key, 0);
+	else
+		btrfs_item_key_to_cpu(eb, &key, 0);
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -6104,6 +6145,23 @@ int cmd_check(int argc, char **argv)
 
 	fprintf(stderr, "checking root refs\n");
 	ret = check_root_refs(root, &root_cache);
+	if (ret)
+		goto out;
+
+	while (repair && !list_empty(&root->fs_info->recow_ebs)) {
+		struct extent_buffer *eb;
+
+		eb = list_first_entry(&root->fs_info->recow_ebs,
+				      struct extent_buffer, recow);
+		ret = recow_extent_buffer(root, eb);
+		if (ret)
+			break;
+	}
+
+	if (!list_empty(&root->fs_info->recow_ebs)) {
+		fprintf(stderr, "Transid errors in file system\n");
+		ret = 1;
+	}
 out:
 	free_root_recs_tree(&root_cache);
 	close_ctree(root);
diff --git a/ctree.c b/ctree.c
index 8b1fc07..e0ffb53 100644
--- a/ctree.c
+++ b/ctree.c
@@ -295,7 +295,8 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	WARN_ON(btrfs_header_generation(buf) > trans->transid);
+	WARN_ON(!(buf->flags & EXTENT_BAD_TRANSID) &&
+		btrfs_header_generation(buf) > trans->transid);
 
 	update_ref_for_cow(trans, root, buf, cow);
 
@@ -319,6 +320,10 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_free_extent(trans, root, buf->start, buf->len,
 				  0, root->root_key.objectid, level, 1);
 	}
+	if (!list_empty(&buf->recow)) {
+		list_del_init(&buf->recow);
+		free_extent_buffer(buf);
+	}
 	free_extent_buffer(buf);
 	btrfs_mark_buffer_dirty(cow);
 	*cow_ret = cow;
diff --git a/ctree.h b/ctree.h
index 35d1ba4..7617f11 100644
--- a/ctree.h
+++ b/ctree.h
@@ -952,6 +952,7 @@ struct btrfs_fs_info {
 
 	struct btrfs_extent_ops *extent_ops;
 	struct list_head dirty_cowonly_roots;
+	struct list_head recow_ebs;
 
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head space_info;
diff --git a/disk-io.c b/disk-io.c
index fec7700..456ad80 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -180,6 +180,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 	       (unsigned long long)parent_transid,
 	       (unsigned long long)btrfs_header_generation(eb));
 	if (ignore) {
+		eb->flags |= EXTENT_BAD_TRANSID;
 		printk("Ignoring transid failure\n");
 		return 0;
 	}
@@ -274,6 +275,12 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		    csum_tree_block(root, eb, 1) == 0 &&
 		    verify_parent_transid(eb->tree, eb, parent_transid, ignore)
 		    == 0) {
+			if (eb->flags & EXTENT_BAD_TRANSID &&
+			    list_empty(&eb->recow)) {
+				list_add_tail(&eb->recow,
+					      &root->fs_info->recow_ebs);
+				eb->refs++;
+			}
 			btrfs_set_buffer_uptodate(eb);
 			return eb;
 		}
@@ -749,6 +756,7 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 	mutex_init(&fs_info->fs_mutex);
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
+	INIT_LIST_HEAD(&fs_info->recow_ebs);
 
 	if (!writable)
 		fs_info->readonly = 1;
@@ -900,6 +908,13 @@ FREE_EXTENT_CACHE_BASED_TREE(mapping_cache, free_map_lookup);
 
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
 {
+	while (!list_empty(&fs_info->recow_ebs)) {
+		struct extent_buffer *eb;
+		eb = list_first_entry(&fs_info->recow_ebs,
+				      struct extent_buffer, recow);
+		list_del_init(&eb->recow);
+		free_extent_buffer(eb);
+	}
 	free_mapping_cache_tree(&fs_info->mapping_tree.cache_tree);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
diff --git a/extent_io.c b/extent_io.c
index acc4702..3344568 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -585,6 +585,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->dev_bytenr = (u64)-1;
 	eb->cache_node.start = bytenr;
 	eb->cache_node.size = blocksize;
+	INIT_LIST_HEAD(&eb->recow);
 
 	free_some_buffers(tree);
 	ret = insert_cache_extent(&tree->cache, &eb->cache_node);
@@ -608,6 +609,7 @@ void free_extent_buffer(struct extent_buffer *eb)
 		struct extent_io_tree *tree = eb->tree;
 		BUG_ON(eb->flags & EXTENT_DIRTY);
 		list_del_init(&eb->lru);
+		list_del_init(&eb->recow);
 		remove_cache_extent(&tree->cache, &eb->cache_node);
 		BUG_ON(tree->cache_size < eb->len);
 		tree->cache_size -= eb->len;
diff --git a/extent_io.h b/extent_io.h
index ad283cd..68fb9ce 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -39,6 +39,7 @@
 #define EXTENT_DEFRAG_DONE (1 << 7)
 #define EXTENT_BUFFER_FILLED (1 << 8)
 #define EXTENT_CSUM (1 << 9)
+#define EXTENT_BAD_TRANSID (1 << 10)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 
 #define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
@@ -72,6 +73,7 @@ struct extent_buffer {
 	u32 len;
 	struct extent_io_tree *tree;
 	struct list_head lru;
+	struct list_head recow;
 	int refs;
 	int flags;
 	int fd;
-- 
1.8.3.1

