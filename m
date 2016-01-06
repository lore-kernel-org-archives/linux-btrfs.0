Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33856 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbcAFUv0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 15:51:26 -0500
Received: by mail-lf0-f43.google.com with SMTP id y184so320267911lfc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 12:51:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568C9A1B.6090907@gmail.com>
References: <568C9A1B.6090907@gmail.com>
Date: Wed, 6 Jan 2016 21:51:24 +0100
Message-ID: <CAPmG0jZAwyZ3t7s60vji0ovr2bTaOJiWOJsaCif2QeNi+v7njw@mail.gmail.com>
Subject: Re: floating point exception (core dumped) - btrfs rescue chunk-recover
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 6, 2016 at 5:37 AM, P R Shah <getprshah@gmail.com> wrote:
> Hello,
>
> TL;DR ==
>
> btrfs 3x500GB RAID 5 - One device failed. Added a new device (btrfs device
> add) and tried to remove the failed device (btrfs device delete).
Pity that you used add and delete, especially with already failing
device in btrfs raid5, this will easily lead to the situation you have
now. A delete assumes all devices healthy and that wasn't the case.
You should have used
 btrfs replace  , likely with option -r.
You could have also tried some non-btrfs saving tricks, like umount
the fs and do a
 dd_rescue  failing_device new_device
and disconnect the failing_device from the system, do a btrfs dev scan
and then mount the fs and do a scrub. I have used this once
successfully. But btrfs replace does work well enough with recent
kernel/tools, so simply use that I would say.
Note that scrub for raid5  in latest kernels is slow, roughly 10MiB/s
per disk for disks you use I think

> I tried to mount the array in degraded mode, but that didn't work either.
> After multiple attempts (including adding back the failed HDD), I finally
> ran the btrfs rescue chunk-recover command on the primary member /dev/sdb.
>
> This ran for about 4 hours, and then failed with "floating point exception
> (core dumped)".
> ==
>
> I am testing out btrfs to gain familiarity with it. I am quite amazed at
> it's capabilities and performance. However, I am either not able to
> understand or implement RAID5 fault tolerance.
>
> I understand from the wiki that RAID56 is experimental. The data I am
> working with is backed up elsewhere and for all intents and purposes,
> discard-able.
>
> I have set up a btrfs RAID5 with 3x500GB Seagate HDDs, with a mount point of
> /storage. Booting is off a fourth HDD (ext4, lubuntu 64bit) that is not
> involved in the RAID.
>
> Everything was working amazingly well, until one HDD failed and was quietly
> offlined. For a couple of days, the RAID was running off 2 HDDs and I didn't
> notice.
>
> When I DID realize, I shut down the system, bought a new HDD (2TB), which
> took a couple of days to arrive.
>
> When I powered up the system again, the failed 500GB was back. Everything
> loaded fine, and looked good. To be on the safe side, I ran a badblocks test
> (ro) on the failing HDD.
>
> Halfway through the test, the HDD disappeared again. After a cold reboot, it
> was loaded fine again.
>
> At this point, I decided to replace the failed HDD. I shutdown, plugged in
> the new HDD in place of the boot HDD, booted up with Lubuntu live, mounted
> (/storage) and added the device to the RAID.
>
> After adding the device successfully, I gave a device delete command for the
> failed HDD. Partway through the process, the failing HDD (/dev/sdc)
> disappeared again, and after waiting a couple of hours, I hard-reset the
> system, and removed the failing HDD, assuming that the RAID will re-build on
> the existing devices.
>
> Now, the RAID (/storage) refused to mount. I got a c_tree error (please see
> enclosed logs below).
>
> I tried to mount the array in degraded mode, but that didn't work either.
> After multiple attempts (including adding back the failed HDD), I finally
> ran the btrfs rescue chunk-recover command on the primary member /dev/sdb.
>
> This ran for about 4 hours, and then failed with "floating point exception
> (core dumped)".
>
> Can I recover the array or should I start again? The data is not important,
> but I would like to know the recovery process, or any misconceptions in my
> thinking that RAID5 with 3 devices is enough for SOHO-level fault tolerance?
You could try to mount with -o recovery with a 4.4 kernel and see what
happens, but I would start again. Maybe you can restart with the
3x500GB, and when you detect the first fail again, do a replace and
see if it works. Then you have an answers to the second question. It
is also up to you if are ok with the slow scrubs and a missing device
fail alert.

