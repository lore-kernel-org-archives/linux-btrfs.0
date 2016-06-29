Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33476 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcF2R2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 13:28:37 -0400
Received: by mail-ob0-f176.google.com with SMTP id xn17so35641985obc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 10:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160629115055.29018e6a@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system> <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
 <20160628024940.3b323b26@system> <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
 <20160629005208.5e9addcf@system> <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
 <20160629115055.29018e6a@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 29 Jun 2016 11:28:24 -0600
Message-ID: <CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2016 at 3:50 AM, Saint Germain <saintger@gmail.com> wrote:

> Already got a backup. I just really want to try to repair it (in order
> to test BTRFS).

I don't know that this is a good test because I think the file system
has already been sufficient corrupted that it can't be fixed. Part of
the problem is that Btrfs isn't aware of faulty drives like mdadm or
lvm yet, so it looks like it'll try to write to all devices and it's
possible for significant confusion to happen if they're each getting
different generation writes. Significant as in, currently beyond
repair.



>
>> > On the other hand it seems interesting to repair instead of just
>> > giving up. It gives a good look at BTRFS resiliency/reliability.
>>
>> On the one hand Btrfs shouldn't become inconsistent in the first
>> place, that's the design goal. On the other hand, I'm finding from the
>> problems reported on the list that Btrfs increasingly mounts at least
>> read only and allows getting data off, even when the file system isn't
>> fully functional or repairable.
>>
>> In your case, once there are metadata problems even with raid 1, it's
>> difficult at best. But once you have the backup you could try some
>> other things once it's certain the hardware isn't adding to the
>> problems, which I'm still not yet certain of.
>>
>
> I'm ready to try anything. Let's experiment.

I kinda think it's a waste of time. Someone else maybe has a better idea?

I think your time is better spent finding out when and why the device
with all of these write errors happened. It must have gone missing for
a while, and you need to find out why that happened and prevent it; OR
you have to be really vigilent at every mount time to make sure both
devices have the same transid (generation). In my case when I tried to
sabotage this, being of by a generation of 1 wasn't a problem for
Btrfs to automatically fix up but I suspect it was only a generation
mismatch in the superblock.


> I got some errors on sdb 2 months ago (I noticed it because it was
> suddenly mounted read-only). I ran a scrub and a check --repair, and
> a lot of errors were corrected. I deleted the files which were not
> repairable and everything was running smoothly since. I ran a scrub a
> few weeks ago and everything was fine.

I'm not sure what to tell you. Maybe look at logs for the last three
weeks for Btrfs and libata related messages to see if something else
happened since that good scrub that you didn't notice. Also look at
the mount messages and see if there are incrementing error counts in
messages like this >

BTRFS info (device sdb1): bdev /dev/sdb1 errs: wr 11881695, rd 14,
flush 7928, corrupt 1714507, gen 1335

Maybe you can ignore corrupt value because once there are checksum
problems that number increments everytime the same corruption is
found, it looks like. But if in the week after the scrub these numbers
are changing there is a hardware problem somewhere and you need to
find it. Btrfs can't be expected to work around every possible
hardware problem.


> So if I understand correctly, you advise to use check --repair
> --init-csum-tree and delete the files which were reported as having
> checksum error ?

Yes but all this does is mask the problem with the files. It might
clean up the error messages do you can find out if the file system
itself is bad, including making btrfs check more legible for file
system problems rather than file extent corruption.


> Is there anyway I can be sure afterwards that the volume is indeed
> completely correct and reliable ?

Unknown. In theory if it passes scrub and btrfs check and mounts read
write then it's a good file system. But there are bugs so it's
possible it comes up healthy but then in a week or month, *shrug*,
it's a test.


> If there is no way to be sure, I think it is better that I cp/rsync all
> data to a new BTRFS volume.

I personally would probably just obliterate it and start over, *and*
also be more vigilant at mount time about generation numbers, and also
check the logs periodically for device problems.

This one *especially* is not good:


