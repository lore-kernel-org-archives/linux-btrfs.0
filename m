Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50493C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30DCC20870
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfAWRio (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:37986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfAWRin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3030B080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8A347DA6F5; Wed, 23 Jan 2019 18:38:10 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: replace btrfs_set_lock_blocking_rw with appropriate helpers
Date:   Wed, 23 Jan 2019 18:38:10 +0100
Message-Id: <2780f2b4ca9cb5dbe5d7602abe016a35f009518c.1548264220.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548264220.git.dsterba@suse.com>
References: <cover.1548264220.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can use the right helper where the lock type is a fixed parameter.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c    | 4 ++--
 fs/btrfs/ctree.c      | 4 ++--
 fs/btrfs/disk-io.c    | 2 +-
 fs/btrfs/locking.h    | 2 +-
 fs/btrfs/qgroup.c     | 6 +++---
 fs/btrfs/ref-verify.c | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 78556447e1d5..136454dbb4af 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1289,7 +1289,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 					goto out;
 				}
 				btrfs_tree_read_lock(eb);
-				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+				btrfs_set_lock_blocking_read(eb);
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie, ignore_offset);
 				btrfs_tree_read_unlock_blocking(eb);
@@ -1650,7 +1650,7 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		/* make sure we can use eb after releasing the path */
 		if (eb != eb_in) {
 			if (!path->skip_locking)
-				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+				btrfs_set_lock_blocking_read(eb);
 			path->nodes[0] = NULL;
 			path->locks[0] = 0;
 		}
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f64aad613727..a9c957c1e2b9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1266,7 +1266,7 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		return eb;
 
 	btrfs_set_path_blocking(path);
-	btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+	btrfs_set_lock_blocking_read(eb);
 
 	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		BUG_ON(tm->slot != 0);
@@ -1356,7 +1356,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		free_extent_buffer(eb_root);
 		eb = alloc_dummy_extent_buffer(fs_info, logical);
 	} else {
-		btrfs_set_lock_blocking_rw(eb_root, BTRFS_READ_LOCK);
+		btrfs_set_lock_blocking_read(eb_root);
 		eb = btrfs_clone_extent_buffer(eb_root);
 		btrfs_tree_read_unlock_blocking(eb_root);
 		free_extent_buffer(eb_root);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6a2a2a951705..ba369b502f4e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -341,7 +341,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 
 	if (need_lock) {
 		btrfs_tree_read_lock(eb);
-		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+		btrfs_set_lock_blocking_read(eb);
 	}
 
 	lock_extent_bits(io_tree, eb->start, eb->start + eb->len - 1,
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 3f81d6900c71..9d9f649e35cc 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -53,7 +53,7 @@ static inline void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 
 static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)
 {
-	btrfs_set_lock_blocking_rw(eb, BTRFS_WRITE_LOCK);
+	btrfs_set_lock_blocking_write(eb);
 }
 
 #endif
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e473a998219..fa9e07e79516 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1832,7 +1832,7 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 			src_path->nodes[cur_level] = eb;
 
 			btrfs_tree_read_lock(eb);
-			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+			btrfs_set_lock_blocking_read(eb);
 			src_path->locks[cur_level] = BTRFS_READ_LOCK_BLOCKING;
 		}
 
@@ -1973,7 +1973,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 		dst_path->slots[cur_level] = 0;
 
 		btrfs_tree_read_lock(eb);
-		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+		btrfs_set_lock_blocking_read(eb);
 		dst_path->locks[cur_level] = BTRFS_READ_LOCK_BLOCKING;
 		need_cleanup = true;
 	}
@@ -2207,7 +2207,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			path->slots[level] = 0;
 
 			btrfs_tree_read_lock(eb);
-			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+			btrfs_set_lock_blocking_read(eb);
 			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
 
 			ret = btrfs_qgroup_trace_extent(trans, child_bytenr,
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index c3557c12656b..d09b6cdb785a 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -583,7 +583,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 				return -EIO;
 			}
 			btrfs_tree_read_lock(eb);
-			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+			btrfs_set_lock_blocking_read(eb);
 			path->nodes[level-1] = eb;
 			path->slots[level-1] = 0;
 			path->locks[level-1] = BTRFS_READ_LOCK_BLOCKING;
@@ -987,7 +987,7 @@ int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
 		return -ENOMEM;
 
 	eb = btrfs_read_lock_root_node(fs_info->extent_root);
-	btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+	btrfs_set_lock_blocking_read(eb);
 	level = btrfs_header_level(eb);
 	path->nodes[level] = eb;
 	path->slots[level] = 0;
-- 
2.20.1

