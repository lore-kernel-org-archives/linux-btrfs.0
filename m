Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932447AbdJaRqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:40 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF268ABF4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/11] btrfs: simplify btrfs_close_bdev
Date: Tue, 31 Oct 2017 18:44:49 +0100
Message-Id: <be1fa06b87548f0ad1888990a76ea2fb429ac798.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Split the conditions a bit.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6e45751ed957..3af2a7fd2d05 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -905,13 +905,15 @@ static void free_device_rcu(struct rcu_head *head)
 
 static void btrfs_close_bdev(struct btrfs_device *device)
 {
-	if (device->bdev && device->writeable) {
+	if (!device->bdev)
+		return;
+
+	if (device->writeable) {
 		sync_blockdev(device->bdev);
 		invalidate_bdev(device->bdev);
 	}
 
-	if (device->bdev)
-		blkdev_put(device->bdev, device->mode);
+	blkdev_put(device->bdev, device->mode);
 }
 
 static void btrfs_prepare_close_one_device(struct btrfs_device *device)
-- 
2.14.0

