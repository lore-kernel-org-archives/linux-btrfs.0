Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:44459 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755449AbcLNOFw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 09:05:52 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] btrfs: drop trace_btrfs_all_work_done() from normal_work_helper()
Date: Wed, 14 Dec 2016 15:05:29 +0100
Message-Id: <20161214140530.6534-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_scrubparity_helper() the ->func() is set to
scrub_parity_bio_endio_worker(). This functions invokes
scrub_free_parity() which kfrees() the `work' object. All is good as
long as trace events are not enabled because we boom with a backtrace
like this:
| Workqueue: btrfs-endio btrfs_endio_helper
| RIP: 0010:[<ffffffff812f81ae>]  [<ffffffff812f81ae>] trace_event_raw_even=
t_btrfs__work__done+0x4e/0xa0
| Call Trace:
|  [<ffffffff8136497d>] btrfs_scrubparity_helper+0x59d/0x780
|  [<ffffffff81364c49>] btrfs_endio_helper+0x9/0x10
|  [<ffffffff8108af8e>] process_one_work+0x26e/0x7b0
|  [<ffffffff8108b516>] worker_thread+0x46/0x560
|  [<ffffffff81091c4e>] kthread+0xee/0x110
|  [<ffffffff818e166a>] ret_from_fork+0x2a/0x40

So in order to avoid this, I remove the trace point.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 fs/btrfs/async-thread.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index e0f071f6b5a7..d0dfc3d2e199 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -318,8 +318,6 @@ static void normal_work_helper(struct btrfs_work *work)
 		set_bit(WORK_DONE_BIT, &work->flags);
 		run_ordered_work(wq);
 	}
-	if (!need_order)
-		trace_btrfs_all_work_done(work);
 }
=20
 void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t uniq_func,
--=20
2.11.0

