Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34660 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbcGFBZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2016 21:25:14 -0400
Received: by mail-vk0-f43.google.com with SMTP id t66so3792259vka.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2016 18:25:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0EBF76CB-A350-4108-91EF-076A73932061@gmail.com>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com>
 <CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com>
 <EDF51D2D-A311-47DF-BFF7-F5C855B9E96D@gmail.com> <CAPmG0jaUz1JeRiu_cAqQXM-mAhBcTLKrmxfTu=OqcrHLBRLA+A@mail.gmail.com>
 <0EBF76CB-A350-4108-91EF-076A73932061@gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Wed, 6 Jul 2016 03:25:12 +0200
Message-ID: <CAPmG0jaUeisyZD6eApjaf=e3OdTaCWFDCoT_8Msc1HUadyNWug@mail.gmail.com>
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 2:32 AM, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
> On 6 Jul 2016, at 00:30, Henk Slager <eye1tm@gmail.com> wrote:
>
> On Mon, Jul 4, 2016 at 11:28 PM, Tomasz Kusmierz <tom.kusmierz@gmail.com>
> wrote:
>
> I did consider that, but:
> - some files were NOT accessed by anything with 100% certainty (well if
> there is a rootkit on my system or something in that shape than maybe yes)
> - the only application that could access those files is totem (well
> Nautilius checks extension -> directs it to totem) so in that case we would
> hear about out break of totem killing people files.
> - if it was a kernel bug then other large files would be affected.
>
> Maybe I’m wrong and it’s actually related to the fact that all those files
> are located in single location on file system (single folder) that might
> have a historical bug in some structure somewhere ?
>
>
> I find it hard to imagine that this has something to do with the
> folderstructure, unless maybe the folder is a subvolume with
> non-default attributes or so. How the files in that folder are created
> (at full disktransferspeed or during a day or even a week) might give
> some hint. You could run filefrag and see if that rings a bell.
>
> files that are 4096 show:
> 1 extent found

I actually meant filefrag for the files that are not (yet) truncated
to 4k. For example for virtual machine imagefiles (CoW), one could see
an MBR write.

> I did forgot to add that file system was created a long time ago and it was
> created with leaf & node size = 16k.
>
>
> If this long time ago is >2 years then you have likely specifically
> set node size = 16k, otherwise with older tools it would have been 4K.
>
> You are right I used -l 16K -n 16K
>
> Have you created it as raid10 or has it undergone profile conversions?
>
> Due to lack of spare disks
> (it may sound odd for some but spending for more than 6 disks for home use
> seems like an overkill)
> and due to last I’ve had I had to migrate all data to new file system.
> This played that way that I’ve:
> 1. from original FS I’ve removed 2 disks
> 2. Created RAID1 on those 2 disks,
> 3. shifted 2TB
> 4. removed 2 disks from source FS and adde those to destination FS
> 5 shifted 2 further TB
> 6 destroyed original FS and adde 2 disks to destination FS
> 7 converted destination FS to RAID10
>
> FYI, when I convert to raid 10 I use:
> btrfs balance start -mconvert=raid10 -dconvert=raid10 -sconvert=raid10 -f
> /path/to/FS
>
> this filesystem has 5 sub volumes. Files affected are located in separate
> folder within a “victim folder” that is within a one sub volume.
>
>
> It could also be that the ondisk format is somewhat corrupted (btrfs
> check should find that ) and that that causes the issue.
>
>
> root@noname_server:/mnt# btrfs check /dev/sdg1
> Checking filesystem on /dev/sdg1
> UUID: d4cd1d5f-92c4-4b0f-8d45-1b378eff92a1
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 4424060642634 bytes used err is 0
> total csum bytes: 4315954936
> total tree bytes: 4522786816
> total fs tree bytes: 61702144
> total extent tree bytes: 41402368
> btree space waste bytes: 72430813
> file data blocks allocated: 4475917217792
>  referenced 4420407603200
>
> No luck there :/

Indeed looks all normal.

> In-lining on raid10 has caused me some trouble (I had 4k nodes) over
> time, it has happened over a year ago with kernels recent at that
> time, but the fs was converted from raid5
>
> Could you please elaborate on that ? you also ended up with files that got
> truncated to 4096 bytes ?

