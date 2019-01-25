Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D92DC282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 387D0218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfAYFJu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:56218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbfAYFJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CCF3ADF5
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 05:09:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 10/12] btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
Date:   Fri, 25 Jan 2019 13:09:23 +0800
Message-Id: <20190125050925.30754-11-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 52c1b0ce6bfd..0d1f09b41421 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3980,7 +3980,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
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
 
@@ -3992,7 +3995,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
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

