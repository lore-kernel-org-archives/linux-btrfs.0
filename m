Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:46743 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdKSG14 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 01:27:56 -0500
Received: by mail-lf0-f46.google.com with SMTP id g35so6710353lfi.13
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Nov 2017 22:27:55 -0800 (PST)
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com>
Date: Sun, 19 Nov 2017 09:27:53 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

19.11.2017 09:17, Chris Murphy пишет:
> fstrim should trim free space, but it only trims unallocated. This is
> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
> behaved this way with 4.12 also.
> 

Well, I was told it should also trim free space ...

https://www.spinics.net/lists/linux-btrfs/msg61819.html

> 
> [root@f27h ~]# fstrim -v /
> /: 39 GiB (41841328128 bytes) trimmed
> [root@f27h ~]# btrfs fi us /
> Overall:
>     Device size:          70.00GiB
>     Device allocated:          31.03GiB
>     Device unallocated:          38.97GiB
>     Device missing:             0.00B
>     Used:              22.02GiB
>     Free (estimated):          47.72GiB    (min: 47.72GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:          65.97MiB    (used: 0.00B)
> 
> Data,single: Size:30.00GiB, Used:21.25GiB
>    /dev/nvme0n1p8      30.00GiB
> 
> Metadata,single: Size:1.00GiB, Used:791.58MiB
>    /dev/nvme0n1p8       1.00GiB
> 
> System,single: Size:32.00MiB, Used:16.00KiB
>    /dev/nvme0n1p8      32.00MiB
> 
> Unallocated:
>    /dev/nvme0n1p8      38.97GiB
> 
> 

