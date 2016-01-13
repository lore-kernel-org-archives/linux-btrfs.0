Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34018 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbcAMSVZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 13:21:25 -0500
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0DIIdRS003525
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jan 2016 10:21:25 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 20dtsu8b2t-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jan 2016 10:21:25 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: add transaction space reservation tracepoints
Date: Wed, 13 Jan 2016 13:21:20 -0500
Message-ID: <1452709280-8098-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a few places where we add to trans->bytes_reserved but don't have the
corresponding trace point.  With these added my tool no longer sees transaction
leaks.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/transaction.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f85ccf6..a4fec0c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -637,6 +637,8 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
 	trans->bytes_reserved = num_bytes;
+	trace_btrfs_space_reservation(root->fs_info, "transaction",
+				      trans->transid, num_bytes, 1);
 
 	return trans;
 }
@@ -1376,7 +1378,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	rsv = trans->block_rsv;
 	trans->block_rsv = &pending->block_rsv;
 	trans->bytes_reserved = trans->block_rsv->reserved;
-
+	trace_btrfs_space_reservation(root->fs_info, "transaction",
+				      trans->transid,
+				      trans->bytes_reserved, 1);
 	dentry = pending->dentry;
 	parent_inode = pending->dir;
 	parent_root = BTRFS_I(parent_inode)->root;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
