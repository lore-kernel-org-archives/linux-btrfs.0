From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: 3.0-rcX BUG at fs/btrfs/ioctl.c:432 - bisected
Date: Fri, 10 Jun 2011 13:29:11 -0600
Message-ID: <4DF27087.8020706@sandia.gov>
References: <4DF140AB.4030805@sandia.gov>
 <20110609234553.GN12709@twin.jikos.cz> <4DF24F0E.4040306@sandia.gov>
 <1307726732-sup-3404@shiny>
 <Pine.LNX.4.64.1106101100310.5245@cobra.newdream.net>
 <Pine.LNX.4.64.1106101112470.5245@cobra.newdream.net>
 <4DF2627F.4030600@redhat.com>
 <Pine.LNX.4.64.1106101134530.5245@cobra.newdream.net>
 <4DF263AD.3070901@redhat.com>
 <Pine.LNX.4.64.1106101139150.5245@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: "Josef Bacik" <josef@redhat.com>,
	"Chris Mason" <chris.mason@oracle.com>, dave <dave@jikos.cz>,
	miaox <miaox@cn.fujitsu.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel@vger.kernel.org
To: "Sage Weil" <sage@newdream.net>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1106101139150.5245@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Sage Weil wrote:
> On Fri, 10 Jun 2011, Josef Bacik wrote:
>> On 06/10/2011 02:35 PM, Sage Weil wrote:
>>> On Fri, 10 Jun 2011, Josef Bacik wrote:
>>>> On 06/10/2011 02:14 PM, Sage Weil wrote:
>>>>> On Fri, 10 Jun 2011, Sage Weil wrote:
>>>>>> On Fri, 10 Jun 2011, Chris Mason wrote:
>>>>>>> Excerpts from Jim Schutt's message of 2011-06-10 13:06:22 -0400:
>>>>>>>
>>>>>>> [ two different btrfs crashes ]
>>>>>>>
>>>>>>> I think your two crashes in btrfs were from the uninit variables and
>>>>>>> those should be fixed in rc2.
>>>>>>>
>>>>>>>> When I did my bisection, my criteria for success/failure was
>>>>>>>> "did mkcephfs succeed?".  When I apply this criteria to a recent
>>>>>>>> linus kernel (e.g. 06e86849cf4019), which includes the fix you
>>>>>>>> mentioned (aa0467d8d2a00e), I get still a different failure mode,
>>>>>>>> which doesn't actually reference btrfs:
>>>>>>>>
>>>>>>>> [  276.364178] BUG: unable to handle kernel NULL pointer dereference at 000000000000000a
>>>>>>>> [  276.365127] IP: [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
>>>>>>> Looking at the resulting code in the oops, we're here in journal_start:
>>>>>>>
>>>>>>>         if (handle) {
>>>>>>>                 J_ASSERT(handle->h_transaction->t_journal == journal);
>>>>>>>
>>>>>>> handle comes from current->journal_info, and we're doing a deref on
>>>>>>> handle->h_transaction, which is probably 0xa.
>>>>>>>
>>>>>>> So, we're leaving crud in current->journal_info and ext3 is finding it.
>>>>>>>
>>>>>>> Perhaps its from ceph starting a transaction but leaving it running?
>>>>>>> The bug came with Josef's transaction performance fixes, but it is
>>>>>>> probably a mixture of his code with the ioctls ceph is using.
>>>>>> Ah, yeah, that's the problem.  We saw a similar problem a while back with 
>>>>>> the start/stop transaction ioctls.  In this case, create_snapshot is doing
>>>>>>
>>>>>> 	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
>>>>>> 	if (IS_ERR(trans)) {
>>>>>> 		ret = PTR_ERR(trans);
>>>>>> 		goto fail;
>>>>>> 	}
>>>>>>
>>>>>> which sets current->journal_info.  Then
>>>>>>
>>>>>> 	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
>>>>>> 	BUG_ON(ret);
>>>>>>
>>>>>> 	list_add(&pending_snapshot->list,
>>>>>> 		 &trans->transaction->pending_snapshots);
>>>>>> 	if (async_transid) {
>>>>>> 		*async_transid = trans->transid;
>>>>>> 		ret = btrfs_commit_transaction_async(trans,
>>>>>> 				     root->fs_info->extent_root, 1);
>>>>>> 	} else {
>>>>>> 		ret = btrfs_commit_transaction(trans,
>>>>>> 				       root->fs_info->extent_root);
>>>>>> 	}
>>>>>>
>>>>>> but the async snap creation ioctl takes the async path, which runs 
>>>>>> btrfs_commit_transaction in a worker thread.
>>>>>>
>>>>>> I'm not sure what the right thing to do is here is... can whatever is in 
>>>>>> journal_info be attached to trans instead in 
>>>>>> btrfs_commit_transaction_async()?
>>>>> It looks like it's not used for anything in btrfs, actually; it's just set 
>>>>> and cleared.  What's the point of that?
>>>>>
>>>> It is used now, check the beginning of start_transaction().  Thanks,
>>> Oh I see, okay.
>>>
>>> So clearing it in btrfs_commit_transaction_async should be fine then, 
>>> right?  When btrfs_commit_transaction runs in the other thread it won't 
>>> care that current->journal_info is NULL.
>>>
>> Oh yeah your patch is good :),
> 
> Okay cool.  Here's the fix with a proper changelog and a little 
> use-after-free paranoia.

This patch solves my issue - thanks a lot.

Tested-by: Jim Schutt <jaschut@sandia.gov>

-- Jim

> 
> Thanks!
> sage
> 
> 
>>From 9881c0752293769d5133c01dff3ab04c0c24c61b Mon Sep 17 00:00:00 2001
> From: Sage Weil <sage@newdream.net>
> Date: Fri, 10 Jun 2011 11:41:25 -0700
> Subject: [PATCH] Btrfs: clear current->journal_info on async transaction commit
> 
> Normally current->jouranl_info is cleared by commit_transaction.  For an
> async snap or subvol creation, though, it runs in a work queue.  Clear
> it in btrfs_commit_transaction_async() to avoid leaking a non-NULL
> journal_info when we return to userspace.  When the actual commit runs in
> the other thread it won't care that it's current->journal_info is already
> NULL.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/transaction.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index dd71966..9d516ed 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1118,8 +1118,11 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
>  		wait_current_trans_commit_start_and_unblock(root, cur_trans);
>  	else
>  		wait_current_trans_commit_start(root, cur_trans);
> -	put_transaction(cur_trans);
>  
> +	if (current->journal_info == trans)
> +		current->journal_info = NULL;
> +
> +	put_transaction(cur_trans);
>  	return 0;
>  }
>  


