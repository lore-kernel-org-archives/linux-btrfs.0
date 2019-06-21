Return-Path: <SRS0=NDcF=UU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389A5C43613
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Jun 2019 19:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B4632084E
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Jun 2019 19:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfFUT2m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Jun 2019 15:28:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:33226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfFUT2k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jun 2019 15:28:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 162A8AEE9;
        Fri, 21 Jun 2019 19:28:39 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, hch@lst.de, darrick.wong@oracle.com,
        david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 3/6] iomap: Check iblocksize before transforming page->private
Date:   Fri, 21 Jun 2019 14:28:25 -0500
Message-Id: <20190621192828.28900-4-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190621192828.28900-1-rgoldwyn@suse.de>
References: <20190621192828.28900-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

btrfs uses page->private as well to store extent_buffer. Make
the check stricter to make sure we are using page->private for iop by
comparing iblocksize < PAGE_SIZE.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 include/linux/iomap.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f49767c7fd83..6511124e58b6 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -128,7 +128,8 @@ struct iomap_page {
 
 static inline struct iomap_page *to_iomap_page(struct page *page)
 {
-	if (page_has_private(page))
+	if (i_blocksize(page->mapping->host) < PAGE_SIZE &&
+			page_has_private(page))
 		return (struct iomap_page *)page_private(page);
 	return NULL;
 }
-- 
2.16.4

