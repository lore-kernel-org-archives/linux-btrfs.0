Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A268C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 02:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C46520818
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 02:05:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C46520818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbeKHLi4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 06:38:56 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34319 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728573AbeKHLi4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 06:38:56 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F2268FEDC58B6;
        Thu,  8 Nov 2018 10:05:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Nov 2018 10:05:30 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btrfs: compression: remove set but not used variable 'tree'
Date:   Thu, 8 Nov 2018 02:15:15 +0000
Message-ID: <1541643315-109723-1-git-send-email-yuehaibing@huawei.com>
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

fs/btrfs/compression.c: In function 'end_compressed_bio_write':
fs/btrfs/compression.c:232:25: warning:
 variable 'tree' set but not used [-Wunused-but-set-variable]

It not used any more after
commit 2922040236f9 ("btrfs: Remove extent_io_ops::writepage_end_io_hook")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/compression.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bde8d04..088570c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -229,7 +229,6 @@ static noinline void end_compressed_writeback(struct inode *inode,
  */
 static void end_compressed_bio_write(struct bio *bio)
 {
-	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
 	struct page *page;
@@ -248,7 +247,6 @@ static void end_compressed_bio_write(struct bio *bio)
 	 * call back into the FS and do all the end_io operations
 	 */
 	inode = cb->inode;
-	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
 	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
 			cb->start, cb->start + cb->len - 1, NULL,



