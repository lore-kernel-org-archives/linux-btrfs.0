Return-Path: <SRS0=KdHO=W4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51044C3A5A4
	for <linux-btrfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2DA2190F
	for <linux-btrfs@archiver.kernel.org>; Sun,  1 Sep 2019 20:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbfIAUJU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:09:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:50760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729051AbfIAUJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Sep 2019 16:09:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 511E6B666;
        Sun,  1 Sep 2019 20:09:18 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, darrick.wong@oracle.com, hch@lst.de,
        david@fromorbit.com, riteshh@linux.ibm.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 15/15] btrfs: update inode size during bio completion
Date:   Sun,  1 Sep 2019 15:08:36 -0500
Message-Id: <20190901200836.14959-16-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190901200836.14959-1-rgoldwyn@suse.de>
References: <20190901200836.14959-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Update the inode size for dio writes during bio completion.
This ties the success of the underlying block layer
whether to increase the size of the inode. Especially for
in aio cases.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 87fbe73ca2e4..f87a9dd154a9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8191,9 +8191,13 @@ static void btrfs_endio_direct_write(struct bio *bio)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio *dio_bio = dip->dio_bio;
+	struct inode *inode = dip->inode;
 
-	btrfs_update_ordered_extent(dip->inode, dip->logical_offset,
+	btrfs_update_ordered_extent(inode, dip->logical_offset,
 				     dip->bytes, !bio->bi_status);
+	if (!bio->bi_status &&
+	    i_size_read(inode) < dip->logical_offset + dip->bytes)
+		i_size_write(inode, dip->logical_offset + dip->bytes);
 
 	kfree(dip);
 
-- 
2.16.4

