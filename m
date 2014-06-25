Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26428 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088AbaFYCYG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 22:24:06 -0400
Message-ID: <53AA31D0.40603@cn.fujitsu.com>
Date: Wed, 25 Jun 2014 10:20:00 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs-progs: fix max mirror number error for chunk-recover
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com> <53AA313C.9010802@redhat.com>
In-Reply-To: <53AA313C.9010802@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2014 10:17 AM, Eric Sandeen wrote:
> On 6/11/14, 9:25 PM, Gui Hecheng wrote:
>> When run chunk-recover on a health btrfs(data profile raid0, with
>> plenty of data), the program has a chance to abort on the number
>> of mirrors of an extent.
>>
>> According to the kernel code, the max mirror number of an extent
>> is 3 not 2:
>> 	ctree.h: 		BTRFS_MAX_MIRRORS	3
>> 	chunk-recover.c :	BTRFS_NUM_MIRRORS	2
>> just change BTRFS_NUM_MIRRORS to 3, and everything goes well.
> Wouldn't it make a lot more sense, then, to change the userspace
> macro to be called BTRFS_MAX_MIRRORS as well?
Yeah, agree,  Nice review. :-)

Wang
>
> -Eric
>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> ---
>>   chunk-recover.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/chunk-recover.c b/chunk-recover.c
>> index 9b46b0b..d5a688e 100644
>> --- a/chunk-recover.c
>> +++ b/chunk-recover.c
>> @@ -42,7 +42,7 @@
>>   #include "btrfsck.h"
>>   #include "commands.h"
>>   
>> -#define BTRFS_NUM_MIRRORS			2
>> +#define BTRFS_NUM_MIRRORS			3
>>   
>>   struct recover_control {
>>   	int verbose;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

