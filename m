Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56377 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754389AbeBGP4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AFF64ADCE
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/14] btrfs: Remove fs_info argument from btrfs_trans_release_metadata
Date: Wed,  7 Feb 2018 17:55:39 +0200
Message-Id: <1518018950-31456-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All current callers of this function just get a reference to the
trans->fs_info member and pass it as the second argument. Collapse this
into the function itself. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5ca4302c136c..3c3ed6e3d484 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -818,9 +818,11 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 	return should_end_transaction(trans);
 }
 
-static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info)
+static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
+
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+
 	if (!trans->block_rsv) {
 		ASSERT(!trans->bytes_reserved);
 		return;
@@ -854,7 +856,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	btrfs_trans_release_metadata(trans, info);
+	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
 	if (!list_empty(&trans->new_bgs))
@@ -875,7 +877,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			must_run_delayed_refs = 2;
 	}
 
-	btrfs_trans_release_metadata(trans, info);
+	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
 	if (!list_empty(&trans->new_bgs))
@@ -1968,7 +1970,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		return ret;
 	}
 
-	btrfs_trans_release_metadata(trans, fs_info);
+	btrfs_trans_release_metadata(trans);
 	trans->block_rsv = NULL;
 
 	cur_trans = trans->transaction;
@@ -2322,7 +2324,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 scrub_continue:
 	btrfs_scrub_continue(fs_info);
 cleanup_transaction:
-	btrfs_trans_release_metadata(trans, fs_info);
+	btrfs_trans_release_metadata(trans);
 	btrfs_trans_release_chunk_metadata(trans);
 	trans->block_rsv = NULL;
 	btrfs_warn(fs_info, "Skipping commit of aborted transaction.");
-- 
2.7.4

