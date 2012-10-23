Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:60788 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab2JWNz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 09:55:29 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: [PATCH 5/6] Btrfs: fix extent buffer reference for tree mod log roots
Date: Tue, 23 Oct 2012 15:55:26 +0200
Message-Id: <1351000527-24952-6-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In get_old_root we grab a lock on the extent buffer before we obtain a
reference on that buffer. That order is changed now.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7093ff5..bed06e8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1274,6 +1274,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	free_extent_buffer(root->node);
 	if (!eb)
 		return NULL;
+	extent_buffer_get(eb);
 	btrfs_tree_read_lock(eb);
 	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
@@ -1286,7 +1287,6 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		__tree_mod_log_rewind(eb, time_seq, tm);
 	else
 		WARN_ON(btrfs_header_level(eb) != 0);
-	extent_buffer_get(eb);
 	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));
 
 	return eb;
-- 
1.7.1

