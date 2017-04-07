Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:34131 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdDGBRv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 21:17:51 -0400
Received: by mail-yb0-f172.google.com with SMTP id m133so14176795ybb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 18:17:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 6 Apr 2017 19:17:50 -0600
Message-ID: <CAJCQCtRg_53WOUYzVHA9Kem7PDBpd+cGgVp4Z3zADA_NFizy4A@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 6, 2017 at 6:47 PM, John Petrini <jpetrini@coredial.com> wrote:

> sudo btrfs fi df /mnt/storage-array/
> Data, RAID10: total=10.72TiB, used=10.72TiB
> System, RAID0: total=128.00MiB, used=944.00KiB
> Metadata, RAID10: total=14.00GiB, used=12.63GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

The third line is kinda scary. System chunk is raid0, so ostensibly a
single device failure means the entire array is lost.

The fastest way to fix it is:

btrfs balance start -mconvert=raid10,soft <mountpoint>

That will make the system chunk raid10.


>
> sudo btrfs fi usage /mnt/storage-array/
> Overall:
>     Device size:   49.12TiB
>     Device allocated:   21.47TiB
>     Device unallocated:   27.65TiB
>     Device missing:      0.00B
>     Used:   21.45TiB
>     Free (estimated):   13.83TiB (min: 13.83TiB)
>     Data ratio:       2.00
>     Metadata ratio:       2.00
>     Global reserve:  512.00MiB (used: 0.00B)
>
> Data,RAID10: Size:10.72TiB, Used:10.71TiB

This is saying you have 10.72T of data. But because it's raid10, it
will take up 2x that much space. This is what's reflected by the
Overall: Used: value of 21.45T, plus some extra for metadata which is
also 2x.




-- 
Chris Murphy
