Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42935 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933494AbdCHAg1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 19:36:27 -0500
Subject: Re: [PATCH 3/9] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option
To: Jeff Mahoney <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.com>, <clm@fb.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-4-quwenruo@cn.fujitsu.com>
 <b9217275-263f-7a72-8194-3a4f3d72c804@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3bbf70b2-124c-8a2a-1a0d-2e8a58b0898b@cn.fujitsu.com>
Date: Wed, 8 Mar 2017 08:36:21 +0800
MIME-Version: 1.0
In-Reply-To: <b9217275-263f-7a72-8194-3a4f3d72c804@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/08/2017 03:21 AM, Jeff Mahoney wrote:
> On 2/27/17 2:10 AM, Qu Wenruo wrote:
>> [BUG]
>> The easist way to reproduce the bug is:
>> ------
>>  # mkfs.btrfs -f $dev -n 16K
>>  # mount $dev $mnt -o inode_cache
>>  # btrfs quota enable $mnt
>>  # btrfs quota rescan -w $mnt
>>  # btrfs qgroup show $mnt
>> qgroupid         rfer         excl
>> --------         ----         ----
>> 0/5          32.00KiB     32.00KiB
>>              ^^ Twice the correct value
>> ------
>>
>> And fstests/btrfs qgroup test group can easily detect them with
>> inode_cache mount option.
>> Although some of them are false alerts since old test cases are using
>> fixed golden output.
>> While new test cases will use "btrfs check" to detect qgroup mismatch.
>>
>> [CAUSE]
>> Inode_cache mount option will make commit_fs_roots() to call
>> btrfs_save_ino_cache() to update fs/subvol trees, and generate new
>> delayed refs.
>>
>> However we call btrfs_qgroup_prepare_account_extents() too early, before
>> commit_fs_roots().
>> This makes the "old_roots" for newly generated extents are always NULL.
>> For freeing extent case, this makes both new_roots and old_roots to be
>> empty, while correct old_roots should not be empty.
>> This causing qgroup numbers not decreased correctly.
>>
>> [FIX]
>> Modify the timing of calling btrfs_qgroup_prepare_account_extents() to
>> just before btrfs_qgroup_account_extents(), and add needed delayed_refs
>> handler.
>> So qgroup can handle inode_map mount options correctly.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Could we also fix this by excepting the free space inode from qgroups?
> It seems like this is something we'd want to do anyway unless we want to
> handle EDQUOT there too.

I'm afraid it's not possible here.

As qgroup accounts any tree and data blocks that belong to specified 
tree(fs and subvolumes), not caring the inode it belongs to.

And the design of free inode space cache is to restore it in 
fs/subvolume tree, which has no difference with normal inode, except it 
doesn't have INODE_REF and its ino is FREE_INO.
(Much the same behavior for space cache inode)

The correct solution for caching free space and inode should be the new 
space cache tree, which puts all these info into their own tree, never 
affecting existing trees.

The only good news is, inode_cache is not commonly used and IIRC has 
bugs. Maybe it will be good idea to depreciate the option?

Thanks,
Qu

Thanks,
Qu

>
> -Jeff
>
>> ---
>>  fs/btrfs/transaction.c | 25 ++++++++++++++++++-------
>>  1 file changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 6b3e0fc2fe7a..1ff3ec797356 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -2130,13 +2130,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  		goto scrub_continue;
>>  	}
>>
>> -	/* Reocrd old roots for later qgroup accounting */
>> -	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
>> -	if (ret) {
>> -		mutex_unlock(&fs_info->reloc_mutex);
>> -		goto scrub_continue;
>> -	}
>> -
>>  	/*
>>  	 * make sure none of the code above managed to slip in a
>>  	 * delayed item
>> @@ -2179,6 +2172,24 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>>  	btrfs_free_log_root_tree(trans, fs_info);
>>
>>  	/*
>> +	 * commit_fs_roots() can call btrfs_save_ino_cache(), which generates
>> +	 * new delayed refs. Must handle them or qgroup can be wrong.
>> +	 */
>> +	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
>> +	if (ret) {
>> +		mutex_unlock(&fs_info->tree_log_mutex);
>> +		mutex_unlock(&fs_info->reloc_mutex);
>> +		goto scrub_continue;
>> +	}
>> +
>> +	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
>> +	if (ret) {
>> +		mutex_unlock(&fs_info->tree_log_mutex);
>> +		mutex_unlock(&fs_info->reloc_mutex);
>> +		goto scrub_continue;
>> +	}
>> +
>> +	/*
>>  	 * Since fs roots are all committed, we can get a quite accurate
>>  	 * new_roots. So let's do quota accounting.
>>  	 */
>>
>
>


