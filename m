Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2482 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752296Ab3LSOiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 09:38:24 -0500
Message-ID: <52B3049C.2050800@fb.com>
Date: Thu, 19 Dec 2013 09:37:16 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs: introduce lock_ref/unlock_ref
References: <1387400849-7274-1-git-send-email-jbacik@fb.com> <1387400849-7274-2-git-send-email-jbacik@fb.com> <20131219040115.GF20579@dastard>
In-Reply-To: <20131219040115.GF20579@dastard>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/18/2013 11:01 PM, Dave Chinner wrote:
> On Wed, Dec 18, 2013 at 04:07:27PM -0500, Josef Bacik wrote:
>> qgroups need to have a consistent view of the references for a particular extent
>> record.  Currently they do this through sequence numbers on delayed refs, but
>> this is no longer acceptable.  So instead introduce lock_ref/unlock_ref.  This
>> will provide the qgroup code with a consistent view of the reference while it
>> does its accounting calculations without interfering with the delayed ref code.
>> Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>   fs/btrfs/ctree.h       |  11 ++++++
>>   fs/btrfs/delayed-ref.c |   2 +
>>   fs/btrfs/delayed-ref.h |   1 +
>>   fs/btrfs/extent-tree.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++--
>>   4 files changed, 113 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index a924274..8b3fd61 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1273,6 +1273,9 @@ struct btrfs_block_group_cache {
>>   
>>   	/* For delayed block group creation */
>>   	struct list_head new_bg_list;
>> +
>> +	/* For locking reference modifications */
>> +	struct extent_io_tree ref_lock;
>>   };
>>   
>>   /* delayed seq elem */
>> @@ -3319,6 +3322,14 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
>>   int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
>>   					 struct btrfs_fs_info *fs_info);
>>   int __get_raid_index(u64 flags);
>> +int lock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
>> +	     u64 num_bytes, int for_cow,
>> +	     struct btrfs_block_group_cache **block_group,
>> +	     struct extent_state **cached_state);
>> +int unlock_ref(struct btrfs_fs_info *fs_info, u64 root_objectid, u64 bytenr,
>> +	       u64 num_bytes, int for_cow,
>> +	       struct btrfs_block_group_cache *block_group,
>> +	       struct extent_state **cached_state);
> Please namespace these - they are far too similar to the generic
> struct lockref name and manipulation functions....
Yup will do, thanks,

Josef
