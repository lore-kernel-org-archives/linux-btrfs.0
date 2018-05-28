Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49767 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939776AbeE1QNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:50 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 59AFFACA7
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:48 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/11] btrfs-progs: check: Make update_pinned_extents take btrfs_fs_info
Date: Mon, 28 May 2018 09:36:44 +0300
Message-Id: <1527489410-3564-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function needs btrfs_fs_info and not a root. So make it directly
take btrfs_fs_info,

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 89fed5b73b1f..8e7f888b5ce5 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1979,12 +1979,11 @@ static int update_block_group(struct btrfs_root *root,
 	return 0;
 }
 
-static int update_pinned_extents(struct btrfs_root *root,
+static int update_pinned_extents(struct btrfs_fs_info *fs_info,
 				u64 bytenr, u64 num, int pin)
 {
 	u64 len;
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (pin) {
 		set_extent_dirty(&fs_info->pinned_extents,
@@ -2033,7 +2032,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 					    EXTENT_DIRTY);
 		if (ret)
 			break;
-		update_pinned_extents(root, start, end + 1 - start, 0);
+		update_pinned_extents(trans->fs_info, start, end + 1 - start,
+				      0);
 		clear_extent_dirty(unpin, start, end);
 		set_extent_dirty(free_space_cache, start, end);
 	}
@@ -2136,7 +2136,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	}
 	free_extent_buffer(buf);
 pinit:
-	update_pinned_extents(root, bytenr, num_bytes, 1);
+	update_pinned_extents(trans->fs_info, bytenr, num_bytes, 1);
 
 	BUG_ON(err < 0);
 	return 0;
@@ -2145,13 +2145,13 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info,
 		       u64 bytenr, u64 num_bytes)
 {
-	update_pinned_extents(fs_info->extent_root, bytenr, num_bytes, 1);
+	update_pinned_extents(fs_info, bytenr, num_bytes, 1);
 }
 
 void btrfs_unpin_extent(struct btrfs_fs_info *fs_info,
 			u64 bytenr, u64 num_bytes)
 {
-	update_pinned_extents(fs_info->extent_root, bytenr, num_bytes, 0);
+	update_pinned_extents(fs_info, bytenr, num_bytes, 0);
 }
 
 /*
-- 
2.7.4

