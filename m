Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbeEPKOL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 06:14:11 -0400
Subject: Re: [PATCH v2 2/3] btrfs: balance: add args info during start and
 resume
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-3-anand.jain@oracle.com>
 <81c9b168-1e51-2940-b7dc-fb753852154a@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <66afe4b3-d90b-cdb1-7050-a58ada51e49e@oracle.com>
Date: Wed, 16 May 2018 18:16:37 +0800
MIME-Version: 1.0
In-Reply-To: <81c9b168-1e51-2940-b7dc-fb753852154a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2018 03:57 PM, Nikolay Borisov wrote:
> 
> 
> On 16.05.2018 05:51, Anand Jain wrote:
>> Balance args info is an important information to be reviewed for the
>> system audit. So this patch adds it to the kernel log.
>>
>> Example:
>>
>> -> btrfs bal start -dprofiles='raid1|single',convert=raid5 -mprofiles='raid1|single',convert=raid5 /btrfs
>>
>>   kernel: BTRFS info (device sdb): balance: start data profiles=raid1|single convert=raid5 metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
>>
>> -> btrfs bal start -dprofiles=raid5,convert=single -mprofiles='raid1|single',convert=raid5 --background /btrfs
>>
>>   kernel: BTRFS info (device sdb): balance: start data profiles=raid5 convert=single metadata profiles=raid1|single convert=raid5 system profiles=raid1|single convert=raid5
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Why can't this code be part of progs, the bctl which you are parsing is
> constructed from the arguments passed from users space? I think you are
> adding way too much string parsing code to the kernel and this is never
> a good sign, since it's very easy to trip.
Theoretically progs is a wrong place for this.
Unfortunately our bctl which is in the kernel, matches with the user
land balance ioctl args so it may feel like progs do it, but its wrong.
If kernel is modifying the chunks there must be proper logs for it,
which this patch does. Next this log is only called at the time of the 
balance setup and resume. And string parsing is behind the flag checks, 
so they aren't that intensive at run time.

Thanks, Anand

>> ---
>> v1->v2: Change log update.
>>          Move adding the logs for balance complete and end to a new patch
>>
>>   fs/btrfs/volumes.c | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 143 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 27da66c47ef2..ce68c4f42f94 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -126,6 +126,32 @@ const char *get_raid_name(enum btrfs_raid_types type)
>>   	return btrfs_raid_array[type].raid_name;
>>   }
>>   
>> +static void get_all_raid_names(u64 bg_flags, char *raid_types)
>> +{
>> +	int i;
>> +	bool found = false;
>> +
>> +	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
>> +		if (bg_flags & btrfs_raid_array[i].bg_flag) {
>> +			if (found) {
>> +				strcat(raid_types, "|");
>> +				strcat(raid_types, btrfs_raid_array[i].raid_name);
>> +			} else {
>> +				found = true;
>> +				sprintf(raid_types, "%s", btrfs_raid_array[i].raid_name);
>> +			}
>> +		}
>> +	}
>> +	if (bg_flags & BTRFS_AVAIL_ALLOC_BIT_SINGLE) {
>> +		if (found) {
>> +			strcat(raid_types, "|");
>> +			strcat(raid_types, "single");
>> +		} else {
>> +			sprintf(raid_types, "%s", "single");
>> +		}
>> +	}
>> +}
>> +
>>   static int init_first_rw_device(struct btrfs_trans_handle *trans,
>>   				struct btrfs_fs_info *fs_info);
>>   static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
>> @@ -3766,6 +3792,121 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
>>   		 (bctl_arg->target & ~allowed)));
>>   }
>>   
>> +static void get_balance_args(struct btrfs_balance_args *bargs, char *args)
>> +{
>> +	char value[64];
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_PROFILES) {
>> +		strcat(args, "profiles=");
>> +		get_all_raid_names(bargs->profiles, value);
>> +		strcat(args, value);
>> +		strcat(args, " ");
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
>> +		snprintf(value, 64, "usage=%llu ", bargs->usage);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
>> +		snprintf(value, 64, "usage_min=%u usage_max=%u ",
>> +			bargs->usage_min, bargs->usage_max);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_DEVID) {
>> +		snprintf(value, 64, "devid=%llu ", bargs->devid);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_DRANGE) {
>> +		snprintf(value, 64, "pstart=%llu pend=%llu ",
>> +			 bargs->pstart, bargs->pend);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_VRANGE) {
>> +		snprintf(value, 64, "vstart=%llu vend %llu ",
>> +			 bargs->vstart, bargs->vend);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_LIMIT) {
>> +		snprintf(value, 64, "limit=%llu ", bargs->limit);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE) {
>> +		snprintf(value, 64, "limit_min=%u limit_max=%u ",
>> +			 bargs->limit_min, bargs->limit_max);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE) {
>> +		snprintf(value, 64, "stripes_min=%u stripes_max=%u ",
>> +			 bargs->stripes_min, bargs->stripes_max);
>> +		strcat(args, value);
>> +	}
>> +
>> +	if (bargs->flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		int index = btrfs_bg_flags_to_raid_index(bargs->target);
>> +		snprintf(value, 64, "convert=%s ",
>> +			 get_raid_name(index));
>> +		strcat(args, value);
>> +	}
>> +
>> +	/* If space was the last char remove it */
>> +	if (strlen(args) && (args[strlen(args) - 1] == ' '))
>> +		args[strlen(args) - 1] = '\0';
>> +}
>> +
>> +static void print_balance_start_or_resume(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
>> +	int log_size = 1024;
>> +	char *args;
>> +
>> +	args = kzalloc(log_size, GFP_KERNEL);
>> +	if (!args) {
>> +		btrfs_warn(fs_info, "balance: failed to log: ENOMEM");
>> +		return;
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_ARGS_SOFT) {
>> +		strcat(args, "soft ");
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_FORCE) {
>> +		strcat(args, "force ");
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_DATA) {
>> +		strcat(args, "data ");
>> +		get_balance_args(&bctl->data, args);
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_METADATA) {
>> +		if (strlen(args) > 0)
>> +			strcat(args, " ");
>> +		strcat(args, "metadata ");
>> +		get_balance_args(&bctl->meta, args);
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
>> +		if (strlen(args) > 0)
>> +			strcat(args, " ");
>> +		strcat(args, "system ");
>> +		get_balance_args(&bctl->sys, args);
>> +	}
>> +
>> +	BUG_ON(strlen(args) > log_size);
>> +	btrfs_info(fs_info, "%s %s",
>> +		   bctl->flags & BTRFS_BALANCE_RESUME ?\
>> +		   "balance: resume":"balance: start", args);
>> +
>> +	kfree(args);
>> +}
>> +
>>   /*
>>    * Should be called with balance mutexe held
>>    */
>> @@ -3906,6 +4047,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   
>>   	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>>   	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>> +	print_balance_start_or_resume(fs_info);
>>   	mutex_unlock(&fs_info->balance_mutex);
>>   
>>   	ret = __btrfs_balance(fs_info);
>> @@ -3943,10 +4085,8 @@ static int balance_kthread(void *data)
>>   	int ret = 0;
>>   
>>   	mutex_lock(&fs_info->balance_mutex);
>> -	if (fs_info->balance_ctl) {
>> -		btrfs_info(fs_info, "balance: resuming");
>> +	if (fs_info->balance_ctl)
>>   		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
>> -	}
>>   	mutex_unlock(&fs_info->balance_mutex);
>>   
>>   	return ret;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
