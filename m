Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D304C56201
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3FC8206F9
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Wt5AU5/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388811AbgKXOtL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 09:49:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:45730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388014AbgKXOtL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Nov 2020 09:49:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606229350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LCFERqfljLtNoHvxTzr6CvYEhz7hPdSHXjUZcYelr6w=;
        b=Wt5AU5/UpNIywBHtv73V1yBJPZD6jkBOhe/SjHlQctlUVh7UNPqo/nycheHxj9CAFy4nin
        UsAzH9Lsw+WgJ2EehqYz+4YMNT9pg8MkfjUHWt71eSz+z5gP2nvaud7av5hyHcnssVRB/o
        N7jZAF8Mf5NspgidKv8EyK5RlBgWT9c=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D4C3AC2D;
        Tue, 24 Nov 2020 14:49:10 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Return bool from should_end_transaction
Date:   Tue, 24 Nov 2020 16:49:08 +0200
Message-Id: <20201124144908.3172095-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fd4293cf69cf..f7b7f18c6ab9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -897,12 +897,12 @@ void btrfs_throttle(struct btrfs_fs_info *fs_info)
 	wait_current_trans(fs_info);
 }

-static int should_end_transaction(struct btrfs_trans_handle *trans)
+static bool should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;

 	if (btrfs_check_space_for_delayed_refs(fs_info))
-		return 1;
+		return true;

 	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
 }
--
2.25.1

