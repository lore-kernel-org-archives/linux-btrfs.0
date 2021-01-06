Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FECC43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 01:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B7F722CAF
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 01:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbhAFBE0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 20:04:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:46050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbhAFBEZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jan 2021 20:04:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1609894953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2PBdVEiDPMEAtB6TzqqrkUOVNUruNNU/re0KCSa0E0=;
        b=Xkw1PBmZsumUdZWaEjKEl40e5fyH5vaikP4jAm2kjLlF5VGEYkgk/ZBuiMQ5jHEXUXF+oh
        1Y3YUczSUsB1/T0tLSLAK+HZVbHoT5b6FQlUrt3Aj/oCyHDz4icEAX8VNLPMi/w2HKrc8x
        5FPwCX88R3DyDt/ombJ2ftiKAcrZ7Hk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE2DFAF5B
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2021 01:02:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 15/22] btrfs: extent_io: make btrfs_clone_extent_buffer() to be subpage compatible
Date:   Wed,  6 Jan 2021 09:01:54 +0800
Message-Id: <20210106010201.37864-16-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106010201.37864-1-wqu@suse.com>
References: <20210106010201.37864-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For btrfs_clone_extent_buffer(), it's mostly the same code of
__alloc_dummy_extent_buffer(), except it has extra page copy.

So to make it subpage compatible, we only need to:
- Call set_extent_buffer_uptodate() instead of SetPageUptodate()
  This will set correct uptodate bit for subpage and regular sector size
  cases.

Since we're calling set_extent_buffer_uptodate() which will also set
EXTENT_BUFFER_UPTODATE bit, we don't need to manually set that bit
either.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 66e70b263343..194cb8b63216 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5106,7 +5106,6 @@ struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buffer *src)
 	if (new == NULL)
 		return NULL;
 
-	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
 	set_bit(EXTENT_BUFFER_UNMAPPED, &new->bflags);
 
 	for (i = 0; i < num_pages; i++) {
@@ -5124,11 +5123,10 @@ struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buffer *src)
 			return NULL;
 		}
 		WARN_ON(PageDirty(p));
-		SetPageUptodate(p);
 		new->pages[i] = p;
 		copy_page(page_address(p), page_address(src->pages[i]));
 	}
-
+	set_extent_buffer_uptodate(new);
 
 	return new;
 }
-- 
2.29.2

