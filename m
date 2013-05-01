Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:57896 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754410Ab3EAIuj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 04:50:39 -0400
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id 87CF55FFFB
	for <linux-btrfs@vger.kernel.org>; Wed,  1 May 2013 17:50:38 +0900 (JST)
Message-ID: <5180D75E.4030605@parallels.com>
Date: Wed, 01 May 2013 17:50:38 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Best Practice - Partition, or not?
References: <loom.20130501T094600-451@post.gmane.org> <5180CB66.9030803@parallels.com> <201305011844.07087.russell@coker.com.au>
In-Reply-To: <201305011844.07087.russell@coker.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/2013 05:44 PM, Russell Coker wrote:
> On Wed, 1 May 2013, dima <dolenin@parallels.com> wrote:
>>> If I want to manage a complete disk with btrfs, what's the "Best
>>> Practice"? Would it be best to create the btrfs filesystem on
>>> "/dev/sdb", or would it be better to create just one partition from
>>> start to end and then do "mkfs.btrfs /dev/sdb1"?
>>>
>>> Would the same recomendation hold true, if we're talking about huge
>>> disks, like 4TB or so?
>
> My biggest BTRFS array is a RAID-1 of 2*3TB disks.  The system in question
> boots from an Intel SSD so I have no need of boot support on the hard disks.
>
>> (NB: grub will not boot from "/dev/sdb", selinux will)
>
> Not sure what you mean here, but SE Linux isn't a boot loader.  Did you mean
> syslinux?  That's a boot loader but I don't know if it works in such a
> configuration.
>

gosh! of course, SYSLINUX. Sorry guys.
(i am working with selinux just now that is why....)

Yes, syslinux will work, I had an install with root btrfs with syslinux 
as a bootloader (at the time when grub2 did not support booting from btrfs)
