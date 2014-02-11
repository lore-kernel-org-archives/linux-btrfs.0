Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54002 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752133AbaBKCSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 21:18:24 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49431 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WD2vX-001CmL-2u
	for linux-btrfs@vger.kernel.org; Mon, 10 Feb 2014 19:18:23 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140209224055.3175e70f@system>
Date: Mon, 10 Feb 2014 19:18:22 -0700
Message-Id: <191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
References: <20140209224055.3175e70f@system>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 9, 2014, at 2:40 PM, Saint Germain <saintger@gmail.com> wrote:
> 
> Then I added another drive for a RAID1 configuration (with btrfs
> balance) and I installed grub on the second hard drive with
> "grub-install /dev/sdb".

That can't work on UEFI. UEFI firmware effectively requires a GPT partition map and something to serve as an EFI System partition on all bootable drives.

Second there's a difference between UEFI with and without secure boot.

With secure boot you need to copy the files your distro installer puts on the target drive EFI System partition to each addition drive's ESP if you want multibooting to work in case of disk failure. The grub on each ESP likely looks on only its own ESP for a grub.cfg. So that then means having to sync grub.cfg's among each disk used for booting. A way around this is to create a single grub.cfg that merely forwards to the "true" grub.cfg. And you can copy this forward-only grub.cfg to each ESP. That way the ESP's never need updating or syncing again.

Without secure boot, you must umount /boot/efi and mount the ESP for each bootable disk is turn, and then merely run:

grub-install

That will cause a core.img to be created for that particular ESP, and it will point to the usual grub.cfg location at /boot/grub.



> 
> If I boot on sdb, it takes sda1 as the root filesystem
> If I switched the cable, it always take the first hard drive as the
> root filesystem (now sdb)
> If I disconnect /dev/sda, the system doesn't boot with a message
> saying that it hasn't found the UUID:
> 
> Scanning for BTRFS filesystems...
> mount: mounting /dev/disk/by-uuid/c64fca2a-5700-4cca-abac-3a61f2f7486c on /root failed: Invalid argument

Well if /dev/sda is missing, and you have an unpartitioned /dev/sdb I don't even know how you're getting this far, and it seems like the UEFI computer might actually be booting in CSM-BIOS mode which presents a conventional BIOS to the operating system. Disintguishing such things gets messy quickly.


> 
> Can you tell me what I have done incorrectly ?
> Is it because of UEFI ? If yes I haven't understood how I can correct
> it in a simple way.
> 
> As extra question, I don't see also how I can configure the system to
> get the correct swap in case of disk failure. Should I force both swap partition
> to have the same UUID ?

If you're really expecting to create a system that can accept a disk failure and continue to work, I don't see how it can depend on swap partitions. It's fine to create them, but just realize if they're actually being used and the underlying physical device dies, the kernel isn't going to like it.

A possible work around is using an md raid1 partition as swap.


Chris Murphy