Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53]:56331 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753075AbaBMIuz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 03:50:55 -0500
Message-ID: <52FC8769.9030405@kingswood-consulting.co.uk>
Date: Thu, 13 Feb 2014 08:50:49 +0000
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: Saint Germain <saintger@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Murphy <lists@colorremedies.com>
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when
 removing drive)
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com> <E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com> <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com>
In-Reply-To: <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/02/14 17:13, Saint Germain wrote:
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

I'm curious, why so big? There's only one file of about 100kb there, and 
I was considering shrinking mine to the minimum possible (which seems to 
be about 33 MB).

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
> 2) Ok I force with grub-install --target=x86_64-efi
> --efi-directory=/boot/efi --bootloader-id=grub --recheck --debug
> /dev/sda
> 3) This time something is generated in /boot/efi: /boot/efi/EFI/grub/grubx64.efi
> 4) Copy the file /boot/efi/EFI/grub/grubx64.efi to
> /boot/efi/EFI/boot/bootx64.efi

                 ^^^^ is EFI/boot/ correct here?

If you're lucky then your BIOS will tell what path it will try to read 
for the boot code. For me that is /EFI/debian/grubx64.efi.

> 5) Reboot and disable the CSM on the motherboard
> 6) No boot possible, I always go directly to the UEFI-BIOS
>
> I am currently stuck there. I read a lot of conflicting advises which
> doesn't work:
>    - use "modprobe efivars" and efibootmgr: not possible because I have
> not booted in EFI (chicken-egg problem)

Not exactly. Boot in EFI mode into your favourite installer rescue mode, 
then chroot into the target filesystem and run efibootmgr there.

Frank

