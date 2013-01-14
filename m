Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab3ANHQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 02:16:33 -0500
Message-ID: <50F3B0F8.4040604@cn.fujitsu.com>
Date: Mon, 14 Jan 2013 15:17:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 11/11] Btrfs: Add ACCESS_ONCE() to transaction->abort
 accesses
References: <50EEB9AF.2010301@cn.fujitsu.com> <20130110173800.GH20089@twin.jikos.cz>
In-Reply-To: <20130110173800.GH20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 10 Jan 2013 18:38:00 +0100, David Sterba wrote:
> On Thu, Jan 10, 2013 at 08:53:03PM +0800, Miao Xie wrote:
>> We may access and update transaction->abort on the different CPUs without lock,
>> so we need ACCESS_ONCE() wrapper to make sure we can get the new value.
> 
> ACCESS_ONCE is not the right synchronization primitive to be used here,
> it is a way to force compiler to generate a single access to the data
> through out the varaible scope, this does not have impact on inter-cpu
> synchronization. This does not give a guarantee of the latest value of
> abort.

ACCESS_ONCE here is not used to synchronize the transaction->abort, it is
used to prevent the compiler from the using optimizations which might create
unsolicited accesses or optimize accesses out of existence.

(Maybe My changelog is too short and the description is not exact. Sorry)

> 
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -267,7 +267,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>>  			     function, line, errstr);
>>  		return;
>>  	}
>> -	trans->transaction->aborted = errno;
>> +	ACCESS_ONCE(trans->transaction->aborted) = errno;
>>  	__btrfs_std_error(root->fs_info, function, line, errno, NULL);
> 
> I don't think it's possible to reach 2 transaction aborts at the same
> time so that the 'aborted' value gets silently overwritten. The error
> message uses the 'errno' value passed to the function and thus this will
> be visible in the syslog. I don't see a better way how to decide which
> of the multiple 'aborted' values should win. A non-zero will abort, all
> of them are in syslog. Enough information for further debugging.

We don't know how the compiler would optimize the code. transaction->abort is
not protected by the lock, and if the compiler is within its rights to manufacture
an additional store by transforming the above code into the following:

trans->transaction->aborted = errno;
if (!trans->blocks_used) {
	trans->transaction->aborted = 0;
	......
}

The read side would get a wrong value.

As Linus said: "if you access unlocked values, you use ACCESS_ONCE(). You
don't say "but it can't matter". Because you simply don't know."

>>  }
>>  /*
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index a950d48..ee6cf27 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -1468,11 +1468,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  		goto cleanup_transaction;
>>  	}
>>  
>> -	if (cur_trans->aborted) {
>> -		ret = cur_trans->aborted;
>> -		goto cleanup_transaction;
>> -	}
> 
> This is called early in the function and stops commit actions in case
> the transaction has been aborted. Continuing despite that does not seem
> right, the filesystem is RO already.

Here, it is possible that there are some tasks which still don't end up the
transaction, and might set transaction->abort later.

> 
>> -
>>  	/* make a pass through all the delayed refs we have so far
>>  	 * any runnings procs may add more while we are here
>>  	 */
>> @@ -1574,6 +1569,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  	wait_event(cur_trans->writer_wait,
>>  		   atomic_read(&cur_trans->num_writers) == 1);
>>  
>> +	if (ACCESS_ONCE(cur_trans->aborted)) {
>> +		ret = cur_trans->aborted;
>> +		goto cleanup_transaction;
>> +	}

I add the check here is also not right. The tasks that save the inode cache and
space cache may also update transaction->abort. I will make a new patch later.

Thanks
Miao

>>  	/*
>>  	 * the reloc mutex makes sure that we stop
>>  	 * the balancing code from coming in and moving
> 
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

