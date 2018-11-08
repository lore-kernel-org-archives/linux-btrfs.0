Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFA3ECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B950C2086A
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B950C2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbeKHRwd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 12:52:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:35020 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726469AbeKHRwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 12:52:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8083ADFE
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 08:18:11 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Remove extent_page_data argument from writepage_delalloc
Date:   Thu,  8 Nov 2018 10:18:07 +0200
Message-Id: <20181108081808.16920-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181108081808.16920-1-nborisov@suse.com>
References: <20181108081808.16920-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The only remaining use of the 'epd' argument in writepage_delalloc is
to reference the extent_io_tree which was set in extent_writepages. Since
it is guaranteed that page->mapping of any page passed to
writepage_delalloc (and __extent_writepage as the sole caller) to be
equal to that passed in extent_writepages we can directly get the
io_tree via the already passed inode (which is also taken from
page->mapping->host). No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e1ce07b2d33a..cca9d3cbe74a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3202,12 +3202,12 @@ static void update_nr_written(struct writeback_control *wbc,
  * This returns < 0 if there were errors (page still locked)
  */
 static noinline_for_stack int writepage_delalloc(struct inode *inode,
-			      struct page *page, struct writeback_control *wbc,
-			      struct extent_page_data *epd,
-			      u64 delalloc_start,
-			      unsigned long *nr_written)
+						 struct page *page,
+						 struct writeback_control *wbc,
+						 u64 delalloc_start,
+						 unsigned long *nr_written)
 {
-	struct extent_io_tree *tree = epd->tree;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	u64 page_end = delalloc_start + PAGE_SIZE - 1;
 	u64 nr_delalloc;
 	u64 delalloc_to_write = 0;
@@ -3471,8 +3471,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	set_page_extent_mapped(page);
 
 	if (!epd->extent_locked) {
-		ret = writepage_delalloc(inode, page, wbc, epd, start,
-					 &nr_written);
+		ret = writepage_delalloc(inode, page, wbc, start, &nr_written);
 		if (ret == 1)
 			goto done_unlocked;
 		if (ret)
-- 
2.17.1

