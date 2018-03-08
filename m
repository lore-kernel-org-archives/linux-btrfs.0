Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755323AbeCHOf5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:57 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 242C7AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 13/22] btrfs: drop fs_info parameter from __tree_mod_log_oldest_root
Date: Thu,  8 Mar 2018 15:33:36 +0100
Message-Id: <2aa1d1598b9b99d5c4104c7e1aa56d5093e39054.1520518876.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e53af58697db..716c140798c3 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1195,9 +1195,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
  * returns the logical address of the oldest predecessor of the given root.
  * entries older than time_seq are ignored.
  */
-static struct tree_mod_elem *
-__tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *eb_root, u64 time_seq)
+static struct tree_mod_elem *__tree_mod_log_oldest_root(
+		struct extent_buffer *eb_root, u64 time_seq)
 {
 	struct tree_mod_elem *tm;
 	struct tree_mod_elem *found = NULL;
@@ -1214,7 +1213,7 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
 	 * first operation that's logged for this root.
 	 */
 	while (1) {
-		tm = tree_mod_log_search_oldest(fs_info, root_logical,
+		tm = tree_mod_log_search_oldest(eb_root->fs_info, root_logical,
 						time_seq);
 		if (!looped && !tm)
 			return NULL;
@@ -1404,7 +1403,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	u64 logical;
 
 	eb_root = btrfs_read_lock_root_node(root);
-	tm = __tree_mod_log_oldest_root(fs_info, eb_root, time_seq);
+	tm = __tree_mod_log_oldest_root(eb_root, time_seq);
 	if (!tm)
 		return eb_root;
 
@@ -1468,7 +1467,7 @@ int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq)
 	int level;
 	struct extent_buffer *eb_root = btrfs_root_node(root);
 
-	tm = __tree_mod_log_oldest_root(root->fs_info, eb_root, time_seq);
+	tm = __tree_mod_log_oldest_root(eb_root, time_seq);
 	if (tm && tm->op == MOD_LOG_ROOT_REPLACE) {
 		level = tm->old_root.level;
 	} else {
-- 
2.16.2

