From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH] btrfs: set task state with schedule_timeout_uninterruptible()
Date: Mon, 26 Jul 2010 12:27:43 +0400
Message-ID: <1280132864-8266-1-git-send-email-segooon@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

worker_loop() uses schedule_timeout() without setting state to
STATE_(UN)INTERRUPTIBLE. As it is called in cycle without checking of
pending signals, use schedule_timeout_uninterruptible().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/btrfs/async-thread.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 7ec1409..54eb070 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -362,7 +362,7 @@ again:
 				 * worker->working is still 1, so nobody
 				 * is going to try and wake us up
 				 */
-				schedule_timeout(1);
+				schedule_timeout_uninterruptible(1);
 				smp_mb();
 				if (!list_empty(&worker->pending) ||
 				    !list_empty(&worker->prio_pending))
-- 
1.7.0.4
