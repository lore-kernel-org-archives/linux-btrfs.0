Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93066C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA03218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 05:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfAYFJw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:09:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:56226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbfAYFJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 00:09:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06204AE03
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2019 05:09:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 11/12] btrfs: extent_io: Kill the BUG_ON() in extent_writepages()
Date:   Fri, 25 Jan 2019 13:09:24 +0800
Message-Id: <20190125050925.30754-12-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125050925.30754-1-wqu@suse.com>
References: <20190125050925.30754-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The @ret from extent_write_cache_pages() can only be 0 or <0, so we only
need to return @ret if something went wrong, or just return @flush_ret.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0d1f09b41421..ec03f4727786 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4130,8 +4130,10 @@ int extent_writepages(struct address_space *mapping,
 
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
 	flush_ret = flush_write_bio(&epd);
-	BUG_ON(flush_ret < 0);
-	return ret;
+	ASSERT(ret <= 0);
+	if (ret)
+		return ret;
+	return flush_ret;
 }
 
 int extent_readpages(struct address_space *mapping, struct list_head *pages,
-- 
2.20.1

