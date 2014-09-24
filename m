Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:28543 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaIXSXO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 14:23:14 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] Btrfs: fix compilation errors under DEBUG
Date: Wed, 24 Sep 2014 20:23:05 +0200
Message-Id: <1411582985-17734-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bi_sector and bi_size moved to bi_iter since commit 4f024f3797c4
("block: Abstract out bvec iterator")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5b5a5c4..d47289c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5708,8 +5708,8 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 		name = rcu_dereference(dev->name);
 		pr_debug("btrfs_map_bio: rw %d, sector=%llu, dev=%lu "
 			 "(%s id %llu), size=%u\n", rw,
-			 (u64)bio->bi_sector, (u_long)dev->bdev->bd_dev,
-			 name->str, dev->devid, bio->bi_size);
+			 (u64)bio->bi_iter.bi_sector, (u_long)dev->bdev->bd_dev,
+			 name->str, dev->devid, bio->bi_iter.bi_size);
 		rcu_read_unlock();
 	}
 #endif
-- 
1.9.3

