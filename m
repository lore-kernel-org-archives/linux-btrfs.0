Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A488CC10F0B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AF2F214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388044AbfDRGdi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:33:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57874 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733151AbfDRGdi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 02:33:38 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D67889D44AABF653ADA3;
        Thu, 18 Apr 2019 14:33:28 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.408.0; Thu, 18 Apr 2019 14:33:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] btrfs: Remove set but not used variable 'fs_info'
Date:   Thu, 18 Apr 2019 06:43:56 +0000
Message-ID: <20190418064356.10418-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

fs/btrfs/free-space-tree.c: In function 'load_free_space_tree':
fs/btrfs/free-space-tree.c:1535:24: warning:
 variable 'fs_info' set but not used [-Wunused-but-set-variable]

It's not used since commit 05e9d3137d47 ("btrfs: get fs_info from block group
in search_free_space_info"),  so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/free-space-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index cfe9dfb0ff05..f5dc115ebba0 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1532,14 +1532,12 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
 int load_free_space_tree(struct btrfs_caching_control *caching_ctl)
 {
 	struct btrfs_block_group_cache *block_group;
-	struct btrfs_fs_info *fs_info;
 	struct btrfs_free_space_info *info;
 	struct btrfs_path *path;
 	u32 extent_count, flags;
 	int ret;
 
 	block_group = caching_ctl->block_group;
-	fs_info = block_group->fs_info;
 
 	path = btrfs_alloc_path();
 	if (!path)



