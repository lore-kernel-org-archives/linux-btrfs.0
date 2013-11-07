Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab3KGDqi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 22:46:38 -0500
Message-ID: <527B0D18.3080704@redhat.com>
Date: Wed, 06 Nov 2013 21:46:32 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/16] btrfs-progs: fix resource leak in scrub_start()
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com> <1383779755-18228-9-git-send-email-sandeen@redhat.com> <527AF15A.5070409@cn.fujitsu.com> <527AF1F4.2050803@cn.fujitsu.com>
In-Reply-To: <527AF1F4.2050803@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/6/13, 7:50 PM, Wang Shilong wrote:
> On 11/07/2013 09:48 AM, Wang Shilong wrote:
>> Hi Eric,
>>
>> On 11/07/2013 07:15 AM, Eric Sandeen wrote:
>>> In the "nothing to resume" case we return directly and leak
>>> several bits of memory; goto out to free them properly.
>>>
>>> Resolves-Coverity-CID: 1125934
>>> Resolves-Coverity-CID: 1125935
>>> Resolves-Coverity-CID: 1125936
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>   cmds-scrub.c |    3 ++-
>>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/cmds-scrub.c b/cmds-scrub.c
>>> index 605af45..5f3eade 100644
>>> --- a/cmds-scrub.c
>>> +++ b/cmds-scrub.c
>>> @@ -1261,7 +1261,8 @@ static int scrub_start(int argc, char **argv, int resume)
>>>           if (!do_quiet)
>>>               printf("scrub: nothing to resume for %s, fsid %s\n",
>>>                      path, fsid);
>>> -        return 2;
>>> +        err = 2;
>>> +        goto out;
>> Thanks for tracking this problem, but
>> i intend to return 2 in such case originally.
>> return '!err' will revert to return 1 rather than 2.
> see label out:
> 
> if (err)
>     return 1
> 

Ah, whoops.  Ok, well we still need to fix the leak.  

I just expected that setting err & going to out would return err ;)

So probably:

if (err)
   return err;

will work.

I'll send a V2.

Thanks for catching it on review!

-Eric

