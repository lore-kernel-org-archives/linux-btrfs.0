Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7231AC4338F
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Jul 2021 01:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590C660F6B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Jul 2021 01:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhG0A7U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 20:59:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33826 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhG0A7T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jul 2021 20:59:19 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E96B8200A6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jul 2021 01:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627349985; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=J3h7E18xAdGA1UJaXJ/BX6mnvpNGGUKciir3SiJxpC8=;
        b=KBXzhpVYPH1xHDd+Qt86Bt/lRPO3jNOr3dGMerQtrXGB5IGPBWI0vZMvxF6p3MQUjibXAy
        wi6kfSTL/xHCaQYdCjDclQaS5wavT1VfLTueiS+J64aaifsAANrgz48IRK8ULl7AOPK23Z
        MBLmLfA80NrY5H56FMwmz/U8kahS25s=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 23930133A7
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jul 2021 01:39:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id YQy7NOBj/2DFRgAAGKfGzw
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jul 2021 01:39:44 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: change the set_page_extent_mapped() call into an ASSERT()
Date:   Tue, 27 Jul 2021 09:39:42 +0800
Message-Id: <20210727013942.83531-1-wqu@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Btrfs uses set_page_extent_mapped() to properly setup a page.

That function would set PagePrivate, and populate needed structure for
subpage.
The timing of calling set_page_extent_mapped() happens before reading a
page or dirtying a page.
Thus when we got a page to write back, if it doesn't have PagePrivate,
it is a big problem in code logic.

Calling set_page_extent_mapped() for such page would just mask the
problem.
Furthermore, for subpage case, we call subpage error helper to clear the
page error bit before calling set_page_extent_mapped().
If we really got a page without Private bit, it can call kernel NULL
pointer dereference.

So change the set_page_extent_mapped() call to an ASSERT(), and move the
check before any page status update call.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 62f0ed2de2b9..219add264acf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4099,6 +4099,12 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	WARN_ON(!PageLocked(page));
 
+	/*
+	 * All dirty page to be written should have PagePrivate set by
+	 * set_page_extent_mapped() when creating the page.
+	 */
+	ASSERT(PagePrivate(page));
+
 	btrfs_page_clear_error(btrfs_sb(inode->i_sb), page,
 			       page_offset(page), PAGE_SIZE);
 
@@ -4115,12 +4121,6 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		flush_dcache_page(page);
 	}
 
-	ret = set_page_extent_mapped(page);
-	if (ret < 0) {
-		SetPageError(page);
-		goto done;
-	}
-
 	if (!epd->extent_locked) {
 		ret = writepage_delalloc(BTRFS_I(inode), page, wbc,
 					 &nr_written);
-- 
2.32.0

