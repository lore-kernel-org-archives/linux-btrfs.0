Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C87C32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C63020825
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 08:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C63020825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbeKHRwc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 12:52:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:35014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726133AbeKHRwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 12:52:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8499AADF4
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 08:18:11 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Move epd::extent_locked check to writepage_delalloc's caller
Date:   Thu,  8 Nov 2018 10:18:06 +0200
Message-Id: <20181108081808.16920-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181108081808.16920-1-nborisov@suse.com>
References: <20181108081808.16920-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If epd::extent_locked is set then writepage_delalloc terminates. Make
this a bit more apparent in the caller by simply bubbling the check up.
This enables to remove epd as an argument to writepage_delalloc in a
future patch. No functional change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 46c299560f4f..e1ce07b2d33a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3215,8 +3215,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 	int ret;
 	int page_started = 0;
 
-	if (epd->extent_locked)
-		return 0;
 
 	while (delalloc_end < page_end) {
 		nr_delalloc = find_lock_delalloc_range(inode, tree,
@@ -3472,11 +3470,14 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 	set_page_extent_mapped(page);
 
-	ret = writepage_delalloc(inode, page, wbc, epd, start, &nr_written);
-	if (ret == 1)
-		goto done_unlocked;
-	if (ret)
-		goto done;
+	if (!epd->extent_locked) {
+		ret = writepage_delalloc(inode, page, wbc, epd, start,
+					 &nr_written);
+		if (ret == 1)
+			goto done_unlocked;
+		if (ret)
+			goto done;
+	}
 
 	ret = __extent_writepage_io(inode, page, wbc, epd,
 				    i_size, nr_written, write_flags, &nr);
-- 
2.17.1