I did not have truncated to 4k files, but your case lets me think of
small files inlining. Default max_inline mount option is 8k and that
means that 0 to ~3k files end up in metadata. I had size corruptions
for several of those small sized files that were updated quite
frequent, also within commit time AFAIK. Btrfs check lists this as
errors 400, although fs operation is not disturbed. I don't know what
happens if those small files are being updated/rewritten and are just
below or just above the max_inline limit.

The only thing I was thinking of is that your files were started as
small, so inline, then extended to multi-GB. In the past, there were
'bad extent/chunk type' issues and it was suggested that the fs would
have been an ext4-converted one (which had non-compliant mixed
metadata and data) but for most it was not the case. So there was/is
something unclear, but full balance or so fixed it as far as I
remember. But it is guessing, I do not have any failure cases like the
one you see.

> You might want to run the python scrips from here:
> https://github.com/knorrie/python-btrfs
>
> Will do.
>
> so that maybe you see how block-groups/chunks are filled etc.
>
> (ps. this email client on OS X is driving me up the wall … have to correct
> the corrections all the time :/)
>
> On 4 Jul 2016, at 22:13, Henk Slager <eye1tm@gmail.com> wrote:
>
> On Sun, Jul 3, 2016 at 1:36 AM, Tomasz Kusmierz <tom.kusmierz@gmail.com>
> wrote:
>
> Hi,
>
> My setup is that I use one file system for / and /home (on SSD) and a
> larger raid 10 for /mnt/share (6 x 2TB).
>
> Today I've discovered that 14 of files that are supposed to be over
> 2GB are in fact just 4096 bytes. I've checked the content of those 4KB
> and it seems that it does contain information that were at the
> beginnings of the files.
>
> I've experienced this problem in the past (3 - 4 years ago ?) but
> attributed it to different problem that I've spoke with you guys here
> about (corruption due to non ECC ram). At that time I did deleted
> files affected (56) and similar problem was discovered a year but not
> more than 2 years ago and I believe I've deleted the files.
>
> I periodically (once a month) run a scrub on my system to eliminate
> any errors sneaking in. I believe I did a balance a half a year ago ?
> to reclaim space after I deleted a large database.
>
> root@noname_server:/mnt/share# btrfs fi show
> Label: none  uuid: 060c2345-5d2f-4965-b0a2-47ed2d1a5ba2
>   Total devices 1 FS bytes used 177.19GiB
>   devid    3 size 899.22GiB used 360.06GiB path /dev/sde2
>
> Label: none  uuid: d4cd1d5f-92c4-4b0f-8d45-1b378eff92a1
>   Total devices 6 FS bytes used 4.02TiB
>   devid    1 size 1.82TiB used 1.34TiB path /dev/sdg1
>   devid    2 size 1.82TiB used 1.34TiB path /dev/sdh1
>   devid    3 size 1.82TiB used 1.34TiB path /dev/sdi1
>   devid    4 size 1.82TiB used 1.34TiB path /dev/sdb1
>   devid    5 size 1.82TiB used 1.34TiB path /dev/sda1
>   devid    6 size 1.82TiB used 1.34TiB path /dev/sdf1
>
> root@noname_server:/mnt/share# uname -a
> Linux noname_server 4.4.0-28-generic #47-Ubuntu SMP Fri Jun 24
> 10:09:13 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> root@noname_server:/mnt/share# btrfs --version
> btrfs-progs v4.4
> root@noname_server:/mnt/share#
>
>
> Problem is that stuff on this filesystem moves so slowly that it's
> hard to remember historical events ... it's like AWS glacier. What I
> can state with 100% certainty is that:
> - files that are affected are 2GB and over (safe to assume 4GB and over)
> - files affected were just read (and some not even read) never written
> after putting into storage
> - In the past I've assumed that files affected are due to size, but I
> have quite few ISO files some backups of virtual machines ... no
> problems there - seems like problem originates in one folder & size >
> 2GB & extension .mkv
>
>
> In case some application is the root cause of the issue, I would say
> try to keep some ro snapshots done by a tool like snapper for example,
> but maybe you do that already. It sounds also like this is some kernel
> bug, snaphots won't help that much then I think.
>
>
>
