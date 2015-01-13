Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63049 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbAMSvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 13:51:00 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so4723451wgh.8
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 10:50:58 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: transaction: Remove unused function
Date: Tue, 13 Jan 2015 19:54:06 +0100
Message-Id: <1421175246-6448-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove the function btrfs_start_transaction_lflush() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/btrfs/transaction.c |    7 -------
 fs/btrfs/transaction.h |    2 --
 2 files changed, 9 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dcaae36..51003ce 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -534,13 +534,6 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 				 BTRFS_RESERVE_FLUSH_ALL);
 }
 
-struct btrfs_trans_handle *btrfs_start_transaction_lflush(
-					struct btrfs_root *root, int num_items)
-{
-	return start_transaction(root, num_items, TRANS_START,
-				 BTRFS_RESERVE_FLUSH_LIMIT);
-}
-
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN, 0);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d8f40e1..027e49e 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -136,8 +136,6 @@ int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
-struct btrfs_trans_handle *btrfs_start_transaction_lflush(
-					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
-- 
1.7.10.4

