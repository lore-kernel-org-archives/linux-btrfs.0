Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34444 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757222AbcH3RN3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 13:13:29 -0400
Received: by mail-oi0-f68.google.com with SMTP id t127so2397807oie.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 10:13:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKzrAgRQ6gkEgWZwG1emf0w5RURkj93L_A4--OK-PaPEf17XvQ@mail.gmail.com>
References: <CAKzrAgTcrjN_qLqzqQ_izpB_AvypaGV=TGNEeH=-18GmOVjAAg@mail.gmail.com>
 <CAJCQCtQhFHX2ba3gYUHw0XtbLousVz8s7ZxMnT1ThU46iOxNOA@mail.gmail.com> <CAKzrAgRQ6gkEgWZwG1emf0w5RURkj93L_A4--OK-PaPEf17XvQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 30 Aug 2016 11:13:28 -0600
Message-ID: <CAJCQCtTcvcCPFk70wGw8McvGpz-miXvRcMq1OkQ=rn+d14R25A@mail.gmail.com>
Subject: Re: `btrfs dev del` fails with `No space left on device`
To: "ojab //" <ojab@ojab.ru>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 4:22 AM, ojab // <ojab@ojab.ru> wrote:
> On Mon, Aug 29, 2016 at 9:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Mon, Aug 29, 2016 at 10:04 AM, ojab // <ojab@ojab.ru> wrote:
>> What do you get for 'btrfs fi us <mp>'
>
> $ sudo btrfs fi us /mnt/xxx/
> Overall:
>     Device size:                  3.64TiB
>     Device allocated:             1.82TiB
>     Device unallocated:           1.82TiB
>     Device missing:                 0.00B
>     Used:                     1.81TiB
>     Free (estimated):             1.83TiB         (min: 943.55GiB)
>     Data ratio:                  1.00
>     Metadata ratio:                  2.00
>     Global reserve:             512.00MiB         (used: 0.00B)
>
> Data,RAID0: Size:1.81TiB, Used:1.80TiB
>    /dev/sdb1        928.48GiB
>    /dev/sdc1        928.48GiB
>
> Metadata,RAID1: Size:3.00GiB, Used:2.15GiB
>    /dev/sdb1          3.00GiB
>    /dev/sdc1          3.00GiB
>
> System,RAID1: Size:32.00MiB, Used:176.00KiB
>    /dev/sdb1         32.00MiB
>    /dev/sdc1         32.00MiB
>
> Unallocated:
>    /dev/sdb1          1.01MiB
>    /dev/sdc1          1.00MiB
>    /dev/sdd1          1.82TiB


The confusion is understandable because sdd1 is bigger than sdc1, so
why can't everything on sdc1 be moved to sdd1? Well, dev add > dev del
doesn't really do that, it's going to end up rewriting metadata to
sdb1 also, and there isn't enough space. Yes, there's 800MiB of unused
space in metadata chunks on sdb1 and sdc1, it should be enough (?) but
clearly it wants more than this for whatever reason. You could argue
it's a bug or some suboptimal behavior, but because this is a 99% full
file system, I'm willing to be it's a low priority bug. Because this
is raid0 you really need to add two devices, not just one.

> I don't quite understand what exactly btrfs is trying to do: I assume
> that block groups should be relocated to the new/empty drive,

There is a scant chance 'btrfs replace' will work better here. But
still the real problem remains, even if you replace sdc1 with sdd1,
sdb1 is still 99% full which in effect makes the file system 99% full
because it can't do anymore raid0 on sdb1, and it's not possible to do
raid0 chunks on a single sdd1 device.

If you can't add a 4th drive, you're going to have to convert to
single profile. Keep all three drives attached, 'btrfs balance start
-dconvert=single' and then once that's complete you should be able to
remove /dev/sdc1, although this will take a while because first
conversion will use space on all three drives, and then the removable
of sdc1 will have to copy chunks off before it can be removed.

> but
> during the delete `btrfs fi us` shows
> Unallocated:
> /dev/sdc1         16.00EiB

Known bug, also happens when resizing and conversions.



> so deleted partition is counted as maximum possible empty drive and
> blocks are relocated to it instead of new/empty drive? (kernel-4.7.2 &
> btrfs-progs-4.7.1 here)
> Is there any way to see where and why block groups are relocated
> during `delete`?

The two reasons this isn't working is a.) it's 99% full already and
b.) it's raid0, so merely adding one device isn't sufficient. It's
probably too full even to do a 3 device balance to restripe raid0
across 3 devices, which is still inefficient because it would leave
50% of the space on sdd as unusable. To do this with uneven devices
and use all the space, you're going to have to use single profile.



-- 
Chris Murphy
