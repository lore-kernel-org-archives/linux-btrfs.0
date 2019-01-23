Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B49C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF6320870
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfAWRir (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:37992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfAWRir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 50346B080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F07F5DA6F5; Wed, 23 Jan 2019 18:38:13 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: open code now trivial btrfs_set_lock_blocking
Date:   Wed, 23 Jan 2019 18:38:13 +0100
Message-Id: <f8c3e8f5766a5eb1a6b9dcd766ef6d606b324ba0.1548264220.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548264220.git.dsterba@suse.com>
References: <cover.1548264220.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_set_lock_blocking is now only a simple wrapper around
btrfs_set_lock_blocking_write. The name does not bring any semantic
value that could not be inferred from the new function so there's no
point keeping it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c       | 22 +++++++++++-----------
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c | 14 +++++++-------
 fs/btrfs/locking.h     |  5 -----
 fs/btrfs/relocation.c  |  8 ++++----
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/tree-defrag.c |  2 +-
 fs/btrfs/tree-log.c    |  6 +++---
 8 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a9c957c1e2b9..a482171fd710 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1464,8 +1464,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	search_start = buf->start & ~((u64)SZ_1G - 1);
 
 	if (parent)
-		btrfs_set_lock_blocking(parent);
-	btrfs_set_lock_blocking(buf);
+		btrfs_set_lock_blocking_write(parent);
+	btrfs_set_lock_blocking_write(buf);
 
 	ret = __btrfs_cow_block(trans, root, buf, parent,
 				 parent_slot, cow_ret, search_start, 0);
@@ -1560,7 +1560,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	if (parent_nritems <= 1)
 		return 0;
 
-	btrfs_set_lock_blocking(parent);
+	btrfs_set_lock_blocking_write(parent);
 
 	for (i = start_slot; i <= end_slot; i++) {
 		struct btrfs_key first_key;
@@ -1619,7 +1619,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			search_start = last_block;
 
 		btrfs_tree_lock(cur);
-		btrfs_set_lock_blocking(cur);
+		btrfs_set_lock_blocking_write(cur);
 		err = __btrfs_cow_block(trans, root, cur, parent, i,
 					&cur, search_start,
 					min(16 * blocksize,
@@ -1834,7 +1834,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		}
 
 		btrfs_tree_lock(child);
-		btrfs_set_lock_blocking(child);
+		btrfs_set_lock_blocking_write(child);
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
 		if (ret) {
 			btrfs_tree_unlock(child);
@@ -1872,7 +1872,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	if (left) {
 		btrfs_tree_lock(left);
-		btrfs_set_lock_blocking(left);
+		btrfs_set_lock_blocking_write(left);
 		wret = btrfs_cow_block(trans, root, left,
 				       parent, pslot - 1, &left);
 		if (wret) {
@@ -1887,7 +1887,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	if (right) {
 		btrfs_tree_lock(right);
-		btrfs_set_lock_blocking(right);
+		btrfs_set_lock_blocking_write(right);
 		wret = btrfs_cow_block(trans, root, right,
 				       parent, pslot + 1, &right);
 		if (wret) {
@@ -2050,7 +2050,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 		u32 left_nr;
 
 		btrfs_tree_lock(left);
-		btrfs_set_lock_blocking(left);
+		btrfs_set_lock_blocking_write(left);
 
 		left_nr = btrfs_header_nritems(left);
 		if (left_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
@@ -2105,7 +2105,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 		u32 right_nr;
 
 		btrfs_tree_lock(right);
-		btrfs_set_lock_blocking(right);
+		btrfs_set_lock_blocking_write(right);
 
 		right_nr = btrfs_header_nritems(right);
 		if (right_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
@@ -3749,7 +3749,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 		return 1;
 
 	btrfs_tree_lock(right);
-	btrfs_set_lock_blocking(right);
+	btrfs_set_lock_blocking_write(right);
 
 	free_space = btrfs_leaf_free_space(fs_info, right);
 	if (free_space < data_size)
@@ -3983,7 +3983,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		return 1;
 
 	btrfs_tree_lock(left);
-	btrfs_set_lock_blocking(left);
+	btrfs_set_lock_blocking_write(left);
 
 	free_space = btrfs_leaf_free_space(fs_info, left);
 	if (free_space < data_size) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ba369b502f4e..e64afc78ed27 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1120,7 +1120,7 @@ void clean_tree_block(struct btrfs_fs_info *fs_info,
 						 -buf->len,
 						 fs_info->dirty_metadata_batch);
 			/* ugh, clear_extent_buffer_dirty needs to lock the page */
-			btrfs_set_lock_blocking(buf);
+			btrfs_set_lock_blocking_write(buf);
 			clear_extent_buffer_dirty(buf);
 		}
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d81035b7ea7d..39f10f1099a0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8492,7 +8492,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	clean_tree_block(fs_info, buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
 
-	btrfs_set_lock_blocking(buf);
+	btrfs_set_lock_blocking_write(buf);
 	set_extent_buffer_uptodate(buf);
 
 	memzero_extent_buffer(buf, 0, sizeof(struct btrfs_header));
@@ -8917,7 +8917,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		reada = 1;
 	}
 	btrfs_tree_lock(next);
-	btrfs_set_lock_blocking(next);
+	btrfs_set_lock_blocking_write(next);
 
 	ret = btrfs_lookup_extent_info(trans, fs_info, bytenr, level - 1, 1,
 				       &wc->refs[level - 1],
@@ -8977,7 +8977,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 			return -EIO;
 		}
 		btrfs_tree_lock(next);
-		btrfs_set_lock_blocking(next);
+		btrfs_set_lock_blocking_write(next);
 	}
 
 	level--;
@@ -9089,7 +9089,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		if (!path->locks[level]) {
 			BUG_ON(level == 0);
 			btrfs_tree_lock(eb);
-			btrfs_set_lock_blocking(eb);
+			btrfs_set_lock_blocking_write(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, fs_info,
@@ -9131,7 +9131,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 		if (!path->locks[level] &&
 		    btrfs_header_generation(eb) == trans->transid) {
 			btrfs_tree_lock(eb);
-			btrfs_set_lock_blocking(eb);
+			btrfs_set_lock_blocking_write(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		}
 		clean_tree_block(fs_info, eb);
@@ -9298,7 +9298,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
 		path->nodes[level] = btrfs_lock_root_node(root);
-		btrfs_set_lock_blocking(path->nodes[level]);
+		btrfs_set_lock_blocking_write(path->nodes[level]);
 		path->slots[level] = 0;
 		path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		memset(&wc->update_progress, 0,
@@ -9328,7 +9328,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		level = btrfs_header_level(root->node);
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
-			btrfs_set_lock_blocking(path->nodes[level]);
+			btrfs_set_lock_blocking_write(path->nodes[level]);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, fs_info,
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 9d9f649e35cc..84ea6ed60047 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -51,9 +51,4 @@ static inline void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 		btrfs_set_lock_blocking_read(eb);
 }
 
-static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)
-{
-	btrfs_set_lock_blocking_write(eb);
-}
-
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 272b287f8cf0..5a2096f76a35 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1773,7 +1773,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	btrfs_node_key_to_cpu(path->nodes[lowest_level], &key, slot);
 
 	eb = btrfs_lock_root_node(dest);
-	btrfs_set_lock_blocking(eb);
+	btrfs_set_lock_blocking_write(eb);
 	level = btrfs_header_level(eb);
 
 	if (level < lowest_level) {
@@ -1786,7 +1786,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		ret = btrfs_cow_block(trans, dest, eb, NULL, 0, &eb);
 		BUG_ON(ret);
 	}
-	btrfs_set_lock_blocking(eb);
+	btrfs_set_lock_blocking_write(eb);
 
 	if (next_key) {
 		next_key->objectid = (u64)-1;
@@ -1852,7 +1852,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 						      slot, &eb);
 				BUG_ON(ret);
 			}
-			btrfs_set_lock_blocking(eb);
+			btrfs_set_lock_blocking_write(eb);
 
 			btrfs_tree_unlock(parent);
 			free_extent_buffer(parent);
@@ -2752,7 +2752,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 			goto next;
 		}
 		btrfs_tree_lock(eb);
-		btrfs_set_lock_blocking(eb);
+		btrfs_set_lock_blocking_write(eb);
 
 		if (!node->eb) {
 			ret = btrfs_cow_block(trans, root, eb, upper->eb,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 127fa1535f58..3e96e2bd3136 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1540,7 +1540,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	btrfs_set_lock_blocking(old);
+	btrfs_set_lock_blocking_write(old);
 
 	ret = btrfs_copy_root(trans, root, old, &tmp, objectid);
 	/* clean up in any case */
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 3c0987ab587d..5f9e2dd413af 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -52,7 +52,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		u32 nritems;
 
 		root_node = btrfs_lock_root_node(root);
-		btrfs_set_lock_blocking(root_node);
+		btrfs_set_lock_blocking_write(root_node);
 		nritems = btrfs_header_nritems(root_node);
 		root->defrag_max.objectid = 0;
 		/* from above we know this is not a leaf */
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ac232b3d6d7e..1a69a45ae926 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2663,7 +2663,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 				if (trans) {
 					btrfs_tree_lock(next);
-					btrfs_set_lock_blocking(next);
+					btrfs_set_lock_blocking_write(next);
 					clean_tree_block(fs_info, next);
 					btrfs_wait_tree_block_writeback(next);
 					btrfs_tree_unlock(next);
@@ -2747,7 +2747,7 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 
 				if (trans) {
 					btrfs_tree_lock(next);
-					btrfs_set_lock_blocking(next);
+					btrfs_set_lock_blocking_write(next);
 					clean_tree_block(fs_info, next);
 					btrfs_wait_tree_block_writeback(next);
 					btrfs_tree_unlock(next);
@@ -2829,7 +2829,7 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 
 			if (trans) {
 				btrfs_tree_lock(next);
-				btrfs_set_lock_blocking(next);
+				btrfs_set_lock_blocking_write(next);
 				clean_tree_block(fs_info, next);
 				btrfs_wait_tree_block_writeback(next);
 				btrfs_tree_unlock(next);
-- 
2.20.1

