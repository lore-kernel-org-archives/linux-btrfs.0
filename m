Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail2.aei.mpg.de ([194.94.224.8]:54722 "EHLO umail2.aei.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750765AbdAaVac (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 16:30:32 -0500
Received: from mailgate.aei.mpg.de (mailgate.aei.mpg.de [194.94.224.5])
        by umail2.aei.mpg.de (Postfix) with ESMTP id 332571BA624E
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 22:30:30 +0100 (CET)
Received: from mailgate.aei.mpg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 258DD406ADE
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 22:30:30 +0100 (CET)
Received: from intranet.aei.uni-hannover.de (ahin1.aei.uni-hannover.de [130.75.117.40])
        by mailgate.aei.mpg.de (Postfix) with ESMTP id 9166A406ADB
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 22:30:28 +0100 (CET)
Subject: Re: btrfs recovery - solved for me
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
 <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
 <CAP8EXU310iKo-exrYk3Hm4tyUQSL+KYEYEV4h8zifiwxmse7uA@mail.gmail.com>
 <161bffef-9bc8-e5da-476b-d214e2a7d69b@aei.mpg.de>
 <CAP8EXU3-hrRSVmBzgB_ACtzxCegzvijX9oU=ZgZ_ekcO6C2-DA@mail.gmail.com>
 <CAKuJGC_rstHxszJGXgUv0tho__roN0Ro-Z1myVsa-bghCORE+w@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Michael Born <Michael.Born@aei.mpg.de>
Message-ID: <d7044d6d-1468-3476-5de6-263f26bc0577@aei.mpg.de>
Date: Tue, 31 Jan 2017 22:30:27 +0100
MIME-Version: 1.0
In-Reply-To: <CAKuJGC_rstHxszJGXgUv0tho__roN0Ro-Z1myVsa-bghCORE+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you all for your help.

Magically, btrfs-find-root worked today. (I attached the steps at the end)
I don't think I changed anything. The btrfs-progs version is still 4.1
because I tried different tagged versions (starting from 4.9) from the
cloned git repo.

The btrfs-find-root on the working / of my computer (Intel 3750K@4.2GHz
on a Samsung 850EVO) took several seconds.
btrfs-find-root on the 60GB dd-image (on the same computer on a 960EVO
ssd) loop device took 6 minutes until it stared asking me "do you want
to keep going on ? (y/N/a): We seem to be looping a lot on..." questions.
I answered them with yes. The command was finished then 1 minute later.
- just for a reference, if somebody wonders, how many days one has to wait.

Strangely, the second run of btrfs-find-root finished differently. The
first run did not mention the snapshots.
This also confirms my suspicion, that the tool is working far from
perfectly.

It's absolutely clear that I came here because of my stupidity (making a
dd backup of my live btrfs root partition), but it really frightens me
how quickly (2 days reading/trying wiki/blog/mailing list solutions) I
came to the point of having to grep text files by its contents from my
image.dd.
I don't run database computer center, so I'm not relying on the nice
btrfs features. But, for my next clean installation I will rather use
ext4 just because there are tons of forensic/recovery tools available
for the worst case.
Thank you again for your quick and helpful answers.

Cheers,
Michael

PS: I now just took the NetworkManager settings to not have to enter all
Wifi details when traveling. So, it was really mostly an exercise.


linux-2bf5:/home/michael # losetup -f
/dev/loop0
linux-2bf5:/home/michael # losetup /dev/loop0 ./20170126_sda2root.dd


linux-2bf5:/home/michael # btrfs fi show
Label: none  uuid: 779e9c04-be4b-4a45-9fc2-000acca5549d
        Total devices 1 FS bytes used 19.02GiB
        devid    1 size 118.16GiB used 25.03GiB path /dev/sda4

Label: none  uuid: 91a79eeb-08e0-470e-beab-916b38e09aca
        Total devices 1 FS bytes used 44.22GiB
        devid    1 size 60.00GiB used 60.00GiB path /dev/loop0

linux-2bf5:/home/michael #


linux-2bf5:/home/michael/btrfs-progs # ./btrfs fi show
Label: none  uuid: 779e9c04-be4b-4a45-9fc2-000acca5549d
        Total devices 1 FS bytes used 19.02GiB
        devid    1 size 118.16GiB used 25.03GiB path /dev/sda4

