Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50896 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2HBDOh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 23:14:37 -0400
Received: by eaac11 with SMTP id c11so728666eaa.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 20:14:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501765E4.5080107@cn.fujitsu.com>
References: <CA+M2DjmS0xB8zinvELi5SBg1QRxabvHfpd1MqJxqCB65qq1ceA@mail.gmail.com>
	<50173C37.9090607@cn.fujitsu.com>
	<CA+M2Dj=oG_1QZKn1Y3wncmCw=dmLF9psBH6PPhe1Xha5-P=h9A@mail.gmail.com>
	<501765E4.5080107@cn.fujitsu.com>
Date: Wed, 1 Aug 2012 22:14:36 -0500
Message-ID: <CA+M2DjmZO=Tyr+ri78YZPsST=pPar746Fyi4XW0G9-O4FnfSOw@mail.gmail.com>
Subject: Re: balance disables nodatacow
From: Kyle Gates <kylegates@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2012 at 11:58 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 07/31/2012 12:35 PM, Kyle Gates wrote:
>
>> On Mon, Jul 30, 2012 at 9:00 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
>>> On 07/31/2012 03:55 AM, Kyle Gates wrote:
>>>
>>>> I have a 3 disk raid1 filesystem mounted with nodatacow. I have a
>>>> folder in said filesystem with the 'C' NOCOW & 'Z' Not_Compressed
>>>> flags set for good measure. I then copy in a large file and proceed to
>>>> make random modifications. Filefrag shows no additional extents
>>>> created, good so far. A big thank you to the those devs who got that
>>>> working.
>>>> However, after a balance run (which crashed btw), modifications to the
>>>> file result in increasing extent counts, ie. no longer obeying
>>>> nodatacow mount option nor the 'C' flag.
>>>> I realize that a balance will cow the data but it should not disable
>>>> the ability to make nodatacow inline changes to a file.
>>>>
>>>> I'm currently running 3.5.0 mainline Ubuntu kernel with the latest
>>>> master of btrfs-progs from a ppa.
>>>>
>>>
>>> hmm, I want to know if your 3.5.0 mainline ubuntu kernel has the commit:
>>>
>>> Btrfs: make btrfs's allocation smoothly with preallocation
>>>
>>> This commit may help you out of trouble.
>>> Please let us know the result.
>>>
>>> thanks,
>>> liubo
>>>
>>>> Thank you.
>>>> Kyle Gates
>> I didn't have that commit before but I do now:
>> Linux home 3.5.0-999-generic #201207290405 SMP Sun Jul 29 08:13:26 UTC
>> 2012 i686 athlon i386 GNU/Linux
>>
>> One of my disks is having some issues though. I got this while running a
>> balance which is now hung:
>>
>
>
> oops, I know where goes wrong.  I should have noticed it, sorry Kyle.
>
> We've not merged the following patch into mainline:
>
> Btrfs: allow delayed refs to be merged V2
> (link: https://patchwork.kernel.org/patch/1197821/)
>
> So could you please apply the patch and test it again?
>
> thanks,
> liubo

I have yet to try a kernel compile so I'll just wait until that patch
is merged, sorry.

On a related note...
Setting the 'C' NOCOW flag on a file will only be obeyed if the
filesystem is mounted with 'nodatasum'
David sent a patch for the simplest case back on 5/15/2012 but I don't
think it got merged.

A nice enhancement would be when nodatacow is enabled, checksums would
be selectively cleared as data extents are modified.

Thanks,
Kyle
