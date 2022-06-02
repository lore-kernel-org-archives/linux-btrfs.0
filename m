Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82AAC433EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jun 2022 07:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiFBHvs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 03:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiFBHvr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2022 03:51:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBDD1EE
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2022 00:51:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8C5EA1F8C7
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2022 07:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654156304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RCSWSsAjLaVkER74cKuKCg3NxnRAbcwLbuY0n0BduGQ=;
        b=GniL6fphPzF9d88bucClWyoK+9F/NJtL6BkQr/r9fLUL+Iwiv4rlvy7w0g6Kz8GCJqwQCg
        p17AoUWeCuSJWxOO5h5j0Vb5V/oehEmpKaNoxXGSEuqjkzpdm0dGssOkb6xBQiVArCxn23
        38qg5Q/81vITR2iIpzpdS/g2IB8xkEQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C6663134F3
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2022 07:51:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wNCDIg9smGI7GAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2022 07:51:43 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/5] btrfs: avoid double for loop inside alloc_rbio_essential_pages()
Date:   Thu,  2 Jun 2022 15:51:20 +0800
Message-Id: <44d46d938a624a6b277bb7ae45bdbcca778fdfa0.1654156185.git.wqu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654156185.git.wqu@suse.com>
References: <cover.1654156185.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The double loop is just checking if the page for the vertical stripe
is allocated.

We can easily convert it to single loop and get rid of @stripe variable.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8d06be2153db..1df5f1208e8b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2392,23 +2392,22 @@ void raid56_add_scrub_pages(struct btrfs_raid_bio *rbio, struct page *page,
 static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 {
 	const u32 sectorsize = rbio->bioc->fs_info->sectorsize;
-	int stripe;
-	int sectornr;
-
-	for_each_set_bit(sectornr, &rbio->dbitmap, rbio->stripe_nsectors) {
-		for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
-			struct page *page;
-			int index = (stripe * rbio->stripe_nsectors + sectornr) *
-				    sectorsize >> PAGE_SHIFT;
+	int total_sector_nr;
 
-			if (rbio->stripe_pages[index])
-				continue;
+	for (total_sector_nr = 0; total_sector_nr < rbio->nr_sectors;
+	     total_sector_nr++) {
+		struct page *page;
+		int sectornr = total_sector_nr % rbio->stripe_nsectors;
+		int index = (total_sector_nr * sectorsize) >> PAGE_SHIFT;
 
-			page = alloc_page(GFP_NOFS);
-			if (!page)
-				return -ENOMEM;
-			rbio->stripe_pages[index] = page;
-		}
+		if (!test_bit(sectornr, &rbio->dbitmap))
+			continue;
+		if (rbio->stripe_pages[index])
+			continue;
+		page = alloc_page(GFP_NOFS);
+		if (!page)
+			return -ENOMEM;
+		rbio->stripe_pages[index] = page;
 	}
 	index_stripe_sectors(rbio);
 	return 0;
-- 
2.36.1

