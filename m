Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46690 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaDFPSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 11:18:00 -0400
Received: from merkaba.localnet (ppp-62-216-209-145.dynamic.mnet-online.de [62.216.209.145])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 4DB2ECD
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Apr 2014 17:17:09 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sun, 06 Apr 2014 17:17:57 +0200
Message-ID: <2460868.gOBF3IKSYk@merkaba>
In-Reply-To: <pan$1013e$ed20a34e$87a63f12$3c7b6f9f@cox.net>
References: <2692878.dRG1K49eOP@fnix> <3745993.asvTJRMXlK@vfr> <pan$1013e$ed20a34e$87a63f12$3c7b6f9f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[not cc´ing you as you didn´t cc anyone and I think you do not like to be CC
´d, note that usual on kernel related mailing lists this is a convention, so I 
may miss it at some time. not restoring other cc´s as I am lazy right now]

Am Samstag, 5. April 2014, 15:06:26 schrieb Duncan:
> Garry T. Williams posted on Sat, 05 Apr 2014 10:26:06 -0400 as excerpted:
> > I no longer see the slow degradation over time because I made the
> > 
> > following directories recursively nodatacow:
> >     .local/share/akonadi
> 
> ...snip...
> 
> OK, we now have a second link to akonadi (and browsers) and slowness,
> this one confirmed as nocow helping.  Thanks.  It's on my list to watch
> for and point out when I see it in posts, now.

I use Akonadi and Nepomuk, long time with, now without mail indexing on a Dual 
SSD BTRFS RAID 1 setup in my laptop. I see performance issues with Akonadi but 
as to what I observed none of these where related to storage.

But I observe, that running this setup for a longer time seems to give hefty 
free space fragmentation, visible by increased fstrim times:

/home: 54407880704 bytes were trimmed
fstrim -v /home  0,00s user 12,25s system 25% cpu 48,062 total

This has almost been instant before.

And this is still good. I redid /home as downsizing the old BTRFS let the 
kernel hang repeatedly. On the old setup, I had a time of several minutes.

On redoing /home I was lazy, and made it single first and converted it to raid1 
for data and metadata. This may have some performance impact, cause last time 
I balanced a BTRFS filesystem the boot time doubled.

That said /home appears to be fast enough for me.

Current setup:

merkaba:~> cat /proc/version
Linux version 3.14.0-tp520 (martin@merkaba) (gcc version 4.8.2 (Debian 
4.8.2-17) ) #52 SMP PREEMPT Mon Mar 31 13:41:48 CEST 2014

Waiting for 3.15-rc2 or so :)

merkaba:~> file -Lsk /dev/sata/home
/dev/sata/home: BTRFS Filesystem label "home", sectorsize 4096, nodesize 
16384, leafsize 16384, UUID=[…], 102075097088/322122547200 bytes used, 2 
devices

That bytes used figure doesn´t seem quite right.

merkaba:~> btrfs fi df /home       
Data, RAID1: total=116.00GiB, used=92.91GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, RAID1: total=4.00GiB, used=2.15GiB

merkaba:~> btrfs fi show
[…]
Label: home  uuid: […]
        Total devices 2 FS bytes used 95.06GiB
        devid    1 size 150.00GiB used 120.00GiB path /dev/dm-0
        devid    2 size 150.00GiB used 120.00GiB path /dev/mapper/sata-home
[…]

merkaba:~> grep /home /proc/mounts
/dev/dm-0 /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
/dev/dm-0 /mnt/home-zeit btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0


I am unsure about the compress=lzo option. The 300 GB Intel SSD 320 (SATA) 
does not compress, but I bet the 480 GB Crucial m500 (mSATA) does. 

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
