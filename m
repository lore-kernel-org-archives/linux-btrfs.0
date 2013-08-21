Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7875 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3HUGfP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 02:35:15 -0400
Message-ID: <52145EC1.4000905@cn.fujitsu.com>
Date: Wed, 21 Aug 2013 14:31:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix heavy delalloc related deadlock
References: <1376494860-8864-1-git-send-email-jbacik@fusionio.com> <52118373.7050800@cn.fujitsu.com> <20130819124952.GB3990@localhost.localdomain>
In-Reply-To: <20130819124952.GB3990@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef

On mon, 19 Aug 2013 08:49:52 -0400, Josef Bacik wrote:
> On Mon, Aug 19, 2013 at 10:31:15AM +0800, Miao Xie wrote:
>> On wed, 14 Aug 2013 11:41:00 -0400, Josef Bacik wrote:
>>> I added a patch where we started taking the ordered operations mutex when we
>>> waited on ordered extents.  We need this because we splice the list and process
>>> it, so if a flusher came in during this scenario it would think the list was
>>> empty and we'd usually get an early ENOSPC.  The problem with this is that this
>>> lock is used in transaction committing.  So we end up with something like this
>>>
>>> Transaction commit
>>> 	-> wait on writers
>>>
>>> Delalloc flusher
>>> 	-> run_ordered_operations (holds mutex)
>>> 		->wait for filemap-flush to do its thing
>>>
>>> flush task
>>> 	-> cow_file_range
>>> 		->wait on btrfs_join_transaction because we're commiting
>>>
>>> some other task
>>> 	-> commit_transaction because we notice trans->transaction->flush is set
>>> 		-> run_ordered_operations (hang on mutex)
>>
>> Sorry, I can not understand this explanation. As far as I know, if the flush task
>> waits on btrfs_join_transaction(), it means the transaction is under commit
>> (state = TRANS_STATE_COMMIT_DOING), and all the external writers(TRANS_START/TRANS_ATTACH/
>> TRANS_USERSPACE) have quitted the current transaction, so no one would try to call
>> run_ordered_operations().
>>
>> Could you show us the reproduce steps?
>>
> 
> Sorry I wrote the wrong thing for the delalloc flusher, that should be
> 
>   ->btrfs_wait_ordered_extents (holds ordered operations mutex)
> 	-> wait for filemap-flush to do its thing
> 
> That should make it clearer.  I reproduced it running xfstests generic/224.
> Thanks,

Your patch can fix the above deadlock problem. And this problem also happens on
the old kernel, so it is better to send it to the stable kernel mail list, and please
add
	Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

By the way, I found the "some other tasks" you said above are tasks that start
TRANS_JOIN transaction handles, if we don't use btrfs_join_transaction/btrfs_commit_transaction
at the same time, we can also avoid the above deadlock. And besides that, I think 
the TRANS_JOIN handle should not be committed because the TRANS_JOIN handle can
grab the current transaction even it is going to be committed, it is error prone if
we commit a TRANS_JOIN handle when the transaction is going to be committed.
And in the most cases that we need commit the transaction, we just want to commit
the current transaction, but don't want to start a new transaction and then commit it,
so in those cases, the TRANS_JOIN is not suitable.

In short, we need clean up the code that use btrfs_join_transaction/btrfs_commit_transaction
at the same time.

Thanks
Miao
