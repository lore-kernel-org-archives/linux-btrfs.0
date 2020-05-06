Return-Path: <SRS0=Eiyt=6U=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50739C38A2A
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 May 2020 13:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A4220746
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 May 2020 13:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgEFNXM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 May 2020 09:23:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728058AbgEFNXM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 May 2020 09:23:12 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9B9D2CFD35C662F401BB;
        Wed,  6 May 2020 21:23:07 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 21:23:00 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>
CC:     <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] btrfs: Remove unused inline function heads_to_leaves
Date:   Wed, 6 May 2020 21:22:39 +0800
Message-ID: <20200506132239.3252-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There's no callers in-tree anymore since commit 64403612b73a ("btrfs:
rework btrfs_check_space_for_delayed_refs")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/extent-tree.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index faa585d54eb7..3593f8cce9e5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2114,22 +2114,6 @@ static u64 find_middle(struct rb_root *root)
 }
 #endif
 
-static inline u64 heads_to_leaves(struct btrfs_fs_info *fs_info, u64 heads)
-{
-	u64 num_bytes;
-
-	num_bytes = heads * (sizeof(struct btrfs_extent_item) +
-			     sizeof(struct btrfs_extent_inline_ref));
-	if (!btrfs_fs_incompat(fs_info, SKINNY_METADATA))
-		num_bytes += heads * sizeof(struct btrfs_tree_block_info);
-
-	/*
-	 * We don't ever fill up leaves all the way so multiply by 2 just to be
-	 * closer to what we're really going to want to use.
-	 */
-	return div_u64(num_bytes, BTRFS_LEAF_DATA_SIZE(fs_info));
-}
-
 /*
  * Takes the number of bytes to be csumm'ed and figures out how many leaves it
  * would require to store the csums for that many bytes.
-- 
2.17.1


