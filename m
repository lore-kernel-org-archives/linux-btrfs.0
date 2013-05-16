Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:44815 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab3EPOsU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:48:20 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp1) (RZmta 31.27 OK)
	with ESMTP id X07dfap4G8bU57 for <linux-btrfs@vger.kernel.org>;
	Thu, 16 May 2013 16:48:19 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: explicitly use global_block_rsv for quota_tree
Date: Thu, 16 May 2013 16:48:19 +0200
Message-Id: <1368715699-17628-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The quota_tree was set up to use the empty_block_rsv before
which would be problematic when the filesystem is filled up
and ENOSPC happens during internal operations while the quota
tree is updated and COWed (when the btrfs_qgroup_info_item
items) are written. In fact, use_block_rsv() which is used
in btrfs_cow_block() falls back to the global_block_rsv in
this case. But just in order to make it more clear what is
happening, change it to explicitly use the global_block_rsv.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d50635d..af1cdfc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4565,6 +4565,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
+	if (fs_info->quota_root)
+		fs_info->quota_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
 
 	update_global_block_rsv(fs_info);
-- 
1.8.2.3

