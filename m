Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55082 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3CKNig (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 09:38:36 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M5Jbd-1UyBIT3btH-00zYL7 for
 <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 14:38:34 +0100
Message-ID: <513DDE59.6030804@gmx.net>
Date: Mon, 11 Mar 2013 14:38:33 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: about btrfs quota issues
References: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com> <513DD925.5040106@gmx.net> <5CEDCD84-0030-4AD1-A470-1F176D1D9CC5@gmail.com>
In-Reply-To: <5CEDCD84-0030-4AD1-A470-1F176D1D9CC5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11.03.2013 14:31, Wang Shilong wrote:
> 
> Hello,
> 
<snip>

>>>
>>> In fact, i think you try to put some work on users, especially when
>>> snapshot happens.
>>> It is complex to track all the group's accounting when having
>>> snapshots..See the following
>>> commands.
>>>
>>> btrfs sub snapshot -c src_qgroupid:dst_qgroupid  <mnt>
>>> btrfs sub snapshot  -x src_qgroupid:dst_qgroupid <mnt>
>>>
>>>
>>> Are these commands designed for some cases regarding to
>>> snapshots/subvolume cases?
>>
>> Yes, these commands would have helped you in the above case. You need to
>> create an empty qgroup and copy the exclusive from there on snapshot
>> creation.
> 
> I am wondering why we need the concept of exclusive.
> Maybe it helps to some extent
> 

It is needed to answer the question 'how many space can I gain but
deleting this subvol or this set of subvolumes?'

> How about just  kicking it off, since the concepts of exclusive
> adds the complexity of btrfs quota.

If you don't need that value, just ignore the tracking error.

> 
> The worst thing is that i don't think users can master this magic
> concept very well.

Normally users don't need very sophisticated scenarios. In fact, they
don't even need higher level quota groups, the basic tracking is
enough. In this case, everything just works as expected for the user.
If you start creating and assigning qgroups manually, prepare to handle
the complexity.

-Arne

> 
>>
>>> If so, i think it really confusing and too complex for users to do
>>> such work, is't it?...
>>
>> It is complex. That is why I always point anyone asking to do some work
>> on btrfs or qgroups to writing an enhanced interface to simplify this
>> task for the user. I don't think the kernel should handle this.
>> And that's why I took the effort to write a pdf to explain the
>> concepts :)
> 
> I don't have any  good ideas about this yet..
> 
>> But the current interface is not only complex, it also is very powerful.
>> You can solve problems with it that no other quota system I know of can
>> solve.
>>
>>>
>>> BTW, i have a question about the function btrfs_qgroup_inherit(),
>>> when copying exclusive value from src_qgroup to dst_qgroup:
>>>
>>>       dst_qgroup->exclusive = src_qgroup->exclusive + level_size
>>>
>>> while copying referenced value from src_qgroup to dot_qgroup:
>>>
>>>       dst_qgroup->referenced = src_qgroup->referenced -level_size
>>>
>>> I can't really figure out...~_~
>>
>> level_size is just a small correction for the space the tree root
>> occupies. The tree root is never shared between sub volumes.
> 
> O.K. I  got it..
> 
> Thanks,
> Wang
> 
>>
>> -Arne
>>
>>>
>>> Thanks,
>>> Wang
>>
> 

