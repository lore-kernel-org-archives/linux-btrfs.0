Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59361 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933035AbeFTIxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 04:53:43 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CAABAAC9F
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 07:39:00 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: check-integrity: Fix NULL pointer dereference for degraded mount
Date: Wed, 20 Jun 2018 15:38:58 +0800
Message-Id: <20180620073858.10794-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t")
changed how btrfsic how we index device state hash.

Now we need to access device->bdev->bd_dev, while for degraded mount
it's completely possible to have device->bdev as NULL, thus it will
trigger a NULL pointer dereference at mount time.

Fix it by checking if the device is degraded before accessing
device->bdev->bd_dev.

There are a lot of other places accessing device->bdev->bd_dev, however
the other call sites have either checked device->bdev, or the
device->bdev is passed from btrfsic_map_block(), so it won't cause harm.

Fixes: f8f84b2dfda5 ("btrfs: index check-integrity state hash by a dev_t")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Please note there are still quite some problem about check-integrity,
including:
1) Warning for degraded mount
2) Meaningless empty lines output

This patch will only fix the obvious NULL pointer dereference exposed by
btrfs/027 with "check_int" mount option.
---
 fs/btrfs/check-integrity.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index a3fdb4fe967d..daf45472bef9 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1539,7 +1539,12 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	}
 
 	device = multi->stripes[0].dev;
-	block_ctx_out->dev = btrfsic_dev_state_lookup(device->bdev->bd_dev);
+	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state) ||
+	    !device->bdev || !device->name)
+		block_ctx_out->dev = NULL;
+	else
+		block_ctx_out->dev = btrfsic_dev_state_lookup(
+							device->bdev->bd_dev);
 	block_ctx_out->dev_bytenr = multi->stripes[0].physical;
 	block_ctx_out->start = bytenr;
 	block_ctx_out->len = len;
-- 
2.17.1

