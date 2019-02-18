Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C34DC4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F22218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 05:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfBRF2U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 00:28:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:55906 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbfBRF2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 00:28:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DBF2AEF5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 05:28:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.1 07/12] btrfs: extent_io: Kill the dead branch in extent_write_cache_pages()
Date:   Mon, 18 Feb 2019 13:27:48 +0800
Message-Id: <20190218052753.24138-8-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>
References: <20190218052753.24138-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since __extent_writepage() will no longer return >0 value,
(ret == AOP_WRITEPAGE_ACTIVATE) will never be true.

Kill that dead branch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b0bb4f0e15b9..aad417015fe2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4007,11 +4007,6 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			}
 
 			ret = __extent_writepage(page, wbc, epd);
-
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
-				unlock_page(page);
-				ret = 0;
-			}
 			if (ret < 0) {
 				/*
 				 * done_index is set past this page,
-- 
2.20.1

