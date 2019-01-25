Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2A9C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4453218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfAYFJl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:56172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfAYFJk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACB4BAE03
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 05:09:39 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 05/12] btrfs: extent_io: Kill the BUG_ON() in extent_write_full_page()
Date:   Fri, 25 Jan 2019 13:09:18 +0800
Message-Id: <20190125050925.30754-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This one is pretty straightforward, __extent_writepage() can only return
<0 or 0.

So if we hit error from __extent_writepage(), then return the error.
Or return the value from flush_write_bio().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6f1982f8ad5c..bc3426dff5a3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3424,6 +3424,9 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
  * records are inserted to lock ranges in the tree, and as dirty areas
  * are found, they are marked writeback.  Then the lock bits are removed
  * and the end_io handler clears the writeback ranges
+ *
+ * Return 0 if everything goes well.
+ * Return <0 for error.
  */
 static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      struct extent_page_data *epd)
@@ -3493,6 +3496,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		end_extent_writepage(page, ret, start, page_end);
 	}
 	unlock_page(page);
+	ASSERT(ret <= 0);
 	return ret;
 
 done_unlocked:
@@ -4044,8 +4048,10 @@ int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 	ret = __extent_writepage(page, wbc, &epd);
 
 	flush_ret = flush_write_bio(&epd);
-	BUG_ON(flush_ret < 0);
-	return ret;
+	ASSERT(ret <= 0);
+	if (ret)
+		return ret;
+	return flush_ret;
 }
 
 int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
-- 
2.20.1

