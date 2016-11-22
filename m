Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51259 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753416AbcKVTfd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 14:35:33 -0500
Subject: Re: [PATCH v2] btrfs: introduce priority based delalloc shrink
 mechanism
To: <dsterba@suse.cz>, <jbacik@fb.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <57FF1E50.7000706@cn.fujitsu.com>
 <1476351085-26821-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20161024154352.GD22935@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <712dd6bb-1550-d718-1301-65bc12dec174@fb.com>
Date: Tue, 22 Nov 2016 14:35:04 -0500
MIME-Version: 1.0
In-Reply-To: <20161024154352.GD22935@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/2016 11:43 AM, David Sterba wrote:
> Hi Josef,
>
> are you fine with V2?
>
> On Thu, Oct 13, 2016 at 05:31:25PM +0800, Wang Xiaoguang wrote:
>> Since commit b02441999efcc6152b87cd58e7970bb7843f76cf, we don't wait all
>> ordered extents, but I run into some enospc errors when doing large file
>> create and delete tests, it's because shrink_delalloc() does not write
>> enough delalloc bytes and wait them finished:
>>     From: Miao Xie <miaox@cn.fujitsu.com>
>>     Date: Mon, 4 Nov 2013 23:13:25 +0800
>>     Subject: [PATCH] Btrfs: don't wait for the completion of all the ordered extents
>>
>>     It is very likely that there are lots of ordered extents in the filesytem,
>>     if we wait for the completion of all of them when we want to reclaim some
>>     space for the metadata space reservation, we would be blocked for a long
>>     time. The performance would drop down suddenly for a long time.
>>
>> Here we introduce a simple reclaim_priority variable, the lower the
>> value, the higher the priority, 0 is the maximum priority. The core
>> idea is:
>>     delalloc_bytes = percpu_counter_sum_positive(&root->fs_info->delalloc_bytes);
>>     if (reclaim_priority)
>>         to_reclaim = orig * (2 << (BTRFS_DEFAULT_FLUSH_PRIORITY - reclaim_priority));
>>     else
>>         to_reclaim = delalloc_bytes;
>>
>> Here 'orig' is the number of metadata we want to reserve, and as the priority
>> increases, we will try wo write more delalloc bytes, meanwhile if
>> "reclaim_priority == 0" returns true, we'll also wait all current ordered
>> extents to finish.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent-tree.c       | 63 ++++++++++++++++++++++++++------------------
>>  include/trace/events/btrfs.h | 11 +++-----
>>  2 files changed, 42 insertions(+), 32 deletions(-)
>>

[ ... ]

>> @@ -5008,8 +5024,8 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
>>  	struct btrfs_space_info *space_info;
>>  	u64 to_reclaim;
>>  	int flush_state;
>> -	int commit_cycles = 0;
>>  	u64 last_tickets_id;
>> +	int reclaim_priority = BTRFS_DEFAULT_FLUSH_PRIORITY;
>>
>>  	fs_info = container_of(work, struct btrfs_fs_info, async_reclaim_work);
>>  	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
>> @@ -5030,8 +5046,11 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
>>  		struct reserve_ticket *ticket;
>>  		int ret;
>>
>> +		if (flush_state > COMMIT_TRANS)
>> +			flush_state = FLUSH_DELAYED_ITEMS_NR;
>>  		ret = flush_space(fs_info->fs_root, space_info, to_reclaim,
>> -			    to_reclaim, flush_state);
>> +				  flush_state, reclaim_priority);
>> +
>>  		spin_lock(&space_info->lock);
>>  		if (!ret)
>>  			try_to_wake_tickets(fs_info->fs_root, space_info);
>> @@ -5049,21 +5068,15 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
>>  		} else {
>>  			last_tickets_id = space_info->tickets_id;
>>  			flush_state = FLUSH_DELAYED_ITEMS_NR;
>> -			if (commit_cycles)
>> -				commit_cycles--;
>> +			reclaim_priority = BTRFS_DEFAULT_FLUSH_PRIORITY;
>>  		}
>>
>> -		if (flush_state > COMMIT_TRANS) {
>> -			commit_cycles++;
>> -			if (commit_cycles > 2) {
>> -				wake_all_tickets(&space_info->tickets);
>> -				space_info->flush = 0;
>> -			} else {
>> -				flush_state = FLUSH_DELAYED_ITEMS_NR;
>> -			}
>> +		if (flush_state > COMMIT_TRANS && reclaim_priority == 0) {
>> +			wake_all_tickets(&space_info->tickets);
>> +			space_info->flush = 0;
>>  		}
>>  		spin_unlock(&space_info->lock);
>> -	} while (flush_state <= COMMIT_TRANS);
>> +	} while ((flush_state <= COMMIT_TRANS) || (--reclaim_priority >= 0));
>>  }

I really like the idea behind this patch, but it's very difficult to 
follow what is going on with flush_state and reclaim_priority in this 
loop.  It needs big flashing signs explaining how long the loop is going 
to continue and what the goals are for bumping or dropping each one.

-chris
