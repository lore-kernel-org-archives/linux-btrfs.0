Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420B7C46465
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 05:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00E6120857
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 05:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00E6120857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbeKHPXQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 10:23:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:46106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbeKHPXQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 10:23:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BDA58AF8D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 05:49:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/6] btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()
Date:   Thu,  8 Nov 2018 13:49:14 +0800
Message-Id: <20181108054919.18253-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181108054919.18253-1-wqu@suse.com>
References: <20181108054919.18253-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Relocation code will drop btrfs_root::reloc_root as soon as
merge_reloc_root() finishes.

However later qgroup code will need to access btrfs_root::reloc_root
after merge_reloc_root() for delayed subtree rescan.

So alter the timming of resetting btrfs_root:::reloc_root, make it
happens after transaction commit.

With this patch, we will introduce a new btrfs_root::state,
BTRFS_ROOT_DEAD_RELOC_TREE, to info part of btrfs_root::reloc_tree user
that although btrfs_root::reloc_tree is still non-NULL, but still it's
not used any more.

The lifespan of btrfs_root::reloc tree will become:
          Old behavior            |              New
------------------------------------------------------------------------
btrfs_init_reloc_root()      ---  | btrfs_init_reloc_root()      ---
  set reloc_root              |   |   set reloc_root              |
                              |   |                               |
                              |   |                               |
merge_reloc_root()            |   | merge_reloc_root()            |
|- btrfs_update_reloc_root() ---  | |- btrfs_update_reloc_root() -+-
     clear btrfs_root::reloc_root |      set ROOT_DEAD_RELOC_TREE |
                                  |      record root into dirty   |
                                  |      roots rbtree             |
                                  |                               |
                                  | reloc_block_group() Or        |
                                  | btrfs_recover_relocation()    |
                                  | | After transaction commit    |
                                  | |- clean_dirty_root()        ---
                                  |     clear btrfs_root::reloc_root

During ROOT_DEAD_RELOC_TREE set lifespan, the only user of
btrfs_root::reloc_tree should be qgroup.

