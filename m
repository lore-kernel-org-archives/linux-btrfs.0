Return-Path: <SRS0=T3D7=7K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D59C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 19:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09273208DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 19:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406534AbgE1TZC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 May 2020 15:25:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:41628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406316AbgE1TVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 May 2020 15:21:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35992AE8C;
        Thu, 28 May 2020 19:21:06 +0000 (UTC)
Date:   Thu, 28 May 2020 14:21:03 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Johannes.Thumshirn@wdc.com,
        hch@infradead.org, dsterba@suse.cz, darrick.wong@oracle.com,
        fdmanana@gmail.com
Subject: [PATCH] iomap: Return zero in case of unsuccessful pagecache
 invalidation before DIO
Message-ID: <20200528192103.xm45qoxqmkw7i5yl@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Filesystems such as btrfs are unable to guarantee page invalidation
because pages could be locked as a part of the extent. Return zero
in case a page cache invalidation is unsuccessful so filesystems can
fallback to buffered I/O. This is similar to
generic_file_direct_write().

This takes care of the following invalidation warning during btrfs
mixed buffered and direct I/O using iomap_dio_rw():

Page cache invalidation failure on direct I/O.  Possible data
corruption due to collision with buffered I/O!

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index e4addfc58107..215315be6233 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -483,9 +483,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	 */
 	ret = invalidate_inode_pages2_range(mapping,
 			pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
-	if (ret)
-		dio_warn_stale_pagecache(iocb->ki_filp);
-	ret = 0;
+	/*
+	 * If a page can not be invalidated, return 0 to fall back
+	 * to buffered write.
+	 */
+	if (ret) {
+		if (ret == -EBUSY)
+			ret = 0;
+		goto out_free_dio;
+	}
 
 	if (iov_iter_rw(iter) == WRITE && !wait_for_completion &&
 	    !inode->i_sb->s_dio_done_wq) {

-- 
Goldwyn
