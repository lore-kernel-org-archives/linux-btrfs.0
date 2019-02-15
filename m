Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B29C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 10:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E333A21900
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 10:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405880AbfBOKvT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:51:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:54662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389255AbfBOKvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 05:51:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8CD03AF6F
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 10:51:17 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5 10/12] btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
Date:   Fri, 15 Feb 2019 18:50:42 +0800
Message-Id: <20190215105044.17619-11-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215105044.17619-1-wqu@suse.com>
References: <20190215105044.17619-1-wqu@suse.com>
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

