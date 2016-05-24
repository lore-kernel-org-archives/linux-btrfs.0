Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54165 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753300AbcEXAbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 20:31:08 -0400
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160523120112.GK29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
Date: Tue, 24 May 2016 08:31:01 +0800
MIME-Version: 1.0
In-Reply-To: <20160523120112.GK29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/23 14:01 +0200:
> The API does not seem right. It's fine to provide functions for full
> int/u32/u64 ranges, but in the cases when we know the range from which
> we request the random number, it has to be passed as parameter. Not
> doing the % by hand.

This makes sense.
I'll add a new function to create random number for a given range.
>
>> +u32 rand_u32(void)
>> +{
>> +	struct timeval tv;
>> +	unsigned short rand_seed[3];
>
> This could be made static (with thread local storage) so the state does
> not get regenerated all the time. Possibly it could be initialize from
> some true random source, not time or pid.

I also considered true random source like /dev/random, but since it's 
possible to wait for entropy pool, it would be quite slow and confusing 
for users.

So time with pid seems good enough.

>
>> +	long int ret;
>> +	int i;
>> +
>> +	gettimeofday(&tv, 0);
>> +	rand_seed[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
>> +	rand_seed[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
>> +	rand_seed[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
>> +
>> +	/* Crank the random number generator a few times */
>> +	gettimeofday(&tv, 0);
>> +	for (i = (tv.tv_sec ^ tv.tv_sec) ^ 0x1F; i > 0; i--)
>> +		nrand48(rand_seed);
>
> This would be then unnecesssray, just draw the number from nrand.

Right, this part is just copied from libuuid, but in fact we don't 
really need to be that random.

>
> About patch separation: please introduce the new api in one patch, use
> in another (ie. drop srand and switch to it).

OK, I'll update it in next version.

Thanks,
Qu


