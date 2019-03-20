Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24560C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF0B32184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfCTG2M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:28:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:39840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727452AbfCTG2M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:28:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6ACF3AC3B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:28:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.3 09/11] btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
Date:   Wed, 20 Mar 2019 14:27:47 +0800
Message-Id: <20190320062749.30953-10-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320062749.30953-1-wqu@suse.com>
References: <20190320062749.30953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In extent_write_cache_pages() since flush_write_bio() can return error,
we need some extra error handling.

For the first flush_write_bio() since we haven't locked the page, we
only need to exit the loop.

For the seconds flush_write_bio() call, we have the page locked, despite
that there is nothing special need to handle.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5de18900a3c3..c38058398d75 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4000,7 +4000,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
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
 
@@ -4012,7 +4015,11 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (PageWriteback(page)) {
 					ret = flush_write_bio(epd);
-					BUG_ON(ret < 0);
+					if (ret < 0) {
+						unlock_page(page);
+						done = 1;
+						break;
+					}
 				}
 				wait_on_page_writeback(page);
 			}
-- 
2.21.0

