Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58399 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbaDOJQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 05:16:30 -0400
Message-ID: <534CF8C6.1050405@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 17:15:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] btrfs-progs: Fix the return value when executing
 'btrfs pro get' on a uncompress file.
References: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>	<1397545492-3054-4-git-send-email-quwenruo@cn.fujitsu.com> <CAL3q7H7Wvgs0ejnd6iAVJMf6mi98tHGcCKu52+FMY98rMrBeHQ@mail.gmail.com>
In-Reply-To: <CAL3q7H7Wvgs0ejnd6iAVJMf6mi98tHGcCKu52+FMY98rMrBeHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 4/4] btrfs-progs: Fix the return value when 
executing 'btrfs pro get' on a uncompress file.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年04月15日 17:09
> On Tue, Apr 15, 2014 at 8:04 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> When executing 'btrfs pro get' on a file which is not compressed, return
>> value will always be 50 since prop_compress() return -ENOATTR.
>>
>> But this should be ignored and other prop_XXX() returns 0, so when
>> prop_compress() is executed on uncompress file, it should return 0.
>>
>> Signed-off-by: Qu Wenruo <quwenro@cn.fujitsu.com>
>> ---
>>   props.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/props.c b/props.c
>> index 4d0aeea..49ee982 100644
>> --- a/props.c
>> +++ b/props.c
>> @@ -146,6 +146,7 @@ static int prop_compression(enum prop_object_type type,
>>                          fprintf(stderr,
>>                                  "ERROR: failed to %s compression for %s. %s\n",
>>                                  value ? "set" : "get", object, strerror(-ret));
>> +               ret = 0;
>>                  goto out;
> Hi Qu,
>
> So this should set ret to 0 if error ==  -ENOATTR. And of course the
> check above should be against  -ENOATTR and not -ENODATA.
>
> thanks
Thanks for pointing it out, I'll send the v2 patch soon.

Thanks,
Qu
>
>
>>          }
>>          if (!value) {
>> --
>> 1.9.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

