Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE25C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0679C2073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbfACHcf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:32:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:46060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729958AbfACHce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 02:32:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B157B00D
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 07:32:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs-progs: uuid: Port btrfs_uuid_tree_add() function
Date:   Thu,  3 Jan 2019 15:32:20 +0800
Message-Id: <20190103073221.10525-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103073221.10525-1-wqu@suse.com>
References: <20190103073221.10525-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function provide the offline ability to add new uuid tree entry.

Also port fs_info->uuid and its initialization and cleanup code to
support uuid tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h     |  7 +++++-
 disk-io.c   | 19 +++++++++++++++-
 uuid-tree.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index f9c49d6041c1..7b9e3f1cef6e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1101,6 +1101,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *csum_root;
 	struct btrfs_root *quota_root;
 	struct btrfs_root *free_space_root;
+	struct btrfs_root *uuid_root;
 
 	struct rb_root fs_root_tree;
 
@@ -2774,11 +2775,15 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct btrfs_path *path,
 			u64 isize);
 
-/* uuid-tree.c */
+/* uuid-tree.c, mounted fs (online) interface */
 int btrfs_lookup_uuid_subvol_item(int fd, const u8 *uuid, u64 *subvol_id);
 int btrfs_lookup_uuid_received_subvol_item(int fd, const u8 *uuid,
 					   u64 *subvol_id);
 
+/* uuid-tree.c, unmounted fs (offline) interface */
+int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
+			u64 subid_cpu);
+
 static inline int is_fstree(u64 rootid)
 {
 	if (rootid == BTRFS_FS_TREE_OBJECTID ||
diff --git a/disk-io.c b/disk-io.c
index e3a3c5fbe492..32a239d0444d 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -664,6 +664,9 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 		return fs_info->dev_root;
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
+	if (location->objectid == BTRFS_UUID_TREE_OBJECTID)
+		return fs_info->uuid_root ? fs_info->uuid_root :
+				ERR_PTR(-ENOENT);
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return fs_info->quota_enabled ? fs_info->quota_root :
 				ERR_PTR(-ENOENT);
@@ -700,6 +703,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 	free(fs_info->dev_root);
 	free(fs_info->csum_root);
 	free(fs_info->free_space_root);
+	free(fs_info->uuid_root);
 	free(fs_info->super_copy);
 	free(fs_info->log_root_tree);
 	free(fs_info);
@@ -720,12 +724,14 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 	fs_info->csum_root = calloc(1, sizeof(struct btrfs_root));
 	fs_info->quota_root = calloc(1, sizeof(struct btrfs_root));
 	fs_info->free_space_root = calloc(1, sizeof(struct btrfs_root));
+	fs_info->uuid_root = calloc(1, sizeof(struct btrfs_root));
 	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
 
 	if (!fs_info->tree_root || !fs_info->extent_root ||
 	    !fs_info->chunk_root || !fs_info->dev_root ||
 	    !fs_info->csum_root || !fs_info->quota_root ||
-	    !fs_info->free_space_root || !fs_info->super_copy)
+	    !fs_info->free_space_root || !fs_info->uuid_root ||
+	    !fs_info->super_copy)
 		goto free_all;
 
 	extent_io_tree_init(&fs_info->extent_cache);
@@ -895,6 +901,15 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		return ret;
 	fs_info->csum_root->track_dirty = 1;
 
+	ret = find_and_setup_root(root, fs_info, BTRFS_UUID_TREE_OBJECTID,
+				  fs_info->uuid_root);
+	if (ret) {
+		free(fs_info->uuid_root);
+		fs_info->uuid_root = NULL;
+	} else {
+		fs_info->uuid_root->track_dirty = 1;
+	}
+
 	ret = find_and_setup_root(root, fs_info, BTRFS_QUOTA_TREE_OBJECTID,
 				  fs_info->quota_root);
 	if (ret) {
@@ -963,6 +978,8 @@ void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
 		free_extent_buffer(fs_info->log_root_tree->node);
 	if (fs_info->chunk_root)
 		free_extent_buffer(fs_info->chunk_root->node);
+	if (fs_info->uuid_root)
+		free_extent_buffer(fs_info->uuid_root->node);
 }
 
 static void free_map_lookup(struct cache_extent *ce)
diff --git a/uuid-tree.c b/uuid-tree.c
index e0bc51a5b8dc..e978b2d599ac 100644
--- a/uuid-tree.c
+++ b/uuid-tree.c
@@ -172,3 +172,68 @@ out:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
+			u64 subid_cpu)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *uuid_root = fs_info->uuid_root;
+	int ret;
+	struct btrfs_path *path = NULL;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int slot;
+	unsigned long offset;
+	__le64 subid_le;
+
+	if (!uuid_root) {
+		warning("%s: uuid root is not initialized", __func__);
+		return -EINVAL;
+	}
+
+	ret = btrfs_uuid_tree_lookup(uuid_root, uuid, type, subid_cpu);
+	if (ret != -ENOENT)
+		return ret;
+
+	key.type = type;
+	btrfs_uuid_to_key(uuid, &key.objectid, &key.offset);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_insert_empty_item(trans, uuid_root, path, &key,
+				      sizeof(subid_le));
+	if (ret >= 0) {
+		/* Add an item for the type for the first time */
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		offset = btrfs_item_ptr_offset(eb, slot);
+	} else if (ret == -EEXIST) {
+		/*
+		 * An item with that type already exists.
+		 * Extend the item and store the new subid at the end.
+		 */
+		btrfs_extend_item(uuid_root, path, sizeof(subid_le));
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		offset = btrfs_item_ptr_offset(eb, slot);
+		offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
+	} else if (ret < 0) {
+		warning("insert uuid item failed %d (0x%016llx, 0x%016llx) type %u!",
+			ret, (unsigned long long)key.objectid,
+			(unsigned long long)key.offset, type);
+		goto out;
+	}
+
+	ret = 0;
+	subid_le = cpu_to_le64(subid_cpu);
+	write_extent_buffer(eb, &subid_le, offset, sizeof(subid_le));
+	btrfs_mark_buffer_dirty(eb);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.20.1