> Any advice, pointers, etc, much appreciated. Tech level: medium-high (RHCE).
>
> Relevant system information:
> === uname -a
> Linux lubuntu 4.2.0-16-generic #19-Ubuntu SMP Thu Oct 8 15:35:06 UTC 2015
> x86_64 x86_64 x86_64 GNU/Linux
If you want try/use raid5, best to use a latest kernel from
kernel.org, like 4.4-rc8. Support for kernel 4.2 will not not be done
anymore by kernel.org, but by Canonical, so in theory, you should
look-up what patches are in this  4.2.0-16-generic #19-Ubuntu and ask
them for support.

> == btrfs --version
> btrfs-progs v4.0
Same for tools version, get the latest ( currently 4.3.1)

> == btrfs fi show
> warning, device 2 is missing
> Label: 'storage'  uuid: 5a3d6590-df08-4520-b61b-802d350849c7
>         Total devices 4 FS bytes used 176.91GiB
>         devid    1 size 465.76GiB used 90.03GiB path /dev/sdb
>         devid    3 size 465.76GiB used 90.01GiB path /dev/sdc
>         devid    4 size 1.82TiB used 10.00GiB path /dev/sda
>         *** Some devices missing
>
> == dmesg info
> ...
> Jan  5 01:45:22 lubuntu kernel: [   10.338295] Btrfs loaded
> Jan  5 01:45:22 lubuntu kernel: [   10.338899] BTRFS: device label storage
> devid 4 transid 969 /dev/sda
> Jan  5 01:45:22 lubuntu kernel: [   10.340448] BTRFS info (device sda): disk
> space caching is enabled
> Jan  5 01:45:22 lubuntu kernel: [   10.340454] BTRFS: has skinny extents
> Jan  5 01:45:22 lubuntu kernel: [   10.343395] BTRFS: failed to read the
> system array on sda
> Jan  5 01:45:22 lubuntu kernel: [   10.352137] BTRFS: open_ctree failed
> Jan  5 01:45:22 lubuntu kernel: [   10.382199] BTRFS: device label storage
> devid 1 transid 969 /dev/sdb
> Jan  5 01:45:22 lubuntu kernel: [   10.383740] BTRFS info (device sdb): disk
> space caching is enabled
> Jan  5 01:45:22 lubuntu kernel: [   10.383744] BTRFS: has skinny extents
> Jan  5 01:45:22 lubuntu kernel: [   10.384469] BTRFS: failed to read the
> system array on sdb
> Jan  5 01:45:22 lubuntu kernel: [   10.392116] BTRFS: open_ctree failed
> Jan  5 01:45:22 lubuntu kernel: [   10.423075] BTRFS: device label storage
> devid 3 transid
>
> ... // after btrfs rescue chunk for about 4 hours
> Jan  5 06:01:45 lubuntu kernel: [15404.828156] traps: btrfs[3016] trap
> divide error ip:4211a0 sp:7ffd7dbb03a8 error:0 in btrfs[400000+73000]
> ...
>
> == some output from btrfs rescu chunk -vv
> ...
>             Stripes list:
>             [ 0] Stripe: devid = 3, offset = 21484273664
>             [ 1] Stripe: devid = 2, offset = 21484273664
>             [ 2] Stripe: devid = 1, offset = 21504196608
>         Chunk: start = 45134905344, len = 2147483648, type = 81, num_stripes
> = 3
>             Stripes list:
>             [ 0] Stripe: devid = 3, offset = 22558015488
>             [ 1] Stripe: devid = 2, offset = 22558015488
>             [ 2] Stripe: devid = 1, offset = 22577938432
>         Chunk: start = 47282388992, len = 2147483648, type = 81, num_stripes
> = 3
>             Stripes list:
>             [ 0] Stripe: devid = 3, offset = 23631757312
>             [ 1] Stripe: devid = 2, offset = 23631757312
>             [ 2] Stripe: devid = 1, offset = 23651680256
> ...
>         Device extent: devid = 4, start = 5369757696, len = 1073741824,
> chunk offset = 201901211648
>         Device extent: devid = 4, start = 6443499520, len = 1073741824,
> chunk offset = 204048695296
>         Device extent: devid = 4, start = 7517241344, len = 1073741824,
> chunk offset = 206196178944
>         Device extent: devid = 4, start = 8590983168, len = 1073741824,
> chunk offset = 208343662592
> // floating point error
>
> Regards,
> PRShah
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
