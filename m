Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36566 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbcDOXAX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 19:00:23 -0400
Received: by mail-lf0-f48.google.com with SMTP id g184so161613035lfb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 16:00:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKWEGV65rRmpuRnUejCqVpdS+S5nbzrQnFAdy+y3X5EYZJgqpw@mail.gmail.com>
References: <CAKWEGV65rRmpuRnUejCqVpdS+S5nbzrQnFAdy+y3X5EYZJgqpw@mail.gmail.com>
Date: Sat, 16 Apr 2016 01:00:21 +0200
Message-ID: <CAPmG0jby+_X6cwSYMEnQvZe6RhAkTuuwAtPTuEsxctxV--RvcQ@mail.gmail.com>
Subject: Re: RAID6, errors at missing device replacement
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2016 at 9:49 PM, Yauhen Kharuzhy
<yauhen.kharuzhy@zavadatar.com> wrote:
> Hi.
>
> I have discovered case when replacement of missing devices causes
> metadata corruption. Does anybody know anything about this?

I just can confirm that there is corruption when doing replacement for
both raid5 and raid6, and not only metadata.
If the replace is done in a very stepwise way, so no other
transactions ongoing on the fs and also when the device
'faillure'/removal is done in a planned way, the replace can be
successfull.

For raid5 extention from 3x100GB -> 4x100GB balance with stripe filter
worked as expected (some 4.4 kernel). I still had this images stored
and tried how the fs would survive an overwite of 1 device with a DVD
image (kernel 4.6.0-rc1). To summarize, i had to do a replace and
scrub and although tons of errors, some very weird/wrong, all files
seemed still be there. Until I unmounted and tried to remount: fs was
totally corrupted and no way to recover.

> I use 4.4.5 kernel with latest global spare patches.
>
> If we have RAID6 (may be reproducible on RAID5 too) and try to replace
> one missing drive by other and after this try to remove another drive
> and replace it, plenty of errors are shown in the log:
>
> [  748.641766] BTRFS error (device sdf): failed to rebuild valid
> logical 7366459392 for dev /dev/sde
> [  748.678069] BTRFS error (device sdf): failed to rebuild valid
> logical 7381139456 for dev /dev/sde
> [  748.693559] BTRFS error (device sdf): failed to rebuild valid
> logical 7290974208 for dev /dev/sde
> [  752.039100] BTRFS error (device sdf): bad tree block start
> 13048831955636601734 6919258112
> [  752.647869] BTRFS error (device sdf): bad tree block start
> 12819300352 6919290880
> [  752.658520] BTRFS error (device sdf): bad tree block start
> 31618367488 6919290880
> [  752.712633] BTRFS error (device sdf): bad tree block start
> 31618367488 6919290880
>
> After device replacement finish, scrub shows uncorrectable errors.
> Btrfs check complains about errors too:
> root@test:~/# btrfs check -p /dev/sdc
> Checking filesystem on /dev/sdc
> UUID: 833fef31-5536-411c-8f58-53b527569fa5
> checksum verify failed on 9359163392 found E4E3BDB6 wanted 00000000
> checksum verify failed on 9359163392 found E4E3BDB6 wanted 00000000
> checksum verify failed on 9359163392 found 4D1F4197 wanted DE0E50EC
> bytenr mismatch, want=9359163392, have=9359228928
>
> Errors found in extent allocation tree or chunk allocation
> checking free space cache [.]
> checking fs roots [.]
> checking csums
> checking root refs
> found 1049788420 bytes used err is 0
> total csum bytes: 1024000
> total tree bytes: 1179648
> total fs tree bytes: 16384
> total extent tree bytes: 16384
> btree space waste bytes: 124962
> file data blocks allocated: 1049755648
>  referenced 1049755648
>
> After first replacement metadata seems not spread across all devices:
> Label: none  uuid: 3db39446-6810-47bf-8732-d5a8793500f3
>         Total devices 4 FS bytes used 1002.00MiB
>         devid    1 size 8.00GiB used 1.28GiB path /dev/sdc
>         devid    2 size 8.00GiB used 1.28GiB path /dev/sdd
>         devid    3 size 8.00GiB used 1.28GiB path /dev/sdf
>         devid    4 size 8.00GiB used 1.25GiB path /dev/sdg
>
> # btrfs device usage /mnt/
> /dev/sdc, ID: 1
>    Device size:             8.00GiB
>    Data,RAID6:              1.00GiB
>    Metadata,RAID6:        256.00MiB
>    System,RAID6:           32.00MiB
>    Unallocated:             6.72GiB
>
> /dev/sdd, ID: 2
>    Device size:             8.00GiB
>    Data,RAID6:              1.00GiB
>    Metadata,RAID6:        256.00MiB
>    System,RAID6:           32.00MiB
>    Unallocated:             6.72GiB
>
> /dev/sdf, ID: 3
>    Device size:             8.00GiB
>    Data,RAID6:              1.00GiB
>    Metadata,RAID6:        256.00MiB
>    System,RAID6:           32.00MiB
>    Unallocated:             6.72GiB
>
> /dev/sdg, ID: 4
>    Device size:             8.00GiB
>    Data,RAID6:              1.00GiB
>    Metadata,RAID6:        256.00MiB
>    Unallocated:             6.75GiB
>
>
> Steps to reproduce:
> 1) Create and mount RAID6
> 2) remove drive belonging to RAID, try write and let kernel code close
> the device
> 3) replace missing device by 'btrfs replace start' command
> 4) remove drive in another slot, try write, wait for closing of it
> 5) start replacing of missing drive -> ERRORS.
>
> If full balance after step 3) was done, no errors appeared.

I used kernel 4.6.0-rc3  running in a Virtualbox, deleted and added
drives as one would do in a live system, rsyncing files to the fs in
the meantime. Both 1st and 2nd replace device show device errors later
on, but the steps 1) to 5) seem to have worked fine, also btrfs de us
shows correct and regular numbers. So the step 5) ERRORS don't seem to
occur.
BUT:
- when scrub is done, it just stops way too early, but no errors in dmesg
- umount works
- then mount again seems successfully but no mount is done actually,
also not after dev scan or other attempts
- after reboot, fs can be mounted, but many files have changed size
(to 0) and dmesg mentions lots of 'no csum' errors.
- roughly half of the data has disappeared, when comparing scrub output and du

Looking at all this, I did not do the full balance after step 3)
workaround; too many things go wrong at the same time for the kernel I
used.

It could be that you want to see how kernel + global spare patches
work out for raid6 replace specifically ? Or just in general for a new
kernel like 4.6.0-rc3 ?

At least it it looks like that the kernel you used did better than 4.6.0-rc3
