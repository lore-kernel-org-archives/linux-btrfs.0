Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37883 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AELgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 06:36:42 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, helmut@hullen.de
Subject: Re: Option LABEL
Date: Sat, 5 Jan 2013 12:36:37 +0100
References: <CO8jDv4uCXB@helmut.hullen.de> (sfid-20130104_003022_582023_E9E01C42)
In-Reply-To: <CO8jDv4uCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301051236.37875.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 3. Januar 2013 schrieb Helmut Hullen:
> Hallo, Hugo,

Hi Helmut,

> Du meintest am 03.01.13:
> 
> [...]
> 
> >>> Trying to use filesystem labels to give unique and stable device
> >>> IDs is the wrong tool for the job.
> 
> >> I beg to differ. On my machines it's the simpliest way, and it's a
> >> sure way.
> 
> >    No, because it doesn't *work*. This is not a bug. This is how
> > things have always behaved -- you're relying on an assumption (one FS
> > per device) which simply isn't true any longer.
> 
> No - I don't rely on such an assumption.
> In the special case I'm just working with I want to use the whole disk  
> only for btrfs.
> 
> In other cases I work with partitions, and there is just the same  
> problem: at least "blkid" and "findfs" don't work when more than 1  
> device has the same label (p.e. /dev/sda3 and /dev/sdc5).

Helmut, it has been shown here in the thread, that they *do* work in
newer versions.

If they don´t work for you please compare your version with the ones that
do work and file a bug report for your Linux distribution.

I use labels in fstab as well and since usually especially for the boot
devices no device with same label comes in, it works.

But using labels you have to be aware that there might happen name
clashes. A BTRFS filesystem which is on more than one device, be it
partitition, disk, LV or what not and having the same label for itself on
every device is *no* such name clash, is just working as intended. And
it should work in /etc/fstab, provided that btrfs device scan is run before
you try to mount it.

No matter how much you try *not to understand* that *filesystems* are
labeled here instead of devices, it is still filesystems that are labeled
here. Each one in a different place on the volume(s) it spans somewhere
in its metadata, usually suberblock. Thats why blkid has to support a
filesystem in order to print its label, if it doesn´t support it yet, it
can´t find the label, cause it doesn´t know where the *filesystem* has
stored it.

And here just to show it again to you:

The files of 1 GB:

merkaba:/mnt/zeit> truncate -s 1G btrfs1             
merkaba:/mnt/zeit> truncate -s 1G btrfs2
merkaba:/mnt/zeit> truncate -s 1G btrfs3


The devices for them:

merkaba:/mnt/zeit> losetup /dev/loop0 btrfs1
merkaba:/mnt/zeit> losetup /dev/loop1 btrfs2
merkaba:/mnt/zeit> losetup /dev/loop2 btrfs3


mkfs.btrfs with label:

merkaba:/mnt/zeit> mkfs.btrfs -L schlumpf -d raid1 -m raid1 /dev/loop[0-2]

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

failed to read /dev/sr0
failed to read /dev/sr0
adding device /dev/loop1 id 2
failed to read /dev/sr0
adding device /dev/loop2 id 3
fs created label schlumpf on /dev/loop0
        nodesize 4096 leafsize 4096 sectorsize 4096 size 3.00GB
Btrfs Btrfs v0.19


Label there and fine:

merkaba:/mnt/zeit> blkid | grep schlumpf
/dev/loop0: LABEL="schlumpf" UUID="08802eb0-2040-4b7d-a4eb-81617f492168" UUID_SUB="453b462b-d1cc-4977-865e-f4ab7d1dee2c" TYPE="btrfs" 
/dev/loop1: LABEL="schlumpf" UUID="08802eb0-2040-4b7d-a4eb-81617f492168" UUID_SUB="41c9810e-41fb-4ac4-8010-718790c83b82" TYPE="btrfs" 
/dev/loop2: LABEL="schlumpf" UUID="08802eb0-2040-4b7d-a4eb-81617f492168" UUID_SUB="8b2b091a-ec88-4c0b-80e6-df06f6d629b7" TYPE="btrfs" 

merkaba:/mnt/zeit> findfs LABEL=schlumpf
/dev/loop2


And changing the label:

merkaba:/mnt/zeit> btrfs fi label /dev/loop0 schlumpfine
failed to read /dev/sr0
failed to read /dev/sr0

merkaba:/mnt/zeit> blkid | grep schlumpf                
/dev/loop0: LABEL="schlumpfine" UUID="08802eb0-2040-4b7d-a4eb-81617f492168" UUID_SUB="453b462b-d1cc-4977-865e-f4ab7d1dee2c" TYPE="btrfs" 
/dev/loop1: LABEL="schlumpfine" UUID="08802eb0-2040-4b7d-a4eb-81617f492168" UUID_SUB="41c9810e-41fb-4ac4-8010-718790c83b82" TYPE="btrfs" 
/dev/loop2: LABEL="schlumpfine" UUID="08802eb0-2040-4b7d-a4eb-81617f492168" UUID_SUB="8b2b091a-ec88-4c0b-80e6-df06f6d629b7" TYPE="btrfs" 

merkaba:/mnt/zeit> findfs LABEL=schlumpf                
findfs: unable to resolve 'LABEL=schlumpf'
merkaba:/mnt/zeit#1> findfs LABEL=schlumpfine
/dev/loop2


Thats with:

merkaba:~> cat /proc/version
Linux version 3.8.0-rc2-tp520 (martin@merkaba) (gcc version 4.7.2 (Debian 4.7.2-4) ) #34 SMP PREEMPT Thu Jan 3 15:46:16 CET 2013
merkaba:~> apt-show-versions btrfs-tools
btrfs-tools/sid uptodate 0.19+20121004-1

on Debian/GNU sid.


In any of these do not work for you, upgrade and/or file bug against your 
distribution to provide fixed packages.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
