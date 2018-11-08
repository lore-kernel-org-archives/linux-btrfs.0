Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483C2C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 02:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC4420818
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 02:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EC4420818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbeKHLiQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 06:38:16 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:39977 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728379AbeKHLiQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 06:38:16 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D77B8FF6B9020;
        Thu,  8 Nov 2018 10:05:06 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Nov 2018 10:04:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btrfs: remove set but not used variable 'tree'
Date:   Thu, 8 Nov 2018 02:14:43 +0000
Message-ID: <1541643283-109411-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

fs/btrfs/extent_io.c: In function 'end_extent_writepage':
fs/btrfs/extent_io.c:2406:25: warning:
 variable 'tree' set but not used [-Wunused-but-set-variable]

It not used any more after
commit 2922040236f9 ("btrfs: Remove extent_io_ops::writepage_end_io_hook")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/extent_io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0f8f9c0..17a15cc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2403,11 +2403,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
-	struct extent_io_tree *tree;
 	int ret = 0;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-
 	btrfs_writepage_endio_finish_ordered(page, start, end, NULL, uptodate);
 
 	if (!uptodate) {



