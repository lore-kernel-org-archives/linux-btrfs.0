Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A20C7EE24
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 May 2023 16:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbjEHQJE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 May 2023 12:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjEHQIx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2023 12:08:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EF66EA2
        for <linux-btrfs@vger.kernel.org>; Mon,  8 May 2023 09:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YXE2wrNkKvYjH5/mlqKZrK9JlA/p2/0j+caHMvI421U=; b=ofxBMo2yeL2RqE0zoSZ0BFSxCE
        C2lx9wCmubMRUWUQGYGpWTyT0cRQSTrsnr3X66S8wNRYGeECnyadeHWfLmk6nLU4dbj05ZM9FEIrL
        NwtT4/YueYViICBrG0f8569kzCLz/X/nTg4eiCevimTk/LvXAYTjXulxoohRb553+t9txNZXhhHSt
        +fpYN0S9emY/XeSe37hADAMA+Q0NmtONG5LE3wz/Qb8TIQnwcR6CdXjDuqt8Bvyx70GtfRcJnMMtS
        6DlANjFZ0QAorXSXPslk7uYnPNsV5zaMUJ7r1xkxyCuwt20B8okipN7urGtnZZnxuaKKtCFeaLn0G
        HBMtcBlQ==;
Received: from [208.98.210.70] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pw3Pu-000w20-34;
        Mon, 08 May 2023 16:08:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 11/21] btrfs: open code btrfs_bio_end_io in btrfs_dio_submit_io
Date:   Mon,  8 May 2023 09:08:33 -0700
Message-Id: <20230508160843.133013-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508160843.133013-1-hch@lst.de>
References: <20230508160843.133013-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_dio_submit_io is the only place that uses btrfs_bio_end_io to end a
bio that hasn't been submitted using btrfs_submit_bio yet, and this
invariant will become a problem with upcoming changes to the btrfs bio
layer.  Just open code the assignment of bi_status and the call to
btrfs_dio_end_io.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3dceedf612d4ba..a425658cfbae0c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7925,7 +7925,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 
 		ret = btrfs_extract_ordered_extent(bbio, dio_data->ordered);
 		if (ret) {
-			btrfs_bio_end_io(bbio, errno_to_blk_status(ret));
+			bbio->bio.bi_status = errno_to_blk_status(ret);
+			btrfs_dio_end_io(bbio);
 			return;
 		}
 	}
-- 
2.39.2

