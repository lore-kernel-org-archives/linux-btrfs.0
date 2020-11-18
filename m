Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD03C5519F
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 08:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C3E20719
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 08:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pgzjp0Su"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgKRIxn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:53:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:47760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgKRIxn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Nov 2020 03:53:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605689621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uibu+OMBtN5wk/b/FCAKad3yQwQwR3rPRKBTmOUHEZE=;
        b=pgzjp0SuGUGmXKPQK82ZBLhTw0KzvijEoGlYel+d/KCcqZUyuczQMZE1LHui/pRbgR36Oh
        xIkE3A27J/67bZV6br7+Uueit68lCTU2amoOSb8LAnELgrxpiGwmw83WHCFN60NafmkV1i
        JsXb+ksaTYM8ZrCmdqJgon60pckHu4s=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3EEB5ABF4
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2020 08:53:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 07/14] btrfs: extent_io: make set/clear_extent_buffer_uptodate() to support subpage size
Date:   Wed, 18 Nov 2020 16:53:12 +0800
Message-Id: <20201118085319.56668-8-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118085319.56668-1-wqu@suse.com>
References: <20201118085319.56668-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For those functions, to support subpage size they just need the follow work:
- set/clear uptodate bitmap
- set page Uptodate if the full range of the page is uptodate

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 40 ++++++++++++++++++++++++++++++++++++----
 fs/btrfs/extent_io.h |  1 +
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 090acf0e6a59..b3edd7fba5c8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5663,10 +5663,24 @@ bool set_extent_buffer_dirty(struct extent_buffer *eb)
 
 void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	int i;
-	struct page *page;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+	struct page *page = eb->pages[0];
 	int num_pages;
+	int i;
+
+	if (btrfs_is_subpage(fs_info)) {
+		struct btrfs_subpage *subpage;
+		int bit_start = (eb->start - page_offset(page)) >>
+				fs_info->sectorsize_bits;
+		int nbits = fs_info->nodesize >>
+				fs_info->sectorsize_bits;
 
+		subpage = (struct btrfs_subpage *)page->private;
+
+		spin_lock_bh(&subpage->lock);
+		bitmap_clear(subpage->uptodate_bitmap, bit_start, nbits);
+		spin_unlock_bh(&subpage->lock);
+	}
 	clear_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
@@ -5678,11 +5692,29 @@ void clear_extent_buffer_uptodate(struct extent_buffer *eb)
 
 void set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
-	int i;
-	struct page *page;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+	struct page *page = eb->pages[0];
 	int num_pages;
+	int i;
 
 	set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+	if (btrfs_is_subpage(fs_info)) {
+		struct btrfs_subpage *subpage;
+		int bit_start = (eb->start - page_offset(page)) >>
+				fs_info->sectorsize_bits;
+		int nbits = fs_info->nodesize >>
+				fs_info->sectorsize_bits;
+
+		subpage = (struct btrfs_subpage *)page->private;
+
+		spin_lock_bh(&subpage->lock);
+		bitmap_set(subpage->uptodate_bitmap, bit_start, nbits);
+		if (bitmap_full(subpage->uptodate_bitmap,
+				BTRFS_SUBPAGE_BITMAP_SIZE))
+			SetPageUptodate(page);
+		spin_unlock_bh(&subpage->lock);
+		return;
+	}
 	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
 		page = eb->pages[i];
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4251bef25aac..11e1e013cb8c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -311,6 +311,7 @@ blk_status_t btrfs_submit_read_repair(struct inode *inode,
 struct btrfs_subpage {
 	spinlock_t lock;
 	DECLARE_BITMAP(tree_block_bitmap, BTRFS_SUBPAGE_BITMAP_SIZE);
+	DECLARE_BITMAP(uptodate_bitmap, BTRFS_SUBPAGE_BITMAP_SIZE);
 };
 
 int btrfs_attach_subpage(struct btrfs_fs_info *fs_info, struct page *page);
-- 
2.29.2

