Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B7CC10F02
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9306218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfBRF2T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 00:28:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:55956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727048AbfBRF2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 00:28:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77DD2AEF5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 05:28:15 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.1 10/12] btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
Date:   Mon, 18 Feb 2019 13:27:51 +0800
Message-Id: <20190218052753.24138-11-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>
References: <20190218052753.24138-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1572e892ec7b..480e138051f0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3998,7 +3998,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 */
 			if (!trylock_page(page)) {
 				ret = flush_write_bio(epd);
-				BUG_ON(ret < 0);
+				if (ret < 0) {
+					done = 1;
+					break;
+				}
 				lock_page(page);
 			}
 
@@ -4010,7 +4013,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (PageWriteback(page)) {
 					ret = flush_write_bio(epd);
-					BUG_ON(ret < 0);
+					if (ret < 0) {
+						done = 1;
+						break;
+					}
 				}
 				wait_on_page_writeback(page);
 			}
-- 
2.20.1

