Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34644 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbcF1AAg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 20:00:36 -0400
Received: by mail-oi0-f49.google.com with SMTP id s66so941658oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 17:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160628010618.58e235fa@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com> <20160628010618.58e235fa@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 18:00:34 -0600
Message-ID: <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 5:06 PM, Saint Germain <saintger@gmail.com> wrote:
> On Mon, 27 Jun 2016 16:58:37 -0600, Chris Murphy
> <lists@colorremedies.com> wrote :
>
>> On Mon, Jun 27, 2016 at 4:55 PM, Chris Murphy
>> <lists@colorremedies.com> wrote:
>>
>> >> BTRFS info (device sdb1): dev_replace from /dev/sda1 (devid 1)
>> >> to /dev/sdd1 started scrub_handle_errored_block: 166 callbacks
>> >> suppressed BTRFS warning (device sdb1): checksum error at logical
>> >> 93445255168 on dev /dev/sda1, sector 77669048, root 5, inode
>> >> 3434831, offset 479232, length 4096, links 1 (path:
>> >> user/.local/share/zeitgeist/activity.sqlite-wal)
>> >> btrfs_dev_stat_print_on_error: 166 callbacks suppressed BTRFS
>> >> error (device sdb1): bdev /dev/sda1 errs: wr 0, rd 0, flush 0,
>> >> corrupt 14221, gen 24 scrub_handle_errored_block: 166 callbacks
>> >> suppressed BTRFS error (device sdb1): unable to fixup (regular)
>> >> error at logical 93445255168 on dev /dev/sda1
>> >
>> > Shoot. You have a lot of these. It looks suspiciously like you're
>> > hitting a case list regulars are only just starting to understand
>>
>> Forget this part completely. It doesn't affect raid1. I just re-read
>> that your setup is not raid1, I don't know why I thought it was raid5.
>>
>> The likely issue here is that you've got legit corruptions on sda (mix
>> of slow and flat out bad sectors), as well as a failing drive.
>>
>> This is also safe to issue:
>>
>> smartctl -l scterc /dev/sda
>> smartctl -l scterc /dev/sdb
>> cat /sys/block/sda/device/timeout
>> cat /sys/block/sdb/device/timeout
>>
>
> My setup is indeed RAID1 (and not RAID5)
>
> root@system:/# smartctl -l scterc /dev/sda
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local
> build) Copyright (C) 2002-14, Bruce Allen, Christian Franke,
> www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
>
> root@system:/# smartctl -l scterc /dev/sdb
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.6.0-0.bpo.1-amd64] (local
> build) Copyright (C) 2002-14, Bruce Allen, Christian Franke,
> www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
>
> root@system:/# cat /sys/block/sda/device/timeout
> 30
> root@system:/# cat /sys/block/sdb/device/timeout
> 30

Good news and bad news. The bad news is this is a significant
misconfiguration, it's very common, and it means that any bad sectors
that don't result in read errors before 30 seconds will mean they
don't get fixed by Btrfs (or even mdadm or LVM raid). So they can
accumulate.

There are two options since your drives support SCT ERC.

1.
smartctl -l scterc,70,70 /dev/sdX  ## done for both drives

That will make sure the drive reports a read error in 7 seconds, well
under the kernel's command timer of 7 seconds. This is how your drives
should normally be configured for RAID usage.

2.
echo 180 > /sys/block/sda/device/timeout
echo 180 > /sys/block/sdb/device/timeout

This *might* actually work better in your case. If you permit the
drives to have really long error recovery, it might actually allow the
data to be returned to Btrfs and then it can start fixing problems.
Maybe. It's a long shot. And there will be upwards of 3 minute hangs.

I would give this a shot first. You can issue these commands safely at
any time, no umount is needed or anything like that. I would do this
even before using cp/rsync or ddrescue because it increases the chance
the drive can recover data from these bad sectors and fix the other
drive.

These settings are not persistent across a reboot unless you set a
udev rule or equivalent.

On one of my drives that supports SCT ERC it only accepts the smartctl
-l command to set the timeout once. I can't change it without power
cycling the drive or it just crashes (yay firmware bugs). Just FYI
it's possible to run into other weirdness.


Last, I have no idea if the massive Btrfs write errors on sda are from
an earlier problem where the drive data or power cable got jiggled or
was otherwise absent temporarily? So depending on how the block
timeout change affects your data recovery, you might end up needing to
do a reboot to get back to a more stable state for all of this? It
really should be able to fix things *if* at least one copy can be read
and then written to the other drive.



-- 
Chris Murphy
