Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753971AbdFPOFz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:05:55 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3 v2] btrfs: account as waiting for IO, while waiting fot the flush bio completion
Date: Fri, 16 Jun 2017 16:04:50 +0200
Message-Id: <f4a6b02affc0256a0da05193e8546578300608b8.1497621455.git.dsterba@suse.com>
In-Reply-To: <cover.1497621455.git.dsterba@suse.com>
References: <cover.1497621455.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar to what submit_bio_wait does, we should account for IO while
waiting for a bio completion. This has marginal visible effects, flush
bio is short-lived.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d824c0fc6821..85f931c5e63c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3520,7 +3520,7 @@ static int wait_dev_flush(struct btrfs_device *device)
 		return 0;
 
 	device->flush_bio_sent = 0;
-	wait_for_completion(&device->flush_wait);
+	wait_for_completion_io(&device->flush_wait);
 
 	if (bio->bi_error) {
 		ret = bio->bi_error;
-- 
2.13.0

