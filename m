Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105AFC2D0E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 14:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2123206F9
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Nov 2020 14:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FblKEmvY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389227AbgKXOoQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 09:44:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:39690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388162AbgKXOoP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Nov 2020 09:44:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1606229054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ue3oTddZ78Vaf06m9DggVdbjoALwN50Ro1tqvxTXT2M=;
        b=FblKEmvYcLnbNpguk+IaSKdPLMu9hAQZSOEEl8lOBhliWWZNKUMRW1RjDJDSYwb5Qv9g54
        d4jIeeEOwbLzF7KgSa+1x16qIgLs4XahRwhgf6AJPovIMpTgJNLoclvmlB+7WeeT4qs9NS
        kb6jy4Dy/p4ZFpP7Rr5+XAF76V6PdYs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A035CAC55;
        Tue, 24 Nov 2020 14:44:14 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Annotate unlocked accesses to transaction state
Date:   Tue, 24 Nov 2020 16:44:13 +0200
Message-Id: <20201124144413.3168075-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_transaction::state is protected by btrfs_fs_info::trans_lock and
all accesses to this variable should be synchornized by it. However,
there are 2 exceptions, namely checking if currently running transaction
has entered its commit phase in start_transaction and in
btrfs_should_end_transaction.

Annotate those 2, unlocked accesses with READ_ONCE respectively. Also
remove the full memory barrier in start_transaction as it provides no
ordering guarantees due to being unpaired. All other accsess  to
transaction state happen under trans_lock being held.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index df5687a92798..e5a5c3604a9b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -695,8 +695,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	h->can_flush_pending_bgs = true;
 	INIT_LIST_HEAD(&h->new_bgs);

-	smp_mb();
-	if (cur_trans->state >= TRANS_STATE_COMMIT_START &&
+	if (READ_ONCE(cur_trans->state) >= TRANS_STATE_COMMIT_START &&
 	    may_wait_transaction(fs_info, type)) {
 		current->journal_info = h;
 		btrfs_commit_transaction(h);
@@ -912,7 +911,7 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;

-	if (cur_trans->state >= TRANS_STATE_COMMIT_START ||
+	if (READ_ONCE(cur_trans->state) >= TRANS_STATE_COMMIT_START ||
 	    test_bit(BTRFS_DELAYED_REFS_FLUSHING,
 		     &cur_trans->delayed_refs.flags))
 		return 1;
--
2.25.1

