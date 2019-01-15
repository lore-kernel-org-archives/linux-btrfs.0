Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7843C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 08:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B01320859
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 08:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfAOIQb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:16:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:47728 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728448AbfAOIQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 03:16:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65FAEAFCC
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 08:16:28 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/7] btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots()
Date:   Tue, 15 Jan 2019 16:16:00 +0800
Message-Id: <20190115081604.785-4-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115081604.785-1-wqu@suse.com>
References: <20190115081604.785-1-wqu@suse.com>
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
                                  | |- clean_dirty_subvs()       ---
                                  |     clear btrfs_root::reloc_root

During ROOT_DEAD_RELOC_TREE set lifespan, the only user of
btrfs_root::reloc_tree should be qgroup.

And to co-operate this, also delayed btrfs_drop_snapshot() call on reloc
tree, btrfs_drop_snapshot() call will also be delayed to
clean_dirty_subvs().

This patch will increase the size of btrfs_root by 16 bytes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h      | 15 ++++++++
 fs/btrfs/disk-io.c    |  1 +
 fs/btrfs/relocation.c | 85 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 84 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0a68cf7032f5..2c374dfb6aec 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1195,6 +1195,13 @@ enum {
 	BTRFS_ROOT_MULTI_LOG_TASKS,
 	BTRFS_ROOT_DIRTY,
 	BTRFS_ROOT_DELETING,
+
+	/*
+	 * Reloc tree is orphan, only kept here for qgroup delayed subtree scan
+	 *
+	 * Set for the subvolume tree owning the reloc tree.
+	 */
+	BTRFS_ROOT_DEAD_RELOC_TREE,
 };
 
 /*
@@ -1307,6 +1314,14 @@ struct btrfs_root {
 	struct list_head ordered_root;
 	u64 nr_ordered_extents;
 
+	/*
+	 * Not empty if this subvolume root has gone through tree block swap
+	 * (relocation)
+	 *
+	 * Will be used by reloc_control::dirty_subv_roots.
+	 */
+	struct list_head reloc_dirty_list;
+
 	/*
 	 * Number of currently running SEND ioctls to prevent
 	 * manipulation with the read-only status via SUBVOL_SETFLAGS
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8da2f380d3c0..bfefa1de0455 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1175,6 +1175,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&root->delalloc_root);
 	INIT_LIST_HEAD(&root->ordered_extents);
 	INIT_LIST_HEAD(&root->ordered_root);
+	INIT_LIST_HEAD(&root->reloc_dirty_list);
 	INIT_LIST_HEAD(&root->logged_list[0]);
 	INIT_LIST_HEAD(&root->logged_list[1]);
 	spin_lock_init(&root->inode_lock);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 272b287f8cf0..1d5cfceb46c1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -162,6 +162,8 @@ struct reloc_control {
 	struct mapping_tree reloc_root_tree;
 	/* list of reloc trees */
 	struct list_head reloc_roots;
+	/* list of subvolume trees who get relocated */
+	struct list_head dirty_subv_roots;
 	/* size of metadata reservation for merging reloc trees */
 	u64 merging_rsv_size;
 	/* size of relocated tree nodes */
@@ -1467,15 +1469,17 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
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
 
@@ -2120,6 +2124,58 @@ static int find_next_key(struct btrfs_path *path, int level,
 	return 1;
 }
 
+/*
+ * Helper to insert current subvolume root into reloc_control::dirty_subv_roots
+ */
+static void insert_dirty_subv(struct btrfs_trans_handle *trans,
+			      struct reloc_control *rc, struct btrfs_root *root)
+{
+	struct btrfs_root *reloc_root = root->reloc_root;
+	struct btrfs_root_item *reloc_root_item;
+	u64 root_objectid = root->root_key.objectid;
+
+	/* @root must be a file tree root with a valid reloc tree */
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
+	if (list_empty(&root->reloc_dirty_list)) {
+		btrfs_grab_fs_root(root);
+		list_add_tail(&root->reloc_dirty_list, &rc->dirty_subv_roots);
+	}
+	return;
+}
+
+static int clean_dirty_subvs(struct reloc_control *rc)
+{
+	struct btrfs_root *root;
+	struct btrfs_root *next;
+	int err = 0;
+	int ret;
+
+	list_for_each_entry_safe(root, next, &rc->dirty_subv_roots,
+				 reloc_dirty_list) {
+		struct btrfs_root *reloc_root = root->reloc_root;
+
+		clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
+		list_del_init(&root->reloc_dirty_list);
+		root->reloc_root = NULL;
+		if (reloc_root) {
+			ret = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
+			if (ret < 0 && !err)
+				err = ret;
+		}
+		btrfs_put_fs_root(root);
+	}
+	return err;
+}
+
 /*
  * merge the relocated tree blocks in reloc tree with corresponding
  * fs tree.
@@ -2259,13 +2315,8 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
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
+		insert_dirty_subv(trans, rc, root);
 
 	if (trans)
 		btrfs_end_transaction_throttle(trans);
@@ -2410,14 +2461,6 @@ void merge_reloc_roots(struct reloc_control *rc)
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
@@ -4079,6 +4122,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		goto out_free;
 	}
 	btrfs_commit_transaction(trans);
+	ret = clean_dirty_subvs(rc);
+	if (ret < 0 && !err)
+		err = ret;
 out_free:
 	btrfs_free_block_rsv(fs_info, rc->block_rsv);
 	btrfs_free_path(path);
@@ -4173,6 +4219,7 @@ static struct reloc_control *alloc_reloc_control(void)
 		return NULL;
 
 	INIT_LIST_HEAD(&rc->reloc_roots);
+	INIT_LIST_HEAD(&rc->dirty_subv_roots);
 	backref_cache_init(&rc->backref_cache);
 	mapping_tree_init(&rc->reloc_root_tree);
 	extent_io_tree_init(&rc->processed_blocks, NULL);
@@ -4468,6 +4515,10 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		goto out_free;
 	}
 	err = btrfs_commit_transaction(trans);
+
+	ret = clean_dirty_subvs(rc);
+	if (ret < 0 && !err)
+		err = ret;
 out_free:
 	kfree(rc);
 out:
-- 
2.20.1

