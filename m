Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35432 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbeEYDCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 23:02:23 -0400
Subject: Re: [PATCH v4 2/3] btrfs: balance: add args info during start and
 resume
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180523063508.18695-1-anand.jain@oracle.com>
 <20180523063508.18695-3-anand.jain@oracle.com>
 <20180524130318.GG6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f14c3ea9-5df7-ab51-8645-2c77b16599e8@oracle.com>
Date: Fri, 25 May 2018 11:04:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180524130318.GG6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/24/2018 09:03 PM, David Sterba wrote:
> On Wed, May 23, 2018 at 02:35:07PM +0800, Anand Jain wrote:
>> Balance arg info is an important information to be reviewed for the
>> system audit. So this patch adds them to the kernel log.
>>
>> Example:
>>
>> ->btrfs bal start --full-balance -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs
> 
> --full-balance should not be here as it's for the case when no filter is
> used.

  Oh yep. I should remove that.

>>   kernel: BTRFS info (device sdc): balance: start -f -d usage=50,limit=10..20 -m soft,profiles=raid1,convert=single -s soft,profiles=raid1,convert=single
> 
> While this looks good, it would not work as is because of the dual
> syntax of -d and -m, the argument is optional and with the space between
> it'll fail with "btrfs filesystem balance start: too many arguments" .

  I have dropped the space after -d -m -s and cut and paste works.
  I have it in the version v4.1a.

> At least the main parts of the string are copy&paste ready, so the
> format can be like
> 
> balance: start force D:usage=50,limit=10..20 M:soft,profiles=raid1,convert=single S:soft,profiles=raid1,convert=single

  This not bad either. But I liked the idea of just plain of cut and
  paste and I am fine with either format. And I have this in the version
  v4.1b. So can you pls pick either v4.1a or v4.1b for the integration.

more below..

> or with "DATA:" "METADATA:"

>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v3->v4: Change log updated with new example.
>> 	Log format is changed to almost match with the cli.
>> 	snprintf drop %s for inline string.
>> 	Print range as =%u..%u instead of min=%umax=%u.
>> 	soft is under the args now.
>> 	force is printed as -f.
>>
>> v2->v3: Change log updated.
>>          Make use of describe_block_group() added in 1/4
>>          Drop using strcat instead use snprintf.
>>          Logs string format updated as shown in the example above.
>>
>> v1->v2: Change log update.
>>          Move adding the logs for balance complete and end to a new patch
>>
>>   fs/btrfs/volumes.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 104 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 44f4799bf06f..85f954f7f93e 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3806,6 +3806,108 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
>>   		 (bctl_arg->target & ~allowed)));
>>   }
>>   
>> +static u32 describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
>> +				 u32 size_buf)
>> +{
>> +	char *bp = buf;
>> +	u64 flags = bargs->flags;
>> +	char tmp_buf[128];
>> +
>> +	if (!flags)
>> +		return 0;
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_SOFT)
>> +		bp += snprintf(bp, buf - bp + size_buf, "soft,");
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_PROFILES) {
>> +		btrfs_describe_block_groups(bargs->profiles, tmp_buf,
>> +					    sizeof(tmp_buf));
>> +		bp += snprintf(bp, buf - bp + size_buf, "profiles=%s,",
>> +			       tmp_buf);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_USAGE)
>> +		bp += snprintf(bp, buf - bp + size_buf, "usage=%llu,",
>> +			       bargs->usage);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_USAGE_RANGE)
>> +		bp += snprintf(bp, buf - bp + size_buf, "usage=%u..%u,",
>> +			       bargs->usage_min, bargs->usage_max);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_DEVID)
>> +		bp += snprintf(bp, buf - bp + size_buf, "devid=%llu,",
>> +			       bargs->devid);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_DRANGE)
>> +		bp += snprintf(bp, buf - bp + size_buf, "drange=%llu..%llu,",
>> +			       bargs->pstart, bargs->pend);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_VRANGE)
>> +		bp += snprintf(bp, buf - bp + size_buf, "vrange%llu..%llu,",
>> +			       bargs->vstart, bargs->vend);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT)
>> +		bp += snprintf(bp, buf - bp + size_buf, "limit=%llu,",
>> +			       bargs->limit);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE)
>> +		bp += snprintf(bp, buf - bp + size_buf, "limit=%u..%u,",
>> +			       bargs->limit_min, bargs->limit_max);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE)
>> +		bp += snprintf(bp, buf - bp + size_buf, "stripes=%u..%u,",
>> +			       bargs->stripes_min, bargs->stripes_max);
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		int index = btrfs_bg_flags_to_raid_index(bargs->target);
>> +
>> +		bp += snprintf(bp, buf - bp + size_buf, "convert=%s,",
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

  I have taken this opportunity to rename this to size_buf.

>> +	char tmp_buf[64];
> 
> This is too short, the profiles= can contain all profile names that
> itself has 50 bytes, plus any filter, this will not fit the buffer.

  oh yes. Theoretically it should be more than the buffer in the
  describe_balance_args() + btrfs_describe_block_groups (128). Given
  that the user might specify all the options with the lengthy stripe
  range in describe_balance_args(), I have made it 192 bytes.

> Other than that, it looks good and I'll add it to for-next. We may still
> want tweak the exact output format and buffer sizes, there's a bit of time.

  I have both types sent (v4.1a: no space v4.1b: cap abbreviates) pls
  pick one. I would go by the method which ever is more easier to cut
  and paste.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
