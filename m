Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:45594 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753988AbdJSSQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:16:17 -0400
Received: by mail-qt0-f169.google.com with SMTP id p1so15577202qtg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 11:16:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] btrfs: don't call btrfs_start_delalloc_roots in flushoncommit
Date: Thu, 19 Oct 2017 14:16:01 -0400
Message-Id: <1508436962-6851-8-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
References: <1508436962-6851-1-git-send-email-josef@toxicpanda.com>
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
 fs/btrfs/transaction.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 68c3e1c04bca..5a8c2649af2f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1916,8 +1916,17 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
+	/*
+	 * We use writeback_inodes_sb here because if we used
+	 * btrfs_start_delalloc_roots we would deadlock with fs freeze.
+	 * Currently are holding the fs freeze lock, if we do an async flush
+	 * we'll do btrfs_join_transaction() and deadlock because we need to
+	 * wait for the fs freeze lock.  Using the direct flushing we benefit
+	 * from already being in a transaction and our join_transaction doesn't
+	 * have to re-take the fs freeze lock.
+	 */
 	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
-		return btrfs_start_delalloc_roots(fs_info, 1, -1);
+		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
 	return 0;
 }
 
-- 
2.7.5

