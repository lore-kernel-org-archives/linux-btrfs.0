Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:39730 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753173AbdHKJ7k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 05:59:40 -0400
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <btrfs@pp.siedziba.pl>
Subject: Re: kernel BUG at
 /build/linux-H5UzH8/linux-4.10.0/fs/btrfs/extent_io.c:2318
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <b6624a14-d63f-4372-b6b8-662a61973547@siedziba.pl>
 <pan$b52c9$ae2c3bc9$d4d1cbcf$e8f8d076@cox.net>
Message-ID: <ee99ff49-ea05-da8d-6a77-fe3f60b8c154@siedziba.pl>
Date: Fri, 11 Aug 2017 11:57:49 +0200
MIME-Version: 1.0
In-Reply-To: <pan$b52c9$ae2c3bc9$d4d1cbcf$e8f8d076@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> So 4.10 isn't /too/ far out of range yet, but I'd strongly consider 
> upgrading (or downgrading to 4.9 LTS) as soon as it's reasonably 
> convenient, before 4.13 in any case.  Unless you prefer to go the 
> distro support route, of course.

I used to stick to latest kernels back when btrfs wasn't as stable and
there were frequently important bug fixes. Nowadays I had no problems
since such a long time, that I forgot to change the kernel after
upgrading the distro. Besides, I thought RAID-1 was stable years ago
(except the degraded mount issue).

Anyway, after I took care of bad blocks by remapping them, scrub fixed
all corruptions without any problems. Fsck comes out clean and
everything seems fine.
