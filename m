Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48963 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754084AbeFTMt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:26 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5ACF8AF55
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 20/34] btrfs: Remove unused fs_info from cleanup_extent_op
Date: Wed, 20 Jun 2018 15:49:02 +0300
Message-Id: <1529498956-4241-21-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The argument is no longer used so remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f13b49497f67..da0c222c013d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2512,7 +2512,6 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
 }
 
 static int cleanup_extent_op(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
 			     struct btrfs_delayed_ref_head *head)
 {
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
@@ -2540,7 +2539,7 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
-	ret = cleanup_extent_op(trans, fs_info, head);
+	ret = cleanup_extent_op(trans, head);
 	if (ret < 0) {
 		unselect_delayed_ref_head(delayed_refs, head);
 		btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
-- 
2.7.4

