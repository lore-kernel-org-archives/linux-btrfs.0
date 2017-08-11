Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:33701 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753039AbdHKLkc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 07:40:32 -0400
Received: by mail-it0-f47.google.com with SMTP id f16so1247137itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Aug 2017 04:40:32 -0700 (PDT)
Subject: Re: kernel BUG at
 /build/linux-H5UzH8/linux-4.10.0/fs/btrfs/extent_io.c:2318
To: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <btrfs@pp.siedziba.pl>,
        linux-btrfs@vger.kernel.org
References: <b6624a14-d63f-4372-b6b8-662a61973547@siedziba.pl>
 <pan$b52c9$ae2c3bc9$d4d1cbcf$e8f8d076@cox.net>
 <ee99ff49-ea05-da8d-6a77-fe3f60b8c154@siedziba.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <279e40dc-aec3-a208-73f9-effc53da2774@gmail.com>
Date: Fri, 11 Aug 2017 07:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <ee99ff49-ea05-da8d-6a77-fe3f60b8c154@siedziba.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-11 05:57, Piotr Pawłow wrote:
> Hello,
>> So 4.10 isn't /too/ far out of range yet, but I'd strongly consider
>> upgrading (or downgrading to 4.9 LTS) as soon as it's reasonably
>> convenient, before 4.13 in any case.  Unless you prefer to go the
>> distro support route, of course.
> 
> I used to stick to latest kernels back when btrfs wasn't as stable and
> there were frequently important bug fixes. Nowadays I had no problems
> since such a long time, that I forgot to change the kernel after
> upgrading the distro. Besides, I thought RAID-1 was stable years ago
> (except the degraded mount issue).
So, just my thoughts on this in particular.  Either you are staying 
absolutely up to date (which I would still recommend if possible, there 
are new fixes going in regularly still, and we've been seing some 
performance improvements recently too), or you're not.  If you're not, 
you should either:
1. Stick to upstream (kernel.org) LTS releases (and still ideally stay 
up to date within that release) and get reasonably reliable help from 
the ML.
2. Stick to your distribution's kernels, and get help from your 
distribution's usual support channels.

As far as raid1 mode, it generally is reasonably stable, but there are 
still edge cases we with bugs that haven't been found (as you found out 
here).
> 
> Anyway, after I took care of bad blocks by remapping them, scrub fixed
> all corruptions without any problems. Fsck comes out clean and
> everything seems fine.
Glad to hear everything is working now!

