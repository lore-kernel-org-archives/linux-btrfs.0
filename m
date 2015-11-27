Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49714 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753552AbbK0AoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 19:44:20 -0500
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        <linux-btrfs@vger.kernel.org>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com> <565784DE.5080401@oracle.com>
CC: <dsterba@suse.cz>, <calestyo@scientia.net>, <ahferroin7@gmail.com>,
        <1i5t5.duncan@cox.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5657A757.90909@cn.fujitsu.com>
Date: Fri, 27 Nov 2015 08:44:07 +0800
MIME-Version: 1.0
In-Reply-To: <565784DE.5080401@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/11/27 06:17 +0800:
>
> Hope we are in sync on..
>
> 1.
> The term auto that you are using here refs to
>   'Progs default-features being updated at the _run time_'.

Yes.

>
> 2.
> In the long run, mostly it would be:
>    progs-version > LTS-kernel-version
> (for the reason that user would need fsck,tools.. etc)

Also true.

But mkfs default features won't change during one or two LTS kernels.

>
>
>>>>>> With the new -O comp= option, the concern on user who want to make a
>>>>>> btrfs for newer kernel is hugely reduced.
>>>>>
>>>>> NO!. actually new option -O comp= provides no concern for users who
>>>>> want to create _a btrfs disk layout which is compatible with more
>>>>> than one kernel_.  above there are two examples of it.
>>>>
>>>> Why you can't give a higher kernel version than current kernel?
>>>
>>>   mount fails.  Pls try !!
>>
>> But that's what user want to do. He/she knows what he is doing.
>> Maybe he is testing btrfs-progs self test without the need to mount
>> it(at least some of the tests doesn't require mount)
>
>   right. It will continue to fail even with this patch set.
>
>
>> Now we need to auto align feature with kernel, who know one day we will
>> need to auto align our libs to upstream package?
>
>   align libs to upstream package ? is there any eg you could provide ?

IIRC, for the ancient time, libblkid is still included in e2fsprogs and 
its API is different from nowadays.

Will us need to support that one with different blkid calls?

>
>
>> Keeping a matrix with different packages like libuuid/acl/attr with
>> different Makefile?
>> At least this is not a good idea for me, and that's the work of
>> autoconfig IIRC.
>>
>> And if I'm a package and face such problem, I'll choose the simplest
>> solution, just add a line in PKGBUILD(package system of Archlinux) of
>> btrfs.
>> ------
>> depends=('linux>=3.14')
>> ------
>> (Yeah, such simple and slick packaging solution is the reason I like
>> Arch over other rolling distribution)
>>
>> Not every thing really needed to be done in code level.
>
>   As we are handling default features at the run time, how is
>   this relevant in this context. ?

I meant, it can be done in packaging level and it's much easier to do.
One dependency line vs near 200 codes.
And it's much predictable than version based detection.

Thanks,
Qu

>
> Thanks, Anand
>
>
>
>


