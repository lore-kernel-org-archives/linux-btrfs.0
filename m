Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeEWGL7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 02:11:59 -0400
Subject: Re: [PATCH v3 2/3] btrfs: balance: add args info during start and
 resume
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180521063745.29343-1-anand.jain@oracle.com>
 <20180521063745.29343-3-anand.jain@oracle.com>
 <20180522123510.GJ6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d33b36da-a945-60d2-212b-12d12d53c229@oracle.com>
Date: Wed, 23 May 2018 14:14:26 +0800
MIME-Version: 1.0
In-Reply-To: <20180522123510.GJ6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/22/2018 08:35 PM, David Sterba wrote:
> On Mon, May 21, 2018 at 02:37:44PM +0800, Anand Jain wrote:
>> Balance arg info is an important information to be reviewed for the
>> system audit. So this patch adds them to the kernel log.
>>
>> Example:
>>
>> -> btrfs bal start -dprofiles='raid1|single',convert=raid5 -mprofiles='raid1|single',convert=raid5 /btrfs
>>   kernel: BTRFS info (device sdb): balance: start data<profiles=single|raid1,convert=raid5>|metadata<profiles=single|raid1,convert=raid5>|system<profiles=single|raid1,convert=raid5>
>>
>> -> btrfs bal start -f -dprofiles=raid5,convert=single -mprofiles='raid1|single',convert=raid5 --background /btrfs
>>   kernel: BTRFS info (device sdb): balance: start force|data<profiles=raid5,convert=single>|metadata<profiles=single|raid1,convert=raid5>|system<profiles=single|raid1,convert=raid5>
> 
> I think the output formatting should be suitable for copy&paste to the
> commandline, the example would be ok, but the other filters need more
> adjustments, see below.
> 
> I'm not sure enclosing the data or metadata inside < ... > is a good
> idea so I suggest to use ( and ) as it does not have an ambiguous
> meaning like < (less than).

  Thanks for suggesting. I think new one as below is much better
  format..

  ->btrfs bal start --full-balance -f 
-mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs

kernel: BTRFS info (device sdc): balance: start -f -d 
usage=50,limit=10..20 -m soft,profiles=raid1,convert=single -s 
soft,profiles=raid1,convert=single


>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2->v3: Change log updated.
>>          Make use of describe_block_group() added in 1/4
>>          Drop using strcat instead use snprintf.
>>          Logs string format updated as shown in the example above.
>>
>> v1->v2: Change log update.
>>          Move adding the logs for balance complete and end to a new patch
>>
>>   fs/btrfs/volumes.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 103 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 02b1d14f510d..d2e6b81f7874 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3810,6 +3810,107 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
>>   		 (bctl_arg->target & ~allowed)));
>>   }
>>   
>> +static u32 describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
>> +				 u32 sz)
>> +{
>> +	char *bp = buf;
>> +	u64 flags = bargs->flags;
>> +	char tmp_buf[128];
>> +
>> +	if (!flags)
>> +		return 0;
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_PROFILES) {
>> +		describe_block_groups(bargs->profiles, tmp_buf,
>> +				      sizeof(tmp_buf));
>> +		bp += snprintf(bp, buf - bp + sz, "%s%s,", "profiles=",
> 
> You don't need to use %s for existing strings

  My bad. I fixed it here and at other places. Thanks.

>> +			       tmp_buf);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_USAGE)
>> +		bp += snprintf(bp, buf - bp + sz, "usage=%llu,", bargs->usage);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_USAGE_RANGE)
>> +		bp += snprintf(bp, buf - bp + sz, "usage_min=%uusage_max=%u,",
> 
> Why don't you add spaces or commas between the values?

  Now the range is printed just as the cli.  =min..max

>> +			       bargs->usage_min, bargs->usage_max);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_DEVID)
>> +		bp += snprintf(bp, buf - bp + sz, "devid=%llu,", bargs->devid);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_DRANGE)
>> +		bp += snprintf(bp, buf - bp + sz, "pstart=%llupend=%llu,",
>> +			       bargs->pstart, bargs->pend);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_VRANGE)
>> +		bp += snprintf(bp, buf - bp + sz, "vstart=%lluvend %llu,",
>> +			       bargs->vstart, bargs->vend);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT)
>> +		bp += snprintf(bp, buf - bp + sz, "limit=%llu,", bargs->limit);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE)
>> +		bp += snprintf(bp, buf - bp + sz, "limit_min=%ulimit_max=%u,",
>> +			       bargs->limit_min, bargs->limit_max);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE)
>> +		bp += snprintf(bp, buf - bp + sz,
>> +			       "stripes_min=%ustripes_max=%u,",
>> +			       bargs->stripes_min, bargs->stripes_max);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		int index = btrfs_bg_flags_to_raid_index(bargs->target);
>> +
>> +		bp += snprintf(bp, buf - bp + sz, "convert=%s,",
>> +			       get_raid_name(index));
>> +	}
>> +
>> +	buf[bp - buf - 1] = '\0'; /* remove last , */
>> +	return bp - buf - 1;
>> +}
>> +
>> +static void describe_balance_start_or_resume(struct btrfs_fs_info *fs_info)
>> +{
>> +	u32 sz = 1024;
>> +	char tmp_buf[64];
>> +	char *buf;
>> +	char *bp;
>> +	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
>> +
>> +	buf = kzalloc(sz, GFP_KERNEL);
>> +	if (!buf)
>> +		return;
>> +
>> +	bp = buf;
>> +	if (bctl->flags & BTRFS_BALANCE_ARGS_SOFT)
>> +		bp += snprintf(bp, buf - bp + sz, "%s|", "soft");
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_FORCE)
>> +		bp += snprintf(bp, buf - bp + sz, "%s|", "force");
> 
> Force is a global option affecting all profiles, but 'soft' is applied
> per profile so it needs to be in the data/metadata/system group.

  Yep. Thanks. Now I have replace force as "-f". Looks better now.

  Pls find v4.

Thanks, Anand

>> +
>> +	if (bctl->flags & BTRFS_BALANCE_DATA) {
>> +		describe_balance_args(&bctl->data, tmp_buf, sizeof(tmp_buf));
>> +		bp += snprintf(bp, buf - bp + sz, "%s<%s>|", "data", tmp_buf);
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_METADATA) {
>> +		describe_balance_args(&bctl->meta, tmp_buf, sizeof(tmp_buf));
>> +		bp += snprintf(bp, buf - bp + sz, "%s<%s>|", "metadata",
>> +			       tmp_buf);
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
>> +		describe_balance_args(&bctl->sys, tmp_buf, sizeof(tmp_buf));
>> +		bp += snprintf(bp, buf - bp + sz, "%s<%s>|", "system", tmp_buf);
>> +	}
>> +
>> +	buf[bp - buf - 1] = '\0'; /* remove last | */
>> +	btrfs_info(fs_info, "%s %s",
>> +		   bctl->flags & BTRFS_BALANCE_RESUME ?
>> +		   "balance: resume":"balance: start", buf);
>> +
>> +	kfree(buf);
>> +}
>> +
>>   /*
>>    * Should be called with balance mutexe held
>>    */
>> @@ -3954,6 +4055,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   
>>   	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>>   	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>> +	describe_balance_start_or_resume(fs_info);
>>   	mutex_unlock(&fs_info->balance_mutex);
>>   
>>   	ret = __btrfs_balance(fs_info);
>> @@ -3991,10 +4093,8 @@ static int balance_kthread(void *data)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
