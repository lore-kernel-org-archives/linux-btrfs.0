Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BEBC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2743218EA
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfBRF2T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 00:28:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:55966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727105AbfBRF2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 00:28:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 108E6AEF6
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 05:28:17 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5.1 11/12] btrfs: extent_io: Handle error better in extent_writepages()
Date:   Mon, 18 Feb 2019 13:27:52 +0800
Message-Id: <20190218052753.24138-12-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>
References: <20190218052753.24138-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Do proper cleanup if we hit any error in extent_writepages(),
and check the return value of flush_write_bio().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 480e138051f0..5db36dbfeb87 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4141,7 +4141,6 @@ int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
 	int ret = 0;
-	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(mapping->host)->io_tree,
@@ -4150,8 +4149,12 @@ int extent_writepages(struct address_space *mapping,
 	};
 
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	flush_ret = flush_write_bio(&epd);
-	BUG_ON(flush_ret < 0);
+	ASSERT(ret <= 0);
+	if (ret < 0) {
+		end_write_bio(&epd, ret);
+		return ret;
+	}
+	ret = flush_write_bio(&epd);
 	return ret;
 }
 
-- 
2.20.1

