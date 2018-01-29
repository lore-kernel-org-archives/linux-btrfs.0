Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42969 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbeA2LVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 06:21:14 -0500
Subject: Re: [PATCH v2] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0aace605-1267-2b4d-d15a-167f4e7946f2@suse.com>
Date: Mon, 29 Jan 2018 13:21:12 +0200
MIME-Version: 1.0
In-Reply-To: <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.01.2018 13:09, Qu Wenruo wrote:
> 
> 
> On 2018年01月29日 15:44, Nikolay Borisov wrote:
>> Running generic/019 with qgroups on the scratch device enabled is
>> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
>> supposed to trigger only on -ENOMEM, in reality, however, it's possible
>> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
>> finds the roots of the extent being tracked and sets the qrecord->old_roots
>> list. If this operation fails nothing critical happens except the
>> quota accounting can be considered wrong. In such case just set the
>> INCONSISTENT flag for the quota and print a warning.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>
>> V2: 
>>  * Always print a warning if btrfs_qgroup_trace_extent_post fails 
>>  * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fails
>>
>>  fs/btrfs/delayed-ref.c | 7 +++++--
>>  fs/btrfs/qgroup.c      | 6 ++++--
>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>> index a1a40cf382e3..5b2789a28a13 100644
>> --- a/fs/btrfs/delayed-ref.c
>> +++ b/fs/btrfs/delayed-ref.c
>> @@ -820,8 +820,11 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>  			     num_bytes, parent, ref_root, level, action);
>>  	spin_unlock(&delayed_refs->lock);
>>  
>> -	if (qrecord_inserted)
>> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
>> +	if (qrecord_inserted) {
>> +		int ret = btrfs_qgroup_trace_extent_post(fs_info, record);
>> +		if (ret < 0)
>> +			btrfs_warn(fs_info, "Error accounting new delayed refs extent (err code: %d). Quota inconsistent", ret);
> 
> Sorry that I didn't point it out in previous review, there are 2 callers
> in delayed-ref.c using btrfs_qgroup_trace_extent_post().
> 
> One is the one you're fixing, and the other one is
> btrfs_add_delayed_data_ref().

Yes, but the callers of btrfs_add_delayed_data_ref seem to be expecting
error values and actually handling them. So a failure doesn't
necessarily mean the fs is in inconsistent state.

> 
> So it would be even better if the warning message can be integrated into
> btrfs_qgroup_trace_extent_post().

See below why I don't think integrating the warning is a good idea. In
the case being modified in this patch we will continue operating
normally, hence the warning and INCONSISTENT flag make sense.

> 
> Also btrfs_qgroup_trace_extent_post() also needs to ignore the return
> value from btrfs_qgroup_trace_extent_post().

I don't think so, if we are able to handle failures as is the case in
the delayed_data_ref case then we might abort the current transaction
and this should leave the fs in a consistent state. In that case even
the "STATUS_FLAG_INCONSISTENT" being set in qgroup_trace_extent_post
might be "wrong" in the sense that a failure from this function doesn't
necessarily make the quota inconsistent if upper layers can handle the
failures and revert their work. So I'm now starting to think that the
inconsistent flag should be set in add_delayed_tree_ref, but this sort
of leaks the qgroup implementation detail into the delayed tree ref
function...
> 
> Thanks,
> Qu
> 
>> +	}
>>  	return 0;
>>  
>>  free_head_ref:
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index b2ab5f795816..33f9dba44e92 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1440,8 +1440,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>>  	int ret;
>>  
>>  	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
>> -	if (ret < 0)
>> +	if (ret < 0) {
>> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>>  		return ret;
>> +	}
>>  
>>  	/*
>>  	 * Here we don't need to get the lock of
>> @@ -2933,7 +2935,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
>>  	if (free && reserved)
>>  		return qgroup_free_reserved_data(inode, reserved, start, len);
>>  	extent_changeset_init(&changeset);
>> -	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
>> +	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>>  	if (ret < 0)
>>  		goto out;
>>
> 
