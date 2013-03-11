Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:52535 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3CKNby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 09:31:54 -0400
Received: by mail-da0-f49.google.com with SMTP id t11so353272daj.22
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 06:31:54 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: about btrfs quota issues
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <513DD925.5040106@gmx.net>
Date: Mon, 11 Mar 2013 21:31:49 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <5CEDCD84-0030-4AD1-A470-1F176D1D9CC5@gmail.com>
References: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com> <513DD925.5040106@gmx.net>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

> On 10.03.2013 05:21, Shilong Wang wrote:
>> Hello, Arne
>> 
>>          Steps to reproduce:
>> 
>> 
>>                mkfs.btrfs <disk>
>>                mount <disk> <mnt>
>>                btrfs quota enable <mnt>
>> 
>>                btrfs sub create <mnt>/sub
>>                btrfs qgroup create 1/1 <mnt>
>>                btrfs qgroup assign sub_qgroupid 1/1 <mnt>
>> 
>> 
>>                dd if=/dev/zero of=<mnt>/sub/data bs=1M count=1
>>                sync
>>                btrfs qgroup show  <mnt>
>>                #until now, every thing goes well, however, if snapshot happens
>>                #the quota accounting will go wrong
>> 
>>               btrfs sub snapshot <mnt>/sub <mnt>/snap
>>               sync
>>               btrfs qgroup show <mnt>
>>               #the accounting information of group(1/1) is not expected
>>               #here exclusive of group (1/1) do not change as expected.
>> 
>> So i took a close look at the algorithm of quota accounting, the 3
>> steps of algorithm don't
>> consider some cases like the above example.
>> 
>> In fact, i think you try to put some work on users, especially when
>> snapshot happens.
>> It is complex to track all the group's accounting when having
>> snapshots..See the following
>> commands.
>> 
>> btrfs sub snapshot -c src_qgroupid:dst_qgroupid  <mnt>
>> btrfs sub snapshot  -x src_qgroupid:dst_qgroupid <mnt>
>> 
>> 
>> Are these commands designed for some cases regarding to
>> snapshots/subvolume cases?
> 
> Yes, these commands would have helped you in the above case. You need to
> create an empty qgroup and copy the exclusive from there on snapshot
> creation.

I am wondering why we need the concept of exclusive.
Maybe it helps to some extent

How about just  kicking it off, since the concepts of exclusive
adds the complexity of btrfs quota.

The worst thing is that i don't think users can master this magic
concept very well.

> 
>> If so, i think it really confusing and too complex for users to do
>> such work, is't it?...
> 
> It is complex. That is why I always point anyone asking to do some work
> on btrfs or qgroups to writing an enhanced interface to simplify this
> task for the user. I don't think the kernel should handle this.
> And that's why I took the effort to write a pdf to explain the
> concepts :)

I don't have any  good ideas about this yet..

> But the current interface is not only complex, it also is very powerful.
> You can solve problems with it that no other quota system I know of can
> solve.
> 
>> 
>> BTW, i have a question about the function btrfs_qgroup_inherit(),
>> when copying exclusive value from src_qgroup to dst_qgroup:
>> 
>>       dst_qgroup->exclusive = src_qgroup->exclusive + level_size
>> 
>> while copying referenced value from src_qgroup to dot_qgroup:
>> 
>>       dst_qgroup->referenced = src_qgroup->referenced -level_size
>> 
>> I can't really figure out...~_~
> 
> level_size is just a small correction for the space the tree root
> occupies. The tree root is never shared between sub volumes.

O.K. I  got it..

Thanks,
Wang

> 
> -Arne
> 
>> 
>> Thanks,
>> Wang
> 

