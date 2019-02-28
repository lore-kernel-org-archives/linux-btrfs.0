Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838D8C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519D12183F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 10:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbfB1KDF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:03:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:59292 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731561AbfB1KDF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 05:03:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36BFFAD84
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 10:03:02 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: Introduce extent_io_tree::owner to distinguish different io_trees
Date:   Thu, 28 Feb 2019 18:02:54 +0800
Message-Id: <20190228100255.10953-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190228100255.10953-1-wqu@suse.com>
References: <20190228100255.10953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs has the following different extent_io_trees used:
- fs_info::free_extents[2]
- btrfs_inode::io_tree
  For both normal inodes and btree inode
- btrfs_inode::io_failure_tree
- btrfs_transaction::dirty_pages
- btrfs_root::dirty_log_pages

If we want to trace bits change in those io_trees, it will be pretty
hard to distinguish them.

Instead of using hard-to-read pointer address, this patch will introduc
a new member extent_io_tree::owner, which uses the unpopulated bits of
extent_io_tree::track_uptodate, to track who owns this extent_io_tree.

This modification needs all the callers of extent_io_tree_init() to
accept a new parameter @owner.

This patch provides the basis for later ftrace events.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c               | 12 ++++++++----
 fs/btrfs/extent_io.c             |  3 ++-
 fs/btrfs/extent_io.h             | 20 ++++++++++++++++++--
 fs/btrfs/inode.c                 |  5 +++--
 fs/btrfs/relocation.c            |  3 ++-
 fs/btrfs/tests/btrfs-tests.c     |  6 ++++--
 fs/btrfs/tests/extent-io-tests.c |  2 +-
 fs/btrfs/transaction.c           |  2 +-
 8 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6a2a2a951705..ab5b23be086c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1205,7 +1205,8 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
 	if (!dummy)
-		extent_io_tree_init(&root->dirty_log_pages, NULL);
+		extent_io_tree_init(&root->dirty_log_pages,
+				    IO_TREE_ROOT_DIRTY_LOG_PAGES, NULL);
 
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
@@ -2129,7 +2130,8 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info)
 	inode->i_mapping->a_ops = &btree_aops;
 
 	RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
-	extent_io_tree_init(&BTRFS_I(inode)->io_tree, inode);
+	extent_io_tree_init(&BTRFS_I(inode)->io_tree, IO_TREE_INODE_IO_TREE,
+			    inode);
 	BTRFS_I(inode)->io_tree.track_uptodate = 0;
 	extent_map_tree_init(&BTRFS_I(inode)->extent_tree);
 
@@ -2739,8 +2741,10 @@ int open_ctree(struct super_block *sb,
 	fs_info->block_group_cache_tree = RB_ROOT;
 	fs_info->first_logical_byte = (u64)-1;
 
-	extent_io_tree_init(&fs_info->freed_extents[0], NULL);
-	extent_io_tree_init(&fs_info->freed_extents[1], NULL);
+	extent_io_tree_init(&fs_info->freed_extents[0],
+			    IO_TREE_FS_INFO_FREED_EXTENTS0, NULL);
+	extent_io_tree_init(&fs_info->freed_extents[1],
+			    IO_TREE_FS_INFO_FREED_EXTENTS1, NULL);
 	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	set_bit(BTRFS_FS_BARRIER, &fs_info->flags);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 52abe4082680..8b1d76261e53 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -200,7 +200,7 @@ void __cold extent_io_exit(void)
 	bioset_exit(&btrfs_bioset);
 }
 
-void extent_io_tree_init(struct extent_io_tree *tree,
+void extent_io_tree_init(struct extent_io_tree *tree, unsigned int owner,
 			 void *private_data)
 {
 	tree->state = RB_ROOT;
@@ -208,6 +208,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	tree->dirty_bytes = 0;
 	spin_lock_init(&tree->lock);
 	tree->private_data = private_data;
+	tree->owner = owner;
 }
 
 static struct extent_state *alloc_extent_state(gfp_t mask)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9673be3f3d1f..84654157ca92 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -107,11 +107,26 @@ struct extent_io_ops {
 				    int mirror);
 };
 
