Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:44462 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755502AbcLNOFw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 09:05:52 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] btrfs: swap free() and trace point in run_ordered_work()
Date: Wed, 14 Dec 2016 15:05:30 +0100
Message-Id: <20161214140530.6534-2-bigeasy@linutronix.de>
In-Reply-To: <20161214140530.6534-1-bigeasy@linutronix.de>
References: <20161214140530.6534-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The previous patch removed a trace point due to a use after free problem
with tracing enabled. While looking at the backtrace it took me a while
to find the right spot. While doing so I noticed that this trace point
could be used after one of two clean-up functions were invoked:
- run_one_async_free()
- async_cow_free()

Both of them free the `work' item so a later use in the tracepoint is
not possible.
This patch swaps the order so we first have the trace point and then
free the struct.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 fs/btrfs/async-thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index d0dfc3d2e199..6f4631bf74f8 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -288,8 +288,8 @@ static void run_ordered_work(struct __btrfs_workqueue *=
wq)
 		 * we don't want to call the ordered free functions
 		 * with the lock held though
 		 */
-		work->ordered_free(work);
 		trace_btrfs_all_work_done(work);
+		work->ordered_free(work);
 	}
 	spin_unlock_irqrestore(lock, flags);
 }
--=20
2.11.0

