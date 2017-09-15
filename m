Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:34904 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdIOQfr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 12:35:47 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:58132)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dstaj-002uI7-54
        for linux-btrfs@vger.kernel.org; Fri, 15 Sep 2017 17:35:45 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dstad-0001pX-M6
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 17:35:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22972.346.933410.148678@tree.ty.sabi.co.uk>
Date: Fri, 15 Sep 2017 17:35:38 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
In-Reply-To: <59BBDFA6.4020500@sarach.com.pl>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
        <59BBB15E.8010002@sarach.com.pl>
        <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
        <59BBDFA6.4020500@sarach.com.pl>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]
>>>> Case #1
>>>> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs
>>>> -> qemu cow2 storage -> guest BTRFS filesystem
>>>> SQL table row insertions per second: 1-2

>>>> Case #2
>>>> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs
>>>> -> qemu raw storage -> guest EXT4 filesystem
>>>> SQL table row insertions per second: 10-15
[ ... ]

>> Q 0) what do you think that you measure here?

> Cow's fragmentation impact on SQL write performance.

That's not what you are measuring, you are measing the impact on
speed of configurations "designed" (perhaps unintentionally) for
maximum flexibility, lowest cost, and complete disregard for
speed.

[ ... ]

> It was quick and dirty task to find, prove and remove
> performance bottleneck at minimal cost.

This is based on the usual confusion between "performance" (the
result of several tradeoffs) and "speed". When you report "row
insertions per second" you are reporting a rate, that is a
"speed", not "performance", which is always multi-dimensional.
http://www.sabi.co.uk/blog/15-two.html?151023#151023

In the cases above speed is low, but I think that, taking into
account flexibility and cost, performance is pretty good.

> AFAIR removing storage cow2 and guest BTRFS storage gave us ~
> 10 times boost.

"Oh doctor, if I stop stabbing my hand with a fork it no longer
hurts, but running while carrying a rucksack full of bricks is
still slower than with a rucksack full of feathers".

[ ... ]
