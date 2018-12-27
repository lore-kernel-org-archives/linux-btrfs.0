Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA287C43612
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3DE2218E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 07:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbeL0HNm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 02:13:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:35016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727225AbeL0HNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 02:13:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5268DAF17
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2018 07:13:40 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: uuid: Port btrfs_uuid_tree_add() function
Date:   Thu, 27 Dec 2018 15:13:32 +0800
Message-Id: <20181227071333.10964-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181227071333.10964-1-wqu@suse.com>
References: <20181227071333.10964-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function provide the offline ability to add new uuid tree entry.
This provides the basis for later proper uuid tree initialization.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h     |  7 +++++-
 uuid-tree.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)

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
diff --git a/uuid-tree.c b/uuid-tree.c
index b9190103c355..3f547198f016 100644
--- a/uuid-tree.c
+++ b/uuid-tree.c
@@ -170,3 +170,68 @@ out:
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

