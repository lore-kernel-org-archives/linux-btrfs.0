Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29266 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932674AbdCaLVL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:21:11 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: delete unused member nobarriers
Date: Fri, 31 Mar 2017 19:26:08 +0800
Message-Id: <20170331112608.32478-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 3 ---
 fs/btrfs/volumes.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08b74daf35d0..9de35bca1f67 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3521,9 +3521,6 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 	struct bio *bio;
 	int ret = 0;
 
-	if (device->nobarriers)
-		return 0;
-
 	if (wait) {
 		bio = device->flush_bio;
 		if (!bio)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 59be81206dd7..fa0b79422695 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -123,7 +123,6 @@ struct btrfs_device {
 	struct list_head resized_list;
 
 	/* for sending down flush barriers */
-	int nobarriers;
 	struct bio *flush_bio;
 	struct completion flush_wait;
 
-- 
2.10.0

