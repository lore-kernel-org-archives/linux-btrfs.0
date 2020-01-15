Return-Path: <SRS0=+Z9o=3E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BF8C33CB1
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 14:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB3862084D
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 14:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgAOOUp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 09:20:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8727 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728925AbgAOOUp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jan 2020 09:20:45 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5B02BC3A919C29B164B6;
        Wed, 15 Jan 2020 22:20:41 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 22:20:35 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>,
        <nborisov@suse.com>
CC:     <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] btrfs: Fix return value while kcalloc fails in btrfs_rmap_block
Date:   Wed, 15 Jan 2020 22:20:27 +0800
Message-ID: <20200115142027.56960-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In btrfs_rmap_block(), if kcalloc fails, it should return
-ENOMEM instead of 0.

Fixes: 767f58cdaf20 ("btrfs: Refactor btrfs_rmap_block to improve readability")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/block-group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8877af5..1485158 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1655,7 +1655,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 	*stripe_len = io_stripe_size;
 out:
 	free_extent_map(em);
-	return 0;
+	return ret;
 }
 
 static int exclude_super_stripes(struct btrfs_block_group *cache)
-- 
2.7.4


