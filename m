Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55657 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGKBix (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 21:38:53 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id DDAD63EE1D6
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 10:38:51 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id EB2A1AC09F7
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 10:38:50 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 645DF1DB8038
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Jul 2014 10:38:50 +0900 (JST)
Message-ID: <53BF3F71.1010703@jp.fujitsu.com>
Date: Fri, 11 Jul 2014 10:35:45 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <sandeen@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] btrfs: remove unnecessary error check
References: <53BE0656.1020202@jp.fujitsu.com> <797384C7-AC2D-45A3-BAAC-B5C717B0C6F1@redhat.com> <53BE3662.5060201@jp.fujitsu.com> <53BE94C6.6000502@redhat.com>
In-Reply-To: <53BE94C6.6000502@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

(2014/07/10 22:27), Eric Sandeen wrote:
> On 7/10/14, 1:44 AM, Satoru Takeuchi wrote:
>> (2014/07/10 12:26), Eric Sandeen wrote:
>>>
>>>
>>>> On Jul 9, 2014, at 10:20 PM, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
>>>>
>>>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>>>
>>>> If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
>>>> obviously "trans" is -ENOSPC. So we can safely remove the redundant
>>>> "(PTR_ERR(trans) == -ENOSPC)" check.
>>>>
>>>
>>> True, but now a comment like:
>>>
>>> /* Handle ENOSPC */
>>>
>>> might still be nice...
>>
>> Eric, thank you for your comment. I fixed my patch.
>> How about is it?
>
> One other thing I missed the first time, I'm sorry, notes below:
>
>>
>> ===
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
>> obviously "trans" is -ENOSPC. So we can safely remove the redundant
>> "(PTR_ERR(trans) == -ENOSPC)" check.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> ---
>>   fs/btrfs/inode.c | 29 +++++++++++++++--------------
>>   1 file changed, 15 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 3668048..115aac3 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -3803,22 +3803,23 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
>>       if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
>>           return trans;
>>
>> -    if (PTR_ERR(trans) == -ENOSPC) {
>> -        u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
>> +    /* Handle ENOSPC */
>>
>> -        trans = btrfs_start_transaction(root, 0);
>> -        if (IS_ERR(trans))
>> -            return trans;
>> -        ret = btrfs_cond_migrate_bytes(root->fs_info,
>> -                           &root->fs_info->trans_block_rsv,
>> -                           num_bytes, 5);
>> -        if (ret) {
>> -            btrfs_end_transaction(trans, root);
>> -            return ERR_PTR(ret);
>> -        }
>> -        trans->block_rsv = &root->fs_info->trans_block_rsv;
>> -        trans->bytes_reserved = num_bytes;
>> +    u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
>
> This variable should be declared at the beginning of the function,
> not in the middle, because it's no longer in a separate code block.

OK, moved.

>
> Also, somehow by the time the patch got here, tabs turned into
> 4 spaces, so this one wouldn't apply for me.

I did't realize that. Thank you.
>
> Sorry for missing the variable declaration problem the first time!

No problem, more review is welcome. THank you very much :-)

This is the v3 patch.

===
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
obviously "trans" is -ENOSPC. So we can safely remove the redundant
"(PTR_ERR(trans) == -ENOSPC)" check.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
  fs/btrfs/inode.c | 28 ++++++++++++++--------------
  1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..e7ac779 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3790,6 +3790,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
  {
  	struct btrfs_trans_handle *trans;
  	struct btrfs_root *root = BTRFS_I(dir)->root;
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
  	int ret;
  
  	/*
@@ -3803,22 +3804,21 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
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
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return trans;
+	ret = btrfs_cond_migrate_bytes(root->fs_info,
+					&root->fs_info->trans_block_rsv,
+					num_bytes, 5);
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

