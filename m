Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56813 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754780AbeCHOfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:55 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE736AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/22] btrfs: embed tree_mod_move structure to tree_mod_elem
Date: Thu,  8 Mar 2018 15:33:33 +0100
Message-Id: <355a7a0e67e45fe8120a70f4a6b452417e05dd08.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree_mod_move is not used anywhere and can be embedded as anonymous
structure.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5585433eac40..e53af58697db 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -299,11 +299,6 @@ enum mod_log_op {
 	MOD_LOG_ROOT_REPLACE,
 };
 
-struct tree_mod_move {
-	int dst_slot;
-	int nr_items;
-};
-
 struct tree_mod_root {
 	u64 logical;
 	u8 level;
@@ -326,7 +321,10 @@ struct tree_mod_elem {
 	u64 blockptr;
 
 	/* this is used for op == MOD_LOG_MOVE_KEYS */
-	struct tree_mod_move move;
+	struct {
+		int dst_slot;
+		int nr_items;
+	} move;
 
 	/* this is used for op == MOD_LOG_ROOT_REPLACE */
 	struct tree_mod_root old_root;
-- 
2.16.2

