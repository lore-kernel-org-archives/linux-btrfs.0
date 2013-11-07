Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3103 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab3KGFKZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:10:25 -0500
Message-ID: <527B1FED.4070604@cn.fujitsu.com>
Date: Thu, 07 Nov 2013 13:06:53 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/16] btrfs-progs: fix resource leak in scrub_start()
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com> <1383779755-18228-9-git-send-email-sandeen@redhat.com> <527AF15A.5070409@cn.fujitsu.com> <527AF1F4.2050803@cn.fujitsu.com> <527B0D18.3080704@redhat.com>
In-Reply-To: <527B0D18.3080704@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/07/2013 11:46 AM, Eric Sandeen wrote:
> On 11/6/13, 7:50 PM, Wang Shilong wrote:
>> On 11/07/2013 09:48 AM, Wang Shilong wrote:
>>> Hi Eric,
>>>
>>> On 11/07/2013 07:15 AM, Eric Sandeen wrote:
>>>> In the "nothing to resume" case we return directly and leak
>>>> several bits of memory; goto out to free them properly.
>>>>
>>>> Resolves-Coverity-CID: 1125934
>>>> Resolves-Coverity-CID: 1125935
>>>> Resolves-Coverity-CID: 1125936
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>    cmds-scrub.c |    3 ++-
>>>>    1 files changed, 2 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/cmds-scrub.c b/cmds-scrub.c
>>>> index 605af45..5f3eade 100644
>>>> --- a/cmds-scrub.c
>>>> +++ b/cmds-scrub.c
>>>> @@ -1261,7 +1261,8 @@ static int scrub_start(int argc, char **argv, int resume)
>>>>            if (!do_quiet)
>>>>                printf("scrub: nothing to resume for %s, fsid %s\n",
>>>>                       path, fsid);
>>>> -        return 2;
>>>> +        err = 2;
>>>> +        goto out;
>>> Thanks for tracking this problem, but
>>> i intend to return 2 in such case originally.
>>> return '!err' will revert to return 1 rather than 2.
>> see label out:
>>
>> if (err)
>>      return 1
>>
> Ah, whoops.  Ok, well we still need to fix the leak.
>
> I just expected that setting err & going to out would return err ;)
>
> So probably:
>
> if (err)
>     return err;
No, we can't.
maybe add a flag, something like:

flag = 0;

/*  we set flag here for a special case */
if (!do_quient)
     printf....
flag = 2;


then in label
out:
...
/* this happen if nothing resume */
     if (flag)
         return flag
/* syntax or other error happens */
     if (err)
         return 1

Previously, 'err' can be an casual positive numbers or error number.
However, we define that we return 1 if syntax error happens.

Thanks,
Wang
>
> will work.
>
> I'll send a V2.
>
> Thanks for catching it on review!
>
> -Eric
>
>


