Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52082 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab2KAM3F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 08:29:05 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 483Qy04SqWRVWoGY (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 06:29:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: check block group used count and fix if specified
Date: Thu, 1 Nov 2012 08:34:54 -0400
Message-ID: <1351773294-1458-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a problem where all of his block groups had invalid used
counts in the block group item.  This patch walks the extent tree and counts
up the used amount for each block group.  If the user specifies repair we
can set the correct used value and when the transaction commits we're all
set.  This was reported and tested by a user and worked.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfsck.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h   |    3 ++
 2 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 67f4a9d..a5f995d 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -3470,6 +3470,108 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int check_block_group_used(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_block_group_cache *block_group,
+				  struct btrfs_path *path, int repair)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 used = 0;
+	int slot;
+	int err = 0;
+	int ret;
+
+	root = root->fs_info->extent_root;
+	key.objectid = min_t(u64, block_group->key.objectid,
+			     BTRFS_SUPER_INFO_OFFSET);
+	key.offset = 0;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	while (1) {
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
+			if (ret) {
+				ret = 0;
+				break;
+			}
+			continue;
+		}
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.objectid < block_group->key.objectid) {
+			path->slots[0]++;
+			continue;
+		}
+
+		if (key.objectid >=
+		    block_group->key.objectid + block_group->key.offset)
+			break;
+
+		if (key.type == BTRFS_EXTENT_ITEM_KEY)
+			used += key.offset;
+		path->slots[0]++;
+	}
+	btrfs_release_path(root, path);
+
+	if (!err && btrfs_block_group_used(&block_group->item) != used) {
+		fprintf(stderr, "Block group %llu has a wrong used amount, "
+			"used=%llu, actually used=%llu%s\n",
+			(unsigned long long)block_group->key.objectid,
+			(unsigned long long)
+			btrfs_block_group_used(&block_group->item),
+			(unsigned long long)used, repair ? ", fixing": "");
+		if (repair) {
+			btrfs_set_block_group_used(&block_group->item, used);
+			set_extent_bits(&root->fs_info->block_group_cache,
+					block_group->key.objectid,
+					block_group->key.objectid +
+					block_group->key.offset - 1,
+					EXTENT_DIRTY, GFP_NOFS);
+		}
+		err = 1;
+	}
+
+	return err;
+}
+
+static int check_block_groups_used(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root, int repair)
+{
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_path *path;
+	u64 bytenr = 0;
+	int ret;
+	int err = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	path->reada = 2;
+	while ((block_group = btrfs_lookup_first_block_group(root->fs_info,
+							     bytenr))) {
+		ret = check_block_group_used(trans, root, block_group, path,
+					     repair);
+		if (ret && !err)
+			ret = err;
+		bytenr = block_group->key.objectid + block_group->key.offset;
+	}
+	btrfs_free_path(path);
+
+	return err;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfsck dev\n");
@@ -3574,6 +3676,11 @@ int main(int ac, char **av)
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree\n");
 
+	fprintf(stderr, "checking block groups used count\n");
+	ret = check_block_groups_used(trans, root, repair);
+	if (ret)
+		fprintf(stderr, "Errors found in block groups\n");
+
 	fprintf(stderr, "checking fs roots\n");
 	ret = check_fs_roots(root, &root_cache);
 	if (ret)
diff --git a/ctree.h b/ctree.h
index 293b24f..b125ede 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2052,6 +2052,9 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr, u64 num,
 			     int alloc, int mark_free);
+struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
+						       btrfs_fs_info *info,
+						       u64 bytenr);
 /* ctree.c */
 int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
-- 
1.7.7.6

