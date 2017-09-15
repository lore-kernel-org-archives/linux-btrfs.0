Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:60460 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbdIOLN5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 07:13:57 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:53814)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dsoZH-002h5S-6g
        for linux-btrfs@vger.kernel.org; Fri, 15 Sep 2017 12:13:55 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dsoZA-0000RR-Ej
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 12:13:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22971.46571.239098.830988@tree.ty.sabi.co.uk>
Date: Fri, 15 Sep 2017 12:13:47 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
In-Reply-To: <59BBB15E.8010002@sarach.com.pl>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
        <59BBB15E.8010002@sarach.com.pl>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Case #1
> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu cow2 storage
> -> guest BTRFS filesystem
> SQL table row insertions per second: 1-2

"Doctor, if I stab my hand with a fork it hurts a lot: can you
cure that?"

> Case #2
> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu raw
> storage -> guest EXT4 filesystem
> SQL table row insertions per second: 10-15

"Doctor, I can't run as fast with a backpack full of bricks as
without it: can you cure that?"

:-)
