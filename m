Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93702C6379D
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD36206F9
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ep70+G24"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389198AbgKXOt3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 09:49:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:46032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388014AbgKXOt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Nov 2020 09:49:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606229367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fYQDqI8dCzJoT3jaclWAYb78KQWmX+4lEklCvSOO5qc=;
        b=Ep70+G24iowkBJvSNKBDQL1NnkGrgsxQbhNq5autWy43PT51Ystw37uC4z/E+/dGaGenEp
        N6mZgfNn4io5ztgsKD6H/6CyFqX9/FY7Pv7/JamUoH87r0KEO5O8xvgWpILpDlY7ys9Lew
        9qcdDAWzc1rOuRFKBz7cwyhnHy80/dQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32A04AC2D;
        Tue, 24 Nov 2020 14:49:27 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Return bool from btrfs_should_end_transaction
Date:   Tue, 24 Nov 2020 16:49:25 +0200
Message-Id: <20201124144925.3172221-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Results in slightly smaller code.

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-11 (-11)
Function                                     old     new   delta
btrfs_should_end_transaction                  96      85     -11
Total: Before=20070, After=20059, chg -0.05%


Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 4 ++--
 fs/btrfs/transaction.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f7b7f18c6ab9..e425451c5811 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -907,14 +907,14 @@ static bool should_end_transaction(struct btrfs_trans_handle *trans)
 	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
 }

-int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
+bool btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;

 	if (READ_ONCE(cur_trans->state) >= TRANS_STATE_COMMIT_START ||
 	    test_bit(BTRFS_DELAYED_REFS_FLUSHING,
 		     &cur_trans->delayed_refs.flags))
-		return 1;
+		return true;

 	return should_end_transaction(trans);
 }
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 8241c050ba71..31ca81bad822 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -218,7 +218,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   int wait_for_unblock);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans);
-int btrfs_should_end_transaction(struct btrfs_trans_handle *trans);
+bool btrfs_should_end_transaction(struct btrfs_trans_handle *trans);
 void btrfs_throttle(struct btrfs_fs_info *fs_info);
 int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
--
2.25.1

