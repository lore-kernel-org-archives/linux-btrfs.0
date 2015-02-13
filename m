Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:37093 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbbBMHyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 02:54:50 -0500
Received: by mail-yk0-f180.google.com with SMTP id 131so6903762ykp.11
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 23:54:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54DDB3A9020000AF000D6A8D@frodo.1stsolutions.be>
References: <54DDB3A9020000AF000D6A8D@frodo.1stsolutions.be>
Date: Fri, 13 Feb 2015 00:54:49 -0700
Message-ID: <CAJCQCtS5acWHChw3ww8phg7tE0JOf9EfwA8nROdecBVrvtaj-w@mail.gmail.com>
Subject: Re: slow system
From: Chris Murphy <lists@colorremedies.com>
To: Roel Niesen <Roel.Niesen@1stsolutions.be>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 13, 2015 at 12:19 AM, Roel Niesen
<Roel.Niesen@1stsolutions.be> wrote:
> Hello,
>
> Sometimes my system is hanging for a few seconds.
> When I start top, I see this :
>
> %cpu: 80.7 command: btrfs-transacti
>
> Is it normal that btrfs-transaction takes such hijg cpu.

Approximately
 how many subvolumes and snapshots?
>
> uname- a:
> Linux sanos1 3.13.11-ckt13 #1 SMP Tue Feb 3 12:06:18 CET 2015 x86_64 x86_64 x86_64 GNU/Linux

It's kindof an old kernel, but I'm not aware of major issues with it.
Still I suggest something newer as there have been a massive amount of
btrfs changes since then. If the hang is reproduced with 3.18.3 or
newer, then I suggest filing a bug report on bugzilla.kernel.org that
includes sysrq+w at the time of the hang, which will dump some debug
output to dmesg. Then post URL for the bug report to the list.

https://www.kernel.org/doc/Documentation/sysrq.txt

>
> btrfs fi sh:
>
> Label: firstpool  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
>         Total devices 16 FS bytes used 5.12TiB
>         devid    1 size 931.51GiB used 930.92GiB path /dev/sdd
>         devid    2 size 931.51GiB used 930.92GiB path /dev/sde
>         devid    5 size 931.51GiB used 930.92GiB path /dev/sdh
>         devid    6 size 931.51GiB used 930.92GiB path /dev/sdi
>         devid    7 size 931.51GiB used 930.92GiB path /dev/sdj
>         devid    8 size 931.51GiB used 930.92GiB path /dev/sdk
>         devid    9 size 931.51GiB used 930.92GiB path /dev/sdl
>         devid    10 size 931.51GiB used 930.92GiB path /dev/sdm
>         devid    11 size 931.51GiB used 930.92GiB path /dev/sdn
>         devid    12 size 931.51GiB used 930.92GiB path /dev/sdo
>         devid    13 size 931.51GiB used 930.92GiB path /dev/sdp
>         devid    14 size 931.51GiB used 930.92GiB path /dev/sdq
>         devid    15 size 931.51GiB used 930.92GiB path /dev/sdf
>         devid    16 size 931.51GiB used 930.92GiB path /dev/sdg
>         devid    18 size 931.51GiB used 1.13GiB path /dev/sdb
>         devid    19 size 931.51GiB used 1.13GiB path /dev/sdc

It looks like a lot more than 5.12TiB used adding up all of those
"used 930.92GiB" and dividing by 2. Kinda strange. I suggest a newer
btrfs-progs also. 3.18.2 is current.


> dmesg:
> empty
>
> Important:
> btrfs device stats /btrfs
> [/dev/sdk].write_io_errs   5
> [/dev/sdk].read_io_errs    19
> [/dev/sdk].flush_io_errs   0
> [/dev/sdk].corruption_errs 0
> [/dev/sdk].generation_errs 0
> [/dev/sdl].write_io_errs   144
> [/dev/sdl].read_io_errs    0
> [/dev/sdl].flush_io_errs   48
> [/dev/sdl].corruption_errs 129
> [/dev/sdl].generation_errs 41
> All other drive and values are  0.

Anytime 2 drives are reporting errors, it's not good. First thing is
to make sure the most important data is backed up. Second, I'd either
do a balance or a scrub and see if these values change (make the
changes I mention down below first). You can reset the number (if you
want, it's not necessary) with btrfs dev stats -z.

>
> Questions:
>
> 1) why is my system slow

Needs sysrq w or t output.
>
> 2) unsificient disk space
> The 2 disk where added in panic because my system got the message on btrfs unsuficiant disk space.  I saw some articles that if the metadata is > 75% it becomes slow and even can't write anythign to it.
> I solved this by temporary added a disk, but that was an iscsi disk from an unstable system.
> So I removed that disk and added 2 new fysical disk.
> The are not yet use until I do a btrfs balance /btrfs ??

Quite a few of these kinds of problems are fixed in newer kernels. So
I suggest that as a first remedy.


> How  can I increase the metadata space?

It shouldn't be necessary


>
> 3) error's on the disk k en l
> Are these drive broke?
> So maybey I have to replace these with teh 2 new once?

All of these errors come with some kind of message in dmesg. If you
can't find them, you should post the entire unfiltered dmesg. Also
check to see the value of SCT ERC, and the kernel's SCSI command timer
for each device:

smartctl -l scterc <dev>
cat /sys/block/<dev>/device/timeout

You can either post it, or confirm that the 2nd value is larger than
the 1st value. And if the first value is "not supported" then assume
it's 120. You can use echo 120 > /sys/block/<dev>/device/timeout to
change this for each device; note it's not a device value being
changed, but the kernel command timer. The first command is a device
value. If these aren't set correctly it's possible that
autocorrections aren't applied correctly, and thus disk errors can
accumulate over time until it's a big problem.

So in order: update backup, update kernel and btrfs-progs, make sure
kernel timer value is higher than device (note the device value is in
deciseconds, while the kernel timer is seconds).


-- 
Chris Murphy
