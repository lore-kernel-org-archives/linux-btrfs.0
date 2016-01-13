Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44410 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbcAMQsM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 11:48:12 -0500
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0DGiAho019529
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jan 2016 08:48:11 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 20ddn8u755-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jan 2016 08:48:11 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: fix truncate_space_check
Date: Wed, 13 Jan 2016 11:48:06 -0500
Message-ID: <1452703686-6341-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

truncate_space_check is using btrfs_csum_bytes_to_leaves() but forgetting to
multiply by nodesize so we get an actual byte count.  We need a tracepoint here
so that we have the matching reserve for the release that will come later.  Also
add a comment to make clear what the intent of truncate_space_check is.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2b8a3fe..44d138a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4221,11 +4221,20 @@ static int truncate_space_check(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
+	/*
+	 * This is only used to apply pressure to the enospc system, we don't
+	 * intend to use this reservation at all.
+	 */
 	bytes_deleted = btrfs_csum_bytes_to_leaves(root, bytes_deleted);
+	bytes_deleted *= root->nodesize;
 	ret = btrfs_block_rsv_add(root, &root->fs_info->trans_block_rsv,
 				  bytes_deleted, BTRFS_RESERVE_NO_FLUSH);
-	if (!ret)
+	if (!ret) {
+		trace_btrfs_space_reservation(root->fs_info, "transaction",
+					      trans->transid,
+					      bytes_deleted, 1);
 		trans->bytes_reserved += bytes_deleted;
+	}
 	return ret;
 
 }
-- 
1.8.3.1

