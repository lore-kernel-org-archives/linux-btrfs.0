Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36531 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbcCTBe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 21:34:56 -0400
Received: by mail-io0-f176.google.com with SMTP id 124so24611460iov.3
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 18:34:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-af54e977-779b-4ee5-82a0-5022c97ad5c5-1458430500649@3capp-gmx-bs56>
References: <trinity-af54e977-779b-4ee5-82a0-5022c97ad5c5-1458430500649@3capp-gmx-bs56>
Date: Sat, 19 Mar 2016 19:34:55 -0600
Message-ID: <CAJCQCtRnCVsAnLH9Ty5fT_9gMSPNTprje-qqDbqbEKt_w3CfzQ@mail.gmail.com>
Subject: Re: unable to mount btrfs partition, please help :(
From: Chris Murphy <lists@colorremedies.com>
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 19, 2016 at 5:35 PM, Patrick Tschackert <Killing-Time@gmx.de> wrote:
> Hi Chris,
>
> thank you for answering so quickly!
>
>> Try 'btrfs check' without any options first.
> $ btrfs check /dev/mapper/storage
> checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
> checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
> bytenr mismatch, want=36340960788480, have=4530277753793296986
> Couldn't read chunk tree
> Couldn't open file system
>
>> To me it seems the problem is instigated by lower layers either not
>> completing critical writes at the time of the power failure, or didn't
>> rebuild correctly.
>
> There wasn't a power failure, a VM crashed whilst writing to the btrfs filesys.

OK I went back and read this again: host is managing the md raid5, the
guest is writing Btrfs to an "encrypted container" but what is that? A
LUKS encrypted LVM LV that's directly used by Virtual Box as a raw
device? It's hard to say what layer broke this. But the VM crashing is
in effect like a power failure, and it's an open question (for me) how
this setup deals with barriers. A shutdown -r now should still cleanly
stop the array so I wouldn't expect there to be an array problem but
then you also report a device failure. Bad luck.

I think in retrospect the safe way to do these kinds of Virtual Box
updates, which require kernel module updates, would have been to
shutdown the VM and stop the array. *shrug*


>
>> You should check the SCT ERC setting on each drive with 'smartctl -l
>> scterc /dev/sdX' and also the kernel command timer setting with 'cat
>> /sys/block/sdX/device/timeout' also for each device. The SCT ERC value
>> must be less than the command timer. It's a common misconfiguration
>> with raid setups.
>
> $ smartctl -l scterc /dev/sda (sdb, sdc, sde, sdg)
> gives me
>
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.16.0-4-amd64] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control command not supported

These drives are technically not suitable for use in any kind of raid
except linear and raid 0 (which have no redundancy so they aren't
really raid). You'd have to dig up drive specs, assuming they're
published, to see what the recovery times are for the drive models
when a bad sector is encountered. But it's typical for such drives to
exceed 30 seconds for recovery, with some drives reported to have 2+
minute recoveries. To properly configure them, you'll have to increase
the kernel's SCSI comment timer to at least 120 to make sure there's
sufficient time to wait for the drive to explicitly spit back a read
error to the kernel. Otherwise, the kernel gives up after 30 seconds,
and resets the link to the drive, and any possibility of fixing up the
bad sector via the raid read error fixup mechanism is thwarted. It's
really common, the linux-raid@ list has many of these kinds of threads
with this misconfiguration as the source problem.




>
> while
> $ smartctl -l scterc /dev/sdf (sdh, sdi, sdj, sdk)
> gives me
>
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.16.0-4-amd64] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)

These drives are suitable for raid out of the box.


>
> $ cat /sys/block/sdX/device/timeout
> gives me "30" for every device
>
> Does that mean my settings for the device timeouts are wrong?

For the first listing of drives yes. And 120 second delays might be
too long for your use case, but that's the reality.

You should change the command timer for the drives that do not support
configurable SCT ERC. And then do a scrub check. And then check both
cat /sys/block/mdX/md/mismatch_cnt, which ideally should be 0, and
also check kernel messages for libata read errors.


>
>> After that's fixed you should do a scrub, and I'm thinking it's best
>> to do only a check, which means 'echo check >
>> /sys/block/mdX/md/sync_action' rather than issuing repair which
>> assumes data strips are correct and parity strips are wrong and
>> rebuilds all parity strips.
>
> I don't quite understand, I thought a scrub could only be done on a mounted filesys?

You have two scrubs. There's a Btrfs scrub. And an md scrub. I'm
referring to the latter.


> Do you reall mean executing the command "echo check > /sys/block/md0/md/sync_action"? At the moment it says "idle" in that file.
> Also, the btrfs filesys sits in an encrypted container, so the setup looks like this:
>
> /dev/md0 (this is the Raid device)
> /dev/mapper/storage (after cryptsetup luksOpen, this is where filesys should be mounted from)
> /media/storage (i always mounted the filesystem into this folder by executing "mount /dev/mapper/storage /media/storage")
>
> Apologies if I didn't make that clear enough in my initial email

Ok so the host is writing Btrfs to /dev/mapper/storage? I guess now I
don't understand what the relevance is of Virtual Box and that crash.
Is it writing VDI files onto the host mounted Btrfs?


>
>
>>> $ uname -a
>>> Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
>>> (2016-02-29) x86_64 GNU/Linux
>>This is old. You should upgrade to something newer, ideally 4.5 but
>>4.4.6 is good also, and then oldest I'd suggest is 4.1.20.
>
> Shouldn't I be able to get the newest kernel by executing "apt-get update && apt-get dist-upgrade"?
> That's what I ran just now, and it doesn't install a newer kernel. Do I really have to manually upgrade to a newer one?

I'm not sure. You might do a list search for debian, as I know debian
users are using newer kernels that they didn't build themselves.


> On top of the sticky situation i'm already in, i'm not sure if I trust myself manually building a new kernel. Should I?



>
>> What do you get for
>> btrfs-find-root /dev/mdX
>> btrfs-show-super -fa /dev/mdX
>
> $ btrfs-find-root /dev/mapper/storage
> Couldn't read chunk tree
> Open ctree failed

Hmm not good. See this similar thread.

http://www.spinics.net/lists/linux-btrfs/msg51711.html




> generation              1322969
> root                    24022309593088
> chunk_root_generation   1275381
> chunk_root              36340959809536

backups in all superblocks have the same chunk_root, no alternative
chunk root to try.

So at the moment I think it's worth trying a newer kernel version and
mounting normally; then mounting with -o recovery; then - recovery,ro.

If that doesn't work, you're best off waiting for a developer to give
advice on the next step;  'btrfs rescue chunk-recover' seems most
appropriate but again someone else a while back had success with
zero-log, but it's hard to say if the two cases are really similar and
maybe that person just got lucky. Both of those change the file system
in irreversible ways, that's why I suggest waiting or asking on IRC.


-- 
Chris Murphy
