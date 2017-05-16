Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34240 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdEPL1b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 07:27:31 -0400
Received: by mail-io0-f180.google.com with SMTP id k91so91186626ioi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 04:27:31 -0700 (PDT)
Subject: Re: "Corrected" errors persist after scrubbing
To: Tom Hale <tom@hale.ee>, Chris Murphy <lists@colorremedies.com>
References: <92b9b7cd-5b54-775f-95c1-4788b2d3ea67@hale.ee>
 <CAJCQCtRmMtm5PW-TsUw+erQdXC9K41F0Nys5R+CRv0=KRh7aHw@mail.gmail.com>
 <e399fe02-0d5e-890f-48e4-423c8ef8174b@hale.ee>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7cffb2de-8f99-633c-72d9-fda14e3f49ed@gmail.com>
Date: Tue, 16 May 2017 07:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <e399fe02-0d5e-890f-48e4-423c8ef8174b@hale.ee>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-16 05:53, Tom Hale wrote:
> Hi Chris,
>
> On 09/05/17 02:26, Chris Murphy wrote:
>> Read errors are fixed by overwrites. If the underlying device doesn't
>> report an error for the write command, it's assumed to succeed. Even
>> md and LVM raid's do this.
>
> I understand assuming writes succeed in general. However, for a tool
> which says (in its usage):
Outside of dm-error and/or dm-flakey, what hardware have you seen that 
fails writes without reporting a write error?  SSD's might do it at the 
lowest level (below firmware), but the SSD firmware will notice and 
should correct it itself, and it won't happen persistently unless the 
device is essentially dead, but in general, short of the storage media 
itself failing, it is entirely safe to assume that what you told the 
device to write is what got written as long as the write commands succeeded.
>
> "verify checksums of data and metadata"
>
> I would expect that the tool reports the *final state* of the data:
Which is easy enough to do by hand without needing to make scrub do more 
work all the time (just run a read-only scrub after the first one).
>
> * Because the explicit function of scrub is to verify that all data can
> be read.
Not exactly, it's function is to verify that checksums are correct, 
verifying that there are no low-level read errors is simply a side 
effect of that.
>
> * In a RAID1 situation, the sysadmin could think that the there are two
> valid copies of all data, when in fact there may only be one.
>
>> What are the complete kernel messages for the scrub event? This should
>> show what problem Btrfs detects and how it fixes it, and what sectors
>> it's fixing each time.
>
> Attached are the kernel logs (and the `grep fixed` version) showing the
> same logical blocks are "fixed" twice.
>
> Below (and attached because of formatting) I show how to reproduce the
> uncorrected errors, producing the attached logs.
>
> Please reply-all as I'm not subscribed.
>
> ----------------------------------------------------
>
> $ pacman -Q btrfs-progs
> btrfs-progs 4.10.2-1
> $ uname -r
> 4.9.24-1-MANJARO
>
> # fallocate -l 500M good-disk
> # fallocate -l 500M bad-disk
> # losetup -f bad-disk # loop0
> # losetup -f good-disk # loop1
> # mdadm --create -v /dev/md0 --level=linear --force --raid-devices=1
> /dev/loop0
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> # mkfs.btrfs -m raid1 -d raid1 /dev/loop1 /dev/md0
> btrfs-progs v4.10.2
> See http://btrfs.wiki.kernel.org for more information.
>
> Performing full device TRIM /dev/loop1 (500.00MiB) ...
> Performing full device TRIM /dev/md0 (499.73MiB) ...
> Label:              (null)
> UUID:               d748537b-3fa4-47cc-9934-62cf391fb638
> Node size:          16384
> Sector size:        4096
> Filesystem size:    999.73MiB
> Block group profiles:
>   Data:             RAID1            64.00MiB
>   Metadata:         RAID1            49.94MiB
>   System:           RAID1             8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  2
> Devices:
>    ID        SIZE  PATH
>     1   500.00MiB  /dev/loop1
>     2   499.73MiB  /dev/md0
> # mount /dev/md0 /mnt/tmp
> # dd if=/dev/urandom of=/mnt/tmp/rand bs=1M
> dd: error writing '/mnt/tmp/rand': No space left on device
> 441+0 records in
> 440+0 records out
> 461963264 bytes (462 MB, 441 MiB) copied, 5.74358 s, 80.4 MB/s
> # umount /mnt/tmp
> # mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> # mdadm --build /dev/md0 --level=faulty --raid-devices=1 /dev/loop0
> mdadm: array /dev/md0 built and started.
>     ├─vg_svelte-swap   swap              suspend
> 0792d327-566d-4306-93f4-810e247827e4   [SWAP]
>     └─vg_svelte-rootfs btrfs             root
> a1d2a0b4-8d4b-4c1c-9c87-5a55de61918e   /mnt/btrfs-vol/rootfs
> # lsblk -f | head -n4
> NAME                   FSTYPE            LABEL    UUID
>                 MOUNTPOINT
> loop0                  linux_raid_member svelte:0
> f7019aa8-3b2d-4e4c-9106-635d0dddca78
> └─md0                  linux_raid_member svelte:0
> f7019aa8-3b2d-4e4c-9106-635d0dddca78
>   └─md127              btrfs
> d748537b-3fa4-47cc-9934-62cf391fb638
> # mount /dev/md127 /mnt/tmp
> # btrfs scrub start -Bd /mnt/tmp
> scrub device /dev/loop1 (id 1) done
>         scrub started at Tue May 16 13:04:50 2017 and finished after
> 00:00:03
>         total bytes scrubbed: 441.22MiB with 0 errors
> scrub device /dev/md127 (id 2) done
>         scrub started at Tue May 16 13:04:50 2017 and finished after
> 00:00:02
>         total bytes scrubbed: 441.22MiB with 0 errors
> # # Introduce errors in /dev/md127:
> # mdadm --grow /dev/md0 --layout=rp400
> layout for /dev/md0 set to 12803
> # btrfs scrub start -Bd /mnt/tmp
>
>
> scrub device /dev/loop1 (id 1) done
>         scrub started at Tue May 16 13:07:57 2017 and finished after
> 00:00:02
>         total bytes scrubbed: 441.22MiB with 0 errors
> scrub device /dev/md127 (id 2) done
>         scrub started at Tue May 16 13:07:57 2017 and finished after
> 00:00:03
>         total bytes scrubbed: 441.22MiB with 19 errors
>         error details: read=19
>         corrected errors: 19, uncorrectable errors: 0, unverified
> errors: 589
> WARNING: errors detected during scrubbing, corrected
> # # Stop producing additional errors, keeping the already existing
> badblocks:
> # mdadm --grow /dev/md0 --layout=clear
> layout for /dev/md0 set to 31
> # # Run scrub for 2nd time:
> # btrfs scrub start -Bd /mnt/tmp
>
>
> scrub device /dev/loop1 (id 1) done
>         scrub started at Tue May 16 13:10:19 2017 and finished after
> 00:00:03
>         total bytes scrubbed: 441.22MiB with 0 errors
> scrub device /dev/md127 (id 2) done
>         scrub started at Tue May 16 13:10:19 2017 and finished after
> 00:00:03
>         total bytes scrubbed: 441.22MiB with 19 errors
>         error details: read=19
>         corrected errors: 19, uncorrectable errors: 0, unverified
> errors: 589
> WARNING: errors detected during scrubbing, corrected
> # # Clean up
> # umount /mnt/tmp
> # mdadm --stop /dev/md127
> mdadm: stopped /dev/md127
> # mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> # losetup -d /dev/loop[01]
> #
>

