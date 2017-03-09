Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42477 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750798AbdCIGDM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Mar 2017 01:03:12 -0500
Subject: Re: [PATCH 1/9] btrfs: qgroup: Add trace point for qgroup reserved
 space
To: Jeff Mahoney <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>,
        <dsterba@suse.com>, <clm@fb.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-2-quwenruo@cn.fujitsu.com>
 <54b53e20-9499-9e24-ddda-c49bddd57b32@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cb7a59be-e44e-2ddf-2664-4ffe09469d54@cn.fujitsu.com>
Date: Thu, 9 Mar 2017 14:02:56 +0800
MIME-Version: 1.0
In-Reply-To: <54b53e20-9499-9e24-ddda-c49bddd57b32@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/08/2017 12:30 AM, Jeff Mahoney wrote:
> On 2/27/17 2:10 AM, Qu Wenruo wrote:
>> Introduce the following trace points:
>> qgroup_update_reserve
>> qgroup_meta_reserve
>>
>> These trace points are handy to trace qgroup reserve space related
>> problems.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/qgroup.c            | 15 +++++++++++++++
>>  include/trace/events/btrfs.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 58 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index a5da750c1087..b303d4794026 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1075,6 +1075,8 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>>  	qgroup->excl += sign * num_bytes;
>>  	qgroup->excl_cmpr += sign * num_bytes;
>>  	if (sign > 0) {
>> +		trace_qgroup_update_reserve(fs_info, qgroup->qgroupid,
>> +					    qgroup->reserved, -(s64)num_bytes);
>>  		if (WARN_ON(qgroup->reserved < num_bytes))
>>  			report_reserved_underflow(fs_info, qgroup, num_bytes);
>>  		else
>> @@ -1100,6 +1102,9 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
>>  		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
>>  		qgroup->excl += sign * num_bytes;
>>  		if (sign > 0) {
>> +			trace_qgroup_update_reserve(fs_info, qgroup->qgroupid,
>> +						    qgroup->reserved,
>> +						    -(s64)num_bytes);
>>  			if (WARN_ON(qgroup->reserved < num_bytes))
>>  				report_reserved_underflow(fs_info, qgroup,
>>  							  num_bytes);
>> @@ -2424,6 +2429,8 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>>
>>  		qg = unode_aux_to_qgroup(unode);
>>
>> +		trace_qgroup_update_reserve(fs_info, qg->qgroupid,
>> +					    qg->reserved, num_bytes);
>>  		qg->reserved += num_bytes;
>>  	}
>>
>> @@ -2469,6 +2476,8 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>>
>>  		qg = unode_aux_to_qgroup(unode);
>>
>> +		trace_qgroup_update_reserve(fs_info, qg->qgroupid,
>> +					    qg->reserved, -(s64)num_bytes);
>>  		if (WARN_ON(qg->reserved < num_bytes))
>>  			report_reserved_underflow(fs_info, qg, num_bytes);
>>  		else
>> @@ -2945,6 +2954,8 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>>  		return 0;
>>
>>  	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
>> +	trace_qgroup_meta_reserve(fs_info, root->objectid,
>> +				  (s64)num_bytes);
>>  	ret = qgroup_reserve(root, num_bytes, enforce);
>>  	if (ret < 0)
>>  		return ret;
>> @@ -2964,6 +2975,8 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
>>  	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
>>  	if (reserved == 0)
>>  		return;
>> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
>> +				  -(s64)reserved);
>>  	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
>>  }
>>
>> @@ -2978,6 +2991,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
>>  	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
>>  	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
>>  	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
>> +	trace_qgroup_meta_reserve(root->fs_info, root->objectid,
>> +				  -(s64)num_bytes);
>>  	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
>>  }
>>
>> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
>> index a3c3cab643a9..2d5799d8a4a2 100644
>> --- a/include/trace/events/btrfs.h
>> +++ b/include/trace/events/btrfs.h
>> @@ -1475,6 +1475,49 @@ TRACE_EVENT(qgroup_update_counters,
>>  		  __entry->cur_new_count)
>>  );
>>
>> +TRACE_EVENT(qgroup_update_reserve,
>> +
>> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 qgid, u64 cur_reserved,
>> +		 s64 diff),
>> +
>> +	TP_ARGS(fs_info, qgid, cur_reserved, diff),
>> +
>> +	TP_STRUCT__entry_btrfs(
>> +		__field(	u64,	qgid			)
>> +		__field(	u64,	cur_reserved		)
>> +		__field(	s64,	diff			)
>> +	),
>> +
>> +	TP_fast_assign_btrfs(fs_info,
>> +		__entry->qgid		= qgid;
>> +		__entry->cur_reserved	= cur_reserved;
>> +		__entry->diff		= diff;
>> +	),
>> +
>> +	TP_printk_btrfs("qgid = %llu, cur_reserved = %llu, diff = %lld",
>> +		__entry->qgid, __entry->cur_reserved, __entry->diff)
>> +);
>> +
>
> This is always called using a qgroup pointer.  Why not just pass it and
> let the the assignment clause grab the values?

Nice idea, I'll update the parameters along with the output format to 
match the latest standard.

Thanks for the review,
Qu
>
>> +TRACE_EVENT(qgroup_meta_reserve,
>> +
>> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 refroot, s64 diff),
>> +
>> +	TP_ARGS(fs_info, refroot, diff),
>> +
>> +	TP_STRUCT__entry_btrfs(
>> +		__field(	u64,	refroot			)
>> +		__field(	s64,	diff			)
>> +	),
>> +
>> +	TP_fast_assign_btrfs(fs_info,
>> +		__entry->refroot	= refroot;
>> +		__entry->diff		= diff;
>> +	),
>> +
>> +	TP_printk_btrfs("refroot = %llu, diff = %lld",
>> +		__entry->refroot, __entry->diff)
>> +);
>
> Same here, but with btrfs_root * instead.
>
> -Jeff
>
>> +
>>  #endif /* _TRACE_BTRFS_H */
>>
>>  /* This part must be outside protection */
>>
>
>


