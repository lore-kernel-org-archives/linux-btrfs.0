Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:48530 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753901AbcJML1X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:27:23 -0400
From: ethanwu <ethanwu@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: ethanwu <ethanwu@synology.com>
Subject: [PATCH 2/2] btrfs-progs: check: add drop key to relocation tree
Date: Thu, 13 Oct 2016 19:09:49 +0800
Message-Id: <1476356989-23131-3-git-send-email-ethanwu@synology.com>
In-Reply-To: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
References: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If subvolume is deleted, we add drop_key into the corresponding
root item, so we know where to start processing the deleted subvolume.
However, we don't skip the keys prior to the drop_key in corresponding
relocation tree of the deleted subvolume. As a result, we might run
into block that is freed and being used again. This cause btrfs
check to report false alarm.

Fix this by adding drop_key for deleted subvolume to its corresponding
relocation tree.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 cmds-check.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index bf6398d..4d7cb68 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -92,6 +92,13 @@ struct extent_backref {
 	unsigned int broken:1;
 };
 
+static int add_root_item_to_list(struct list_head *head,
+				  u64 objectid, u64 bytenr, u64 last_snapshot,
+				  u8 level, u8 drop_level,
+				  int level_size, struct btrfs_key *drop_key);
+
+static void free_root_item_list(struct list_head *list);
+
 static inline struct extent_backref* to_extent_backref(struct list_head *entry)
 {
 	return list_entry(entry, struct extent_backref, list);
@@ -3761,6 +3768,10 @@ static int check_fs_roots(struct btrfs_root *root,
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
 	int ret;
 	int err = 0;
+	struct list_head dropping_trees;
+	struct btrfs_disk_key *drop_progress;
+
+	INIT_LIST_HEAD(&dropping_trees);
 
 	if (ctx.progress_enabled) {
 		ctx.tp = TASK_FS_ROOTS;
@@ -3818,6 +3829,32 @@ again:
 				err = 1;
 				goto next;
 			}
+
+			drop_progress = &tmp_root->root_item.drop_progress;
+			if (btrfs_disk_key_objectid(drop_progress) != 0) {
+				struct btrfs_key drop_key;
+
+				btrfs_disk_key_to_cpu(&drop_key, drop_progress);
+				ret = add_root_item_to_list(&dropping_trees,
+						tmp_root->root_key.objectid,
+						0, 0, 0, tmp_root->root_item.drop_level,
+						0, &drop_key);
+				if (ret < 0) {
+					err = 1;
+					goto out;
+				}
+			} else if (key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+				struct root_item_record *ri_rec;
+
+				list_for_each_entry(ri_rec, &dropping_trees, list) {
+					if (ri_rec->objectid == key.offset) {
+						btrfs_cpu_key_to_disk(drop_progress, &ri_rec->drop_key);
+						tmp_root->root_item.drop_level = ri_rec->drop_level;
+						break;
+					}
+				}
+			}
+
 			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret == -EAGAIN) {
 				free_root_recs_tree(root_cache);
@@ -3837,6 +3874,7 @@ next:
 		path.slots[0]++;
 	}
 out:
+	free_root_item_list(&dropping_trees);
 	btrfs_release_path(&path);
 	if (err)
 		free_extent_cache_tree(&wc.shared);
@@ -8536,6 +8574,9 @@ again:
 		if (found_key.type == BTRFS_ROOT_ITEM_KEY) {
 			unsigned long offset;
 			u64 last_snapshot;
+			struct root_item_record *ri_rec;
+			struct btrfs_key drop_key = {0};
+			u8 drop_level = 0;
 
 			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
@@ -8543,11 +8584,20 @@ again:
 			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
 				level = btrfs_root_level(&ri);
 				level_size = root->nodesize;
+				if (found_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+					list_for_each_entry(ri_rec, &dropping_trees, list) {
+						if (ri_rec->objectid == found_key.offset) {
+							drop_key = ri_rec->drop_key;
+							drop_level = ri_rec->drop_level;
+							break;
+						}
+					}
+				}
 				ret = add_root_item_to_list(&normal_trees,
 						found_key.objectid,
 						btrfs_root_bytenr(&ri),
 						last_snapshot, level,
-						0, level_size, NULL);
+						drop_level, level_size, &drop_key);
 				if (ret < 0)
 					goto out;
 			} else {
-- 
1.9.1

