Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56895 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751818AbdFOQug (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:50:36 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF91FAB9D
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:50:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/5] btrfs: account as waiting for IO, while waiting fot the flush bio completion
Date: Thu, 15 Jun 2017 18:49:25 +0200
Message-Id: <ee2d525739984033396f4bdefaa5d68f11553a0b.1497544265.git.dsterba@suse.com>
In-Reply-To: <cover.1497544265.git.dsterba@suse.com>
References: <cover.1497544265.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar to what submit_bio_wait does, we should account for IO while
waiting for a bio completion. This has marginal visible effects, flush
bio is short-lived.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 27d44d6ab775..05ff81ecb887 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3519,7 +3519,7 @@ static int wait_dev_flush(struct btrfs_device *device)
 	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
 		return 0;
 
-	wait_for_completion(&device->flush_wait);
+	wait_for_completion_io(&device->flush_wait);
 
 	if (bio->bi_error) {
 		ret = bio->bi_error;
-- 
2.13.0

