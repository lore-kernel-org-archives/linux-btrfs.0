Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:54990 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728814AbeIGAxh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 20:53:37 -0400
Received: by mail-wm0-f52.google.com with SMTP id c14-v6so12601414wmb.4
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 13:16:30 -0700 (PDT)
Subject: Re: btrfs send hung in pipe_wait
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
 <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com>
 <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
 <d0223039-5c8f-38db-fe32-0b46b220e699@gmail.com>
 <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
From: Stefan Loewen <stefan.loewen@gmail.com>
Message-ID: <326f12a3-ee55-0812-5ea6-f54c0362a29b@gmail.com>
Date: Thu, 6 Sep 2018 22:16:23 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtREREvzveNqdahGb8GN62_CJMyeL8GhjxnqmVZqxKiDUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[root@archlinux @data]# btrfs fi us /mnt/intenso_white/
Overall:
Device size:                 911.51GiB
Device allocated:            703.09GiB
Device unallocated:          208.43GiB
Device missing:                  0.00B
Used:                        658.19GiB
Free (estimated):            249.75GiB      (min: 145.53GiB)
Data ratio:                       1.00
Metadata ratio:                   2.00
Global reserve:              512.00MiB      (used: 0.00B)
Data,single: Size:695.01GiB, Used:653.69GiB
/dev/sdb1     695.01GiB
Metadata,DUP: Size:4.00GiB, Used:2.25GiB
/dev/sdb1       8.00GiB
System,DUP: Size:40.00MiB, Used:96.00KiB
/dev/sdb1      80.00MiB
Unallocated:
/dev/sdb1     208.43GiB

Does that mean Metadata is duplicated?

Ok so to summarize and see if I understood you correctly:
There are bad sectors on disk. Running an extended selftest (smartctl -t 
long) could find those and replace them with spare sectors.
If it does not I can try calculating the physical (4K) sector number and 
write to that to make the drive notice and mark the bad sector.
Is there a way to find out which file I will be writing to beforehand? 
Or is it easier to just write to the sector and then wait for scrub to 
tell me (and the sector is broken anyways)?

For the drive: Not under warranty anymore. It's an external HDD that I 
had lying around for years, mostly unused. Now I wanted to use it as 
part of my small DIY NAS.


On 9/6/18 9:58 PM, Chris Murphy wrote:
> On Thu, Sep 6, 2018 at 12:36 PM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
>> Output of the commands is attached.
> fdisk
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
>
> smart
> Sector Sizes:     512 bytes logical, 4096 bytes physical
>
> So clearly the case is lying about the actual physical sector size of
> the drive. It's very common. But it means to fix the bad sector by
> writing to it, must be a 4K write. A 512 byte write to the reported
> LBA, will fail because it is a RMW, and the read will fail. So if you
> write to that sector, you'll get a read failure. Kinda confusing. So
> you can convert the LBA to a 4K value, and use dd to write to that "4K
> LBA" using bs=4096 and a count of 1.... but only when you're ready to
> lose all 4096 bytes in that sector. If it's data, it's fine. It's the
> loss of one file, and scrub will find and report path to file so you
> know what was affected.
>
> If it's metadata, it could be a problem. What do you get for 'btrfs fi
> us <mountpoint>' for this volume? I'm wondering if DUP metadata is
> being used across the board with no single chunks. If so, then you can
> zero that sector, and Btrfs will detect the missing metadata in that
> chunk on scrub, and fix it up from a copy. But if you only have single
> copy metadata, it just depends what's on that block as to how
> recoverable or repairable this is.
>
>
> 195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
> 196 Reallocated_Event_Count -O--CK   252   252   000    -    0
> 197 Current_Pending_Sector  -O--CK   252   252   000    -    0
> 198 Offline_Uncorrectable   ----CK   252   252   000    -    0
>
> Interesting, no complaints there. Unexpected.
>
> 11 Calibration_Retry_Count -O--CK   100   100   000    -    8
> 200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    31
>
> https://kb.acronis.com/content/9136
>
> This is a low hour device, probably still under warranty? I'd get it
> swapped out. If you want more ammunition for arguing in favor of a
> swap out under warranty you could do
>
> smartctl -t long /dev/sdb
>
> That will take just under 4 hours to run (you can use the drive in the
> meantime, but it'll take a bit longer); and then after that
>
> smartctl -x /dev/sdb
>
> And see if it's found a bad sector or updated any of those smart
> values for the worse in particular the offline values.
>
>
>
>
> SCT (Get) Error Recovery Control command failed
>
> OK so not configurable, it is whatever it is and we don't know what
> that is. Probably one of the really long recoveries.
>
>
>
>
>> The broken-sector-theory sounds plausible and is compatible with my new
>> findings:
>> I suspected the problem to be in one specific directory, let's call it
>> "broken_dir".
>> I created a new subvolume and copied broken_dir over.
>> - If I copied it with cp --reflink, made a snapshot and tried to btrfs-send
>> that, it hung
>> - If I rsynced broken_dir over I could snapshot and btrfs-send without a
>> problem.
> Yeah I'm not sure what it is, maybe a data block.
>
>> But shouldn't btrfs scrub or check find such errors?
> Nope. Btrfs expects the drive to complete the read command, but always
> second guesses the content of the read by comparing to checksums. So
> if the drive just supplied corrupt data, Btrfs would detect that and
> discretely report, and if there's a good copy it would self heal. But
> it can't do that because the drive or USB bus also seems to hang in
> such a way that a bunch of tasks are also hung, and none of them are
> getting a clear pass/fail for the read. It just hangs.
>
> Arguably the device or the link should not hang. So I'm still
> wondering if something else is going on, but this is just the most
> obvious first problem, and maybe it's being complicated by another
> problem we haven't figure out yet. Anyway, once this problem is solve,
> it'll become clear if there are additional problems or not.
>
> In my case, I often get usb reset errors when I directly connect USB
> 3.0 drives to my Intel NUC, but I don't ever get them when plugging
> the drive into a dyconn hub. So if you don't already have a hub in
> between the drive and the computer, it might be worth considering.
> Basically the hub is going to read and completely rewrite the whole
> stream that goes through it (in both directions).
>
>
>
