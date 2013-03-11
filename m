Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37814 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3CKLEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 07:04:49 -0400
Received: by mail-pb0-f47.google.com with SMTP id rp2so3585408pbb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 04:04:49 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: about btrfs quota issues
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com>
Date: Mon, 11 Mar 2013 19:04:44 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <CF068BFA-79FF-4D3A-BA6D-99F6034D374E@gmail.com>
References: <CAP9B-Qkzy=Q+Lh5zeH7LhgQUQuEa4DPubku6cTr4DEuVxu1Swg@mail.gmail.com>
To: Arne Jansen <sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ping..

> Hello, Arne
> 
>          Steps to reproduce:
> 
> 
>                mkfs.btrfs <disk>
>                mount <disk> <mnt>
>                btrfs quota enable <mnt>
> 
>                btrfs sub create <mnt>/sub
>                btrfs qgroup create 1/1 <mnt>
>                btrfs qgroup assign sub_qgroupid 1/1 <mnt>
> 
> 
>                dd if=/dev/zero of=<mnt>/sub/data bs=1M count=1
>                sync
>                btrfs qgroup show  <mnt>
>                #until now, every thing goes well, however, if snapshot happens
>                #the quota accounting will go wrong
> 
>               btrfs sub snapshot <mnt>/sub <mnt>/snap
>               sync
>               btrfs qgroup show <mnt>
>               #the accounting information of group(1/1) is not expected
>               #here exclusive of group (1/1) do not change as expected.
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
> If so, i think it really confusing and too complex for users to do
> such work, is't it?...
> 
> BTW, i have a question about the function btrfs_qgroup_inherit(),
> when copying exclusive value from src_qgroup to dst_qgroup:
> 
>       dst_qgroup->exclusive = src_qgroup->exclusive + level_size
> 
> while copying referenced value from src_qgroup to dot_qgroup:
> 
>       dst_qgroup->referenced = src_qgroup->referenced -level_size
> 
> I can't really figure out...~_~
> 
> Thanks,
> Wang

