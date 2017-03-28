Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38159 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753066AbdC1Mgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 08:36:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2235FAE17
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 12:35:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: sink GFP flags parameter to tree_mod_log_insert_move
Date: Tue, 28 Mar 2017 14:35:01 +0200
Message-Id: <20170328123501.22004-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All (1) callers pass the same value.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7dc8844037e0..d034d47c5470 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -567,7 +567,7 @@ tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
 static noinline int
 tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *eb, int dst_slot, int src_slot,
-			 int nr_items, gfp_t flags)
+			 int nr_items)
 {
 	struct tree_mod_elem *tm = NULL;
 	struct tree_mod_elem **tm_list = NULL;
@@ -578,11 +578,11 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	if (!tree_mod_need_log(fs_info, eb))
 		return 0;
 
-	tm_list = kcalloc(nr_items, sizeof(struct tree_mod_elem *), flags);
+	tm_list = kcalloc(nr_items, sizeof(struct tree_mod_elem *), GFP_NOFS);
 	if (!tm_list)
 		return -ENOMEM;
 
-	tm = kzalloc(sizeof(*tm), flags);
+	tm = kzalloc(sizeof(*tm), GFP_NOFS);
 	if (!tm) {
 		ret = -ENOMEM;
 		goto free_tms;
@@ -596,7 +596,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 
 	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
 		tm_list[i] = alloc_tree_mod_elem(eb, i + dst_slot,
-		    MOD_LOG_KEY_REMOVE_WHILE_MOVING, flags);
+		    MOD_LOG_KEY_REMOVE_WHILE_MOVING, GFP_NOFS);
 		if (!tm_list[i]) {
 			ret = -ENOMEM;
 			goto free_tms;
@@ -873,7 +873,7 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 {
 	int ret;
 	ret = tree_mod_log_insert_move(fs_info, dst, dst_offset, src_offset,
-				       nr_items, GFP_NOFS);
+				       nr_items);
 	BUG_ON(ret < 0);
 }
 
-- 
2.12.0

