Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5215EC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 13:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADE9204EA
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 13:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHYNnb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:43:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:34940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgHYNnS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 09:43:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C39BAACDB;
        Tue, 25 Aug 2020 13:43:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Tyler Richmond <t.d.richmond@gmail.com>
Subject: [PATCH] btrfs: tree-checker: fix the error message for transid error
Date:   Tue, 25 Aug 2020 21:42:51 +0800
Message-Id: <20200825134251.31609-1-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The error message for inode transid is the same for inode generation,
which makes us unable to detect the real problem.

Reported-by: Tyler Richmond <t.d.richmond@gmail.com>
Fixes: 496245cac57e ("btrfs: tree-checker: Verify inode item")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 517b44300a05..7b1fee630f97 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -984,7 +984,7 @@ static int check_inode_item(struct extent_buffer *leaf,
 	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
 	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
 		inode_item_err(leaf, slot,
-			"invalid inode generation: has %llu expect [0, %llu]",
+			"invalid inode transid: has %llu expect [0, %llu]",
 			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
 		return -EUCLEAN;
 	}
-- 
2.28.0

