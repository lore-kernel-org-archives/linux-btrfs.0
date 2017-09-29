Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34252 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbdI2Tof (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:35 -0400
Received: by mail-qk0-f194.google.com with SMTP id d70so412330qkc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:35 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 19/21] btrfs: don't call btrfs_start_delalloc_roots in flushoncommit
Date: Fri, 29 Sep 2017 15:44:03 -0400
Message-Id: <1506714245-23072-20-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're holding the sb_start_intwrite lock at this point, and doing async
filemap_flush of the inodes will result in a deadlock if we freeze the
fs during this operation.  This is because we could do a
btrfs_join_transaction() in the thread we are waiting on which would
block at sb_start_intwrite, and thus deadlock.  Using
writeback_inodes_sb() side steps the problem by not introducing all of
these extra locking dependencies.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 68c3e1c04bca..9fed8c67b6e8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1917,7 +1917,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
-		return btrfs_start_delalloc_roots(fs_info, 1, -1);
+		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
 	return 0;
 }
 
-- 
2.7.4

