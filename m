Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32748 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726699AbeGRIbS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 04:31:18 -0400
Date: Wed, 18 Jul 2018 15:54:31 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 13/19] btrfs: qgroup: Drop fs_info parameter from
 btrfs_qgroup_trace_extent
Message-ID: <20180718075431.GI575@fnst.localdomain>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
 <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
 <ca879289-7a26-e445-210d-0d8c8c9c173e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <ca879289-7a26-e445-210d-0d8c8c9c173e@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 02:58:06PM +0800, Qu Wenruo wrote:
>
>
>On 2018年07月18日 14:45, Lu Fengqi wrote:
>> It can be fetched from the transaction handle.
>> 
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/qgroup.c   | 13 ++++++-------
>>  fs/btrfs/qgroup.h   |  5 ++---
>>  fs/btrfs/tree-log.c |  2 +-
>>  3 files changed, 9 insertions(+), 11 deletions(-)
>> 
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index c85c1a0e933a..01add73cb2aa 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1579,10 +1579,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>>  	return 0;
>>  }
>>  
>> -int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>> -		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>> -		gfp_t gfp_flag)
>> +int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
>> +			      u64 num_bytes, gfp_t gfp_flag)
>>  {
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>
>Just lines below, we do extra WARN_ON(trans == NULL).
>So if we really hit some case with NULL trans, this would cause a NULL
>pointer dereference.
>
>Although I have to admit, I'm a little paranoid about possible NULL
>trans passed in.
>So maybe it's a good timing to remove that WARN_ON() too?

Sorry, I didn't notice this WARN_ON(trans == NULL). However, I have
confirmed that the callers of btrfs_qgroup_trace_{extent, leaf_items,
subtree} should never pass NULL as trans. In my opinion the WARN_ON() can
be removed without any bad effect.

-- 
Thanks,
Lu

>
>Thanks,
>Qu
>
>>  	struct btrfs_qgroup_extent_record *record;
>>  	struct btrfs_delayed_ref_root *delayed_refs;
>>  	int ret;
>> @@ -1644,8 +1644,8 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
>>  
>>  		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
>>  
>> -		ret = btrfs_qgroup_trace_extent(trans, fs_info, bytenr,
>> -						num_bytes, GFP_NOFS);
>> +		ret = btrfs_qgroup_trace_extent(trans, bytenr, num_bytes,
>> +						GFP_NOFS);
>>  		if (ret)
>>  			return ret;
>>  	}
>> @@ -1796,8 +1796,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
>>  			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>>  			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
>>  
>> -			ret = btrfs_qgroup_trace_extent(trans, fs_info,
>> -							child_bytenr,
>> +			ret = btrfs_qgroup_trace_extent(trans, child_bytenr,
>>  							fs_info->nodesize,
>>  							GFP_NOFS);
>>  			if (ret)
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index 385367989ed6..0215dc0b1710 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -212,9 +212,8 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>>   * Return <0 for error, like memory allocation failure or invalid parameter
>>   * (NULL trans)
>>   */
>> -int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>> -		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>> -		gfp_t gfp_flag);
>> +int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
>> +			      u64 num_bytes, gfp_t gfp_flag);
>>  
>>  /*
>>   * Inform qgroup to trace all leaf items of data
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 7b7498f1f641..10f6a4223897 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -685,7 +685,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>>  		 * as the owner of the file extent changed from log tree
>>  		 * (doesn't affect qgroup) to fs/file tree(affects qgroup)
>>  		 */
>> -		ret = btrfs_qgroup_trace_extent(trans, fs_info,
>> +		ret = btrfs_qgroup_trace_extent(trans,
>>  				btrfs_file_extent_disk_bytenr(eb, item),
>>  				btrfs_file_extent_disk_num_bytes(eb, item),
>>  				GFP_NOFS);
>> 
>


