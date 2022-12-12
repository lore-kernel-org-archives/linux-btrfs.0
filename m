Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA25C4332F
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Dec 2022 07:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiLLHG2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Dec 2022 02:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiLLHGV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2022 02:06:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1231826CA
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2022 23:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DNt1PvE4IyTiJjQttibIpnY5JrV8koJ8MFXXiZQXc38=; b=DGbEul4zc9gg+sYglHmXFFYtOz
        IVjM7IshqOytj12ONAQwW6egvzbGpdh10sL4mIlOAOIvzLvmjFtrHsqUZ/A6AxXNqqI4L3oaIydXK
        ooPEPwy0XZfeda1QBkS6vrIXLdMiH0NdvNI9IKgLWB7berNj8brq45aHVgqqPs78bUEp5i/WjwAmn
        ukmLHOlnhgsbiLqv1HCrrmtgdK/mk0W7CbtUaVMBToyDw3hyz7gQgSF/vQYOAGmV5e7jQWN14vbeY
        xxUU9ZtR/9vHA28bOnyDSaAh8FMz5aj43EKi61+y6EaHhtr3nhQx0ATvK7iWkB+T6Qu0ydSS5L3Tv
        OwZyEhdA==;
Received: from [2001:4bb8:192:2f53:34e0:118:ce10:200c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p4ctH-009DtL-15; Mon, 12 Dec 2022 07:06:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: cleanup rmw_rbio
Date:   Mon, 12 Dec 2022 08:06:10 +0100
Message-Id: <20221212070611.5209-3-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212070611.5209-1-hch@lst.de>
References: <20221212070611.5209-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Remove the write goto label by moving the data page allocation and data
read into the branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/raid56.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5603ba1af55584..5035e2b20a5e02 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2293,24 +2293,22 @@ static int rmw_rbio(struct btrfs_raid_bio *rbio)
 	 * Either full stripe write, or we have every data sector already
 	 * cached, can go to write path immediately.
 	 */
-	if (rbio_is_full(rbio) || !need_read_stripe_sectors(rbio))
-		goto write;
-
-	/*
-	 * Now we're doing sub-stripe write, also need all data stripes to do
-	 * the full RMW.
-	 */
-	ret = alloc_rbio_data_pages(rbio);
-	if (ret < 0)
-		return ret;
+	if (!rbio_is_full(rbio) && need_read_stripe_sectors(rbio)) {
+		/*
+		 * Now we're doing sub-stripe write, also need all data stripes
+		 * to do the full RMW.
+		 */
+		ret = alloc_rbio_data_pages(rbio);
+		if (ret < 0)
+			return ret;
 
-	index_rbio_pages(rbio);
+		index_rbio_pages(rbio);
 
-	ret = rmw_read_wait_recover(rbio);
-	if (ret < 0)
-		return ret;
+		ret = rmw_read_wait_recover(rbio);
+		if (ret < 0)
+			return ret;
+	}
 
-write:
 	/*
 	 * At this stage we're not allowed to add any new bios to the
 	 * bio list any more, anyone else that wants to change this stripe
-- 
2.35.1

