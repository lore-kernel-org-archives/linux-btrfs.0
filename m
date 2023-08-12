Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34F1C41513
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Aug 2023 10:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbjHLK71 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 12 Aug 2023 06:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbjHLK70 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2023 06:59:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C154B10C;
        Sat, 12 Aug 2023 03:59:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 12BF567373; Sat, 12 Aug 2023 12:51:34 +0200 (CEST)
Date:   Sat, 12 Aug 2023 12:51:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        "Darrick J . Wong" <djwong@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        nbd@other.debian.org, linux-s390@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/17] block: consolidate __invalidate_device and
 fsync_bdev
Message-ID: <20230812105133.GA11904@lst.de>
References: <20230811100828.1897174-1-hch@lst.de> <20230811100828.1897174-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811100828.1897174-14-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The buildbot pointed out correctly (but rather late), that the special
s390/dasd export needs a _MODULE postfix, so this will have to be
folded in:

diff --git a/block/bdev.c b/block/bdev.c
index 2a035be7f3ee90..a20263fa27a462 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -967,7 +967,7 @@ void bdev_mark_dead(struct block_device *bdev, bool surprise)
 
 	invalidate_bdev(bdev);
 }
-#ifdef CONFIG_DASD
+#ifdef CONFIG_DASD_MODULE
 /*
  * Drivers should not use this directly, but the DASD driver has historically
  * had a shutdown to offline mode that doesn't actually remove the gendisk
