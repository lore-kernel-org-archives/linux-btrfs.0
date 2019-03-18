Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4457DC10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F8C20872
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 15:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfCRPp0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:45:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:44294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726808AbfCRPpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 11:45:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B219EAEEE
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 15:45:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Avoid possible qgroup_rsv_size overflow in btrfs_calculate_inode_block_rsv_size
Date:   Mon, 18 Mar 2019 17:45:20 +0200
Message-Id: <20190318154520.4086-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190318154520.4086-1-nborisov@suse.com>
References: <20190318154520.4086-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

qgroup_rsv_size is calculated as the product of
outstanding_extent * fs_info->nodesize. The product is calculated with
32 bith precision since both variables are defined as u32. Yet
qgroup_rsv_size expects a 64 bit result.

Avoid possible multiplication overflow by casting outstanding_extent to
u64.

Fixes-coverity-id: 1435101
ff6bc37eb7f6 ("btrfs: qgroup: Use independent and accurate per inode qgroup rsv")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b085d8215f0e..beddf9eef4a2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6173,7 +6173,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	 *
 	 * This is overestimating in most cases.
 	 */
-	qgroup_rsv_size = outstanding_extents * fs_info->nodesize;
+	qgroup_rsv_size = (u64) outstanding_extents * fs_info->nodesize;
 
 	spin_lock(&block_rsv->lock);
 	block_rsv->size = reserve_size;
-- 
2.17.1

