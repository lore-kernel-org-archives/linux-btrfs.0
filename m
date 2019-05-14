Return-Path: <SRS0=HdJy=TO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FA4C04AB4
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 May 2019 10:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 535442085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 May 2019 10:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfENKzD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 May 2019 06:55:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:40870 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbfENKyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 May 2019 06:54:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 157ADAF95
        for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2019 10:54:49 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/8] btrfs: Explicitly reserve space for devreplace item
Date:   Tue, 14 May 2019 13:54:43 +0300
Message-Id: <20190514105445.23051-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190514105445.23051-1-nborisov@suse.com>
References: <20190514105445.23051-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Part of device replace involves writing an item to the device root
containing information about pending replace operations. Currently space
for this item is not being explicitly reserved so this works thanks to
presence of global reserve. While not fatal it's not good practice.
Let's be explicit about space requirement of device replace and reserve
space when starting the transaction.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/dev-replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 61ae43308192..fb2bbc2a53a9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -477,8 +477,8 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 
-	/* force writing the updated state information to disk */
-	trans = btrfs_start_transaction(root, 0);
+	/* Commit dev_replace state and reserve 1 item for it. */
+	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		down_write(&dev_replace->rwsem);
-- 
2.17.1

