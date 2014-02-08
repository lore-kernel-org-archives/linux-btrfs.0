Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:52768 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaBHWXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 17:23:07 -0500
Received: from ip-94-112-189-223.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.189.223])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-btrfs@vger.kernel.org>; 8 Feb 2014 23:16:24 +0100
Date: Sat, 8 Feb 2014 23:18:43 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: always choose work from prio_head first
Message-ID: <20140208221843.GA12866@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case we do not refill, we can overwrite cur pointer from prio_head
by one from not prioritized head, what looks as something that was
not intended.

This change make we always take works from prio_head first until it's
not empty.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
I found this by reading code, not sure if change is correct.
Patch is only compile tested.

 fs/btrfs/async-thread.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c1e0b0c..0b78bf2 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -262,18 +262,19 @@ static struct btrfs_work *get_next_work(struct btrfs_worker_thread *worker,
 	struct btrfs_work *work = NULL;
 	struct list_head *cur = NULL;
 
-	if (!list_empty(prio_head))
+	if (!list_empty(prio_head)) {
 		cur = prio_head->next;
+		goto out;
+	}
 
 	smp_mb();
 	if (!list_empty(&worker->prio_pending))
 		goto refill;
 
-	if (!list_empty(head))
+	if (!list_empty(head)) {
 		cur = head->next;
-
-	if (cur)
 		goto out;
+	}
 
 refill:
 	spin_lock_irq(&worker->lock);
-- 
1.7.4.4

