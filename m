Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48608 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbaGNPKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 11:10:31 -0400
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 818BECB
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 17:10:30 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5
Date: Mon, 14 Jul 2014 17:10:30 +0200
Message-ID: <3226395.MP6iD3ZiSL@merkaba>
In-Reply-To: <1502954.OtX3SzjMKZ@merkaba>
References: <1502954.OtX3SzjMKZ@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> Hi!
> 
> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days of
> usage, with 3-16-rc5 I had a hang again. Less than a hour since booting it.
> 
> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
> didn´t happen that quickly after boot and since backtrace looks a bit
> different from what I have in memory, I post this in a new thread.
> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
> issues.

Probably good to add some basic information on the filesystem:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 123.20GiB
        devid    1 size 160.00GiB used 159.98GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 159.98GiB path /dev/dm-3

Btrfs v3.14.1
merkaba:~#1> btrfs fi df /home
Data, RAID1: total=154.95GiB, used=120.61GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=2.59GiB
unknown, single: total=512.00MiB, used=0.00
merkaba:~> df -hT /home
Dateisystem            Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/mapper/msata-home btrfs  320G    247G   69G   79% /home

merkaba:~> file -sk /dev/sata/home
/dev/sata/home: symbolic link to `../dm-3'
merkaba:~> file -sk /dev/dm-3     
/dev/dm-3: BTRFS Filesystem label "home", sectorsize 4096, nodesize 16384, 
leafsize 16384, UUID=b96c4f72- 523-45ac-a401-f7be73dd624a, 
132303151104/343597383680 bytes used, 2 devices


I think I switched it to skinny extents, but I am not completely sure.


Dual SSD BTRFS RAID 1

No snapshots at the moment. And plenty of space free.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
