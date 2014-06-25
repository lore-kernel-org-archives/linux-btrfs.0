Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaFYFOm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 01:14:42 -0400
Message-ID: <53AA5ABF.1030102@redhat.com>
Date: Wed, 25 Jun 2014 00:14:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: fix max mirror number error for chunk-recover
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>	 <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com>	 <53AA313C.9010802@redhat.com> <1403662935.31177.3.camel@localhost.localdomain>
In-Reply-To: <1403662935.31177.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/24/14, 9:22 PM, Gui Hecheng wrote:
> On Tue, 2014-06-24 at 21:17 -0500, Eric Sandeen wrote:
>> On 6/11/14, 9:25 PM, Gui Hecheng wrote:
>>> When run chunk-recover on a health btrfs(data profile raid0, with
>>> plenty of data), the program has a chance to abort on the number
>>> of mirrors of an extent.
>>>
>>> According to the kernel code, the max mirror number of an extent
>>> is 3 not 2:
>>> 	ctree.h: 		BTRFS_MAX_MIRRORS	3
>>> 	chunk-recover.c :	BTRFS_NUM_MIRRORS	2
>>> just change BTRFS_NUM_MIRRORS to 3, and everything goes well.
>>
>> Wouldn't it make a lot more sense, then, to change the userspace
>> macro to be called BTRFS_MAX_MIRRORS as well?
>>
>> -Eric
>>
> Yes, Eric, unify the names between userspace and kernelspace is really a
> good point. Also, I plan to move the macro into ctree.h, what do you
> think?

It's only used in chunk-recover.c, so I don't see much point to moving it
to a new file.

To be honest, I haven't paid a lot of attention to the code.  The macro
*is* actually used to limit the same thing in userspace as in kernelspace,
right? ;)

-Eric

> -Gui
> 
>>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>>> ---
>>>  chunk-recover.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/chunk-recover.c b/chunk-recover.c
>>> index 9b46b0b..d5a688e 100644
>>> --- a/chunk-recover.c
>>> +++ b/chunk-recover.c
>>> @@ -42,7 +42,7 @@
>>>  #include "btrfsck.h"
>>>  #include "commands.h"
>>>  
>>> -#define BTRFS_NUM_MIRRORS			2
>>> +#define BTRFS_NUM_MIRRORS			3
>>>  
>>>  struct recover_control {
>>>  	int verbose;
>>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

