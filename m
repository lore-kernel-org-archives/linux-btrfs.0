Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:12977 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] Btrfs: fix tree mod log rewind of ADD operations
Date: Wed, 27 Jun 2012 19:24:58 +0200
Message-Id: <1340817899-16343-7-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a MOD_LOG_KEY_ADD operation is rewinded, we remove the key from the
tree block. If its not the last key, removal involves a move operation.
This move operation was explicitly done before this commit.

However, at insertion time, there's a move operation before the actual
addition to make room for the new key, which is recorded in the tree mod
log as well. This means, we must drop the move operation when rewinding the
add operation, because the next operation we'll be rewinding will be the
corresponding MOD_LOG_MOVE_KEYS operation.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e005d9b..b98f860 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1094,11 +1094,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 						      tm->generation);
 			break;
 		case MOD_LOG_KEY_ADD:
-			if (tm->slot != n - 1) {
-				o_dst = btrfs_node_key_ptr_offset(tm->slot);
-				o_src = btrfs_node_key_ptr_offset(tm->slot + 1);
-				memmove_extent_buffer(eb, o_dst, o_src, p_size);
-			}
+			/* if a move operation is needed it's in the log */
 			n--;
 			break;
 		case MOD_LOG_MOVE_KEYS:
-- 
1.7.3.4

