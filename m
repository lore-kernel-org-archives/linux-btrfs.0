Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11822 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2IWJyQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 05:54:16 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8N9sEPD027861
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Sep 2012 17:54:14 +0800
Message-ID: <505EDC4A.1060709@cn.fujitsu.com>
Date: Sun, 23 Sep 2012 17:54:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <505A8632.10101@cn.fujitsu.com> <505C2E62.2000400@cn.fujitsu.com> <20120921152444.GV17430@twin.jikos.cz>
In-Reply-To: <20120921152444.GV17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Sep 2012 17:24:44 +0200, David Sterba wrote:
> On Fri, Sep 21, 2012 at 05:07:46PM +0800, Miao Xie wrote:
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3335,6 +3335,24 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>>  
>>  			goto do_balance;
>>  		}
>> +
>> +		if ((bargs->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
>> +		    (bargs->data.usage < 0 || bargs->data.usage > 100)) {
> 
> the 0 checks belong here
> 
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
>> @@ -2347,7 +2335,8 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
>>  	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>>  	chunk_used = btrfs_block_group_used(&cache->item);
>>  
>> -	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
>> +	BUG_ON(bargs->usage < 0 || bargs->usage > 100);
> 
> otherwise it reliably crashes here

Sorry, I don't know why it will crash here if we input 0. I tried to input 0,
and it worked well.

I think the only case we must take into account is the users might input the wrong value (>100 or <0)
on the old kernel, and it can be stored into the filesystem. If we mount this filesystem
on the new kernel, some problems may happen.

Thanks
Miao
