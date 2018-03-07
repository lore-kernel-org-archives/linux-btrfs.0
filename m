Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:42105 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933698AbeCGRhe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Mar 2018 12:37:34 -0500
Received: by mail-wr0-f181.google.com with SMTP id k9so3003100wre.9
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Mar 2018 09:37:33 -0800 (PST)
Received: from archlinux.localnet (229.red-79-150-122.dynamicip.rima-tde.net. [79.150.122.229])
        by smtp.gmail.com with ESMTPSA id r6sm19807319wrg.63.2018.03.07.09.37.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Mar 2018 09:37:31 -0800 (PST)
From: Diego <diegocg@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Improve error stats message
Date: Wed, 07 Mar 2018 18:37:29 +0100
Message-ID: <1588327.cr4xlG2VNd@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A typical notification of filesystem errors looks like this:

BTRFS error (device sda2): bdev /dev/sda2 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0

The device name is being printed twice. Also, these abbreviatures
feel unnecesary. Make the message look like this instead:

BTRFS error (device sda2): errors: write 0, read 1, flush 0, corrupt 0, generation 0


Signed-off-by: Diego Calleja <diegocg@gmail.com>
---
 fs/btrfs/volumes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2ceb924ca0d6..52fee5bb056f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7238,9 +7238,8 @@ static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev)
 {
 	if (!dev->dev_stats_valid)
 		return;
-	btrfs_err_rl_in_rcu(dev->fs_info,
-		"bdev %s errs: wr %u, rd %u, flush %u, corrupt %u, gen %u",
-			   rcu_str_deref(dev->name),
+	btrfs_err_rl(dev->fs_info,
+		"errors: write %u, read %u, flush %u, corrupt %u, generation %u",
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_WRITE_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_READ_ERRS),
 			   btrfs_dev_stat_read(dev, BTRFS_DEV_STAT_FLUSH_ERRS),
-- 
2.16.2




