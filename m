Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38366 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab2IXCGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 22:06:12 -0400
Message-ID: <505FBFCE.3010503@cn.fujitsu.com>
Date: Mon, 24 Sep 2012 10:05:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <505A8632.10101@cn.fujitsu.com> <505C2E62.2000400@cn.fujitsu.com> <20120923114924.GA1975@zambezi.lan>
In-Reply-To: <20120923114924.GA1975@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 23 Sep 2012 14:49:24 +0300, Ilya Dryomov wrote:
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 9384a2a..d8d53f7 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3335,6 +3335,24 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>>  
>>  			goto do_balance;
>>  		}
>> +
>> +		if ((bargs->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
>> +		    (bargs->data.usage < 0 || bargs->data.usage > 100)) {
>> +			ret = -EINVAL;
>> +			goto out_bargs;
>> +		}
>> +
>> +		if ((bargs->meta.flags & BTRFS_BALANCE_ARGS_USAGE) &&
>> +		    (bargs->meta.usage < 0 || bargs->meta.usage > 100)) {
>> +			ret = -EINVAL;
>> +			goto out_bargs;
>> +		}
>> +
>> +		if ((bargs->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
>> +		    (bargs->sys.usage < 0 || bargs->sys.usage > 100)) {
>> +			ret = -EINVAL;
>> +			goto out_bargs;
>> +		}
>>  	} else {
>>  		bargs = NULL;
>>  	}
> 
> Why not drop this hunk ...

Generally, we should check the value when it is input. If not, we might
run our program with the wrong value, and it is possible to cause unknown
problems. So I think the above chunk is necessary.

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6019fb2..ff86f91 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2334,8 +2334,13 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
>  	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>  	chunk_used = btrfs_block_group_used(&cache->item);
>  
> -	BUG_ON(bargs->usage < 0 || bargs->usage > 100);
> -	user_thresh = div_factor(cache->key.offset, bargs->usage);
> +	if (bargs->usage == 0)
> +		user_thresh = 0;
> +	else if (bargs->usage >= 100)
> +		user_thresh = cache->key.offset;
> +	else
> +		user_thresh = div_factor(cache->key.offset, bargs->usage);
> +
>  	if (chunk_used < user_thresh)
>  		ret = 0;
> 
> (diff is on top of the patch in question)
> 
> This is the most straightforward transformation I can think of.  It
> doesn't result in an unnecessary BUG_ON, keeps churn to a minimum and

agree with you.

> doesn't change the "style" of the balance ioctl.  (If I were to check
> every filter argument that way, btrfs_balance_ioctl() would be very long
> and complicated.)


I think the check in btrfs_balance_ioctl() is necessary, the reason is above.

Thanks
Miao
