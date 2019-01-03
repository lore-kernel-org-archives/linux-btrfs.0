Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BD8C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15BC52073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfACHc3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:32:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:46028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728276AbfACHc3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 02:32:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3D6FB00E
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 07:32:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/5] btrfs-progs: Export btrfs_create_tree() and move it to disk-io.c
Date:   Thu,  3 Jan 2019 15:32:17 +0800
Message-Id: <20190103073221.10525-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103073221.10525-1-wqu@suse.com>
References: <20190103073221.10525-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just as how kernel uses it.

This provides the basis for later uuid creation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c         | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 disk-io.h         |  4 ++-
 free-space-tree.c | 72 -----------------------------------------------
 3 files changed, 75 insertions(+), 73 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 5fafa144c0d3..0668031b974b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1723,3 +1723,75 @@ int btrfs_set_buffer_uptodate(struct extent_buffer *eb)
 {
 	return set_extent_buffer_uptodate(eb);
 }
+
+struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+				     struct btrfs_fs_info *fs_info,
+				     u64 objectid)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	int ret = 0;
+
+	root = kzalloc(sizeof(*root), GFP_KERNEL);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+
+	btrfs_setup_root(root, fs_info, objectid);
+	root->root_key.objectid = objectid;
+	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root->root_key.offset = 0;
+
+	leaf = btrfs_alloc_free_block(trans, root, fs_info->nodesize, objectid,
+			NULL, 0, 0, 0);
+	if (IS_ERR(leaf)) {
+		ret = PTR_ERR(leaf);
+		leaf = NULL;
+		goto fail;
+	}
+
+	memset_extent_buffer(leaf, 0, 0, sizeof(struct btrfs_header));
+	btrfs_set_header_bytenr(leaf, leaf->start);
+	btrfs_set_header_generation(leaf, trans->transid);
+	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
+	btrfs_set_header_owner(leaf, objectid);
+	root->node = leaf;
+	write_extent_buffer(leaf, fs_info->fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
+			    btrfs_header_chunk_tree_uuid(leaf),
+			    BTRFS_UUID_SIZE);
+	btrfs_mark_buffer_dirty(leaf);
+
+	extent_buffer_get(root->node);
+	root->commit_root = root->node;
+	root->track_dirty = 1;
+
+	root->root_item.flags = 0;
+	root->root_item.byte_limit = 0;
+	btrfs_set_root_bytenr(&root->root_item, leaf->start);
+	btrfs_set_root_generation(&root->root_item, trans->transid);
+	btrfs_set_root_level(&root->root_item, 0);
+	btrfs_set_root_refs(&root->root_item, 1);
+	btrfs_set_root_used(&root->root_item, leaf->len);
+	btrfs_set_root_last_snapshot(&root->root_item, 0);
+	btrfs_set_root_dirid(&root->root_item, 0);
+	memset(root->root_item.uuid, 0, BTRFS_UUID_SIZE);
+	root->root_item.drop_level = 0;
+
+	key.objectid = objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_insert_root(trans, tree_root, &key, &root->root_item);
+	if (ret)
+		goto fail;
+
+	return root;
+
+fail:
+	if (leaf)
+		free_extent_buffer(leaf);
+
+	kfree(root);
+	return ERR_PTR(ret);
+}
diff --git a/disk-io.h b/disk-io.h
index 05cbbce6ea4a..c4a6a020dd88 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -197,5 +197,7 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_fs_info *fs_info,
 		     struct extent_buffer *eb);
 int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb);
-
+struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+				     struct btrfs_fs_info *fs_info,
+				     u64 objectid);
 #endif
diff --git a/free-space-tree.c b/free-space-tree.c
index 6ef57928f1a9..5089fef0652c 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -1420,78 +1420,6 @@ out:
 	return ret;
 }
 
-static struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
-				     u64 objectid)
-{
-	struct extent_buffer *leaf;
-	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_root *root;
-	struct btrfs_key key;
-	int ret = 0;
-
-	root = kzalloc(sizeof(*root), GFP_KERNEL);
-	if (!root)
-		return ERR_PTR(-ENOMEM);
-
-	btrfs_setup_root(root, fs_info, objectid);
-	root->root_key.objectid = objectid;
-	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
-	root->root_key.offset = 0;
-
-	leaf = btrfs_alloc_free_block(trans, root, fs_info->nodesize, objectid,
-			NULL, 0, 0, 0);
-	if (IS_ERR(leaf)) {
-		ret = PTR_ERR(leaf);
-		leaf = NULL;
-		goto fail;
-	}
-
-	memset_extent_buffer(leaf, 0, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(leaf, leaf->start);
-	btrfs_set_header_generation(leaf, trans->transid);
-	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(leaf, objectid);
-	root->node = leaf;
-	write_extent_buffer(leaf, fs_info->fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
-	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
-			    btrfs_header_chunk_tree_uuid(leaf),
-			    BTRFS_UUID_SIZE);
-	btrfs_mark_buffer_dirty(leaf);
-
-	extent_buffer_get(root->node);
-	root->commit_root = root->node;
-	root->track_dirty = 1;
-
-	root->root_item.flags = 0;
-	root->root_item.byte_limit = 0;
-	btrfs_set_root_bytenr(&root->root_item, leaf->start);
-	btrfs_set_root_generation(&root->root_item, trans->transid);
-	btrfs_set_root_level(&root->root_item, 0);
-	btrfs_set_root_refs(&root->root_item, 1);
-	btrfs_set_root_used(&root->root_item, leaf->len);
-	btrfs_set_root_last_snapshot(&root->root_item, 0);
-	btrfs_set_root_dirid(&root->root_item, 0);
-	memset(root->root_item.uuid, 0, BTRFS_UUID_SIZE);
-	root->root_item.drop_level = 0;
-
-	key.objectid = objectid;
-	key.type = BTRFS_ROOT_ITEM_KEY;
-	key.offset = 0;
-	ret = btrfs_insert_root(trans, tree_root, &key, &root->root_item);
-	if (ret)
-		goto fail;
-
-	return root;
-
-fail:
-	if (leaf)
-		free_extent_buffer(leaf);
-
-	kfree(root);
-	return ERR_PTR(ret);
-}
-
 #define btrfs_set_fs_compat_ro(__fs_info, opt) \
 	__btrfs_set_fs_compat_ro((__fs_info), BTRFS_FEATURE_COMPAT_RO_##opt)
 
-- 
2.20.1

