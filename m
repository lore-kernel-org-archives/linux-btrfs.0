Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42025 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2INJAA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 05:00:00 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8E8xwEi000645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 08:59:59 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8E8xwVG028525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 08:59:58 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8E8xwi6025435
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 03:59:58 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs: fix trans block rsv regression
Date: Fri, 14 Sep 2012 16:58:04 +0800
Message-Id: <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some workloads we have nested joining transaction operations,
eg.
  run_delalloc_nocow
      btrfs_join_transaction
      cow_file_range
         btrfs_join_transaction

it can be a serious bug since each trans handler has only two
block_rsv, orig_rsv and block_rsv, which means we may lose our
first block_rsv after two joining transaction operations:

1) btrfs_start_transaction
      trans->block_rsv = A

2) btrfs_join_transaction
      trans->orig_rsv = trans->block_rsv; ---> orig_rsv is now A
      trans->block_rsv = B

3) btrfs_join_transaction
      trans->orig_rsv = trans->block_rsv; ---> orig_rsv is now B
      trans->block_rsv = C
   ...

This uses a list of block_rsv instead so that we can either
a) PUSH the old one into the list and use a new one in joining, or
b) POP the old one in ending this transaction.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c |   25 +++++++++++++++++++++----
 fs/btrfs/transaction.h |    7 ++++++-
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0c17d9e..a36ae05 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -306,9 +306,17 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK &&
 			type != TRANS_JOIN_ONLY);
 		h = current->journal_info;
-		h->use_count++;
-		h->orig_rsv = h->block_rsv;
+		if (h->block_rsv) {
+			struct btrfs_trans_rsv_item *item;
+			item = kmalloc(sizeof(*item), GFP_NOFS);
+			if (!item)
+				return ERR_PTR(-ENOMEM);
+			item->rsv = h->block_rsv;
+			INIT_LIST_HEAD(&item->list);
+			list_add(&item->list, &h->blk_rsv_list);
+		}
 		h->block_rsv = NULL;
+		h->use_count++;
 		goto got_it;
 	} else if (type == TRANS_JOIN_ONLY) {
 		return ERR_PTR(-ENOENT);
@@ -367,11 +375,11 @@ again:
 	h->use_count = 1;
 	h->adding_csums = 0;
 	h->block_rsv = NULL;
-	h->orig_rsv = NULL;
 	h->aborted = 0;
 	h->qgroup_reserved = qgroup_reserved;
 	h->delayed_ref_elem.seq = 0;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
+	INIT_LIST_HEAD(&h->blk_rsv_list);
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -523,7 +531,15 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	int err = 0;
 
 	if (--trans->use_count) {
-		trans->block_rsv = trans->orig_rsv;
+		trans->block_rsv = NULL;
+		if (!list_empty(&trans->blk_rsv_list)) {
+			struct btrfs_trans_rsv_item *item;
+			item = list_entry(trans->blk_rsv_list.next,
+					  struct btrfs_trans_rsv_item, list);
+			list_del_init(&item->list);
+			trans->block_rsv = item->rsv;
+			kfree(item);
+		}
 		return 0;
 	}
 
@@ -558,6 +574,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		count++;
 	}
 	btrfs_trans_release_metadata(trans, root);
+	BUG_ON(!list_empty(&trans->blk_rsv_list));
 	trans->block_rsv = NULL;
 
 	sb_end_intwrite(root->fs_info->sb);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 59adf55..7fa11b7 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -57,7 +57,6 @@ struct btrfs_trans_handle {
 	unsigned long delayed_ref_updates;
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
-	struct btrfs_block_rsv *orig_rsv;
 	int aborted;
 	int adding_csums;
 	/*
@@ -68,6 +67,12 @@ struct btrfs_trans_handle {
 	struct btrfs_root *root;
 	struct seq_list delayed_ref_elem;
 	struct list_head qgroup_ref_list;
+	struct list_head blk_rsv_list;
+};
+
+struct btrfs_trans_rsv_item {
+	struct btrfs_block_rsv *rsv;
+	struct list_head list;
 };
 
 struct btrfs_pending_snapshot {
-- 
1.7.7.6

