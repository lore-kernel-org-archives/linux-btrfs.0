Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34062 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966320AbeF2I5J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:57:09 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3816AD66
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:57:08 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 13/14] btrfs: raid56: don't lock stripe cache table when freeing
Date: Fri, 29 Jun 2018 10:57:07 +0200
Message-Id: <6c508b165cc727f07137f0208ce68ce3ce70c2c9.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is called either at the end of the mount or if the mount fails.
In both cases, there's nothing running that can use the table so the
lock is pointless.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/raid56.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 272acd9b1192..0840b054e4b7 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -407,19 +407,16 @@ static void remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 static void btrfs_clear_rbio_cache(struct btrfs_fs_info *info)
 {
 	struct btrfs_stripe_hash_table *table;
-	unsigned long flags;
 	struct btrfs_raid_bio *rbio;
 
 	table = info->stripe_hash_table;
 
-	spin_lock_irqsave(&table->cache_lock, flags);
 	while (!list_empty(&table->stripe_cache)) {
 		rbio = list_entry(table->stripe_cache.next,
 				  struct btrfs_raid_bio,
 				  stripe_cache);
 		__remove_rbio_from_cache(rbio);
 	}
-	spin_unlock_irqrestore(&table->cache_lock, flags);
 }
 
 /*
-- 
2.17.1

