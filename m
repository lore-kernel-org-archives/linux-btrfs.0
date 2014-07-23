Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53983 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaGWLNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 07:13:33 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Date: Wed, 23 Jul 2014 13:13:13 +0200
Message-ID: <3409219.Io5zg3Bq1f@merkaba>
In-Reply-To: <53CED469.5040700@fb.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <5008370.djvLzDh1Vh@merkaba> <53CED469.5040700@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 22. Juli 2014, 17:15:21 schrieb Chris Mason:
> On 07/22/2014 05:13 PM, Martin Steigerwald wrote:
> > Am Dienstag, 22. Juli 2014, 10:53:03 schrieb Chris Mason:
> >> On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
> >>>> Running 3.15.6 with this patch applied on top:
> >>>>  - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/
> >>>>  /home/nyx/`
> >>>> 
> >>>> - no extra error messages printed (`dmesg | grep racing`) compared to
> >>>> without the patch
> >>> 
> >>> I got same results with 3.16-rc5 + this patch (see thread BTRFS hang
> >>> with
> >>> 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
> >>> 
> >>>> To recap some details (so I can have it all in one place):
> >>>>  - /home/ is btrfs with compress=lzo
> >>> 
> >>> BTRFS RAID 1 with lzo.
> >>> 
> >>>>  - I have _not_ created any nodatacow files.
> >>> 
> >>> Me neither.
> >>> 
> >>>>  - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
> >>>> 
> >>>> mentioning the use of dmcrypt)
> >>> 
> >>> Same, except no dmcrypt.
> >> 
> >> Thanks for the help in tracking this down everyone.  We'll get there!
> >> Are you all running multi-disk systems (from a btrfs POV, more than one
> >> device?)  I don't care how many physical drives this maps to, just does
> >> btrfs think there's more than one drive.
> > 
> > As I told before I am using BTRFS RAID 1. Two logival volumes on two
> > distinct SSDs. RAID is directly in BTRFS, no SoftRAID here (which I
> > wouldn´t want to use with SSDs anyway).
> 
> When you say logical volumes, you mean LVM right?  Just making sure I
> know all the pieces involved.

Exactly.

As a recap from the other thread:

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
leafsize 16384, UUID=[…], 
132303151104/343597383680 bytes used, 2 devices


And LVM layout:

merkaba:~> lsblk
NAME                    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                       8:0    0 279,5G  0 disk 
├─sda1                    8:1    0     4M  0 part 
├─sda2                    8:2    0   191M  0 part 
├─sda3                    8:3    0   286M  0 part 
└─sda4                    8:4    0   279G  0 part 
  ├─sata-home (dm-3)    254:3    0   160G  0 lvm  
  ├─sata-swap (dm-4)    254:4    0    12G  0 lvm  [SWAP]
  └─sata-debian (dm-5)  254:5    0    30G  0 lvm  
sdb                       8:16   0 447,1G  0 disk 
├─sdb1                    8:17   0   200M  0 part 
├─sdb2                    8:18   0   300M  0 part /boot
└─sdb3                    8:19   0 446,7G  0 part 
  ├─msata-home (dm-0)   254:0    0   160G  0 lvm  
  ├─msata-daten (dm-1)  254:1    0   200G  0 lvm  
  └─msata-debian (dm-2) 254:2    0    30G  0 lvm  
sr0                      11:0    1  1024M  0 rom 

sda is Intel SSD 320 SATA

sdb is Crucial m500 mSATA

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