> Jun 28 11:35:23 system kernel: [49887.681350] ata2.00: exception Emask 0x0 SAct 0x600 SErr 0x0 action 0x6 frozen
> Jun 28 11:35:23 system kernel: [49887.685258] ata2.00: failed command: READ FPDMA QUEUED
> Jun 28 11:35:23 system kernel: [49887.689251] ata2.00: cmd 60/00:48:80:d7:70/01:00:0f:00:00/40 tag 9 ncq 131072 in
> Jun 28 11:35:23 system kernel: [49887.689251]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jun 28 11:35:23 system kernel: [49887.696884] ata2.00: status: { DRDY }
> Jun 28 11:35:23 system kernel: [49887.700353] ata2.00: failed command: READ FPDMA QUEUED
> Jun 28 11:35:23 system kernel: [49887.703749] ata2.00: cmd 60/00:50:80:d8:70/01:00:0f:00:00/40 tag 10 ncq 131072 in
> Jun 28 11:35:23 system kernel: [49887.703749]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jun 28 11:35:23 system kernel: [49887.710243] ata2.00: status: { DRDY }
> Jun 28 11:35:23 system kernel: [49887.713250] ata2: hard resetting link


This is a hung read command. The drive hasn't responded within the
time set in /sys/block/sdX/device/timeout and like I mentioned in a
previous message that's 30 seconds by default. When recovering from a
bad or unknown state it's probably better to set this to 180 for each
drive. In normal usage, it's better to set the SCT ERC for each drive
to 70 deciseconds so errors happens faster and Btrfs can fix it
sooner.

Reset means we don't really know what went wrong.


> Jun 28 11:35:24 system kernel: [49888.023941] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> Jun 28 11:35:24 system kernel: [49888.037132] ata2.00: configured for UDMA/133
> Jun 28 11:35:24 system kernel: [49888.037143] ata2: EH complete
> Jun 28 11:35:27 system kernel: [49890.782261] ata2.00: exception Emask 0x0 SAct 0x2000 SErr 0x0 action 0x0
> Jun 28 11:35:27 system kernel: [49890.783864] ata2.00: irq_stat 0x40000008
> Jun 28 11:35:27 system kernel: [49890.785437] ata2.00: failed command: READ FPDMA QUEUED
> Jun 28 11:35:27 system kernel: [49890.787034] ata2.00: cmd 60/00:68:80:d7:70/01:00:0f:00:00/40 tag 13 ncq 131072 in
> Jun 28 11:35:27 system kernel: [49890.787034]          res 41/40:00:08:d8:70/00:00:0f:00:00/40 Emask 0x409 (media error) <F>
> Jun 28 11:35:27 system kernel: [49890.794700] ata2.00: status: { DRDY ERR }
> Jun 28 11:35:27 system kernel: [49890.796272] ata2.00: error: { UNC }
> Jun 28 11:35:27 system kernel: [49890.811742] ata2.00: configured for UDMA/133
> Jun 28 11:35:27 system kernel: [49890.811755] sd 1:0:0:0: [sdb] tag#13 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jun 28 11:35:27 system kernel: [49890.811758] sd 1:0:0:0: [sdb] tag#13 Sense Key : Medium Error [current] [descriptor]
> Jun 28 11:35:27 system kernel: [49890.811760] sd 1:0:0:0: [sdb] tag#13 Add. Sense: Unrecovered read error - auto reallocate failed
> Jun 28 11:35:27 system kernel: [49890.811763] sd 1:0:0:0: [sdb] tag#13 CDB: Read(10) 28 00 0f 70 d7 80 00 01 00 00
> Jun 28 11:35:27 system kernel: [49890.811765] blk_update_request: I/O error, dev sdb, sector 259053576
> Jun 28 11:35:27 system kernel: [49890.813241] ata2: EH complete


This is semi-bad in that it means there's a sector that can't be read.
Its data is lost. Btrfs has to use a mirror copy but if that mirror
copy is corrupt / doesn't mass checksum, then Btrfs will not do a
fixup and you're stuck. It's good in that there's an explicit read
error due to media defect and the drive supplied the LBA that's
affected. Some of these are OK as long as they're being fixed through
redundancy.



-- 
Chris Murphy
