Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602A4C282D8
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC9620882
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfA3OvG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:38094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731387AbfA3OvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C244DB07B
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:04 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/15] btrfs: Make WARN_ON in a canonical form
Date:   Wed, 30 Jan 2019 16:50:49 +0200
Message-Id: <20190130145102.4708-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-1-nborisov@suse.com>
References: <20190130145102.4708-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is no point in using a construct like 'if (!condition)
WARN_ON(1)'. Use WARN_ON(!condition) directly. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fc3f6acc3c9b..79d0bc813a72 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10798,13 +10798,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	}
 
 	spin_lock(&trans->transaction->dirty_bgs_lock);
-	if (!list_empty(&block_group->dirty_list)) {
-		WARN_ON(1);
-	}
-	if (!list_empty(&block_group->io_list)) {
-		WARN_ON(1);
-	}
+	WARN_ON(!list_empty(&block_group->dirty_list));
+	WARN_ON(!list_empty(&block_group->io_list));
 	spin_unlock(&trans->transaction->dirty_bgs_lock);
+
 	btrfs_remove_free_space_cache(block_group);
 
 	spin_lock(&block_group->space_info->lock);
-- 
2.17.1

