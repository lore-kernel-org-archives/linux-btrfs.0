Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40116 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaGJGpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 02:45:03 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 0DE9B3EE1D0
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 15:45:01 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E8975AC083E
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 15:44:59 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5F6561DB8037
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 15:44:59 +0900 (JST)
Message-ID: <53BE3662.5060201@jp.fujitsu.com>
Date: Thu, 10 Jul 2014 15:44:50 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <esandeen@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs: remove unnecessary error check
References: <53BE0656.1020202@jp.fujitsu.com> <797384C7-AC2D-45A3-BAAC-B5C717B0C6F1@redhat.com>
In-Reply-To: <797384C7-AC2D-45A3-BAAC-B5C717B0C6F1@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/10 12:26), Eric Sandeen wrote:
>
>
>> On Jul 9, 2014, at 10:20 PM, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
>>
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
>> obviously "trans" is -ENOSPC. So we can safely remove the redundant
>> "(PTR_ERR(trans) == -ENOSPC)" check.
>>
>
> True, but now a comment like:
>
> /* Handle ENOSPC */
>
> might still be nice...

Eric, thank you for your comment. I fixed my patch.
How about is it?


===
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
obviously "trans" is -ENOSPC. So we can safely remove the redundant
"(PTR_ERR(trans) == -ENOSPC)" check.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
  fs/btrfs/inode.c | 29 +++++++++++++++--------------
  1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..115aac3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3803,22 +3803,23 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
  	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
  		return trans;
  
-	if (PTR_ERR(trans) == -ENOSPC) {
-		u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
+	/* Handle ENOSPC */
  
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
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
+
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

