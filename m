Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA59C61DA4
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Feb 2023 16:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBPQfF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 11:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjBPQfD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2023 11:35:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155A1497C6
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2023 08:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SWFcWzJIi7WFLL7LpcgdnC9AlHg8Oeaim3L4HMsEs7o=; b=apR1dTx41nm0kW2lvEQXN0oS+A
        yR/weNcB4IezMB2GF+TO19vCh1MEs5pE6ftW0gcr6JWWlgIq7xQRHZ+Y6UMKGZnrcrY/B/2Cu3Q5V
        A5iVg48GB6Uv8CBt1mXu77IMys4sP8SIRLAj+Ekp8ogxX+p4PKCOLA4zUu89rzvr0KpTdzhZ5sEOm
        aCOGO1oecJlP+y46iw2jSWlaZj6JujeqacstVYpcZStXmDlgXwHoAR0aS9NxfpfcfU8B6JB/XnlHp
        6F0hDeaOpARg8wu3Z/NgvScaD+e6qaQBUwh66VZCIfW8gDuuR750bk3SyS/Ka/pMqm6DXLBy4mtIt
        ZLLDe5+w==;
Received: from [2001:4bb8:181:6771:37af:42b9:3236:81df] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pShDm-00BD16-5L; Thu, 16 Feb 2023 16:34:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 07/12] btrfs: rename the this_bio_flag variable in btrfs_do_readpage
Date:   Thu, 16 Feb 2023 17:34:32 +0100
Message-Id: <20230216163437.2370948-8-hch@lst.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216163437.2370948-1-hch@lst.de>
References: <20230216163437.2370948-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Rename this_bio_flag to compress_type to match the surrounding code
and better document the intent.  Also use the proper enum type instead
of unsigned long.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/extent_io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4fe128d2895f88..24a1e988dd0fab 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1213,7 +1213,7 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 	bio_ctrl->end_io_func = end_bio_extent_readpage;
 	begin_page_read(fs_info, page);
 	while (cur <= end) {
-		unsigned long this_bio_flag = 0;
+		enum btrfs_compression_type compress_type = BTRFS_COMPRESS_NONE;
 		bool force_bio_submit = false;
 		u64 disk_bytenr;
 
@@ -1238,11 +1238,11 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		BUG_ON(end < cur);
 
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
-			this_bio_flag = em->compress_type;
+			compress_type = em->compress_type;
 
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
-		if (this_bio_flag != BTRFS_COMPRESS_NONE)
+		if (compress_type != BTRFS_COMPRESS_NONE)
 			disk_bytenr = em->block_start;
 		else
 			disk_bytenr = em->block_start + extent_offset;
@@ -1314,13 +1314,13 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 			continue;
 		}
 
-		if (bio_ctrl->compress_type != this_bio_flag)
+		if (bio_ctrl->compress_type != compress_type)
 			submit_one_bio(bio_ctrl);
 	
 		if (force_bio_submit)
 			submit_one_bio(bio_ctrl);
 		ret = submit_extent_page(bio_ctrl, disk_bytenr, page, iosize,
-					 pg_offset, this_bio_flag);
+					 pg_offset, compress_type);
 		if (ret) {
 			/*
 			 * We have to unlock the remaining range, or the page
-- 
2.39.1

