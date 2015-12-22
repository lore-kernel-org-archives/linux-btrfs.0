Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57352 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbbLVOWo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 09:22:44 -0500
Subject: Re: [PATCH v4 1/2] btrfs: Introduce new mount option backuproot to
 replace recovery
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAHji153JzZu0BW80fJo38GwEesAGWbwWcLhrianwXqbvTFjJaA@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56795C7D.3010800@gmx.com>
Date: Tue, 22 Dec 2015 22:21:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAHji153JzZu0BW80fJo38GwEesAGWbwWcLhrianwXqbvTFjJaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/22/2015 08:30 PM, Holger Hoffstätte wrote:
> On Tue, Dec 22, 2015 at 3:16 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Current "recovery" mount option will only try to use backup root.
>> However the word "recovery" is too generic and may be confusing for some
>> users.
>>
>> Here introduce a new and more specific mount option, "backuproot" to
>> replace "recovery" mount option.
>> "Recovery" will be kept for compatibility reason, but will be
>> deprecated.
>
> I agree that this makes much more sense from a user's perspective, so +1.
>
> But why not go all the way: try backuproot automatically when the
> initial mount fails,
> log the fallback and simply deprecate/ignore the option?

Auto repair is commonly a good choice, but only for small or expected 
problem.

For case like need to replay log against power loss, that's completely 
OK to auto do it without any human input.

But for case like current tree/chunk/extent root corruption, it is 
already a *BIG* problem.
Either corrupted device or hidden Btrfs bug.

And in some case, using auto backup root may lead to more problem, 
especially when the generation difference is larger than 2, it's 
possible backup root points to completely wrong extents.

So here I still follow the original behavior.

Thanks,
Qu
>
> Either this works - in which case there is no need to involve a human,
> which may not
> even exist - or it does not. If it does not, things are hosed anyway
> and we can fail
> properly.
>
> Any reasons not to do this?
>
> -h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
