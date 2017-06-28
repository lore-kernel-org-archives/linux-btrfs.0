Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3961 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751541AbdF1Fnu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 01:43:50 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: <ahferroin7@gmail.com>, <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v4 4/6] btrfs: Allow barrier_all_devices to do chunk level device check
Date: Wed, 28 Jun 2017 13:43:33 +0800
Message-ID: <20170628054335.18806-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The last user of num_tolerated_disk_barrier_failures is
barrier_all_devices().
But it's can be easily changed to new per-chunk degradable check
framework.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6ba2a53999f9..7ec766d8510f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3518,20 +3518,10 @@ static int wait_dev_flush(struct btrfs_device *device)
 	return bio->bi_error;
 }
 
-static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
+static int check_barrier_error(struct btrfs_fs_info *fs_info)
 {
-	int dev_flush_error = 0;
-	struct btrfs_device *dev;
-
-	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
-		if (!dev->bdev || dev->last_flush_error)
-			dev_flush_error++;
-	}
-
-	if (dev_flush_error >
-	    fsdevs->fs_info->num_tolerated_disk_barrier_failures)
+	if (!btrfs_check_rw_degradable(fs_info))
 		return -EIO;
-
 	return 0;
 }
 
@@ -3586,7 +3576,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		 * to arrive at the volume status. So error checking
 		 * is being pushed to a separate loop.
 		 */
-		return check_barrier_error(info->fs_devices);
+		return check_barrier_error(info);
 	}
 	return 0;
 }
-- 
2.13.1



