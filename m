From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when throttling transactions
Date: Fri, 15 Jul 2011 09:54:55 -0400
Message-ID: <4E2046AF.3030405@redhat.com>
References: <1310664370-20091-1-git-send-email-josef@redhat.com> <4E1FAC6A.3050501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1FAC6A.3050501@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2011 10:56 PM, liubo wrote:
> On 07/15/2011 01:26 AM, Josef Bacik wrote:
>> Hit this nice little deadlock.  What happens is this
>>
>> __btrfs_end_transaction with throttle set, --use_count so it equals 0
>>   btrfs_commit_transaction
>>     <somebody else actually manages to start the commit>
>>     btrfs_end_transaction --use_count so now its -1 <== BAD
>>       we just return and wait on the transaction
>>
>> This is bad because we just return after our use_count is -1 and don't let go
>> of our num_writer count on the transaction, so the guy committing the
>> transaction just sits there forever.  Fix this by inc'ing our use_count if we're
>> going to call commit_transaction so that if we call btrfs_end_transaction it's
>> valid.  Thanks,
>>
>> Signed-off-by: Josef Bacik <josef@redhat.com>
>> ---
>>  fs/btrfs/transaction.c |   13 ++++++++++---
>>  1 files changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 654755b..00b81fb5 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -497,10 +497,17 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>>  	}
>>  
>>  	if (lock && cur_trans->blocked && !cur_trans->in_commit) {
>> -		if (throttle)
>> +		if (throttle) {
>> +			/*
>> +			 * We may race with somebody else here so end up having
>> +			 * to call end_transaction on ourselves again, so inc
>> +			 * our use_count.
>> +			 */
>> +			trans->use_count++;
>>  			return btrfs_commit_transaction(trans, root);
>> -		else
>> +		} else {
>>  			wake_up_process(info->transaction_kthread);
>> +		}
>>  	}
>>  
>>  	WARN_ON(cur_trans != info->running_transaction);
>> @@ -1225,7 +1232,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  	if (cur_trans->in_commit) {
>>  		spin_unlock(&cur_trans->commit_lock);
>>  		atomic_inc(&cur_trans->use_count);
>> -		btrfs_end_transaction(trans, root);
>> +		__btrfs_end_transaction(trans, root, 0, 1);
>>  
> 
> Looks good.
> 
> BTW, btrfs_end_transaction(trans, root) is just __btrfs_end_transaction(trans, root, 0, 1).
> 

Oops you're right, I saw the 1 for lock and thought it was for throttle.
 Thanks,

Josef
