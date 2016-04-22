Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60851 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbcDVGC7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 02:02:59 -0400
Subject: Re: Question: raid1 behaviour on failure
To: Matthias Bodenbinder <matthias@bodenbinder.de>,
        <linux-btrfs@vger.kernel.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
 <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
 <nf9o32$7r4$1@ger.gmane.org>
 <180d89ae-32cf-ad59-2b6e-56ed82e9f439@cn.fujitsu.com>
 <nfb39q$iv0$1@ger.gmane.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1772508d-40b5-5303-8edb-29b5504216aa@cn.fujitsu.com>
Date: Fri, 22 Apr 2016 14:02:45 +0800
MIME-Version: 1.0
In-Reply-To: <nfb39q$iv0$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Matthias Bodenbinder wrote on 2016/04/21 19:40 +0200:
> Am 21.04.2016 um 07:43 schrieb Qu Wenruo:
>> There are already unmerged patches which will partly do the mdadm level behavior, like automatically change to degraded mode without making the fs RO.
>>
>> The original patchset:
>> http://comments.gmane.org/gmane.comp.file-systems.btrfs/48335
>
> The description of thix patch says:
>
> "Although the one-size-fit-all solution is quite safe, it's too strict if
> data and metadata has different duplication level."
> ...
> "This patchset will introduce a new per-chunk degradable check for btrfs,
> allow above case to succeed, and it's quite small anyway."
>
>
> My raid1 is "-m raid1 -d raid1". Both the same duplication level. Would that patch make any difference?

Without this patch, we can abort_transaction() at commit or space 
allocation time.
(There is also user can't reproduce your bug though)

Although this patchset is not full fix, it provides the basis for later 
raid1 failure fix.

And that's the reason Anand Jain pick these patchse into this big 
auto-replace patchset.

I was meant to do further fix, but now Anand Jain is pushing 
auto-replace so I didn't do anything newer after the original patchset.

>
> And: What do I need to do to test this in "debian stable"? I am not a programmer - but I know how to use git and how to compile with proper configuration directions.

If no experience in git and kernel compile, then you can still do your 
contribution.

Since Satoru can't reproduce the problem, would you please try his 
method to reproduce it?

As I found your kernel is 4.4, not old but still not the latest, while I 
think Satoru is using the latest one.

If it's possible, please use the 4.5/4.6-rc kernel if debian provided.
If it's not possible (debian doesn't provide 4.5 or 4.6-rc), would you 
please try the same process Satoro provided.

As unlike Satoru's process, your fs is not newly created(empty).

If we can reproduce it, it would be much easier to fix.

Thanks,
Qu

>
> Matthias
>
>
>> Or the latest patchset inside Anand Jain's auto-replace patchset:
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/55446
>>
>> Thanks,
>> Qu
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


