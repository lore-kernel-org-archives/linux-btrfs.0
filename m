Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51491 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab2JSJvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 05:51:54 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH 1/4] Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's nritems
Date: Fri, 19 Oct 2012 17:50:52 +0800
Message-Id: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Key MOD_LOG_KEY_REMOVE_WHILE_MOVING means that we're doing memmove inside
an extent buffer node, and the node's number of items remains unchanged
(unless we are inserting a single pointer, but we have MOD_LOG_KEY_ADD for that).

So we don't need to increase node's number of items during rewinding,
otherwise we may get an node larger than leafsize and cause general protection
errors later.

Here is the details,
- If we do memory move for inserting a single pointer, we need to
  add node's nritems by one, and we honor MOD_LOG_KEY_ADD for adding.

- If we do memory move for deleting a single pointer, we need to
  decrease node's nritems by one, and we honor MOD_LOG_KEY_REMOVE for
  deleting.

- If we do memory move for balance left/right, we need to decrease
  node's nritems, and we honor MOD_LOG_KEY_REMOVE for balaning.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b334362..2858c2f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1142,13 +1142,13 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		switch (tm->op) {
 		case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
 			BUG_ON(tm->slot < n);
-		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
 		case MOD_LOG_KEY_REMOVE:
+			n++;
+		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
 			btrfs_set_node_key(eb, &tm->key, tm->slot);
 			btrfs_set_node_blockptr(eb, tm->slot, tm->blockptr);
 			btrfs_set_node_ptr_generation(eb, tm->slot,
 						      tm->generation);
-			n++;
 			break;
 		case MOD_LOG_KEY_REPLACE:
 			BUG_ON(tm->slot >= n);
-- 
1.7.7.6

