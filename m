Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16678 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2JRIBX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 04:01:23 -0400
Message-ID: <507FB74B.4020807@oracle.com>
Date: Thu, 18 Oct 2012 16:01:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup for __merge_refs
References: <1350544242-2271-1-git-send-email-bo.li.liu@oracle.com> <507FB062.1010806@jan-o-sch.net> <507FB186.9040901@oracle.com> <507FB2E1.2090106@jan-o-sch.net>
In-Reply-To: <507FB2E1.2090106@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/18/2012 03:42 PM, Jan Schmidt wrote:
> On Thu, October 18, 2012 at 09:36 (+0200), Liu Bo wrote:
>> On 10/18/2012 03:31 PM, Jan Schmidt wrote:
>>> On Thu, October 18, 2012 at 09:10 (+0200), Liu Bo wrote:
>>>> Parents must be same after going through ref_for_same_block.
>>>
>>> Well. We could kill that for the moment. However, ref_for_same_block wasn't
>>> meant to check for the parent. We should do ...
>>>
>>> --- a/fs/btrfs/backref.c
>>> +++ b/fs/btrfs/backref.c
>>> @@ -400,8 +400,6 @@ static inline int ref_for_same_block(struct __prelim_ref *ref1,
>>>                 return 0;
>>>         if (ref1->key_for_search.offset != ref2->key_for_search.offset)
>>>                 return 0;
>>> -       if (ref1->parent != ref2->parent)
>>> -               return 0;
>>>
>>>         return 1;
>>>  }
>>>
>>> Those two lines were originally added while debugging. The idea was to merge
>>> indirect (parent == 0) and shared backrefs (parent != 0) to avoid the expensive
>>> tree search for indirect backrefs when possible.
>>>
>>> We would need extensive testing to remove those two lines from the current
>>> version, though...
>>>
>>
>> Oh, all right, would you make this as a patch by yourself or I can send a V2 for you?
> 
> If you want to make sure nothing would break with that patch, feel free to send
> it :-) It's quite a few things to think of, and a lot to test, though. Currently
> I don't want to put that much effort into backref walking performance. I might
> do so later if you decide not to do it now.
> 

Well, I can make the change locally and do some testing to see if it brings any bugs.

> I'm also okay with applying your original patch for now, although those lines
> are very likely come back in the future.
> 

So just leave it alone :)

thanks,
liubo

> Thanks,
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

