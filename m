Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:17691 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2INLad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 07:30:33 -0400
Message-ID: <50531550.9070204@oracle.com>
Date: Fri, 14 Sep 2012 19:30:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: fix deadlock with freeze and sync
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com> <505301F5.9020802@cn.fujitsu.com>
In-Reply-To: <505301F5.9020802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2012 06:07 PM, Miao Xie wrote:
> On 	fri, 14 Sep 2012 16:58:03 +0800, Liu Bo wrote:
>> While testing xfstests 068, I realized that
>>
>> commit bd7de2c9a449e26a5493d918618eb20ae60d56bd
>> (Btrfs: fix deadlock with freeze and sync V2)
>>
>> did not fix the bug yet, since someone might jump in between checking
>> running transaction and joining transaction, and we may still run into
>> deadlock between freeze and sync.
> 
> Did you meet the problem by test? 
> I think it is impossible to happen, because nobody can start a new transaction
> after the filesystem is froze, so the ->running_transaction check must be false
> when syncing the filesystem. And beside that this patch is wrong(Please see below).
> 

Yes, I knew the reason but I did run into the same deadlock.

>> So IMO the safest and most efficient way is to check running transaction
>> in joining a transaction directly.
>>
>> With this patch, I tested xfstests 068 for 120 times and it did not get
>> into deadlock at least here.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>  fs/btrfs/super.c       |    9 +--------
>>  fs/btrfs/transaction.c |   11 ++++++++++-
>>  fs/btrfs/transaction.h |    1 +
>>  3 files changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index abb9081..02a3961 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -852,14 +852,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>>  
>>  	btrfs_wait_ordered_extents(root, 0, 0);
>>  
>> -	spin_lock(&fs_info->trans_lock);
>> -	if (!fs_info->running_transaction) {
>> -		spin_unlock(&fs_info->trans_lock);
>> -		return 0;
>> -	}
>> -	spin_unlock(&fs_info->trans_lock);
>> -
>> -	trans = btrfs_join_transaction(root);
>> +	trans = btrfs_join_transaction_only(root);
>>  	if (IS_ERR(trans))
>>  		return PTR_ERR(trans);
>>  	return btrfs_commit_transaction(trans, root);
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 27c2600..0c17d9e 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -272,6 +272,7 @@ enum btrfs_trans_type {
>>  	TRANS_JOIN,
>>  	TRANS_USERSPACE,
>>  	TRANS_JOIN_NOLOCK,
>> +	TRANS_JOIN_ONLY,
>>  };
>>  
>>  static int may_wait_transaction(struct btrfs_root *root, int type)
>> @@ -302,12 +303,15 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>>  		return ERR_PTR(-EROFS);
>>  
>>  	if (current->journal_info) {
>> -		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK);
>> +		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK &&
>> +			type != TRANS_JOIN_ONLY);
>>  		h = current->journal_info;
>>  		h->use_count++;
>>  		h->orig_rsv = h->block_rsv;
>>  		h->block_rsv = NULL;
>>  		goto got_it;
>> +	} else if (type == TRANS_JOIN_ONLY) {
>> +		return ERR_PTR(-ENOENT);
>>  	}
> 
> the code here is wrong, it makes the sync task skip the transaction commit because
> ->journal_info of the sync task is always NULL(Only ->journal_info of the task which
> starts transaction before it end the current transaction is !0).
> 

I've double checked this and realized what you're saying is reasonable.
So there must be something wrong elsewhere, I'll look into it :)

Thanks a LOT!

- liubo

