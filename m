Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeIGTgn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:43 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 165DAAC1F
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 04/11] btrfs: open code btrfs_after_dev_replace_commit
Date: Fri,  7 Sep 2018 16:55:09 +0200
Message-Id: <925e3bc53e863ab05898a0c2aa05ee2226bb8ed4.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Too trivial, the purpose can be simply documented in a comment.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 8 --------
 fs/btrfs/dev-replace.h | 1 -
 fs/btrfs/transaction.c | 5 ++++-
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 004e8d380a11..8b512dddf727 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -382,14 +382,6 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
-
-	dev_replace->committed_cursor_left =
-		dev_replace->cursor_left_last_write_of_item;
-}
-
 static char* btrfs_dev_name(struct btrfs_device *device)
 {
 	if (!device || test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 1c91bf9ef39a..795c551f5b5e 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -11,7 +11,6 @@ struct btrfs_ioctl_dev_replace_args;
 int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info);
-void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 			    struct btrfs_ioctl_dev_replace_args *args);
 int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e7856e15adbf..c0c75b5ae12a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1197,7 +1197,10 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 
 	list_add_tail(&fs_info->extent_root->dirty_list,
 		      &trans->transaction->switch_commits);
-	btrfs_after_dev_replace_commit(fs_info);
+
+	/* Update dev-replace pointer once everything is committed */
+	fs_info->dev_replace.committed_cursor_left =
+		fs_info->dev_replace.cursor_left_last_write_of_item;
 
 	return 0;
 }
-- 
2.18.0
