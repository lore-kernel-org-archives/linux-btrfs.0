Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15899 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbbAMCEy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 21:04:54 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D24G4Z025907
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 10:04:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs-progs: Report corrupted trees after check_chunks_and_extents()
Date: Tue, 13 Jan 2015 10:04:44 +0800
Message-ID: <1421114687-6084-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function check_chunks_and_extents() will iterate all the extents, so
we should have a brief view on which tree is corrupted according to the
backref of extents we iterated.

This patch will mark root corrupted if we find extents whose backref
can't be verified.
And after check_chunks_and_extents() report it to user.
This will helps a lot for users to determine later recovery strategy,
e.g. if user find only csum tree is corrupted, --init-csum will be the
best choice (and in fact, current btrfsck only gives tons of unfriendly
error and no advice or what tree is corrupted).

This patch also provides the basis for later automatic csum/extent tree
rebuild.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h      |  2 ++
 2 files changed, 98 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index ddc0ded..500207e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7221,6 +7221,53 @@ static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 	}
 }
 
+/*
+ * Mark corresponding btrfs_root corrupted according to the extent_record.
+ * NOTE: For subvolume/fs tree, it will all be marked to fs tree since
+ * we can't determine which exact tree.
+ */
+static int mark_root_corrupted(struct btrfs_fs_info *fs_info,
+			       struct extent_record *rec)
+{
+	struct extent_backref *back;
+	struct tree_backref *tback;
+	struct btrfs_key key;
+	struct btrfs_root *root;
+
+	/* For data, it must be fs/subvolue tree */
+	if (!rec->metadata) {
+data:
+		fs_info->have_corrupted_root = 1;
+		fs_info->fs_root->corrupted = 1;
+		return 0;
+	}
+
+	if (list_empty(&rec->backrefs))
+		return -EINVAL;
+	back = list_entry(rec->backrefs.next, struct extent_backref, list);
+	/* Impossible, but still consider it as data */
+	if (back->is_data)
+		goto data;
+
+	tback = (struct tree_backref *)back;
+	if (is_fstree(tback->root))
+		key.objectid = BTRFS_FS_TREE_OBJECTID;
+	else
+		key.objectid = tback->root;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (PTR_ERR(root) == -ENOENT)
+		root = NULL;
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+	fs_info->have_corrupted_root = 1;
+	if (root)
+		root->corrupted = 1;
+	return 0;
+}
+
 static int check_extent_refs(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
@@ -7362,6 +7409,8 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 			}
 			err = 1;
 		}
+		if (err && !fixed)
+			mark_root_corrupted(root->fs_info, rec);
 
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
@@ -8885,6 +8934,48 @@ out:
 	return bad_roots;
 }
 
+#define CORRUPTED_ROOT		(1<<0)
+#define CORRUPTED_CHUNK		(1<<1)
+#define CORRUPTED_EXTENT	(1<<2)
+#define CORRUPTED_DEVICE	(1<<3)
+#define CORRUPTED_FS		(1<<4)
+#define CORRUPTED_CSUM		(1<<5)
+static u16 report_root_corrupted(struct btrfs_fs_info *fs_info,
+				  const char *prefix)
+{
+	int ret = 0;
+
+	if (!fs_info->have_corrupted_root)
+		return ret;
+	fprintf(stderr,
+		"The following tree(s) may have corrupted/missing extent references:\n");
+	if (!fs_info->tree_root || fs_info->tree_root->corrupted) {
+		fprintf(stderr, "%sroot tree\n", prefix);
+		ret |= CORRUPTED_ROOT;
+	}
+	if (!fs_info->chunk_root || fs_info->chunk_root->corrupted) {
+		fprintf(stderr, "%schunk tree\n", prefix);
+		ret |= CORRUPTED_CHUNK;
+	}
+	if (!fs_info->extent_root || fs_info->extent_root->corrupted) {
+		fprintf(stderr, "%sextent tree\n", prefix);
+		ret |= CORRUPTED_EXTENT;
+	}
+	if (!fs_info->dev_root || fs_info->dev_root->corrupted) {
+		fprintf(stderr, "%sdevice tree\n", prefix);
+		ret |= CORRUPTED_DEVICE;
+	}
+	if (!fs_info->fs_root || fs_info->fs_root->corrupted) {
+		fprintf(stderr, "%sfs/file tree\n", prefix);
+		ret |= CORRUPTED_FS;
+	}
+	if (!fs_info->csum_root || fs_info->csum_root->corrupted) {
+		fprintf(stderr, "%schecksum tree\n", prefix);
+		ret |= CORRUPTED_CSUM;
+	}
+	return ret;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -9113,6 +9204,11 @@ int cmd_check(int argc, char **argv)
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
 
+	/*
+	 * chunk and extent tree check has iterates all the extents,
+	 * so know we have a brief view on which trees are damaged.
+	 */
+	report_root_corrupted(info, "\t");
 	ret = repair_root_items(info);
 	if (ret < 0)
 		goto close_out;
diff --git a/ctree.h b/ctree.h
index 5dbc767..48fa492 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1004,6 +1004,7 @@ struct btrfs_fs_info {
 				int refs_to_drop);
 	struct cache_tree *fsck_extent_cache;
 	struct cache_tree *corrupt_blocks;
+	unsigned int have_corrupted_root:1;
 };
 
 /*
@@ -1052,6 +1053,7 @@ struct btrfs_root {
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
 	struct rb_node rb_node;
+	unsigned int corrupted:1;
 };
 
 /*
-- 
2.2.1

