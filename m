Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38630 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731999AbeGSPeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:34:02 -0400
Received: by mail-qt0-f194.google.com with SMTP id y19-v6so7408468qto.5
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:31 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 17/22] btrfs: don't take the dio_sem in the fsync path
Date: Thu, 19 Jul 2018 10:50:01 -0400
Message-Id: <20180719145006.17532-17-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we've changed the fsync() path to always run ordered extents
before doing the tree log we no longer need to take the dio_sem in the
tree log path.  This gets rid of a lockdep splat that I was seeing with
the AIO tests.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/tree-log.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f8220ec02036..aa06e1954b84 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4439,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&extents);
 
-	down_write(&inode->dio_sem);
 	write_lock(&tree->lock);
 	test_gen = root->fs_info->last_trans_committed;
 	logged_start = start;
@@ -4520,7 +4519,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
-	up_write(&inode->dio_sem);
 
 	btrfs_release_path(path);
 	if (!ret)
-- 
2.14.3

