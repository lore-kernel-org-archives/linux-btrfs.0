Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46751 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbbKZWRY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 17:17:24 -0500
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <565784DE.5080401@oracle.com>
Date: Fri, 27 Nov 2015 06:17:02 +0800
MIME-Version: 1.0
In-Reply-To: <5656FBB7.5020802@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hope we are in sync on..

1.
The term auto that you are using here refs to
  'Progs default-features being updated at the _run time_'.

2.
In the long run, mostly it would be:
   progs-version > LTS-kernel-version
(for the reason that user would need fsck,tools.. etc)


>>>>> With the new -O comp= option, the concern on user who want to make a
>>>>> btrfs for newer kernel is hugely reduced.
>>>>
>>>> NO!. actually new option -O comp= provides no concern for users who
>>>> want to create _a btrfs disk layout which is compatible with more
>>>> than one kernel_.  above there are two examples of it.
>>>
>>> Why you can't give a higher kernel version than current kernel?
>>
>>   mount fails.  Pls try !!
>
> But that's what user want to do. He/she knows what he is doing.
> Maybe he is testing btrfs-progs self test without the need to mount
> it(at least some of the tests doesn't require mount)

  right. It will continue to fail even with this patch set.


> Now we need to auto align feature with kernel, who know one day we will
> need to auto align our libs to upstream package?

  align libs to upstream package ? is there any eg you could provide ?


> Keeping a matrix with different packages like libuuid/acl/attr with
> different Makefile?
> At least this is not a good idea for me, and that's the work of
> autoconfig IIRC.
>
> And if I'm a package and face such problem, I'll choose the simplest
> solution, just add a line in PKGBUILD(package system of Archlinux) of
> btrfs.
> ------
> depends=('linux>=3.14')
> ------
> (Yeah, such simple and slick packaging solution is the reason I like
> Arch over other rolling distribution)
>
> Not every thing really needed to be done in code level.

  As we are handling default features at the run time, how is
  this relevant in this context. ?

Thanks, Anand


