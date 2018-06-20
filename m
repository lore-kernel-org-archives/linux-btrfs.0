Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754027AbeFTMtZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:25 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 141C3AEC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 19/34] btrfs: Remove fs_info from run_delayed_extent_op
Date: Wed, 20 Jun 2018 15:49:01 +0300
Message-Id: <1529498956-4241-20-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always called with a valid transaction handle so
fs_info can be referenced from there. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index edc1c98c3556..f13b49497f67 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2318,10 +2318,10 @@ static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 }
 
 static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
-				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_delayed_ref_head *head,
 				 struct btrfs_delayed_extent_op *extent_op)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_key key;
 	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
@@ -2526,7 +2526,7 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 	spin_unlock(&head->lock);
-	ret = run_delayed_extent_op(trans, fs_info, head, extent_op);
+	ret = run_delayed_extent_op(trans, head, extent_op);
 	btrfs_free_delayed_extent_op(extent_op);
 	return ret ? ret : 1;
 }
-- 
2.7.4

