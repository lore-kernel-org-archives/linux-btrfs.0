Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49078 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754878AbaE2KFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 06:05:19 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4TA5HXV005259
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 18:05:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs-progs: fsck: remove unfriendly BUG_ON() for searching tree failure
Date: Thu, 29 May 2014 18:01:43 +0800
Message-ID: <1401357704-9752-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1401357704-9752-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1401357704-9752-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfsck would hit assertation failure for some searching tree failure.
It is true that filesystem may get some metadata block corrupted,
and btrfsck could not deal with these corruptings. But, Users really
don't want a BUG_ON() here, Instead, just return errors to caller.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 84 +++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 26 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 00d37b8..c56da2a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -899,7 +899,8 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 	key.offset = child_root_id;
 	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path,
 				0, 0);
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		return ret;
 	btrfs_release_path(&path);
 	if (!ret)
 		return 1;
@@ -909,15 +910,14 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path,
 				0, 0);
-	BUG_ON(ret <= 0);
+	if (ret < 0)
+		goto out;
 
 	while (1) {
 		leaf = path.nodes[0];
 		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root->fs_info->tree_root, &path);
-			BUG_ON(ret < 0);
-
-			if (ret > 0)
+			if (ret)
 				break;
 			leaf = path.nodes[0];
 		}
@@ -936,8 +936,10 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 
 		path.slots[0]++;
 	}
-
+out:
 	btrfs_release_path(&path);
+	if (ret < 0)
+		return ret;
 	return has_parent? 0 : -1;
 }
 
@@ -1090,14 +1092,15 @@ static int process_inode_extref(struct extent_buffer *eb,
 
 }
 
-static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
+static int count_csum_range(struct btrfs_root *root, u64 start,
+			    u64 len, u64 *found)
 {
 	struct btrfs_key key;
 	struct btrfs_path path;
 	struct extent_buffer *leaf;
-	int ret ;
+	int ret;
 	size_t size;
-	u64 found = 0;
+	*found = 0;
 	u64 csum_end;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
@@ -1109,7 +1112,8 @@ static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
 
 	ret = btrfs_search_slot(NULL, root->fs_info->csum_root,
 				&key, &path, 0, 0);
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		goto out;
 	if (ret > 0 && path.slots[0] > 0) {
 		leaf = path.nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0] - 1);
@@ -1122,9 +1126,10 @@ static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
 		leaf = path.nodes[0];
 		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root->fs_info->csum_root, &path);
-			BUG_ON(ret < 0);
 			if (ret > 0)
 				break;
+			else if (ret < 0)
+				goto out;
 			leaf = path.nodes[0];
 		}
 
@@ -1146,13 +1151,16 @@ static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
 			size = min(csum_end - start, len);
 			len -= size;
 			start += size;
-			found += size;
+			*found += size;
 		}
 
 		path.slots[0]++;
 	}
+out:
+	if (ret < 0)
+		return ret;
 	btrfs_release_path(&path);
