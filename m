Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab2IUI0g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 04:26:36 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8L8QTUQ003188
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2012 16:26:29 +0800
Message-ID: <505C24B7.5080508@cn.fujitsu.com>
Date: Fri, 21 Sep 2012 16:26:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <505A8632.10101@cn.fujitsu.com> <20120920132802.GM17430@twin.jikos.cz>
In-Reply-To: <20120920132802.GM17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Sep 2012 15:28:03 +0200, David Sterba wrote:
> On Thu, Sep 20, 2012 at 10:57:54AM +0800, Miao Xie wrote:
>> Because those functions are mostly used on the hot path, and we are sure
>> the parameters are right in the most cases, we don't add complex checks
>> for the parameters. But in the other place, we must check and make sure
>> the parameters are right. So besides the code cleanup, this patch also
>> add a check for the usage of the space balance, it is the only place that
>> we need add check to make sure the parameters of div_factor{_fine} are
>> right till now.
> 
> I've reviewed the hotpaths, makes sense to optimize for speed. Adding
> the boundary checks to balance ioctl is ok.
> 
> A few suggestions:
> 
> * drop the version that does the /10 version and keep only /100 (naming
>   it div_factor)
> * drop the
> 
> +	if (factor == 10)
> +		return num;
> 
> check, there's only one instance where we pass the maximum value (and
> it's not a frequent case), so there's the if() penalty, makes the
> function smaller and even more suitable for inlining.

OK.

> 
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
> 
> data.usage <= 0
> 
> otherwise you'd divide by 0 in chunk_usage_filter()

The divisor always is 100 or 10, so...

>> diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
>> new file mode 100644
>> index 0000000..b7816ce
>> --- /dev/null
>> +++ b/fs/btrfs/math.h
> 
> I think we don't need single file to hold one trivial function then :)
> 
>> @@ -0,0 +1,44 @@
>> +#include <asm/div64.h>
>> +
>> +static inline u64 div_factor(u64 num, int factor)
>> +{
>> +	num *= factor;
>> +	do_div(num, 100);
>> +	return num;
>> +}

I don't find a suitable file to put it down. Maybe we can stuff it
into ctree.h, but I prefer a single file to a unrelated file.

Thanks
Miao
