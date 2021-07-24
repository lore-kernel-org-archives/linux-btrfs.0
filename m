Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA900C4320A
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F1960E9C
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhGXGeJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbhGXGeI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Jul 2021 02:34:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F253AC061575;
        Sat, 24 Jul 2021 00:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ldF7cKeMt9ecyiZEFA5vqbYztORNhlhWrCTZrNU7ozI=; b=vHTYNmMFrT7zHG9MUZDaxl/7pq
        rYUJ3dsLnT0++/dg/NfqWKRGYBgSggn5wFJVTu7LCMZVFH82AMHawUAgxJCJOdQW2eamDO9qlkhJW
        jPVg+CJn3UySBIiURNYGJznuuyCqpXjkNSNo6E2ZQR0XDC7sQGwDBNNpnKtV05x1WrHziQ3R6fFSb
        ocK2++sHvn82iuHWEYJ4k7uIAk0XHbTmH4hzCSBOR2/tl3B869iMh1Hu+lrcOMAjgba95ilgJuhjj
        3N8FvAdns6JnqiHG8On0vCPwoN7RPbpoNq71SXuu5hjShFdH1VzqWdUJ+LM1KUOnVEhNU9z1EVHKG
        QhcHvysw==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7BrO-00C4ao-Iw; Sat, 24 Jul 2021 07:14:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 04/10] block: remove the GENHD_FL_UP check in blkdev_get_no_open
Date:   Sat, 24 Jul 2021 09:12:43 +0200
Message-Id: <20210724071249.1284585-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724071249.1284585-1-hch@lst.de>
References: <20210724071249.1284585-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The GENHD_FL_UP check in blkdev_get_no_open is superflous.  The actual
non-racy check happens later under open_mutex in blkdev_get_by_dev,
and the inodes are removed from the inode hash early in del_gendisk,
so it does not provide any useful short cut.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9ef4f1fc2cb0..932f4034ad66 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1340,7 +1340,7 @@ struct block_device *blkdev_get_no_open(dev_t dev)
 	disk = bdev->bd_disk;
 	if (!kobject_get_unless_zero(&disk_to_dev(disk)->kobj))
 		goto bdput;
-	if ((disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
+	if (disk->flags & GENHD_FL_HIDDEN)
 		goto put_disk;
 	if (!try_module_get(bdev->bd_disk->fops->owner))
 		goto put_disk;
-- 
2.30.2

