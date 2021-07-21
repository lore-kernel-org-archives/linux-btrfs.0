Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64EDC636CA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Jul 2021 15:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3AFD61208
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Jul 2021 15:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbhGUO5W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 10:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbhGUO5V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jul 2021 10:57:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D19BC061575;
        Wed, 21 Jul 2021 08:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JTQg97LfXhxEgJekbyUthk6njZqT/SjBp9PCGRorI7M=; b=fxkhrVaAFHh/AQwNj5JMO3k1Uq
        Z3U+FgpJGnjPGO/uHD7115X5hbREHDsDXsjZbnzKaeRj2sy2pPHdplyeIlcpC78ENsw1N4oJbCG0C
        oxtg25ymSjEXJ2SRXaC3diCIxecmYA/2w/N0BszhHBLJpWv/LLmgNsuWsK8/kjCrm5QdaXsIHw4uY
        QZNkw/lWprzJNqbVMJcPxnncZwbTTvHgOnIH4MDxWoq+Of419h7W/juuXrjdeX6M/jRYqYZduzp3a
        Ep3Cue9GvwwUMYmgO/zlRKsGGcdOTMWUJCxDQeh1L1X3vlRUweq1+9NYJv1MJ2Osb0172XdQCzek1
        bF2qM0GA==;
Received: from [2001:4bb8:193:7660:d6d5:72f4:23f7:1898] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6EHx-009LM2-Dv; Wed, 21 Jul 2021 15:37:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] loop: don't grab a reference to the block device
Date:   Wed, 21 Jul 2021 17:35:21 +0200
Message-Id: <20210721153523.103818-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210721153523.103818-1-hch@lst.de>
References: <20210721153523.103818-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The whole device block device won't be removed while the disk is still
alive, so don't bother to grab a reference to it.
---
 drivers/block/loop.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f37b9e3d833c..62c5120cf744 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1249,10 +1249,6 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	if (partscan)
 		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
 
-	/* Grab the block_device to prevent its destruction after we
-	 * put /dev/loopXX inode. Later in __loop_clr_fd() we bdput(bdev).
-	 */
-	bdgrab(bdev);
 	mutex_unlock(&lo->lo_mutex);
 	if (partscan)
 		loop_reread_partitions(lo);
@@ -1332,7 +1328,6 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	blk_queue_physical_block_size(lo->lo_queue, 512);
 	blk_queue_io_min(lo->lo_queue, 512);
 	if (bdev) {
-		bdput(bdev);
 		invalidate_bdev(bdev);
 		bdev->bd_inode->i_mapping->wb_err = 0;
 	}
-- 
2.30.2

