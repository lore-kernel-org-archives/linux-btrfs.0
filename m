Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBABECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC7F620827
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC7F620827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbeKHXwW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 18:52:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:47348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbeKHXwW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 18:52:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 90D15B06E
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 14:16:40 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Check for missing device before bio submission in btrfs_map_bio
Date:   Thu,  8 Nov 2018 16:16:38 +0200
Message-Id: <20181108141638.31681-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Before btrfs_map_bio submits all stripe bio it does a number of checks
to ensure the device for every stripe is present. However, it doesn't
do a DEV_STATE_MISSING check, instead this is relegated to the lower
level btrfs_schedule_bio (in the async submission case, sync submission
doesn't check DEV_STATE_MISSING at all). Additionally
btrfs_schedule_bios does the duplicate device->bdev check which has
already been performed in btrfs_map_bio.

This patch moves the DEV_STATE_MISSING check in btrfs_map_bio and
removes the duplicate device->bdev check. Doing so ensures that no bio
cloning/submission happens for both async/sync requests in the face of
missing device. This makes the async io submission path slightly shorter
in terms of instruction count. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 44c5e8ccb644..3312cad65209 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6106,12 +6106,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
 
-	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state) ||
-	    !device->bdev) {
-		bio_io_error(bio);
-		return;
-	}
-
 	/* don't bother with additional async steps for reads, right now */
 	if (bio_op(bio) == REQ_OP_READ) {
 		btrfsic_submit_bio(bio);
@@ -6240,7 +6234,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
-		if (!dev || !dev->bdev ||
+		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
+						   &dev->dev_state) ||
 		    (bio_op(first_bio) == REQ_OP_WRITE &&
 		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
 			bbio_error(bbio, first_bio, logical);
-- 
2.17.1

