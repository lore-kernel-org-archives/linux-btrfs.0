Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:43729 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaE2Vb5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 17:31:57 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so1091025wes.10
        for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 14:31:56 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix transaction leak during fsync call
Date: Thu, 29 May 2014 23:31:39 +0100
Message-Id: <1401402699-27056-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1401392024-5906-1-git-send-email-fdmanana@gmail.com>
References: <1401392024-5906-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_log_dentry_safe() returns an error, we set ret to 1 and
fall through with the goal of committing the transaction. However,
in the case where the inode doesn't need a full sync, we would call
btrfs_wait_ordered_range() against the target range for our inode,
and if it returned an error, we would return without commiting or
ending the transaction.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Leave the call to btrfs_wait_ordered_range(), it's needed if
    the fs is mounted with -o no_flushoncommit.

 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e46bfaf..5a00597 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2025,8 +2025,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		if (!full_sync) {
 			ret = btrfs_wait_ordered_range(inode, start,
 						       end - start + 1);
-			if (ret)
+			if (ret) {
+				btrfs_end_transaction(trans, root);
 				goto out;
+			}
 		}
 		ret = btrfs_commit_transaction(trans, root);
 	} else {
-- 
1.9.1

