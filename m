Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759215AbeD1Co2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 22:44:28 -0400
Subject: Re: [PATCH 2/2] btrfs: add balance args info during start and resume
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180426080129.3270-1-anand.jain@oracle.com>
 <20180426080129.3270-3-anand.jain@oracle.com>
 <9822975f-9fe7-429d-2871-84ed9e5d299d@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <16571dc5-de44-fe74-5641-e825af114cee@oracle.com>
Date: Sat, 28 Apr 2018 10:46:39 +0800
MIME-Version: 1.0
In-Reply-To: <9822975f-9fe7-429d-2871-84ed9e5d299d@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/27/2018 02:46 PM, Nikolay Borisov wrote:
> 
> 
> On 26.04.2018 11:01, Anand Jain wrote:
>> Balance args info is an important information to be reviewed on the
>> system under audit. So this patch adds that.
> 
> Would have been good to add example output to the change log.

Here are the samples (will add in v2): (only for the illustrations, 
configs may not be ideal)

1. Find raid1 or single convert them to raid5 for both data and metadata:

btrfs bal start -dprofiles='raid1|single',convert=raid5 
-mprofiles='raid1|single',convert=raid5 /btrfs

  kernel: BTRFS info (device sdb): balance: start data 
profiles=raid1|single convert=raid5 metadata profiles=raid1|single 
convert=raid5 system profiles=raid1|single convert=raid5
::
  kernel: BTRFS info (device sdb): balance: ended with status: 0

2. Start, Pause and resume.

btrfs bal start -dprofiles=raid5,convert=single 
-mprofiles='raid1|single',convert=raid5 --background /btrfs && btrfs bal 
pause /btrfs && btrfs bal resume /btrfs

  kernel: BTRFS info (device sdb): balance: start data profiles=raid5 
convert=single metadata profiles=raid1|single convert=raid5 system 
profiles=raid1|single convert=raid5
  ::
  kernel: BTRFS info (device sdb): balance: paused  (<-- I am planning 
to add %age completed here at a later point of time).
  ::
  kernel: BTRFS info (device sdb): balance: resume data profiles=raid5 
convert=single metadata profiles=raid1|single convert=raid5 system 
profiles=raid1|single convert=raid5
  ::
  kernel: BTRFS info (device sdb): balance: ended with status: 0

::

>> @@ -3770,6 +3796,121 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
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
> +	if (bg_flags & BTRFS_AVAIL_ALLOC_BIT_SINGLE) {
> +		if (found) {

  Hmm.. I didn't get this part of your comments.

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
> 
> Having all those ifs as independent statements means we can potentially
> have each and every value present, I haven't really counted how long the
> string could potentially get. Is it not possible to convert some of them
> into if/else if constructs or is it indeed possible to have all of them
> present at once?

  It won't help much there are only -usage- and -limit- which are
  mutually exclusive with -usage_range- and -limit_range- respectively.
  Moreover its just one time when balance starts/resumes.

  Further as these are flags, I like to do the correct way, that is,
  depend on the flags to print its args, so that we know if there is
  anything wrong. And there is one..

  btrfs bal start -dusage="5..90",usage=100 /btrfs

    kernel: BTRFS info (device sdb): balance: start data usage=100 <-- 
we pick the -usage- which is correct.

  btrfs bal start -dusage=100,usage="5..90" /btrfs

    kernel: BTRFS info (device sdb): balance: start data 
usage=386547056645 usage_min=5 usage_max=90 <-- we pick the usage with a 
wrong value. a bug.


>> @@ -3910,11 +4051,19 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>>   
>>   	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>>   	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>> +	print_balance_start_or_resume(fs_info);
>>   	mutex_unlock(&fs_info->balance_mutex);
>>   
>>   	ret = __btrfs_balance(fs_info);
>>   
>>   	mutex_lock(&fs_info->balance_mutex);
>> +	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
>> +		btrfs_info(fs_info, "balance: paused");
>> +	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
>> +		btrfs_info(fs_info, "balance: canceled");
>> +	else
>> +		btrfs_info(fs_info, "balance: ended with status: %d", ret);
>> +
> 
> Unrelated change

  As of now there is no logs when balance completes or paused.
  I can move this to a new patch as I didn't say it explicitly
  in the change log.

>>   	clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>>   
>>   	if (bargs) {
>> @@ -3947,10 +4096,8 @@ static int balance_kthread(void *data)
>>   	int ret = 0;
>>   
>>   	mutex_lock(&fs_info->balance_mutex);
>> -	if (fs_info->balance_ctl) {
>> -		btrfs_info(fs_info, "balance: resuming");
>> +	if (fs_info->balance_ctl)
>>   		ret = btrfs_balance(fs_info->balance_ctl, NULL);
>> -	}
> Unrelated change.

  Why?

Thanks, Anand
