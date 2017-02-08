Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:37618 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751235AbdBHXDa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 18:03:30 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:48598)
        by azure.uno.uk.net with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
        (Exim 4.87)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cba9F-0000fE-6H
        for linux-btrfs@vger.kernel.org; Wed, 08 Feb 2017 21:51:33 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cba3g-0003JD-IM
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 21:45:48 +0000
Message-ID: <22683.37260.208424.336485@tree.ty.sabi.co.uk>
Date: Wed, 8 Feb 2017 21:45:48 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: understanding disk space usage
In-Reply-To: <171155ef-93c2-f438-3bbd-ca550381c80d@gmail.com>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
        <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
        <22683.12104.679173.639568@tree.ty.sabi.co.uk>
        <171155ef-93c2-f438-3bbd-ca550381c80d@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]
> The issue isn't total size, it's the difference between total
> size and the amount of data you want to store on it. and how
> well you manage chunk usage. If you're balancing regularly to
> compact chunks that are less than 50% full, [ ... ] BTRFS on
> 16GB disk images before with absolutely zero issues, and have
> a handful of fairly active 8GB BTRFS volumes [ ... ]

Unfortunately balance operations are quite expensive, especially
from inside VMs. On the other hand if the system is not much
disk constrained relatively frequent balances is a good idea
indeed. It is a bit like the advice in the other thread on OLTP
to run frequent data defrags, which are also quite expensive.

Both combined are like running the compactor/cleaner on log
structured (another variants of "COW") filesystems like NILFS2:
running that frequently means tighter space use and better
locality, but is quite expensive too.

>> [ ... ] My impression is that the Btrfs design trades space
>> for performance and reliability.

> In general, yes, but a more accurate statement would be that
> it offers a trade-off between space and convenience. [ ... ]

It is not quite "convenience", it is overhead: whole-volume
operations like compacting, defragmenting (or fscking) tend to
cost significantly in IOPS and also in transfer rate, and on
flash SSDs they also consume lifetime.

Therefore personally I prefer to have quite a bit of unused
space in Btrfs or NILFS2, at a minimum around double at 10-20%
than the 5-10% that I think is the minimum advisable with
conventional designs.
