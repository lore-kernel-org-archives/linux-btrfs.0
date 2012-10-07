Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49116 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2JGOsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 10:48:55 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 7 Oct 2012 16:48:53 +0200
Cc: =?utf-8?q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
References: <50714AC8.4010100@petaramesh.org> <201210071259.05801.Martin@lichtvoll.de> <50718C44.2080701@petaramesh.org> (sfid-20121007_163444_636745_E6F75E74)
In-Reply-To: <50718C44.2080701@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210071648.54027.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Swâmi Petaramesh:
> Le 07/10/2012 12:59, Martin Steigerwald a écrit :
> > btrfs fi df (preferably with btrfs tools from Goffredo)
> > btrfs fi show
> 
> I don't think I miss any free space ;-)

Well I could I know this beforehand?

> (From one of my machines, but the others have rather the same
> architecture...)
> 
> # btrfs fi sh
> failed to read /dev/sr0
> Label: 'BTR_POOL'  uuid: 7266e630-ba72-404c-bfbd-759d3a6ce2e3
>     Total devices 1 FS bytes used 278.55GB
>     devid    1 size 912.26GB used 464.04GB path /dev/dm-1

Hmmm. Looks fine for me.

Where is this volume pool located on? On which drive(s)?

> Label: 'BTR_BOOT'  uuid: b280100e-6a9a-4488-a207-d4e3f001b4c9
>     Total devices 1 FS bytes used 504.39MB
>     devid    1 size 1.00GB used 729.50MB path /dev/sda2
> 
> 
> # btrfs fi df /boot
> System: total=4.00MB, used=4.00KB
> Data+Metadata: total=725.50MB, used=504.38MB
> 
> # btrfs fi df /
> Data: total=426.01GB, used=273.00GB
> System, DUP: total=8.00MB, used=56.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=19.00GB, used=5.55GB
> Metadata: total=8.00MB, used=0.00
> 
> # df -h /boot /
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda2       1,1G  505M  517M  50% /boot
> -               913G  285G  602G  33% /
> 
> 
> ...and I have quite a lot of snapshots, as I use OpenSuSE excellent
> "snapper" utility :
[…]
> ...or if you prefer, something like :
> 
> # btrfs su li /
> ID 256 top level 5 path UBUNTU
> ID 259 top level 5 path UBUNTU/@
> ID 261 top level 5 path UBUNTU/@tmp
> ID 262 top level 5 path UBUNTU/@home

This could be 100 or more subvolumes / snapshots.

Maybe slowness could be related to this one.

It would be good to have some capture of this slowness with

vmstat 10

iostat -xd 10 /your/device

or something like that. Especially for the later, cause it shows the count 
of reads and writes.

Also how much RAM has the machine? What does free -m / cat /proc/meminfo 
tell.

Other than that I leave this too BTRFS developers to answer to. I think 
that this has become easier by the data you provided.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
