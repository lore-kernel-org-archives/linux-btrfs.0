Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933083AbdKORoE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92B66AAAD
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: switch to refcount_t type for btrfs_trans_handle::use_count
Date: Wed, 15 Nov 2017 18:41:59 +0100
Message-Id: <cda18ee5cf6a36a74241a0df3dc997fcf5aefc8c.1510767175.git.dsterba@suse.com>
In-Reply-To: <cover.1510767175.git.dsterba@suse.com>
References: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The use_count is a reference counter, we can use the refcount_t type,
though we don't use the atomicity. This is not a performance critical
code and we could catch the underflows. The type is changed from long,
but the number of references will fit an int.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 12 ++++++------
 fs/btrfs/transaction.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dac688c696c3..6348573e26a7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -495,8 +495,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	if (current->journal_info) {
 		WARN_ON(type & TRANS_EXTWRITERS);
 		h = current->journal_info;
-		h->use_count++;
-		WARN_ON(h->use_count > 2);
+		refcount_inc(&h->use_count);
+		WARN_ON(refcount_read(&h->use_count) > 2);
 		h->orig_rsv = h->block_rsv;
 		h->block_rsv = NULL;
 		goto got_it;
@@ -567,7 +567,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	h->transid = cur_trans->transid;
 	h->transaction = cur_trans;
 	h->root = root;
-	h->use_count = 1;
+	refcount_set(&h->use_count, 1);
 	h->fs_info = root->fs_info;
 
 	h->type = type;
@@ -837,8 +837,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	int err = 0;
 	int must_run_delayed_refs = 0;
 
-	if (trans->use_count > 1) {
-		trans->use_count--;
+	if (refcount_read(&trans->use_count) > 1) {
+		refcount_dec(&trans->use_count);
 		trans->block_rsv = trans->orig_rsv;
 		return 0;
 	}
@@ -1868,7 +1868,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	DEFINE_WAIT(wait);
 
-	WARN_ON(trans->use_count > 1);
+	WARN_ON(refcount_read(&trans->use_count) > 1);
 
 	btrfs_abort_transaction(trans, err);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index c48a4a03f1b4..afa88f035654 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -111,7 +111,7 @@ struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
 	u64 chunk_bytes_reserved;
-	unsigned long use_count;
+	refcount_t use_count;
 	unsigned long delayed_ref_updates;
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
-- 
2.14.3

