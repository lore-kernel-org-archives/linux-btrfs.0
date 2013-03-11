Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58302 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3CKNQZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 09:16:25 -0400
Received: from mailout-de.gmx.net ([10.1.76.2]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Mev0Z-1UPfag0SvR-00OYs1 for
 <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 14:16:23 +0100
Message-ID: <513DD925.5040106@gmx.net>
Date: Mon, 11 Mar 2013 14:16:21 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Shilong Wang <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: about btrfs quota issues
References: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com>
In-Reply-To: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10.03.2013 05:21, Shilong Wang wrote:
> Hello, Arne
> 
>           Steps to reproduce:
> 
> 
>                 mkfs.btrfs <disk>
>                 mount <disk> <mnt>
>                 btrfs quota enable <mnt>
> 
>                 btrfs sub create <mnt>/sub
>                 btrfs qgroup create 1/1 <mnt>
>                 btrfs qgroup assign sub_qgroupid 1/1 <mnt>
> 
> 
>                 dd if=/dev/zero of=<mnt>/sub/data bs=1M count=1
>                 sync
>                 btrfs qgroup show  <mnt>
>                 #until now, every thing goes well, however, if snapshot happens
>                 #the quota accounting will go wrong
> 
>                btrfs sub snapshot <mnt>/sub <mnt>/snap
>                sync
>                btrfs qgroup show <mnt>
>                #the accounting information of group(1/1) is not expected
>                #here exclusive of group (1/1) do not change as expected.
> 
> So i took a close look at the algorithm of quota accounting, the 3
> steps of algorithm don't
> consider some cases like the above example.
> 
> In fact, i think you try to put some work on users, especially when
> snapshot happens.
> It is complex to track all the group's accounting when having
> snapshots..See the following
> commands.
> 
> btrfs sub snapshot -c src_qgroupid:dst_qgroupid  <mnt>
> btrfs sub snapshot  -x src_qgroupid:dst_qgroupid <mnt>
> 
> 
> Are these commands designed for some cases regarding to
> snapshots/subvolume cases?

Yes, these commands would have helped you in the above case. You need to
create an empty qgroup and copy the exclusive from there on snapshot
creation.

> If so, i think it really confusing and too complex for users to do
> such work, is't it?...

It is complex. That is why I always point anyone asking to do some work
on btrfs or qgroups to writing an enhanced interface to simplify this
task for the user. I don't think the kernel should handle this.
And that's why I took the effort to write a pdf to explain the
concepts :)
But the current interface is not only complex, it also is very powerful.
You can solve problems with it that no other quota system I know of can
solve.

> 
> BTW, i have a question about the function btrfs_qgroup_inherit(),
> when copying exclusive value from src_qgroup to dst_qgroup:
> 
>        dst_qgroup->exclusive = src_qgroup->exclusive + level_size
> 
> while copying referenced value from src_qgroup to dot_qgroup:
> 
>        dst_qgroup->referenced = src_qgroup->referenced -level_size
> 
> I can't really figure out...~_~

level_size is just a small correction for the space the tree root
occupies. The tree root is never shared between subvolumes.

-Arne

> 
> Thanks,
> Wang

