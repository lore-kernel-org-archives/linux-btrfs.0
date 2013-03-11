Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51257 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3CKOpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 10:45:33 -0400
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MPbHb-1UAPHh0Rdp-004iTj for
 <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 15:45:32 +0100
Message-ID: <513DEE09.10402@gmx.net>
Date: Mon, 11 Mar 2013 15:45:29 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: about btrfs quota issues
References: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com> <513DD925.5040106@gmx.net> <5CEDCD84-0030-4AD1-A470-1F176D1D9CC5@gmail.com> <513DDE59.6030804@gmx.net> <6BF8C2BD-6DB4-47DA-95FA-5ACFACA7D036@gmail.com> <513DE84E.6010503@gmx.net> <EDA76C9B-DA11-4909-94CE-01CB8B7D766E@gmail.com>
In-Reply-To: <EDA76C9B-DA11-4909-94CE-01CB8B7D766E@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11.03.2013 15:35, Wang Shilong wrote:
> 
>> On 11.03.2013 15:15, Wang Shilong wrote:
>>>
>>> <snip>
>>>
>>>>> The worst thing is that i don't think users can master this magic
>>>>> concept very well.
>>>>
>>>> Normally users don't need very sophisticated scenarios. In fact, they
>>>> don't even need higher level quota groups, the basic tracking is
>>>> enough. In this case, everything just works as expected for the user.
>>>> If you start creating and assigning qgroups manually, prepare to handle
>>>> the complexity.
>>>>
>>> Considering this case:
>>>
>>> a subvolume related to a user, we limit the space by limiting every subvolume
>>> qgroup, but  we also want to limit  the total space all the users can use. So we create
>>> a parent qgroup(1/1 for example) and assign all subvolume group to this parent group.
>>>
>>> The above case is regularly used i think, What's more, many snapshots may be done.
>>> So  i think what i am concerning is not a corner case..
>>
>> So you just missed to assign the new subvolume to 1/1 by using -i on
>> snapshot creation.
>>
> 
> When snapshot happens,  the exclusive of 1/1 will go wrong even with  this simple case..

Your example does not describe your use case. If you want to account the
snapshot to the user, you also have to assign the snapshot to 1/1. If you
do so, the exclusive will be correct.

-Arne

> 
> However, thanks very much for your patience and kindly reply ^_^
> 
> Thanks, 
> Wang
> 
>> -Arne
>>
>>>
>>> Thanks,
>>> Wang
>>>>
>>>>>
>>>>>>
>>>>>>> If so, i think it really confusing and too complex for users to do
>>>>>>> such work, is't it?...
>>>>>>
>>>>>> It is complex. That is why I always point anyone asking to do some work
>>>>>> on btrfs or qgroups to writing an enhanced interface to simplify this
>>>>>> task for the user. I don't think the kernel should handle this.
>>>>>> And that's why I took the effort to write a pdf to explain the
>>>>>> concepts :)
>>>>>
>>>>> I don't have any  good ideas about this yet..
>>>>>
>>>>>> But the current interface is not only complex, it also is very powerful.
>>>>>> You can solve problems with it that no other quota system I know of can
>>>>>> solve.
>>>>>>
>>>>>>>
>>>>>>> BTW, i have a question about the function btrfs_qgroup_inherit(),
>>>>>>> when copying exclusive value from src_qgroup to dst_qgroup:
>>>>>>>
>>>>>>>     dst_qgroup->exclusive = src_qgroup->exclusive + level_size
>>>>>>>
>>>>>>> while copying referenced value from src_qgroup to dot_qgroup:
>>>>>>>
>>>>>>>     dst_qgroup->referenced = src_qgroup->referenced -level_size
>>>>>>>
>>>>>>> I can't really figure out...~_~
>>>>>>
>>>>>> level_size is just a small correction for the space the tree root
>>>>>> occupies. The tree root is never shared between sub volumes.
>>>>>
>>>>> O.K. I  got it..
>>>>>
>>>>> Thanks,
>>>>> Wang
>>>>>
>>>>>>
>>>>>> -Arne
>>>>>>
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Wang
>>>>>>
>>>>>
>>>>
>>>
>>
> 

