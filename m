Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61134 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753230AbdAAJ2z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Jan 2017 04:28:55 -0500
Subject: Re: Btrfs send does not preserve reflinked files within subvolumes.
To: Glenn Washburn <development@efficientek.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20161228204430.348cb61f@crass-Ideapad-Z570>
 <c4956c5f-b9e2-fe28-0c0d-4e6a03da9a7c@cn.fujitsu.com>
 <20161229042055.17e4774e@crass-Ideapad-Z570>
 <a9f1fb46-5311-2279-68a0-66cf9979ebac@cn.fujitsu.com>
 <20161231180614.3c78537b@crass-Ideapad-Z570>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6ac3a0db-91f7-14d9-b3ae-d95009100f2e@gmx.com>
Date: Sun, 1 Jan 2017 17:28:22 +0800
MIME-Version: 1.0
In-Reply-To: <20161231180614.3c78537b@crass-Ideapad-Z570>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Glenn,

On 01/01/2017 08:06 AM, Glenn Washburn wrote:
> Hey Qu,
>
> On Fri, 30 Dec 2016 08:47:07 +0800
> Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>> Hi Glenn,
>>
>> Confirmed it's kernel bug.
>> Send stream doesn't contain the clone operation.
>>
>> So it's kernel send to blame.
>>
>>>
>>> As I was using btrgs-progs v4.4, I've compiled v4.9 to get the nice
>>> --dump option for receive (which you seem to have added, kudos!).
>>> The output of the dump option is in the *.recv-dump.log files.
>>> However, I see no clone command in the output.
>>>
>>> Keep in mind that I'm running Ubuntu kernel 4.4.0-53-generic, which
>>> I believe to be mostly v4.4.30 with a few patches.  Any ideas when
>>> send started using "clone" in the kernel?
>>
>> Not pretty sure about from which exact kernel version send can detect
>> reflink.
>>
>> AFAIC I sent an RFC patch to disable reflink detection in send in
>> July 2016, and it just got rejected.
>>
>> So I assume at least v4.6 kernel works.
>
> I've tested with Ubuntu's 4.8 kernel and still no luck.  What kernel
> version are you using? And what version of btrfs-progs?

Mainline v4.8 and v4.9 works for me.

Maybe Ubuntu adds some out-of-tree patch?
Would you please try mainline kernel?

>
> If I understand you correctly, you're trying to submit a patch that
> disables reflink detection, which would prevent what I'm trying to do?

Yes. But it's just an RFC patch, and IIRC Jeff from SUSE is working on a 
new backref iteration algorithm to handle it.
So the RFC patch will never be merged.

> Why is this desired and is it able to be switched off?

The patch doesn't get merged into mainline, so nothing to worry unless 
Ubuntu picked it.
And if Ubuntu picked it, unless Ubuntu guys add some black magic, no 
method to disable it.

The idea is, current backref walker will iterate *ALL* backrefs, to 
ensure we can find correct owner to send out clone operation other than 
normal write.

Normally it works fine, but for case like in-band or out-of-band dedupe, 
it's possible an extent to be referred millions times.

Furthermore due to the bad designed backref walk algorithm, it takes 
O(n^3)~O(n^4) time to iterate all backref.
This means we will takes hours for one backref walk, hanging the fs.

So, right now I'm not sure what's going wrong. I can only suggest to use 
mainline kernel to test the behavior other than Ubuntu one.

If it's not convenient for you to build mainline kernel, I would suggest 
to extract kernel from Archlinux, whose kernel is almost mainline with 
minium modification.
(Any quite easy to extract, just unxz it)

Thanks,
Qu

>
> Thanks,
> Glenn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
