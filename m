Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:45606 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaCKOca (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 10:32:30 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so10132826wes.29
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 07:32:29 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: add missing kfree in btrfs_destroy_workqueue
Date: Tue, 11 Mar 2014 14:31:44 +0000
Message-Id: <1394548304-8741-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/async-thread.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 00623dd..66532b8 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -315,6 +315,7 @@ void btrfs_destroy_workqueue(struct btrfs_workqueue *wq)
 	if (wq->high)
 		__btrfs_destroy_workqueue(wq->high);
 	__btrfs_destroy_workqueue(wq->normal);
+	kfree(wq);
 }
 
 void btrfs_workqueue_set_max(struct btrfs_workqueue *wq, int max)
-- 
1.7.9.5

