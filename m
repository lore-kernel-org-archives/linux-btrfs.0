Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261ACC7EE23
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 08:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbjEWIQU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 04:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbjEWIPm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 04:15:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16019A7
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 01:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=76unRlbV3A9Mop5L5PwCi8hmeO6JSgnUFL1w7O3UiYE=; b=mVFrbjGsFBvIwq7eMUdmxYlJSM
        c8c/n4fA3D3w+AQemz68YTgSP9TvUh8aDmOV24bBqoASc+cjy4hcXeCT5C9xistjDRsWEejp1giVp
        8SHsGm7AAVhZIfNp+CTNa8kEO2yKoU3kVFSQGU7bzJF5oPyzyTZgwACBaS5M/4QYjMqrvQOZynnJU
        jfFf2sKtGAmA3FeVmDbmzr39ni7BHWpM+0XMHzKEc0LRegaBzSlqneOhChhA03H9V3xD/e1E38Rip
        otKvaKjRhm028/L+nrscMrm6G+SUrRNVxUT2ZQhBK3+jYDAvLCASWLAPrHREKgeAPIh5YKmEqRUvO
        VuZIZdog==;
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q1N9Y-009OXQ-0E;
        Tue, 23 May 2023 08:13:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH 11/16] btrfs: move nr_to_write to __extent_writepage
Date:   Tue, 23 May 2023 10:13:17 +0200
Message-Id: <20230523081322.331337-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523081322.331337-1-hch@lst.de>
References: <20230523081322.331337-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Move the nr_to_write accounting from __extent_writepage_io to
__extent_writepage_io as we'll grow another __extent_writepage_io that
doesn't want this accounting soon.  Also drop the obsolete comment -
decrementing a counter in the on-stack writeback_control data structure
doesn't need the page lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/extent_io.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6151b38add8759..ac4ef0527bed49 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1370,12 +1370,6 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 		return 1;
 	}
 
-	/*
-	 * we don't want to touch the inode after unlocking the page,
-	 * so we update the mapping writeback index now
-	 */
-	bio_ctrl->wbc->nr_to_write--;
-
 	bio_ctrl->end_io_func = end_bio_extent_writepage;
 	while (cur <= end) {
 		u64 disk_bytenr;
@@ -1521,6 +1515,8 @@ static int __extent_writepage(struct page *page, struct btrfs_bio_ctrl *bio_ctrl
 	if (ret == 1)
 		return 0;
 
+	bio_ctrl->wbc->nr_to_write--;
+
 done:
 	if (nr == 0) {
 		/* make sure the mapping tag for page dirty gets cleared */
-- 
2.39.2

