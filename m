From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 10/12 v5] Btrfs: kick off useless code
Date: Sat, 6 Aug 2011 17:37:45 +0800
Message-ID: <1312623467-31487-11-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

fsync will wait for writeback till it finishes, and last_trans will get the real
transid recorded in writeback, so it does not need an extra +1 to ensure fsync's
process on the file.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/file.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7a84219..d6df2bc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1404,19 +1404,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 
 	mutex_unlock(&inode->i_mutex);
 
-	/*
-	 * we want to make sure fsync finds this change
-	 * but we haven't joined a transaction running right now.
-	 *
-	 * Later on, someone is sure to update the inode and get the
-	 * real transid recorded.
-	 *
-	 * We set last_trans now to the fs_info generation + 1,
-	 * this will either be one more than the running transaction
-	 * or the generation used for the next transaction if there isn't
-	 * one running right now.
-	 */
-	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
 	if (num_written > 0 || num_written == -EIOCBQUEUED) {
 		err = generic_write_sync(file, pos, num_written);
 		if (err < 0 && num_written > 0)
-- 
1.6.5.2

