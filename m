Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70114C4742C
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CCBD206D9
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LwiawLYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgKMMxQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:53:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:47856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgKMMxP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Nov 2020 07:53:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605271993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cCi3WgK717mGLnnS9E4ZdjSCh/mnwVaqzyrQH8+gPgk=;
        b=LwiawLYOPUYoUjRkbg2/RDPEaszB3wYfoyRQDwwzT6NN0Mfuw1TMMVBjEwzkcPK3Z8j6mU
        khP1NGbopwCDBX5I1bfB1lQrxeahCJ416CK0r/dJ2IbkckA+qqaBjOWCjvBbBLfkIsyrNu
        CActwNXPbI5epG97gjwvrjU3UCFYeL8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CEA1AABD1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2020 12:53:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 22/24] btrfs: scrub: support subpage data scrub
Date:   Fri, 13 Nov 2020 20:51:47 +0800
Message-Id: <20201113125149.140836-23-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113125149.140836-1-wqu@suse.com>
References: <20201113125149.140836-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs scrub is in fact much more flex than buffered data write path, as
we can read an unaligned subpage data into page offset 0.

This ability makes subpage support much easier, we just need to check
each scrub_page::page_len and ensure we only calculate hash for [0,
page_len) of a page, and call it a day for subpage scrub support.

There is a small thing to notice, for subpage case, we still do sector
by sector scrub.
This means we will submit a read bio for each sector to scrub, resulting
the same amount of read bios, just like the 4K page systems.

This behavior can be considered as a good thing, if we want everything
to be the same as 4K page systems.
But this also means, we're wasting the ability to submit larger bio
using 64K page size.
This is another problem to consider in the future.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ed63921789d4..4be376f2a82f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1781,8 +1781,9 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	struct scrub_ctx *sctx = sblock->sctx;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
-	u8 csum[BTRFS_CSUM_SIZE];
 	struct scrub_page *spage;
+	u32 sectorsize = fs_info->sectorsize;
+	u8 csum[BTRFS_CSUM_SIZE];
 	char *kaddr;
 
 	BUG_ON(sblock->page_count < 1);
@@ -1794,11 +1795,15 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 
 	shash->tfm = fs_info->csum_shash;
 	crypto_shash_init(shash);
-	crypto_shash_digest(shash, kaddr, PAGE_SIZE, csum);
+
+	/*
+	 * In scrub_pages() and scrub_pages_for_parity() we ensure
+	 * each spage only contains just one sector of data.
+	 */
+	crypto_shash_digest(shash, kaddr, sectorsize, csum);
 
 	if (memcmp(csum, spage->csum, sctx->fs_info->csum_size))
 		sblock->checksum_error = 1;
-
 	return sblock->checksum_error;
 }
 
-- 
2.29.2

