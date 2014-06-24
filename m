Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:47723 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaFXPtJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 11:49:09 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so584996wes.26
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 08:49:08 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: assert send doesn't attempt to start transactions
Date: Tue, 24 Jun 2014 17:48:28 +0100
Message-Id: <1403628508-13711-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When starting a transaction just assert that current->journal_info
doesn't contain a send transaction stub, since send isn't supposed
to start transactions and when it finishes (either successfully or
not) it's supposed to set current->journal_info to NULL.

This is motivated by the change titled:

    Btrfs: fix crash when starting transaction

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 614eac3..47870ca 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -386,11 +386,13 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 	bool reloc_reserved = false;
 	int ret;
 
+	/* Send isn't supposed to start transactions. */
+	ASSERT(current->journal_info != (void *)BTRFS_SEND_TRANS_STUB);
+
 	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return ERR_PTR(-EROFS);
 
-	if (current->journal_info &&
-	    current->journal_info != (void *)BTRFS_SEND_TRANS_STUB) {
+	if (current->journal_info) {
 		WARN_ON(type & TRANS_EXTWRITERS);
 		h = current->journal_info;
 		h->use_count++;
-- 
1.9.1

