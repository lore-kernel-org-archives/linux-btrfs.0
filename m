Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:54923 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdI2ToT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:19 -0400
Received: by mail-qt0-f181.google.com with SMTP id i13so903198qtc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 07/21] Btrfs: only check delayed ref usage in should_end_transaction
Date: Fri, 29 Sep 2017 15:43:51 -0400
Message-Id: <1506714245-23072-8-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were only doing btrfs_check_space_for_delayed_refs() if the metadata
space was full, ie we couldn't allocate chunks.  This assumes we'll be
able to allocate chunks during transaction commit, but since nothing
does a LIMIT flush during the transaction commit this won't actually
happen unless we happen to run shy of actual space.  We already take
into account a full fs in btrfs_check_space_for_delayed_refs() so just
kill this extra check to make sure we're ending the transaction when we
need to.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/transaction.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9c5f126064bd..68c3e1c04bca 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -797,8 +797,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
-	if (fs_info->global_block_rsv.space_info->full &&
-	    btrfs_check_space_for_delayed_refs(trans, fs_info))
+	if (btrfs_check_space_for_delayed_refs(trans, fs_info))
 		return 1;
 
 	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
-- 
2.7.4

