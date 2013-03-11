Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:42538 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3CKOPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 10:15:41 -0400
Received: by mail-da0-f48.google.com with SMTP id w4so849871dam.7
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 07:15:40 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: about btrfs quota issues
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <513DDE59.6030804@gmx.net>
Date: Mon, 11 Mar 2013 22:15:35 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <6BF8C2BD-6DB4-47DA-95FA-5ACFACA7D036@gmail.com>
References: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com> <513DD925.5040106@gmx.net> <5CEDCD84-0030-4AD1-A470-1F176D1D9CC5@gmail.com> <513DDE59.6030804@gmx.net>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


<snip>

>> The worst thing is that i don't think users can master this magic
>> concept very well.
> 
> Normally users don't need very sophisticated scenarios. In fact, they
> don't even need higher level quota groups, the basic tracking is
> enough. In this case, everything just works as expected for the user.
> If you start creating and assigning qgroups manually, prepare to handle
> the complexity.
> 
Considering this case:

a subvolume related to a user, we limit the space by limiting every subvolume
qgroup, but  we also want to limit  the total space all the users can use. So we create
a parent qgroup(1/1 for example) and assign all subvolume group to this parent group.

The above case is regularly used i think, What's more, many snapshots may be done.
So  i think what i am concerning is not a corner case..

Thanks,
Wang
> 
>> 
>>> 
>>>> If so, i think it really confusing and too complex for users to do
>>>> such work, is't it?...
>>> 
>>> It is complex. That is why I always point anyone asking to do some work
>>> on btrfs or qgroups to writing an enhanced interface to simplify this
>>> task for the user. I don't think the kernel should handle this.
>>> And that's why I took the effort to write a pdf to explain the
>>> concepts :)
>> 
>> I don't have any  good ideas about this yet..
>> 
>>> But the current interface is not only complex, it also is very powerful.
>>> You can solve problems with it that no other quota system I know of can
>>> solve.
>>> 
>>>> 
>>>> BTW, i have a question about the function btrfs_qgroup_inherit(),
>>>> when copying exclusive value from src_qgroup to dst_qgroup:
>>>> 
>>>>      dst_qgroup->exclusive = src_qgroup->exclusive + level_size
>>>> 
>>>> while copying referenced value from src_qgroup to dot_qgroup:
>>>> 
>>>>      dst_qgroup->referenced = src_qgroup->referenced -level_size
>>>> 
>>>> I can't really figure out...~_~
>>> 
>>> level_size is just a small correction for the space the tree root
>>> occupies. The tree root is never shared between sub volumes.
>> 
>> O.K. I  got it..
>> 
>> Thanks,
>> Wang
>> 
>>> 
>>> -Arne
>>> 
>>>> 
>>>> Thanks,
>>>> Wang
>>> 
>> 
> 

