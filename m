Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab2KTDEl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 22:04:41 -0500
Message-ID: <50AAEF55.1030008@cn.fujitsu.com>
Date: Tue, 20 Nov 2012 10:47:49 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Daniel J Blueman <daniel@quora.org>, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH RESEND] Btrfs: fix deadlock when the process of delayed
 refs fails
References: <50A9F9C6.6090901@cn.fujitsu.com> <20121119101847.GA8692@gmail.com>
In-Reply-To: <20121119101847.GA8692@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 19 Nov 2012 18:18:48 +0800, Liu Bo wrote:
>> @@ -2316,14 +2315,12 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>>  				if (ret) {
>>  					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
>>  					spin_lock(&delayed_refs->lock);
>> +					btrfs_delayed_ref_unlock(locked_ref);
>>  					return ret;
>>  				}
>>  
>>  				goto next;
>>  			}
>> -
>> -			list_del_init(&locked_ref->cluster);
>> -			locked_ref = NULL;
>>  		}
>>  
>>  		ref->in_tree = 0;
>> @@ -2350,11 +2347,24 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>>  
>>  		ret = run_one_delayed_ref(trans, root, ref, extent_op,
>>  					  must_insert_reserved);
>> -
>> -		btrfs_put_delayed_ref(ref);
>>  		kfree(extent_op);
>>  		count++;
>>  
>> +		/*
>> +		 * If this node is a head, we will pick the next head to deal
>> +		 * with. If there is something wrong when we process the
>> +		 * delayed ref, we will end our operation. So in these two
>> +		 * cases, we have to unlock the head and drop it from the
>> +		 * cluster list before we release it though the code is ugly.
>> +		 */
>> +		if (btrfs_delayed_ref_is_head(ref) || ret) {
>> +			list_del_init(&locked_ref->cluster);
>> +			btrfs_delayed_ref_unlock(locked_ref);
>> +			locked_ref = NULL;
>> +		}
>> +
> 
> In case that we don't remove mutex_unlock above,
> 
> if ret is non-zero, either
> A)locked_ref is not NULL, or
> B)locked_ref is NULL, and it has done list_del_init above and
>   also done mutex_unlock in run_one_delayed_ref().
> 
> So in the case A), it is ok to do list_del_init() and mutex_unlock(),
> while in the case B), we need to do nothing.
> 
> Then the code can be clean as we wish,
> if (ret) {
> 	if (locked_ref) {
> 		list_del_init();
> 		mutex_unlock();
> 	}
> 	...
> }

I think it is not good style that locking/unlocking a lock in the different functions, because
it is error prone and the readability of the code is very bad, so I remove mutex_unlock() in
run_one_delayed_ref().

Maybe I should not mix the code of the error path into the normal one, I will send out a new patch
to make the code cleaner and more readable.

Thanks
Miao
