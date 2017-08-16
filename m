Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34203 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751949AbdHPPPe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 11:15:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B666CACFF
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 15:15:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: expose internal free space tree routine only if sanity tests are enabled
Date: Wed, 16 Aug 2017 18:15:23 +0300
Message-Id: <1502896523-2431-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The internal free space tree management routines are always exposed for testing
purposes. Make them dependent on SANITY_TESTS being on so that they are exposed
only when they really have to.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 54ffced3bce8..ba3787df43c3 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -44,7 +44,7 @@ int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info,
 				u64 start, u64 size);
 
-/* Exposed for testing. */
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct btrfs_free_space_info *
 search_free_space_info(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
@@ -68,5 +68,6 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 				  struct btrfs_path *path);
 int free_space_test_bit(struct btrfs_block_group_cache *block_group,
 			struct btrfs_path *path, u64 offset);
+#endif
 
 #endif
-- 
2.7.4

