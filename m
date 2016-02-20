Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36979 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbcBTRj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 12:39:59 -0500
From: Simon Quigley <tsimonq2@ubuntu.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Quigley <tsimonq2@ubuntu.com>
Subject: [PATCH] btrfs: async-thread: Fixed a brace coding style issue
Date: Sat, 20 Feb 2016 11:39:45 -0600
Message-Id: <1455989985-7521-1-git-send-email-tsimonq2@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Braces aren't needed if it's only a single-line statement.
checkpatch.pl confirmed this.
This is now fixed.

Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
---
 fs/btrfs/async-thread.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 5fb60ea..7914dd2 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -227,9 +227,9 @@ static inline void thresh_exec_hook(struct __btrfs_workqueue *wq)
 out:
 	spin_unlock(&wq->thres_lock);
 
-	if (need_change) {
+	if (need_change)
 		workqueue_set_max_active(wq->normal_wq, wq->current_active);
-	}
+
 }
 
 static void run_ordered_work(struct __btrfs_workqueue *wq)
-- 
2.7.0

