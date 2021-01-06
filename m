Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175D6C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 01:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A1C221E2
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Jan 2021 01:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbhAFBEB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 20:04:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:45862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAFBEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jan 2021 20:04:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1609894959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQlBqz5v3NWCBmxD/Uhou6ZrSwHpTRBkJ3uEhbbONbc=;
        b=fkj53oEnaj62J1L6KK4qOIIYYCBLGN8H12QvM0+BIXWd0s1CSrH28Leiu2NPQWWlFJVuTG
        VltOxnNDGm0L8bXA4Owkb7SvGArnvxAhkACbACM6xG4PaEqrDVn+zsIsZjukLlxvcqOskD
        gLywmOukqWrZtWfIhBttUgs+dwbRsVA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DEFAEAF94
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2021 01:02:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 18/22] btrfs: extent_io: make endio_readpage_update_page_status() to handle subpage case
Date:   Wed,  6 Jan 2021 09:01:57 +0800
Message-Id: <20210106010201.37864-19-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106010201.37864-1-wqu@suse.com>
References: <20210106010201.37864-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

To handle subpage status update, add the following new tricks:
- Use btrfs_page_*() helpers to update page status
  Now we can handle both cases well.

- No page unlock for subpage metadata
  Since subpage metadata doesn't utilize page locking at all, skip it.
  For subpage data locking, it's handled in later commits.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b828314bf43a..2902484ab9f9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2839,15 +2839,24 @@ static void endio_readpage_release_extent(struct processed_extent *processed,
 	processed->uptodate = uptodate;
 }
 
-static void endio_readpage_update_page_status(struct page *page, bool uptodate)
+static void endio_readpage_update_page_status(struct page *page, bool uptodate,
+					      u64 start, u32 len)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+
+	ASSERT(page_offset(page) <= start &&
+		start + len <= page_offset(page) + PAGE_SIZE);
+
 	if (uptodate) {
-		SetPageUptodate(page);
+		btrfs_page_set_uptodate(fs_info, page, start, len);
 	} else {
-		ClearPageUptodate(page);
-		SetPageError(page);
+		btrfs_page_clear_uptodate(fs_info, page, start, len);
+		btrfs_page_set_error(fs_info, page, start, len);
 	}
-	unlock_page(page);
+
+	if (fs_info->sectorsize == PAGE_SIZE)
+		unlock_page(page);
+	/* Subpage locking will be handled in later patches */
 }
 
 /*
@@ -2984,7 +2993,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 		bio_offset += len;
 
 		/* Update page status and unlock */
-		endio_readpage_update_page_status(page, uptodate);
+		endio_readpage_update_page_status(page, uptodate, start, len);
 		endio_readpage_release_extent(&processed, BTRFS_I(inode),
 					      start, end, uptodate);
 	}
-- 
2.29.2

