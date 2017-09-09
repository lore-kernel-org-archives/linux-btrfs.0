Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37632 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757334AbdIIJGJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 05:06:09 -0400
Received: by mail-wm0-f65.google.com with SMTP id f4so3153613wmh.4
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Sep 2017 02:06:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sat, 9 Sep 2017 11:05:47 +0200
Message-ID: <CAA7pwKMmM4+96D3iPA5n_g-sFPk1L6skK9-18ZOg7SizHsUqoQ@mail.gmail.com>
Subject: Re: Please help with exact actions for raid1 hot-swap
To: Marat Khalili <mkh@rqc.ru>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 September 2017 at 09:46, Marat Khalili <mkh@rqc.ru> wrote:
>
> Dear list,
>
> I'm going to replace one hard drive (partition actually) of a btrfs raid1. Can you please spell exactly what I need to do in order to get my filesystem working as RAID1 again after replacement, exactly as it was before? I saw some bad examples of drive replacement in this list so I afraid to just follow random instructions on wiki, and putting this system out of action even temporarily would be very inconvenient.


I recently replaced both disks in a two disk Btrfs raid1 to increase
capacity and took some notes.

Using systemd? systemd will automatically unmount a degraded disk and
ruin your one chance to replace the disk as long as Btrfs has the bug
where it notes single chunks and one disk missing and refuses to mount
degraded again.

Comment out your mount in fstab and run "systemctl daemon-reload". The
mount file in /var/run/systemd/generator/ will be removed. (Is there a
better way?)

Unmount the volume.

# hdparm -Y /dev/sdb
# echo 1 > /sys/block/sdb/device/delete

Replace the disk. Create partitions etc. You might have to restart
smartd, if using it.

Make Btrfs forget the old device. Will otherwise think the old disk is
still there. (Is there a better way?)
# rmmod btrfs; modprobe btrfs
# btrfs device scan

# mount -o degraded /dev/sda7 /mnt/data
# btrfs device usage /mnt/data

# btrfs replace start <missing devid> /dev/sdbX /mnt/data
# btrfs replace status /mnt/data

Convert single or dup chunks to raid1
# btrfs balance start -fv -dconvert=raid1,soft -mconvert=raid1,soft
-sconvert=raid1,soft /mnt/data

Unmount, restore fstab, reload systemd again, mount.

>
> For this filesystem:
>
>> $ sudo btrfs fi show /dev/sdb7
>> Label: 'data'  uuid: 37d3313a-e2ad-4b7f-98fc-a01d815952e0
>>     Total devices 2 FS bytes used 106.23GiB
>>     devid    1 size 2.71TiB used 126.01GiB path /dev/sda7
>>     devid    2 size 2.71TiB used 126.01GiB path /dev/sdb7
>> $ grep /mnt/data /proc/mounts
>> /dev/sda7 /mnt/data btrfs rw,noatime,space_cache,autodefrag,subvolid=5,subvol=/ 0 0
>> $ sudo btrfs fi df /mnt/data
>> Data, RAID1: total=123.00GiB, used=104.57GiB
>> System, RAID1: total=8.00MiB, used=48.00KiB
>> Metadata, RAID1: total=3.00GiB, used=1.67GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>> $ uname -a
>> Linux host 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>
>
> I've got this in dmesg:
>
>> [Sep 8 20:31] ata6.00: exception Emask 0x0 SAct 0x7ecaa5ef SErr 0x0 action 0x0
>> [  +0.000051] ata6.00: irq_stat 0x40000008
>> [  +0.000029] ata6.00: failed command: READ FPDMA QUEUED
>> [  +0.000038] ata6.00: cmd 60/70:18:50:6c:f3/00:00:79:00:00/40 tag 3 ncq 57344 in
>>                        res 41/40:00:68:6c:f3/00:00:79:00:00/40 Emask 0x409 (media error) <F>
>> [  +0.000094] ata6.00: status: { DRDY ERR }
>> [  +0.000026] ata6.00: error: { UNC }
>> [  +0.001195] ata6.00: configured for UDMA/133
>> [  +0.000030] sd 6:0:0:0: [sdb] tag#3 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> [  +0.000005] sd 6:0:0:0: [sdb] tag#3 Sense Key : Medium Error [current] [descriptor]
>> [  +0.000004] sd 6:0:0:0: [sdb] tag#3 Add. Sense: Unrecovered read error - auto reallocate failed
>> [  +0.000005] sd 6:0:0:0: [sdb] tag#3 CDB: Read(16) 88 00 00 00 00 00 79 f3 6c 50 00 00 00 70 00 00
>> [  +0.000003] blk_update_request: I/O error, dev sdb, sector 2045996136
>> [  +0.000047] BTRFS error (device sda7): bdev /dev/sdb7 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
>> [  +0.000062] BTRFS error (device sda7): bdev /dev/sdb7 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
>> [  +0.000077] ata6: EH complete
>
>
> There's still 1 in Current_Pending_Sector line of smartctl output as of now, so it probably won't heal by itself.
>
> --
>
> With Best Regards,
> Marat Khalili
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
