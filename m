Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58575 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750961AbdFORLJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 13:11:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4A9F7AC41
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 17:11:08 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: move fs_info::fs_frozen to the flags
Date: Thu, 15 Jun 2017 19:10:03 +0200
Message-Id: <20170615171003.28004-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can keep the state among the other fs_info flags, there's no reason
why fs_frozen would need to be separate.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       | 5 ++---
 fs/btrfs/disk-io.c     | 1 -
 fs/btrfs/super.c       | 6 ++++--
 fs/btrfs/transaction.c | 3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f0f5f28784b6..6375e57a5a69 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -716,6 +716,8 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_LOG1_ERR			12
 #define BTRFS_FS_LOG2_ERR			13
 #define BTRFS_FS_QUOTA_OVERRIDE			14
+/* Used to record internally whether fs has been frozen */
+#define BTRFS_FS_FROZEN				15
 
 /*
  * Indicate that a whole-filesystem exclusive operation is running
@@ -1107,9 +1109,6 @@ struct btrfs_fs_info {
 	 */
 	struct list_head pinned_chunks;
 
-	/* Used to record internally whether fs has been frozen */
-	int fs_frozen;
-
 	/* Cached block sizes */
 	u32 nodesize;
 	u32 sectorsize;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b00ebff13f8..2ac0a35f4450 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2661,7 +2661,6 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
-	fs_info->fs_frozen = 0;
 	fs_info->sb = sb;
 	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
 	fs_info->metadata_ratio = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3371213924bd..1138301f0cab 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2242,7 +2242,7 @@ static int btrfs_freeze(struct super_block *sb)
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root = fs_info->tree_root;
 
-	fs_info->fs_frozen = 1;
+	set_bit(BTRFS_FS_FROZEN, &fs_info->flags);
 	/*
 	 * We don't need a barrier here, we'll wait for any transaction that
 	 * could be in progress on other threads (and do delayed iputs that
@@ -2261,7 +2261,9 @@ static int btrfs_freeze(struct super_block *sb)
 
 static int btrfs_unfreeze(struct super_block *sb)
 {
-	btrfs_sb(sb)->fs_frozen = 0;
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+
+	clear_bit(BTRFS_FS_FROZEN, &fs_info->flags);
 	return 0;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ab030fb22530..97e33513b195 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2314,7 +2314,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * it'll result in deadlock about SB_FREEZE_FS.
 	 */
 	if (current != fs_info->transaction_kthread &&
-	    current != fs_info->cleaner_kthread && !fs_info->fs_frozen)
+	    current != fs_info->cleaner_kthread &&
+	    !test_bit(BTRFS_FS_FROZEN, &fs_info->flags))
 		btrfs_run_delayed_iputs(fs_info);
 
 	return ret;
-- 
2.13.0

