Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966316AbeF2I5H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:57:07 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E277AD67
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:57:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/14] btrfs: raid56: merge rbio_is_full helpers
Date: Fri, 29 Jun 2018 10:57:05 +0200
Message-Id: <23f86f58e6ac35db671c90cb2e4cb9e95c0b8ac1.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's only one call site of the unlocked helper so it can be folded
into the caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 339cce0878d1..272acd9b1192 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -507,32 +507,21 @@ static void run_xor(void **pages, int src_cnt, ssize_t len)
 }
 
 /*
- * returns true if the bio list inside this rbio
- * covers an entire stripe (no rmw required).
- * Must be called with the bio list lock held, or
- * at a time when you know it is impossible to add
- * new bios into the list
+ * Returns true if the bio list inside this rbio covers an entire stripe (no
+ * rmw required).
  */
-static int __rbio_is_full(struct btrfs_raid_bio *rbio)
+static int rbio_is_full(struct btrfs_raid_bio *rbio)
 {
+	unsigned long flags;
 	unsigned long size = rbio->bio_list_bytes;
 	int ret = 1;
 
+	spin_lock_irqsave(&rbio->bio_list_lock, flags);
 	if (size != rbio->nr_data * rbio->stripe_len)
 		ret = 0;
-
 	BUG_ON(size > rbio->nr_data * rbio->stripe_len);
-	return ret;
-}
-
-static int rbio_is_full(struct btrfs_raid_bio *rbio)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&rbio->bio_list_lock, flags);
-	ret = __rbio_is_full(rbio);
 	spin_unlock_irqrestore(&rbio->bio_list_lock, flags);
+
 	return ret;
 }
 
-- 
2.17.1

