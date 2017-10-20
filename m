Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbdJTPLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 11:11:08 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mathieu.desnoyers@efficios.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Remove redundant memory barrier
Date: Fri, 20 Oct 2017 18:10:58 +0300
Message-Id: <1508512259-16867-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1508512259-16867-1-git-send-email-nborisov@suse.com>
References: <1508512259-16867-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As per atomic_t.txt documentation :
 - RMW operations that have a return value are fully ordered;

atomic_xchg is one such operation so it already includes everything it needs
w.r.t memory ordering and add a comment ot be more explicit about that.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index c5dd48eb7b3d..0b8ddcbf8462 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -520,7 +520,13 @@ static inline int btrfs_dev_stat_read_and_reset(struct btrfs_device *dev,
 	int ret;
 
 	ret = atomic_xchg(dev->dev_stat_values + index, 0);
-	smp_mb__before_atomic();
+	/*
+	 * atomic_xchg implies a full memory barriers as per atomic_t.txt:
+	 * - RMW operations that have a return value are fully ordered;
+	 *
+	 * This implicit memory barriers is paired with the smp_rmb in
+	 * btrfs_run_dev_stats
+	 */
 	atomic_inc(&dev->dev_stats_ccnt);
 	return ret;
 }
-- 
2.7.4