+enum {
+	IO_TREE_FS_INFO_FREED_EXTENTS0,
+	IO_TREE_FS_INFO_FREED_EXTENTS1,
+	IO_TREE_INODE_IO_TREE,
+	IO_TREE_INODE_IO_FAILURE_TREE,
+	IO_TREE_RELOCATION_PROCESSED_BLOCKS,
+	IO_TREE_TRANSACTION_DIRTY_PAGES,
+	IO_TREE_ROOT_DIRTY_LOG_PAGES,
+	IO_TREE_TMP,
+};
+
 struct extent_io_tree {
 	struct rb_root state;
 	void *private_data;
 	u64 dirty_bytes;
-	int track_uptodate;
+	unsigned int track_uptodate:1;
+
+	/* who owns this io tree, should be above IO_TREE_* enum */
+	unsigned int owner:15;
+
 	spinlock_t lock;
 	const struct extent_io_ops *ops;
 };
@@ -240,7 +255,8 @@ typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 					  u64 start, u64 len,
 					  int create);
 
-void extent_io_tree_init(struct extent_io_tree *tree, void *private_data);
+void extent_io_tree_init(struct extent_io_tree *tree, unsigned int owner,
+			 void *private_data);
 int try_release_extent_mapping(struct page *page, gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c349667c761..8eaa1c22346a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9128,8 +9128,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);
-	extent_io_tree_init(&ei->io_tree, inode);
-	extent_io_tree_init(&ei->io_failure_tree, inode);
+	extent_io_tree_init(&ei->io_tree, IO_TREE_INODE_IO_TREE, inode);
+	extent_io_tree_init(&ei->io_failure_tree,
+			    IO_TREE_INODE_IO_FAILURE_TREE, inode);
 	ei->io_tree.track_uptodate = 1;
 	ei->io_failure_tree.track_uptodate = 1;
 	atomic_set(&ei->sync_writers, 0);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 272b287f8cf0..7e1d3b6fc050 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4175,7 +4175,8 @@ static struct reloc_control *alloc_reloc_control(void)
 	INIT_LIST_HEAD(&rc->reloc_roots);
 	backref_cache_init(&rc->backref_cache);
 	mapping_tree_init(&rc->reloc_root_tree);
-	extent_io_tree_init(&rc->processed_blocks, NULL);
+	extent_io_tree_init(&rc->processed_blocks,
+			    IO_TREE_RELOCATION_PROCESSED_BLOCKS, NULL);
 	return rc;
 }
 
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 8a59597f1883..f34f2e3b271d 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -115,8 +115,10 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
 	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
 	INIT_RADIX_TREE(&fs_info->buffer_radix, GFP_ATOMIC);
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
-	extent_io_tree_init(&fs_info->freed_extents[0], NULL);
-	extent_io_tree_init(&fs_info->freed_extents[1], NULL);
+	extent_io_tree_init(&fs_info->freed_extents[0],
+			    IO_TREE_FS_INFO_FREED_EXTENTS0, NULL);
+	extent_io_tree_init(&fs_info->freed_extents[1],
+			    IO_TREE_FS_INFO_FREED_EXTENTS1, NULL);
 	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	set_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
 
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 3c46d7f23456..7eaeea348b31 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -77,7 +77,7 @@ static int test_find_delalloc(u32 sectorsize)
 		return -ENOMEM;
 	}
 
-	extent_io_tree_init(&tmp, NULL);
+	extent_io_tree_init(&tmp, IO_TREE_TMP, NULL);
 
 	/*
 	 * First go through and create and mark all of our pages dirty, we pin
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4ec2b660d014..c609d1b396ee 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -274,7 +274,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	spin_lock_init(&cur_trans->dropped_roots_lock);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
-			     fs_info->btree_inode);
+			IO_TREE_TRANSACTION_DIRTY_PAGES, fs_info->btree_inode);
 	fs_info->generation++;
 	cur_trans->transid = fs_info->generation;
 	fs_info->running_transaction = cur_trans;
-- 
2.21.0

