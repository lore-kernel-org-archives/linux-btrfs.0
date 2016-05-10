Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:33691 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbcEJAOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 20:14:06 -0400
Received: by mail-qg0-f68.google.com with SMTP id 90so12492400qgz.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 17:14:05 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH] Trivial fix for typos in comments.
Date: Mon,  9 May 2016 20:13:30 -0400
Message-Id: <1462839210-10040-2-git-send-email-nsteeves@gmail.com>
In-Reply-To: <1462839210-10040-1-git-send-email-nsteeves@gmail.com>
References: <1462839210-10040-1-git-send-email-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 fs/btrfs/disk-io.c     | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/file.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 50bed6c..c66c752 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -816,7 +816,7 @@ static void run_one_async_done(struct btrfs_work *work)
 	    waitqueue_active(&fs_info->async_submit_wait))
 		wake_up(&fs_info->async_submit_wait);
 
-	/* If an error occured we just want to clean up the bio and move on */
+	/* If an error occurred we just want to clean up the bio and move on */
 	if (async->error) {
 		async->bio->bi_error = async->error;
 		bio_endio(async->bio);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..7ed61e9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5752,7 +5752,7 @@ out_fail:
 
 		/*
 		 * This is tricky, but first we need to figure out how much we
-		 * free'd from any free-ers that occured during this
+		 * free'd from any free-ers that occurred during this
 		 * reservation, so we reset ->csum_bytes to the csum_bytes
 		 * before we dropped our lock, and then call the free for the
 		 * number of bytes that were freed while we were trying our
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index af782fd..c2c378d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1825,7 +1825,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	/*
 	 * We also have to set last_sub_trans to the current log transid,
 	 * otherwise subsequent syncs to a file that's been synced in this
-	 * transaction will appear to have already occured.
+	 * transaction will appear to have already occurred.
 	 */
 	spin_lock(&BTRFS_I(inode)->lock);
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
-- 
2.1.4

