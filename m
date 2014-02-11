Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:39818 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaBKDPa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 22:15:30 -0500
Received: by mail-bk0-f50.google.com with SMTP id w16so2068551bkz.37
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 19:15:29 -0800 (PST)
Received: from system (e180211082.adsl.alicedsl.de. [85.180.211.82])
        by mx.google.com with ESMTPSA id f11sm14003969bkj.6.2014.02.10.19.15.28
        for <linux-btrfs@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Mon, 10 Feb 2014 19:15:28 -0800 (PST)
Date: Tue, 11 Feb 2014 04:15:27 +0100
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Message-ID: <20140211041527.57ef96c4@system>
In-Reply-To: <191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello !

On Mon, 10 Feb 2014 19:18:22 -0700, Chris Murphy
<lists@colorremedies.com> wrote :

> 
> On Feb 9, 2014, at 2:40 PM, Saint Germain <saintger@gmail.com> wrote:
> > 
> > Then I added another drive for a RAID1 configuration (with btrfs
> > balance) and I installed grub on the second hard drive with
> > "grub-install /dev/sdb".
> 
> That can't work on UEFI. UEFI firmware effectively requires a GPT
> partition map and something to serve as an EFI System partition on
> all bootable drives.
> 
> Second there's a difference between UEFI with and without secure boot.
> 
> With secure boot you need to copy the files your distro installer
> puts on the target drive EFI System partition to each addition
> drive's ESP if you want multibooting to work in case of disk failure.
> The grub on each ESP likely looks on only its own ESP for a grub.cfg.
> So that then means having to sync grub.cfg's among each disk used for
> booting. A way around this is to create a single grub.cfg that merely
> forwards to the "true" grub.cfg. And you can copy this forward-only
> grub.cfg to each ESP. That way the ESP's never need updating or
> syncing again.
> 
> Without secure boot, you must umount /boot/efi and mount the ESP for
> each bootable disk is turn, and then merely run:
> 
> grub-install
> 
> That will cause a core.img to be created for that particular ESP, and
> it will point to the usual grub.cfg location at /boot/grub.
> 

Ok I need to really understand how my motherboard works (new Z87E-ITX).
It is written "64Mb AMI UEFI Legal BIOS", so I thought it was really
UEFI.

> 
> > 
> > If I boot on sdb, it takes sda1 as the root filesystem
> > If I switched the cable, it always take the first hard drive as the
> > root filesystem (now sdb)
> > If I disconnect /dev/sda, the system doesn't boot with a message
> > saying that it hasn't found the UUID:
> > 
> > Scanning for BTRFS filesystems...
> > mount:
> > mounting /dev/disk/by-uuid/c64fca2a-5700-4cca-abac-3a61f2f7486c
> > on /root failed: Invalid argument
> 
> Well if /dev/sda is missing, and you have an unpartitioned /dev/sdb I
> don't even know how you're getting this far, and it seems like the
> UEFI computer might actually be booting in CSM-BIOS mode which
> presents a conventional BIOS to the operating system. Disintguishing
> such things gets messy quickly.
> 

/dev/sdb has the same partition as /dev/sda.
Duncan gave me the hint with degraded mode and I managed to boot
(however I had some problem with mounting sda2).

> > 
> > Can you tell me what I have done incorrectly ?
> > Is it because of UEFI ? If yes I haven't understood how I can
> > correct it in a simple way.
> > 
> > As extra question, I don't see also how I can configure the system
> > to get the correct swap in case of disk failure. Should I force
> > both swap partition to have the same UUID ?
> 
> If you're really expecting to create a system that can accept a disk
> failure and continue to work, I don't see how it can depend on swap
> partitions. It's fine to create them, but just realize if they're
> actually being used and the underlying physical device dies, the
> kernel isn't going to like it.
> 
> A possible work around is using an md raid1 partition as swap.
> 

I understand. Normally the swap will only be used for hibernating. I
don't expect to use it except perhaps in some extreme case.

Thanks for your help !
