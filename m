Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754136AbeFTMt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:29 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A57FBADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 31/34] btrfs: Remove fs_info from btrfs_alloc_logged_file_extent
Date: Wed, 20 Jun 2018 15:49:13 +0300
Message-Id: <1529498956-4241-32-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from trans since the function is always called
within a valid transaction

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 1 -
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/tree-log.c    | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6498abf8ba36..eba0b1530843 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2676,7 +2676,6 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     u64 offset, u64 ram_bytes,
 				     struct btrfs_key *ins);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   u64 root_objectid, u64 owner, u64 offset,
 				   struct btrfs_key *ins);
 int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47b80297dbc2..06823f69637b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8229,10 +8229,10 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
  * space cache bits as well
  */
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   u64 root_objectid, u64 owner, u64 offset,
 				   struct btrfs_key *ins)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret;
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_space_info *space_info;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f8220ec02036..ecdf45465798 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -715,7 +715,6 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				 * allocation tree
 				 */
 				ret = btrfs_alloc_logged_file_extent(trans,
-						fs_info,
 						root->root_key.objectid,
 						key->objectid, offset, &ins);
 				if (ret)
-- 
2.7.4

