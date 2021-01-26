Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4FBC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Jan 2021 08:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C445522573
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Jan 2021 08:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389973AbhAZIhA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 03:37:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:54960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbhAZIgM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jan 2021 03:36:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611650088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fcfUn8RcbC7BhrZSNgxa1lNSVfWskxmvt0NCQOx9pbw=;
        b=WZJU2oJMXQrg7INHhAgPMzOdRzaRsF/476/G04a54VzBOAC4ifEofwOIy2kuJQKDRZXXMH
        Rlt7YZizpb2gCWW4/N7bncUwz1wwI2+A4Hvvef0th4+iPx7H4YIz2utKmwHwZ43RDOd5a+
        NrIJ7iPMl6i7UfrG/Ah0C/A+B4d7q10=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C11B7AF7F;
        Tue, 26 Jan 2021 08:34:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH v5 11/18] btrfs: support subpage in btrfs_clone_extent_buffer
Date:   Tue, 26 Jan 2021 16:33:55 +0800
Message-Id: <20210126083402.142577-12-wqu@suse.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210126083402.142577-1-wqu@suse.com>
References: <20210126083402.142577-1-wqu@suse.com>
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
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 78fd36ba1f47..d1c1bbc19226 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5161,11 +5161,10 @@ struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buffer *src)
 			return NULL;
 		}
 		WARN_ON(PageDirty(p));
-		SetPageUptodate(p);
 		new->pages[i] = p;
 		copy_page(page_address(p), page_address(src->pages[i]));
 	}
-	set_bit(EXTENT_BUFFER_UPTODATE, &new->bflags);
+	set_extent_buffer_uptodate(new);
 
 	return new;
 }
-- 
2.30.0

