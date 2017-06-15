Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56901 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751818AbdFOQud (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:50:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECC93AC29
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:50:31 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/5] btrfs: move dev stats accounting out of wait_dev_flush
Date: Thu, 15 Jun 2017 18:49:27 +0200
Message-Id: <4d289b92beb5c7d81ba1c6e26a18bcc7868a9f67.1497544265.git.dsterba@suse.com>
In-Reply-To: <cover.1497544265.git.dsterba@suse.com>
References: <cover.1497544265.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should really just wait in wait_dev_flush and let the caller decide
what to do with the error value.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 05ff81ecb887..59a732a13370 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3512,7 +3512,6 @@ static void write_dev_flush(struct btrfs_device *device)
  */
 static int wait_dev_flush(struct btrfs_device *device)
 {
-	int ret = 0;
 	struct request_queue *q = bdev_get_queue(device->bdev);
 	struct bio *bio = device->flush_bio;
 
@@ -3521,13 +3520,7 @@ static int wait_dev_flush(struct btrfs_device *device)
 
 	wait_for_completion_io(&device->flush_wait);
 
-	if (bio->bi_error) {
-		ret = bio->bi_error;
-		btrfs_dev_stat_inc_and_print(device,
-				BTRFS_DEV_STAT_FLUSH_ERRS);
-	}
-
-	return ret;
+	return bio->bi_error;
 }
 
 static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
@@ -3586,6 +3579,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		ret = wait_dev_flush(dev);
 		if (ret) {
 			dev->last_flush_error = ret;
+			btrfs_dev_stat_inc_and_print(dev,
+					BTRFS_DEV_STAT_FLUSH_ERRS);
 			errors_wait++;
 		}
 	}
-- 
2.13.0

