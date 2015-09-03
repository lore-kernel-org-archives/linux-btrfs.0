Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35484 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbbICAvw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 20:51:52 -0400
Received: by pacfv12 with SMTP id fv12so28295771pac.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2015 17:51:52 -0700 (PDT)
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Subject: [PATCH] btrfs: qgroup: exit the rescan worker during umount
Date: Wed,  2 Sep 2015 17:51:45 -0700
Message-Id: <1441241505-16266-1-git-send-email-jmaggard@netgear.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was hitting a consistent NULL pointer dereference during shutdown that
showed the trace running through end_workqueue_bio().  I traced it back to
the endio_meta_workers workqueue being poked after it had already been
destroyed.

Eventually I found that the root cause was a qgroup rescan that was still
in progress while we were stopping all the btrfs workers.

Currently we explicitly pause balance and scrub operations in
close_ctree(), but we do nothing to stop the qgroup rescan.  We should
probably be doing the same for qgroup rescan, but that's a much larger
change.  This small change is good enough to allow me to unmount without
crashing.

Signed-off-by: Justin Maggard <jmaggard@netgear.com>
---
 fs/btrfs/qgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d904ee1..5bfcee9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2278,7 +2278,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		goto out;
 
 	err = 0;
-	while (!err) {
+	while (!err && !btrfs_fs_closing(fs_info)) {
 		trans = btrfs_start_transaction(fs_info->fs_root, 0);
 		if (IS_ERR(trans)) {
 			err = PTR_ERR(trans);
@@ -2301,7 +2301,8 @@ out:
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-	fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
+	if (!btrfs_fs_closing(fs_info)) {
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
@@ -2330,7 +2331,9 @@ out:
 	}
 	btrfs_end_transaction(trans, fs_info->quota_root);
 
-	if (err >= 0) {
+	if (btrfs_fs_closing(fs_info)) {
+		btrfs_info(fs_info, "qgroup scan paused");
+	} else if (err >= 0) {
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			err > 0 ? " (inconsistency flag cleared)" : "");
 	} else {
-- 
2.5.1

