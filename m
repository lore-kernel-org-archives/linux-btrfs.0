Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54444 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaGJDUL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 23:20:11 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id BB6653EE0FB
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 12:20:09 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id B3116AC0A44
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 12:20:08 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 07B8F1DB803E
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 12:20:07 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
	by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 392FA6D650B
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 12:20:06 +0900 (JST)
Message-ID: <53BE0656.1020202@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 12:19:50 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: remove unnecessary error check
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
obviously "trans" is -ENOSPC. So we can safely remove the redundant
"(PTR_ERR(trans) == -ENOSPC)" check.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 fs/btrfs/inode.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..01bb43c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3803,22 +3803,21 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
-	if (PTR_ERR(trans) == -ENOSPC) {
-		u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
 
-		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
-			return trans;
-		ret = btrfs_cond_migrate_bytes(root->fs_info,
-					       &root->fs_info->trans_block_rsv,
-					       num_bytes, 5);
-		if (ret) {
-			btrfs_end_transaction(trans, root);
-			return ERR_PTR(ret);
-		}
-		trans->block_rsv = &root->fs_info->trans_block_rsv;
-		trans->bytes_reserved = num_bytes;
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return trans;
+	ret = btrfs_cond_migrate_bytes(root->fs_info,
+				       &root->fs_info->trans_block_rsv,
+				       num_bytes, 5);
+	if (ret) {
+		btrfs_end_transaction(trans, root);
+		return ERR_PTR(ret);
 	}
+	trans->block_rsv = &root->fs_info->trans_block_rsv;
+	trans->bytes_reserved = num_bytes;
+
 	return trans;
 }
 
-- 
1.9.3

