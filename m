Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40035 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752859AbdCOQD4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:03:56 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51B6FAC22
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 16:03:00 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: preallocate radix tree node for readahead
Date: Wed, 15 Mar 2017 17:02:23 +0100
Message-Id: <81148cc21c03374082730036fe9c35f3072bd173.1489593696.git.dsterba@suse.com>
In-Reply-To: <cover.1489593696.git.dsterba@suse.com>
References: <cover.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can preallocate the node so insertion does not have to do that under
the lock. The GFP flags for the per-device radix tree are initialized to
 GFP_NOFS & ~__GFP_DIRECT_RECLAIM
but we can use GFP_KERNEL, same as an allocation above anyway, but also
because readahead is optional and not on any critical writeout path.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c   | 7 +++++++
 fs/btrfs/volumes.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index e88bca87f5d2..fdae8ca79401 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -270,6 +270,12 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 	if (!zone)
 		return NULL;
 
+	ret = radix_tree_preload(GFP_KERNEL);
+	if (ret) {
+		kfree(zone);
+		return NULL;
+	}
+
 	zone->start = start;
 	zone->end = end;
 	INIT_LIST_HEAD(&zone->list);
@@ -299,6 +305,7 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 			zone = NULL;
 	}
 	spin_unlock(&fs_info->reada_lock);
+	radix_tree_preload_end();
 
 	return zone;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73d56eef5e60..f158b8657ae3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -247,7 +247,7 @@ static struct btrfs_device *__alloc_device(void)
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
 	btrfs_device_data_ordered_init(dev);
-	INIT_RADIX_TREE(&dev->reada_zones, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
+	INIT_RADIX_TREE(&dev->reada_zones, GFP_KERNEL);
 	INIT_RADIX_TREE(&dev->reada_extents, GFP_NOFS & ~__GFP_DIRECT_RECLAIM);
 
 	return dev;
-- 
2.12.0

