Return-Path: <SRS0=t89p=OY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F1DC43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 15 Dec 2018 06:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60C12080F
	for <linux-btrfs@archiver.kernel.org>; Sat, 15 Dec 2018 06:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbeLOGXd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 15 Dec 2018 01:23:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46729 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727757AbeLOGXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Dec 2018 01:23:33 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5455490B3CF2B;
        Sat, 15 Dec 2018 14:23:29 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.408.0; Sat, 15 Dec 2018 14:23:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btrfs: remove set but not used variable 'num_pages'
Date:   Sat, 15 Dec 2018 06:31:07 +0000
Message-ID: <1544855467-154115-1-git-send-email-yuehaibing@huawei.com>
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

fs/btrfs/ioctl.c: In function 'btrfs_extent_same':
fs/btrfs/ioctl.c:3260:6: warning:
 variable 'num_pages' set but not used [-Wunused-but-set-variable]

It not used any more since commit 9ee8234e6220 ("Btrfs: use
generic_remap_file_range_prep() for cloning and deduplication")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fab9443..15fc467 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3257,7 +3257,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
 	int ret;
-	int num_pages = PAGE_ALIGN(BTRFS_MAX_DEDUPE_LEN) >> PAGE_SHIFT;
 	u64 i, tail_len, chunk_count;
 
 	/* don't make the dst file partly checksummed */
@@ -3270,8 +3269,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
-	if (chunk_count == 0)
-		num_pages = PAGE_ALIGN(tail_len) >> PAGE_SHIFT;
 
 	for (i = 0; i < chunk_count; i++) {
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,



