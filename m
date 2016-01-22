Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22572 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbcAVBa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 20:30:57 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 0FDC9418AD49
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 09:30:35 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: async-thread: Fix a use-after-free error for trace
Date: Fri, 22 Jan 2016 09:28:38 +0800
Message-ID: <1453426118-11198-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Parameter of trace_btrfs_work_queued() can be freed in its workqueue.
So no one use use that pointer after queue_work().

Fix the user-after-free bug by move the trace line before queue_work().

Reported-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/async-thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 88d9af3..5fb60ea 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -328,8 +328,8 @@ static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
 		list_add_tail(&work->ordered_list, &wq->ordered_list);
 		spin_unlock_irqrestore(&wq->list_lock, flags);
 	}
-	queue_work(wq->normal_wq, &work->normal_work);
 	trace_btrfs_work_queued(work);
+	queue_work(wq->normal_wq, &work->normal_work);
 }
 
 void btrfs_queue_work(struct btrfs_workqueue *wq,
-- 
2.7.0



