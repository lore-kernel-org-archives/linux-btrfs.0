Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753971AbdFPOF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:05:58 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3 v2] btrfs: move dev stats accounting out of wait_dev_flush
Date: Fri, 16 Jun 2017 16:04:52 +0200
Message-Id: <42dd9010ed622ba5a7d499bb8389b9ff386aaf86.1497621455.git.dsterba@suse.com>
In-Reply-To: <cover.1497621455.git.dsterba@suse.com>
References: <cover.1497621455.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should really just wait in wait_dev_flush and let the caller decide
what to do with the error value.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 85f931c5e63c..5992e42c5e3c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3513,7 +3513,6 @@ static void write_dev_flush(struct btrfs_device *device)
  */
 static int wait_dev_flush(struct btrfs_device *device)
 {
-	int ret = 0;
 	struct bio *bio = device->flush_bio;
 
 	if (!device->flush_bio_sent)
@@ -3522,13 +3521,7 @@ static int wait_dev_flush(struct btrfs_device *device)
 	device->flush_bio_sent = 0;
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
@@ -3587,6 +3580,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
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

