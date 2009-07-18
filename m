From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 5/6] fs/btrfs: convert nested spin_lock_irqsave to spin_lock
Date: Sat, 18 Jul 2009 17:25:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907181725320.26792@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

If spin_lock_irqsave is called twice in a row with the same second
argument, the interrupt state at the point of the second call overwrites
the value saved by the first call.  Indeed, the second call does not need
to save the interrupt state, so it is changed to a simple spin_lock.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/async-thread.c             |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 6e4f6c5..019e8af 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -424,11 +424,11 @@ int btrfs_requeue_work(struct btrfs_work *work)
 	 * list
 	 */
 	if (worker->idle) {
-		spin_lock_irqsave(&worker->workers->lock, flags);
+		spin_lock(&worker->workers->lock);
 		worker->idle = 0;
 		list_move_tail(&worker->worker_list,
 			       &worker->workers->worker_list);
-		spin_unlock_irqrestore(&worker->workers->lock, flags);
+		spin_unlock(&worker->workers->lock);
 	}
 	if (!worker->working) {
 		wake = 1;