Label: none  uuid: 91a79eeb-08e0-470e-beab-916b38e09aca
        Total devices 1 FS bytes used 44.22GiB
        devid    1 size 60.00GiB used 60.00GiB path /dev/loop0

btrfs-progs v4.1
linux-2bf5:/home/michael/btrfs-progs # ./btrfs-find-root /dev/sda4
Superblock thinks the generation is 14210
Superblock thinks the level is 1
Found tree root at 12232638464 gen 14210 level 1
Well block 12173475840(gen: 14209 level: 1) seems good, but
generation/level doesn't match, want gen: 14210 level: 1
Well block 12081152000(gen: 14198 level: 1) seems good, but
generation/level doesn't match, want gen: 14210 level: 1
linux-2bf5:/home/michael/btrfs-progs # ./btrfs-find-root /dev/loop0
Couldn't read tree root
Superblock thinks the generation is 549995
Superblock thinks the level is 1
Well block 32794263552(gen: 550001 level: 1) seems good, but
generation/level doesn't match, want gen: 549995 level: 1
linux-2bf5:/home/michael/btrfs-progs #



linux-2bf5:/home/michael/btrfs-progs # ./btrfs restore -t 32794263552
/dev/loop0 /home/michael/btrfs/
parent transid verify failed on 32794263552 wanted 549995 found 550001
parent transid verify failed on 32794263552 wanted 549995 found 550001
Ignoring transid failure
We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.4, do you want to keep going
on ? (y/N/a): y
We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.3, do you want to keep going
on ? (y/N/a): We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.2, do you want to keep going
on ? (y/N/a): y
We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.1, do you want to keep going
on ? (y/N/a): We seem to be looping a lot on
/home/michael/btrfs/var/tmp/kdecache-miborn/plasma_theme_openSUSElight_v0.5.kcache,
do you want to keep going on ? (y/N/a): y
Error writing: 28 No space left on device
Error copying data for /home/michael/btrfs/var/cache/cups/ppds.dat
Error searching /home/michael/btrfs/var/cache/cups/ppds.dat
Error searching /home/michael/btrfs/var/cache/cups/ppds.dat
Error searching /home/michael/btrfs/var/cache/cups/ppds.dat
We seem to be looping a lot on
/home/michael/btrfs/var/tmp/kdecache-miborn/plasma_theme_openSUSElight_v0.5.kcache,
do you want to keep going on ? (y/N/a):
linux-2bf5:/home/michael/btrfs-progs #


linux-2bf5:/home/michael/btrfs-progs # ./btrfs restore -t 32794263552
/dev/loop0 /home/michael/btrfs/
parent transid verify failed on 32794263552 wanted 549995 found 550001
parent transid verify failed on 32794263552 wanted 549995 found 550001
Ignoring transid failure
We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.4, do you want to keep going
on ? (y/N/a): y
We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.3, do you want to keep going
on ? (y/N/a): We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.2, do you want to keep going
on ? (y/N/a): y
We seem to be looping a lot on
/home/michael/btrfs/var/log/audit/audit.log.1, do you want to keep going
on ? (y/N/a): We seem to be looping a lot on
/home/michael/btrfs/var/tmp/kdecache-miborn/plasma_theme_openSUSElight_v0.5.kcache,
do you want to keep going on ? (y/N/a): y
We seem to be looping a lot on
/home/michael/btrfs/var/tmp/kdecache-miborn/plasma_theme_openSUSElight_v0.5.kcache,
do you want to keep going on ? (y/N/a): Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
Skipping snapshot snapshot
linux-2bf5:/home/michael/btrfs-progs #




Am 31.01.2017 um 03:30 schrieb Lakshmipathi.G:
>>
>> Does someone on the list know if ext3/4 data recovery tools can also
>> search btrfs data?  That's another option.
>>
>> Gordon
>>
> ext3/4 (or other) data recovery tools can help, if they have generic
> file search mode not tied to specific file systems.
> Have a look at ext4magic
> http://ext4magic.sourceforge.net/ext4magic_en.html  - It said to have
> file carving option. Though I'm not sure whether it accepts non-ext file
> system.
> 
> And there is https://github.com/Lakshmipathi/extcarve (supports
> different FS) but I never updated it in years, so skeptical about it. I
> guess this https://github.com/sleuthkit/sleuthkit may be your best bet.
> 
> If want to take recovery tool route - remember to backup original dd
> image file.
> ----
> Cheers,
> Lakshmipathi.G

