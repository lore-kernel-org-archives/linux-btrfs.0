Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbbJKRvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 13:51:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 885F0AC66
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 17:51:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: add barrier for waitqueue_active in clear_btree_io_tree
Date: Sun, 11 Oct 2015 19:50:23 +0200
Message-Id: <b666a9cd993c6a49c4bf23a1ed476359c978f60b.1444579885.git.dsterba@suse.com>
In-Reply-To: <cover.1444579885.git.dsterba@suse.com>
References: <cover.1444579885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waitqueue_active should be preceded by a barrier, in this function we
don't need to call it all the time.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 74bc3338418b..e8e5b5a10719 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -82,6 +82,12 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 static void clear_btree_io_tree(struct extent_io_tree *tree)
 {
 	spin_lock(&tree->lock);
+	/*
+	 * Do a single barrier for the waitqueue_active check here, the state
+	 * of the waitqueue should not change once clear_btree_io_tree is
+	 * called.
+	 */
+	smp_mb();
 	while (!RB_EMPTY_ROOT(&tree->state)) {
 		struct rb_node *node;
 		struct extent_state *state;
-- 
2.1.3

