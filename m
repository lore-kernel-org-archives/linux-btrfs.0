Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48739 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753387AbaBLRui convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 12:50:38 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when removing drive)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com>
Date: Wed, 12 Feb 2014 10:50:33 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <65B17477-EA31-4423-91A1-2FDB2FCDD95E@colorremedies.com>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com> <E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com> <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com>
To: Saint Germain <saintger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 12, 2014, at 10:13 AM, Saint Germain <saintger@gmail.com> wrote:

> On 11 February 2014 19:15, Chris Murphy <lists@colorremedies.com> wrote:
>>> 
>>> To summarize, I think I have 3 options for partitioning (I am not
>>> considering UEFI secure boot or swap):
>>> 1) grub, BTRFS partition (i.e. full disk in BTRFS), /boot inside BTRFS subvolume
>> 
>> This doesn't seem like a good idea for a boot drive to be without partitions.
>> 
>> 
>>> 2) grub, GPT partition, with (A) on sda1, and a BTRFS partition on
>>> sda2, /boot inside BTRFS subvolume
>>> 3) grub, GPT partition, with (A) on sda1, /boot (ext4) on sda2, and a
>>> BTRFS on sda3
>>> 
>>> (A) = BIOS Boot partition (1 MiB) or EFI System Partition (FAT32, 550MiB)
>>> 
>>> I don't really see the point of having UEFI/ESP if I don't use other
>>> proprietary operating system, so I think I will go with (A) = BIOS
>>> Boot partition except if there is someting I have missed.
>> 
>> You need to boot your system in UEFI and CSM-BIOS modes, and compare the dmesg for each. I'm finding it common the CSM limits power management, and relegates drives to IDE speeds rather than full SATA link speeds. Sometimes it's unavoidable to use the CSM if it has better overall behavior for your use case. I've found it to be lacking and have abandoned it. It's basically intended for booting Windows XP, right?
>> 
> 
> Ok based on your advices, here is what I have done so far to use UEFI
> (remeber that the objective is to have a clean and simple BTRFS RAID1
> install).
> 
> A) I start first with only one drive, I have gone with the following
> partition scheme (Debian wheezy, kernel 3.12, grub 2.00, GPT partition
> with parted):
> sda1 = 1MiB BIOS Boot partition (no FS, "set 1 bios_grub on" with
> parted to set the type)
> sda2 = 550 MiB EFI System Partition (FAT32, "toggle 2 boot" with
> parted to set the type),  mounted on /boot/efi
> sda3 = 1 TiB root partition (BTRFS), mounted on /
> sda4 = 6 GiB swap partition
> (that way I should be able to be compatible with both CSM or UEFI)
> 
> B) normal Debian installation on sdas, activate the CSM on the
> motherboard and reboot.
> 
> C) apt-get install grub-efi-amd64 and grub-install /dev/sda
> 
> And the problems begin:
> 1) grub-install doesn't give any error but using the --debug I can see
> that it is not using EFI.


Expected. If you boot with CSM enabled, you get a BIOS boot.



> 2) Ok I force with grub-install --target=x86_64-efi
> --efi-directory=/boot/efi --bootloader-id=grub --recheck --debug
> /dev/sda
> 3) This time something is generated in /boot/efi: /boot/efi/EFI/grub/grubx64.efi
> 4) Copy the file /boot/efi/EFI/grub/grubx64.efi to
> /boot/efi/EFI/boot/bootx64.efi

I wouldn't expect this grubx64.efi to work because efivars and access to NVRAM simply doesn't exist if you are CSM booted.

> 5) Reboot and disable the CSM on the motherboard
> 6) No boot possible, I always go directly to the UEFI-BIOS

Boot CSM mode, grub-install /dev/sda will install a BIOS grub into the BIOS Boot partition. It's fine for the fstab to still mount the ESP to /boot/efi - it's ignored.

Boot UEFI mode, grub-install will install a UEFI grub to the ESP.



> I am currently stuck there. I read a lot of conflicting advises which
> doesn't work:
>  - use "modprobe efivars" and efibootmgr: not possible because I have
> not booted in EFI (chicken-egg problem)
>  - use update-grub or use grub-mkconfig (to generate
> /boot/efi/grub/grub.cfg): no results
>  - other exotic commands…

Hmm I'm not certain whether the grub.cfg produced by grub-mkconfig is the same in UEFI vs CSM modes. Boot in both modes, create grub.cfg in each, then diff them.

However, I think grub.cfg on the ESP is a mistake because for bootable raid1 to be resilient in the face of one disk failure, you need some way to always keep each disk's ESP synchronized. It's better for he grub.cfg to be on Btrfs raid1 /boot/grub/grub.cfg. 

It's a separate topic for the grub list but I'm finding the idea of a persistently rw mounted ESP to be troubling. This isn't done on Windows or OS X, I don't know why this convention is used on Linux. The firmware doesn't mount it per se, but it's read only in any case, and the OS loader doesn't need the ESP mounted rw either, nor should it.

> 
> I will continue to document this "experience" (hope that it will be
> useful for others), and hope to get to the point where I can have a
> good system in BTRFS RAID1 mode.
> You have to be very motivated to get into this, It is really a challenge ! ;-)

Bootable raid1 on UEFI on grub-devel@
http://lists.gnu.org/archive/html/grub-devel/2014-02/msg00002.html

I think it's just not fully considered yet.



Chris Murphy

