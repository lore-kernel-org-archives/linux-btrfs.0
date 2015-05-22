Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23483 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753805AbbEVCxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 22:53:03 -0400
Message-ID: <555E9A0C.3030205@cn.fujitsu.com>
Date: Fri, 22 May 2015 10:53:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Fix a bug in __btrfs_map_block() always
 maps wrong stripe for DUP/RAID1
References: <1431305148-18953-1-git-send-email-quwenruo@cn.fujitsu.com> <20150521160655.GZ23255@twin.jikos.cz>
In-Reply-To: <20150521160655.GZ23255@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 1/2] btrfs-progs: Fix a bug in __btrfs_map_block() 
always maps wrong stripe for DUP/RAID1
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月22日 00:06

> On Mon, May 11, 2015 at 08:45:47AM +0800, Qu Wenruo wrote:
>> In __btrfs_map_block(), stripe_index is always wrong if mirror_num is
>> given.
>>
>> For DUP/RAID1 case, if mirror_num is given, e.g. 1, it should return the
>> second stripe.
>> But codes consider the mirror_num is start from 1 and always minus 1,
>> causing even mirror number is given as 1, __btrfs_map_block() will still
>> map the first stripe not the second.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   volumes.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/volumes.c b/volumes.c
>> index 16dbf64..c66c02a 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -1397,7 +1397,7 @@ again:
>> -			stripe_index = mirror_num - 1;
>> +			stripe_index = mirror_num;
>> @@ -1416,7 +1416,7 @@ again:
>> -			stripe_index = mirror_num - 1;
>> +			stripe_index = mirror_num;
>
> The original code is same in kernel, is the logic different in the
> userspace code? If yes I don't see it.
>
It seems that I was confused about mirror_num of btrfs_map_block function.

When mirror mirror_num 0, it will map all stripes and if larger than 0,
it will map the <mirror_num>th stripe.

So when mirror_num is given 1, it should return the first stripe.
And it's the correct behavior.
If I am wrong again, please correct me.

Please ignore the patch.

Thanks,
Qu