And to co-operate this, also delayed btrfs_drop_snapshot() call on reloc
tree, btrfs_drop_snapshot() call will also be delayed to
clean_dirty_root().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h      |   1 +
 fs/btrfs/relocation.c | 125 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80953528572d..2c33506bdaaa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1149,6 +1149,7 @@ struct btrfs_subvolume_writers {
 #define BTRFS_ROOT_FORCE_COW		6
 #define BTRFS_ROOT_MULTI_LOG_TASKS	7
 #define BTRFS_ROOT_DIRTY		8
+#define BTRFS_ROOT_DEAD_RELOC_TREE	9
 
 /*
  * in ram representation of the tree.  extent_root is used for all allocations
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 924116f654a1..6f1f11b5d8f6 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -143,6 +143,20 @@ struct file_extent_cluster {
 	unsigned int nr;
 };
 
+/*
+ * Helper structure to keep record of a file tree whose reloc
+ * root needs to be cleaned up.
+ *
+ * Since reloc_control is used less frequently than btrfs_root, this should
+ * prevent us to add another structure in btrfs_root.
+ */
+struct dirty_source_root {
+	struct rb_node node;
+
+	/* Root must be file tree */
+	struct btrfs_root *root;
+};
+
 struct reloc_control {
 	/* block group to relocate */
 	struct btrfs_block_group_cache *block_group;
@@ -172,6 +186,9 @@ struct reloc_control {
 	u64 search_start;
 	u64 extents_found;
 
+	/* dirty source roots, whose reloc root needs to be cleaned up */
+	struct rb_root dirty_roots;
+
 	unsigned int stage:8;
 	unsigned int create_reloc_tree:1;
 	unsigned int merge_reloc_tree:1;
@@ -1467,15 +1484,17 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 	struct btrfs_root_item *root_item;
 	int ret;
 
-	if (!root->reloc_root)
+	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state) ||
+	    !root->reloc_root)
 		goto out;
 
 	reloc_root = root->reloc_root;
 	root_item = &reloc_root->root_item;
 
+	/* root->reloc_root will stay until current relocation finished */
 	if (fs_info->reloc_ctl->merge_reloc_tree &&
 	    btrfs_root_refs(root_item) == 0) {
-		root->reloc_root = NULL;
+		set_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 		__del_reloc_root(reloc_root);
 	}
 
@@ -2120,6 +2139,84 @@ static int find_next_key(struct btrfs_path *path, int level,
 	return 1;
 }
 
+/*
+ * Helper to insert current root into reloc_control::dirty_roots
+ */
+static int insert_dirty_root(struct btrfs_trans_handle *trans,
+			     struct reloc_control *rc,
+			     struct btrfs_root *root)
+{
+	struct rb_node **p = &rc->dirty_roots.rb_node;
+	struct rb_node *parent = NULL;
+	struct dirty_source_root *entry;
+	struct btrfs_root *reloc_root = root->reloc_root;
+	struct btrfs_root_item *reloc_root_item;
+	u64 root_objectid = root->root_key.objectid;
+
+	/* @root must be a file tree root*/
+	ASSERT(root_objectid != BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(reloc_root);
+
+	reloc_root_item = &reloc_root->root_item;
+	memset(&reloc_root_item->drop_progress, 0,
+		sizeof(reloc_root_item->drop_progress));
+	reloc_root_item->drop_level = 0;
+	btrfs_set_root_refs(reloc_root_item, 0);
+	btrfs_update_reloc_root(trans, root);
+
+	/* We're at relocation route, not writeback route, GFP_KERNEL is OK */
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+	btrfs_grab_fs_root(root);
+	entry->root = root;
+	while (*p) {
+		struct dirty_source_root *cur_entry;
+
+		parent = *p;
+		cur_entry = rb_entry(parent, struct dirty_source_root, node);
+
+		if (root_objectid < cur_entry->root->root_key.objectid)
+			p = &(*p)->rb_left;
+		else if (root_objectid > cur_entry->root->root_key.objectid)
+			p = &(*p)->rb_right;
+		else {
+			/* This root is already dirtied */
+			btrfs_put_fs_root(root);
+			kfree(entry);
+			return 0;
+		}
+	}
+	rb_link_node(&entry->node, parent, p);
+	rb_insert_color(&entry->node, &rc->dirty_roots);
+	return 0;
+}
+
+static int clean_dirty_root(struct reloc_control *rc)
+{
+	struct dirty_source_root *entry;
+	struct dirty_source_root *next;
+	int err = 0;
+	int ret;
+
+	rbtree_postorder_for_each_entry_safe(entry, next, &rc->dirty_roots,
+					     node) {
+		struct btrfs_root *reloc_root = entry->root->reloc_root;
+
+		clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &entry->root->state);
+		entry->root->reloc_root = NULL;
+		if (reloc_root) {
+			ret = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
+			if (ret < 0 && !err)
+				err = ret;
+		}
+		btrfs_put_fs_root(entry->root);
+		kfree(entry);
+	}
+	rc->dirty_roots = RB_ROOT;
+	return err;
+}
+
 /*
  * merge the relocated tree blocks in reloc tree with corresponding
  * fs tree.
@@ -2259,13 +2356,8 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 out:
 	btrfs_free_path(path);
 
-	if (err == 0) {
-		memset(&root_item->drop_progress, 0,
-		       sizeof(root_item->drop_progress));
-		root_item->drop_level = 0;
-		btrfs_set_root_refs(root_item, 0);
-		btrfs_update_reloc_root(trans, root);
-	}
+	if (err == 0)
+		err = insert_dirty_root(trans, rc, root);
 
 	if (trans)
 		btrfs_end_transaction_throttle(trans);
@@ -2410,14 +2502,6 @@ void merge_reloc_roots(struct reloc_control *rc)
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-
-		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
-		if (ret < 0) {
-			if (list_empty(&reloc_root->root_list))
-				list_add_tail(&reloc_root->root_list,
-					      &reloc_roots);
-			goto out;
-		}
 	}
 
 	if (found) {
@@ -4078,6 +4162,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		goto out_free;
 	}
 	btrfs_commit_transaction(trans);
+	ret = clean_dirty_root(rc);
+	if (ret < 0 && !err)
+		err = ret;
 out_free:
 	btrfs_free_block_rsv(fs_info, rc->block_rsv);
 	btrfs_free_path(path);
@@ -4481,6 +4568,10 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		goto out_free;
 	}
 	err = btrfs_commit_transaction(trans);
+
+	ret = clean_dirty_root(rc);
+	if (ret < 0 && !err)
+		err = ret;
 out_free:
 	kfree(rc);
 out:
-- 
2.19.1

