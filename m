Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34397 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbcBITfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 14:35:54 -0500
Received: by mail-lb0-f175.google.com with SMTP id cw1so106085341lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 11:35:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160207182841.0d749ea7@redPill>
References: <20160207182841.0d749ea7@redPill>
Date: Tue, 9 Feb 2016 20:35:53 +0100
Message-ID: <CAPmG0jaRphE4jWi4aGUk_tV2OYyddVUXjwcNtuN+A97PTWtYVA@mail.gmail.com>
Subject: Re: One disc of 3-disc btrfs-raid5 failed - files only partially readable
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 7, 2016 at 6:28 PM, Benjamin Valentin
<benpicco@googlemail.com> wrote:
> Hi,
>
> I created a btrfs volume with 3x8TB drives (ST8000AS0002-1NA) in raid5
> configuration.
> I copied some TB of data onto it without errors (from eSATA drives, so
> rather fast - I mention that because of [1]), then set it up as a
> fileserver where it had data read and written to it over a gigabit
> ethernet connection for several days.
> This however didn't go so well because after one day, one of the drives
> dropped off the SATA bus.
>
> I don't know if that was related to [1] (I was running Linux 4.4-rc6 to
> avoid that) and by now all evidence has been eaten by logrotate :\
>
> But I was not concerned for I had set up raid5 to provide redundancy
> against one disc failure - unfortunately it did not.
>
> When trying to read a file I'd get an I/O error after some hundret MB
> (this is random across multiple files, but consistent for the same
> file) on both files written before and after the disc failue.
>
> (There was still data being written to the volume at this point.)
>
> After a reboot a couple days later the drive showed up again and SMART
> reported no errors, but the I/O errors remained.
>
> I then ran btrfs scrub (this took about 10 days) and afterwards I was
> again able to completely read all files written *before* the disc
> failure.
>
> However, many files written *after* the event (while only 2 drives were
> online) are still only readable up to a point:
>
> $ dd if=Dr.Strangelove.mkv of=/dev/null
> dd: error reading ‘Dr.Strangelove.mkv’:
> Input/output error
> 5331736+0 records in
> 5331736+0 records out
> 2729848832 bytes (2,7 GB) copied, 11,1318 s, 245 MB/s
>
> $ ls -sh
> 4,4G Dr.Strangelove.mkv
>
> [  197.321552] BTRFS warning (device sda): csum failed ino 171545 off 2269564928 csum 2566472073 expected csum 2434927850
> [  197.321574] BTRFS warning (device sda): csum failed ino 171545 off 2269569024 csum 566472073 expected csum 212160686
> [  197.321592] BTRFS warning (device sda): csum failed ino 171545 off 2269573120 csum 2566472073 expected sum 2202342500
>
> I tried btrfs check --repair but to no avail, got some
>
> [ 4549.762299] BTRFS warning (device sda): failed to load free space cache for block group 1614937063424, rebuilding it now
> [ 4549.790389] BTRFS error (device sda): csum mismatch on free space cache
>
> and this result
>
> checking extents
> Fixed 0 roots.
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> enabling repair mode
> Checking filesystem on /dev/sda
> UUID: ed263a9a-f65c-4bb6-8ee7-0df42b7fbfb8
> cache and super generation don't match, space cache will be invalidated
> found 11674258875712 bytes used err is 0
> total csum bytes: 11387937220
> total tree bytes: 13011156992
> total fs tree bytes: 338083840
> total extent tree bytes: 99123200
> btree space waste bytes: 1079766991
> file data blocks allocated: 14669115838464
>  referenced 14668840665088
>
> when I mount the volume with -o nospace_cache I instead get
>
> [ 6985.165421] BTRFS warning (device sda): csum failed ino 171545 off 2269560832 csum 2566472073 expected csum 874509527
> [ 6985.165469] BTRFS warning (device sda): csum failed ino 171545 off 2269564928 csum 566472073 expected csum 2434927850
> [ 6985.165490] BTRFS warning (device sda): csum failed ino 171545 off 2269569024 csum 2566472073 expected csum 212160686
>
> when trying to read the file.

You could use 1-time mount option clear_cache, then mount normally and
cache will be rebuild automatically (but also corrected if you don't
clear it)

> Do you think there is still a chance to recover those files?

You can use  btrfs restore  to get files off a damaged fs.

> Also am I mistaken to believe that btrfs-raid5 would continue to
> function when one disc fails?

The problem you encountered is quite typical unfortunately, the answer
is yes if you stop writing to the fs. But thats not acceptable of
course. A key problem of btrfs raid (also in recent kernels like 4.4)
is that when a (redundant) device goes offline (like pulling SATA
cable or HDD firmware crash) btrfs/kernel does not notice or does not
act correctly upon it under various circumstances. So same as in you
case, the writing to disappeared device seems to continue. For just
the data, this might then still be recoverable, but for the rest of
the structures, it might corrupt the fs heavily.

What should happen is that the btrfs+kernel+fs state switches to
degraded mode and warn about devicefailure so that user can take
action. Or completely automatically start using a spare disk that is
standby but connected. But this spare disk method is currently just
patched in this list, it will take time before they appear in mainline
kernel I assume.

It is possible to reproduce the issue of 1 device of a raid array
disappearing while btrfs/kernel still thinks its there. I hit this
problem myself twice with loop devices, it ruined things, luckily is
was only for some test. btrfs dev scan did not help, unload btrfs mod
or reboot or disconnect all devices in array and then reconnect.
Others have seen this with real USB devices.

A third issue is the SMR drives in raid array.
If you do
smartctl -l scterc /dev/sda

you see that it is not supported. So btrfs/kernel on your linux system
might be misinformed about availability of 1 or more of the drives at
some point in time.

Even with the SMR patch [1] applied, 1 device might take very long to
respond compared to the other 2. The more the fs is used, the higher
the chance that 1 simple write to 1 disk might trigger internal zone
rewrite during which the drive can't accept other tasks (that is at
least how it appears). So how long should btrfs/kernel wait? or assume
device failure?
This is a reason this SMR drive is not recommended in raid
configurations AFAIU. But maybe there is a way to configure timeouts
etc in such a way that it will work. Of course it might also be that
there really is some device failure, pity that the log is not
available. I would change logging in such a way that you can go back
to initial use (months back).



> If you need any more info I'm happy to provide that - here is some
> information about the system:
>
> Linux nashorn 4.4.0-2-generic #16-Ubuntu SMP Thu Jan 28 15:44:21 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs-progs v4.4
>
> Label: 'data'  uuid: ed263a9a-f65c-4bb6-8ee7-0df42b7fbfb8
>         Total devices 3 FS bytes used 10.62TiB
>         devid    1 size 7.28TiB used 5.33TiB path /dev/sda
>         devid    2 size 7.28TiB used 5.33TiB path /dev/sdb
>         devid    3 size 7.28TiB used 5.33TiB path /dev/sdc
>
> Data, RAID5: total=10.64TiB, used=10.61TiB
> System, RAID1: total=40.00MiB, used=928.00KiB
> Metadata, RAID1: total=13.00GiB, used=12.12GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> Thank you!
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=93581
> [2] full dmesg: http://paste.ubuntu.com/14965237/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
