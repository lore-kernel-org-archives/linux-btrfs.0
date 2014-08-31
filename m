Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36577 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHaKe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 06:34:29 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.17: Yay! New sizes in df -h
Date: Sun, 31 Aug 2014 12:34:27 +0200
Message-ID: <2090485.596Ci4qveW@merkaba>
In-Reply-To: <B16D2447-74E8-44CD-BC56-BB3AA7E8A99C@colorremedies.com>
References: <1940832.0FjNKhTY79@merkaba> <B16D2447-74E8-44CD-BC56-BB3AA7E8A99C@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 27. August 2014, 10:54:56 schrieb Chris Murphy:
> On Aug 27, 2014, at 5:45 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Hi!
> > 
> > Now I get this with 3.17-rc2:
> > 
> > merkaba:~> LANG=C df -hT / /home
> > Filesystem     Type   Size  Used Avail Use% Mounted on
> > /dev/dm-5      btrfs   30G   17G   23G  43% /
> > /dev/dm-0      btrfs  160G  129G   59G  69% /home
> > 
> > 
> > /: 17+23 = 40 GiB, compressed 10 GiB away with lzo?
> > /home: 59+129 = 188 GiB, compressed 28 GiB away with lzo?
> > 
> > 
> > This is BTRFS RAID 1 on Dual SSD:
> > 
> > merkaba:~> btrfs fi df /
> > Data, RAID1: total=25.00GiB, used=15.33GiB
> > System, RAID1: total=8.00MiB, used=16.00KiB
> > Metadata, RAID1: total=2.00GiB, used=677.33MiB
> > unknown, single: total=240.00MiB, used=0.00
> > 
> > merkaba:~> btrfs fi df /home
> > Data, RAID1: total=154.97GiB, used=125.70GiB
> > System, RAID1: total=32.00MiB, used=48.00KiB
> > Metadata, RAID1: total=5.00GiB, used=2.71GiB
> > unknown, single: total=512.00MiB, used=0.00
> 
> Hmm, I'm not seeing such a large discrepancy between Used+Avail and Size.

I see.

Well the /home has a large maildir and lots of git checkouts with highly 
compressible text files.

My data directory for larger files which is only on the mSATA SSD doesn´t
have this discrepancy:

merkaba:~> LANG=C df -hT /daten
Filesystem              Type   Size  Used Avail Use% Mounted on
/dev/mapper/msata-daten btrfs  200G  183G   17G  92% /daten

merkaba:~> btrfs fi df /daten 
Data, single: total=187.01GiB, used=182.05GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=1.01GiB, used=288.09MiB
unknown, single: total=112.00MiB, used=0.00


I also use compress=lzo on it, although it I wonder whether its necessary as I 
think the Crucial m500 mSATA SSD firmware compresses itself while the Intel
SSD 320 SATA SSD firmware does not. But still even with compression in the
firmware, it BTRFS compresses I can use more of the capacity. I wonder
whether this can harm the reliability of the SSD, if its firmware relies on
at least partly compressible data.


> No compression, all volumes populated with send/receive and contain same
> data.

Well I wouldn´t expect to see discrepancies without compressed data. But on 
the other hand I did not dig into how the new calculation actually works so 
far.
 
> 3.16.1
> # df -h
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/sdb                  40G  2.8G   37G   7% /home        # single 40GB
> device /dev/sdc                  40G  5.5G   33G  15% /mnt	    # two 20GB
> devices, raid1
> 
> Reboot 3.17.0rc2
> # df -h
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/sdb                  40G  2.8G   37G   7% /home        # single 40GB
> device /dev/sdc                  20G  2.8G   17G  15% /mnt	    # two 20GB
> devices, raid1
> 
> ======
> sde is two 20GB devices, raid1, -o compress, populated the same as above w/
> send/receive
> 
> 3.16.1
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/sde                  40G  3.8G   35G  10% /mnt
> 
> 3.17.0rc2
> Filesystem               Size  Used Avail Use% Mounted on
> /dev/sde                  20G  2.0G   18G  10% /mnt
> 
> 
> In the last example, Used went from 2.8G to 2.0G due to compression. But
> with or without compression, Used+Avail=Size.

Hmmm, I see. Then it might not be compression at all what explains the 
differences I see?

Any other explainations?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
