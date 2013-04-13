Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:34334 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3DMNUN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 09:20:13 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix unlock after free on rewinded tree blocks
Date: Sat, 13 Apr 2013 15:19:55 +0200
Message-Id: <1365859195-8620-4-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When tree_mod_log_rewind decides to make a copy of the current tree buffer
for its modifications, it subsequently freed the buffer before unlocking it.
Obviously, those operations are required in reverse order.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0260795..0b40336 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1190,6 +1190,13 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 	btrfs_set_header_nritems(eb, n);
 }
 
+/*
+ * Called with eb read locked. If the buffer cannot be rewinded, the same buffer
+ * is returned. If rewind operations happen, a fresh buffer is returned. The
+ * returned buffer is always read-locked. If the returned buffer is not the
+ * input buffer, the lock on the input buffer is released and the input buffer
+ * is freed (its refcount is decremented).
+ */
 static struct extent_buffer *
 tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		    u64 time_seq)
@@ -1223,8 +1230,11 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 	}
 
 	extent_buffer_get(eb_rewin);
+	btrfs_tree_read_unlock(eb);
 	free_extent_buffer(eb);
 
+	extent_buffer_get(eb_rewin);
+	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
 		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
@@ -2796,15 +2806,9 @@ again:
 				btrfs_clear_path_blocking(p, b,
 							  BTRFS_READ_LOCK);
 			}
+			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
 			p->locks[level] = BTRFS_READ_LOCK;
 			p->nodes[level] = b;
-			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
-			if (b != p->nodes[level]) {
-				btrfs_tree_unlock_rw(p->nodes[level],
-						     p->locks[level]);
-				p->locks[level] = 0;
-				p->nodes[level] = b;
-			}
 		} else {
 			p->slots[level] = slot;
 			unlock_up(p, level, lowest_unlock, 0, NULL);
-- 
1.7.1