-	return found;
+	return 0;
 }
 
 static int process_file_extent(struct btrfs_root *root,
@@ -1167,6 +1175,7 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 extent_offset = 0;
 	u64 mask = root->sectorsize - 1;
 	int extent_type;
+	int ret;
 
 	rec = active_node->current;
 	BUG_ON(rec->ino != key->objectid || rec->refs > 1);
@@ -1221,7 +1230,9 @@ static int process_file_extent(struct btrfs_root *root,
 		else
 			disk_bytenr += extent_offset;
 
-		found = count_csum_range(root, disk_bytenr, num_bytes);
+		ret = count_csum_range(root, disk_bytenr, num_bytes, &found);
+		if (ret < 0)
+			return ret;
 		if (extent_type == BTRFS_FILE_EXTENT_REG) {
 			if (found > 0)
 				rec->found_csum_item = 1;
@@ -1242,7 +1253,6 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	u32 nritems;
 	int i;
 	int ret = 0;
-	int error = 0;
 	struct cache_tree *inode_cache;
 	struct shared_node *active_node;
 
@@ -1292,10 +1302,8 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 		default:
 			break;
 		};
-		if (ret != 0)
-			error = 1;
 	}
-	return error;
+	return ret;
 }
 
 static void reada_walk_down(struct btrfs_root *root,
@@ -1366,6 +1374,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			break;
 		if (*level == 0) {
 			ret = process_one_leaf(root, cur, wc);
+			if (ret < 0)
+				err = ret;
 			break;
 		}
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
@@ -1759,6 +1769,7 @@ static int merge_root_recs(struct btrfs_root *root,
 	struct ptr_node *node;
 	struct inode_record *rec;
 	struct inode_backref *backref;
+	int ret = 0;
 
 	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
 		free_inode_recs_tree(src_cache);
@@ -1774,7 +1785,10 @@ static int merge_root_recs(struct btrfs_root *root,
 		remove_cache_extent(src_cache, &node->cache);
 		free(node);
 
-		if (!is_child_root(root, root->objectid, rec->ino))
+		ret = is_child_root(root, root->objectid, rec->ino);
+		if (ret < 0)
+			break;
+		else if (ret == 0)
 			goto skip;
 
 		list_for_each_entry(backref, &rec->backrefs, list) {
@@ -1795,6 +1809,8 @@ static int merge_root_recs(struct btrfs_root *root,
 skip:
 		free_inode_rec(rec);
 	}
+	if (ret < 0)
+		return ret;
 	return 0;
 }
 
@@ -1953,6 +1969,7 @@ static int check_fs_root(struct btrfs_root *root,
 			 struct walk_control *wc)
 {
 	int ret = 0;
+	int err = 0;
 	int wret;
 	int level;
 	struct btrfs_path path;
@@ -1990,7 +2007,8 @@ static int check_fs_root(struct btrfs_root *root,
 		level = root_item->drop_level;
 		path.lowest_level = level;
 		wret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-		BUG_ON(wret < 0);
+		if (wret < 0)
+			goto skip_walking;
 		btrfs_node_key(path.nodes[level], &found_key,
 				path.slots[level]);
 		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
@@ -2010,9 +2028,12 @@ static int check_fs_root(struct btrfs_root *root,
 		if (wret != 0)
 			break;
 	}
+skip_walking:
 	btrfs_release_path(&path);
 
-	merge_root_recs(root, &root_node.root_cache, root_cache);
+	err = merge_root_recs(root, &root_node.root_cache, root_cache);
+	if (err < 0)
+		ret = err;
 
 	if (root_node.current) {
 		root_node.current->checked = 1;
@@ -2020,7 +2041,9 @@ static int check_fs_root(struct btrfs_root *root,
 				root_node.current);
 	}
 
-	ret = check_inode_recs(root, &root_node.inode_cache);
+	err = check_inode_recs(root, &root_node.inode_cache);
+	if (!ret)
+		ret = err;
 	return ret;
 }
 
@@ -2061,13 +2084,19 @@ static int check_fs_roots(struct btrfs_root *root,
 	key.objectid = 0;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
-	BUG_ON(ret < 0);
+	if (ret < 0) {
+		err = 1;
+		goto out;
+	}
 	while (1) {
 		leaf = path.nodes[0];
 		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(tree_root, &path);
-			if (ret != 0)
+			if (ret) {
+				if (ret < 0)
+					err = 1;
 				break;
+			}
 			leaf = path.nodes[0];
 		}
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
@@ -2098,8 +2127,10 @@ static int check_fs_roots(struct btrfs_root *root,
 next:
 		path.slots[0]++;
 	}
+out:
 	btrfs_release_path(&path);
-
+	if (err)
+		free_extent_cache_tree(&wc.shared);
 	if (!cache_tree_empty(&wc.shared))
 		fprintf(stderr, "warning line %d\n", __LINE__);
 
@@ -6245,7 +6276,8 @@ again:
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 	ret = btrfs_search_slot(NULL, root->fs_info->tree_root,
 					&key, &path, 0, 0);
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		goto out;
 	while(1) {
 		leaf = path.nodes[0];
 		slot = path.slots[0];
-- 
1.9.0

