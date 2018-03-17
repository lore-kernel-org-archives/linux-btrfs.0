Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:46730 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752685AbeCQRbI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Mar 2018 13:31:08 -0400
Received: by mail-ot0-f169.google.com with SMTP id g97-v6so13454124otg.13
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Mar 2018 10:31:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180317013438.73e5bc35@couracado.motaleite.net>
References: <20180314020313.2f444787@couracado.motaleite.net>
 <CAJCQCtQg5_V0POgNbQs894Bq6JExpdb5b38F_T000kFanMQxag@mail.gmail.com> <20180317013438.73e5bc35@couracado.motaleite.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 17 Mar 2018 11:31:07 -0600
Message-ID: <CAJCQCtSR8HB4E_9Xntazz=eQ5FokW63TyGb+=PzM8m4=i3x_jQ@mail.gmail.com>
Subject: Re: btrfs errors
To: higuita <higuita@gmx.net>, Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 16, 2018 at 7:34 PM, higuita <higuita@gmx.net> wrote:
> On Tue, 13 Mar 2018 22:24:43 -0600, Chris Murphy
> <lists@colorremedies.com> wrote:

>> c. (optional) take a btrfs image before you do the repair because if
>> something blows up, at least that will help a dev figure out why btrfs
>> check blew up your file system.
>
>         done! i was expecting a image with at least my used space ( ~40GB),
> but i got a 1GB file. Is that normal?

Depends on 'btrfs fi us' output for metadata, and what compression
option used for btrfs-image. The resulting image output by btrfs-image
is only metadata. Also, if you want to sanitize file names, it's
recommended to use the -ss switch rather than just -s; I guess it's
easier for the devs.


>         After booting with a livecd and running a --repair with
> btrfs-progs v4.15.1, it didn't look it have done almost anything to the
> errors, running a new check still show mostly the same errors:

OK but we need the entire output from the repair attempt...

> # btrfs check --force /dev/vdisk/root
> WARNING: filesystem mounted, continuing because of --force

Maybe Qu or Liu can say otherwise. But in my opinion, btrfs check on
mounted file system is unreliable. If it's completely idle, no writes
the entire time the check is happening, it might be reliable. But it's
expected that btrfs check is an offline check. And btrfs scrub is an
online check.


OK so going back to your first email, I've noticed a couple things:

1.
The problem file system is vdisk/root which is an LVM LV made from two
PVs which are two SSDs. By default LVM uses linear concat so it should
be possible to figure out which drive is actually involved. It's
probably not important to know the mapping right now, but it does make
the troubleshooting more complicated.

2.
>From dmesg, one of the drives has a GPT problem and it makes me wonder
why. The backup GPT is at the end of the drive, so whatever stepped on
it probably did not affect anything in sdd2 which is one of the PVs
for vdisk/root. So it probably isn't related.

[    8.976491] Alternate GPT is invalid, using primary GPT.
[    8.976506]  sdd: sdd1 sdd2 sdd3 sdd4

3.
You got this message from btrfs scrub
ERROR: scrubbing /dev/mapper/vdisk-root failed for device id 1:
ret=-1, errno=5 (Input/output error)

Do you have the kernel message that appeared at the exact same time as this?


I suggest rebooting from live media and attaching output for the following:

btrfs check
btrfs check --mode=lowmem
mount the Btrfs volume and scrub it, and include all the kernel
messages specifically from mount through the end of scrub, including
any user space i/o errors. The problem could be anything in the
storage stack so we need to see device, device-mapper messages as well
as Btrfs.
umount and try btrfs check --repair but include all the output


The lowmem check is a different implementation and sometimes gives
different results.


-- 
Chris Murphy
