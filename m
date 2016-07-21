Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47379 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752395AbcGUTSL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 15:18:11 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix memory leak of block group cache
To: <bo.li.liu@oracle.com>
References: <1469061234-15337-1-git-send-email-bo.li.liu@oracle.com>
 <1469061852-21185-1-git-send-email-bo.li.liu@oracle.com>
 <9300daf6-000a-7bfa-f7a8-c0b418cbd6ba@fb.com>
 <20160721190342.GA22835@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <0ee2835c-17e4-08d3-69ef-280dc9e188ad@fb.com>
Date: Thu, 21 Jul 2016 15:17:41 -0400
MIME-Version: 1.0
In-Reply-To: <20160721190342.GA22835@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/21/2016 03:03 PM, Liu Bo wrote:
> On Thu, Jul 21, 2016 at 11:32:26AM -0400, Chris Mason wrote:
>>
>>
>> On 07/20/2016 08:44 PM, Liu Bo wrote:
>>> While processing delayed refs, we may update block group's statistics
>>> and attach it to cur_trans->dirty_bgs, and later writing dirty block
>>> groups will process the list, which happens during
>>> btrfs_commit_transaction().
>>>
>>> For whatever reason, the transaction is aborted and dirty_bgs
>>> is not processed in cleanup_transaction(), we end up with memory leak
>>> of these dirty block group cache.
>>>
>>> Since btrfs_start_dirty_block_groups() doesn't make it go to the commit
>>> critical section, this also adds the cleanup work inside it.
>>
>> It's the start_drity_block_groups() hunt that worries me a bit:
>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 50bd683..7a35c9d 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -3698,6 +3698,8 @@ again:
>>>  			goto again;
>>>  		}
>>>  		spin_unlock(&cur_trans->dirty_bgs_lock);
>>> +	} else if (ret < 0) {
>>> +		btrfs_cleanup_dirty_bgs(cur_trans, root);
>>>  	}
>>>
>>>  	btrfs_free_path(path);
>>>
>>
>> We have checks in here to make sure only one process runs
>> btrfs_start_dirty_block_groups() but that doesn't mean that only one process
>> its messing around with the cache inode.  Is there any reason we can't let
>> this cleanup wait for the cleanup_transaction code?
>>
>> btrfs_run_delayed_refs() already aborts when it fails.
>
> update_block_group() is the only producer to add block group cache to
> dirty_bgs list, and if btrfs_run_delayed_refs() aborts, the transaction
> is aborted, so seems that there won't be anyone manipulating dirty_bgs
> list, am I missing?
>

No, the dirty_bgs processing is safe I think.  My concern is with the 
cache inode which we iput()

> Another point is that when we fail on btrfs_start_dirty_block_groups(),
> btrfs_commit_transaction() won't get to cleanup_transaction error
> handling,

Right, because we don't actually finish the commit.  Someone will 
eventually though ;)

>
> btrfs_commit_transaction() {
> 	...
> 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
> 		...
> 		ret = btrfs_start_dirty_block_groups(trans, root);
> 	}
> 	if (ret) {
> 		btrfs_end_transaction(trans, root);
> 		return ret;
> 	}
> 	...
> 	cleanup_transaction();
> }
>
>
> But yes, if we delay the cleanup, we still have a chance to do cleanup
> in btrfs_error_commit_super(), and I have sent another patch to add
> several ASSERT()s to check block group related memory leak, with which
> we'll be warned if anything wrong.
>
> I'm OK to remove the part that causes concerns.

Thanks.

-chris

