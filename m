Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46605 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752416AbaBMRdx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 12:33:53 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when removing drive)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52FC8769.9030405@kingswood-consulting.co.uk>
Date: Thu, 13 Feb 2014 10:33:51 -0700
Cc: Saint Germain <saintger@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <298ECBDF-898C-4C2E-8004-BBCFEB677969@colorremedies.com>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com> <E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com> <CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com> <52FC8769.9030405@kingswood-consulting.co.uk>
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 13, 2014, at 1:50 AM, Frank Kingswood <frank@kingswood-consulting.co.uk> wrote:

> On 12/02/14 17:13, Saint Germain wrote:
>> Ok based on your advices, here is what I have done so far to use UEFI
>> (remeber that the objective is to have a clean and simple BTRFS RAID1
>> install).
>> 
>> A) I start first with only one drive, I have gone with the following
>> partition scheme (Debian wheezy, kernel 3.12, grub 2.00, GPT partition
>> with parted):
>> sda1 = 1MiB BIOS Boot partition (no FS, "set 1 bios_grub on" with
>> parted to set the type)
>> sda2 = 550 MiB EFI System Partition (FAT32, "toggle 2 boot" with
>> parted to set the type),  mounted on /boot/efi
> 
> I'm curious, why so big? There's only one file of about 100kb there, and I was considering shrinking mine to the minimum possible (which seems to be about 33 MB).

I'm not sure what OS loader you're using but I haven't seen a grubx64.efi less than ~500KB. In general I'm seeing it at about 1MB. The Fedora grub-efi and shim packages as installed on the ESP take up 10MB. So 33MiB is a bit small, and if we were more conservative, we'd update the OS loader by writing the new one to a temp directory rather than overwriting existing. And then remove the old, and rename the new.

The UEFI spec says if the system partition is FAT, it should be FAT32. For removable media it's FAT12/FAT16. I don't know what tool the various distro installers are using, but at least on Fedora they are using mkdosfs, part of dosfstools. And its cutoff for making FAT16/FAT32 based on media size is 500MB unless otherwise specified, and the installer doesn't specify so actually by default Fedora system partitions are FAT16, to no obvious ill effect. But if you want a FAT32 ESP created by the installer the ESP needs to be 500MiB or 525MB. So 550MB is a reasonable number to make that happen.

If we were slightly smarter (and more A.R.), UEFI bugs aside, we'd put the ESP as the last partition on the disk rather than as the first and then honestly would we really care about consuming even 1GiB of the slowest part of a spinning disk? Or causing a bit of overprovisioning for SSD? No. It's probably a squeak of an improvement if anything.

For those who want to use gummiboot, it calls for the kernel and initramfs to be located on the ESP and is mounted at /boot rather than /boot/efi. So that's also a reason to make it bigger than usual.




>> sda3 = 1 TiB root partition (BTRFS), mounted on /
>> sda4 = 6 GiB swap partition
>> (that way I should be able to be compatible with both CSM or UEFI)
>> 
>> B) normal Debian installation on sdas, activate the CSM on the
>> motherboard and reboot.
>> 
>> C) apt-get install grub-efi-amd64 and grub-install /dev/sda
>> 
>> And the problems begin:
>> 1) grub-install doesn't give any error but using the --debug I can see
>> that it is not using EFI.
>> 2) Ok I force with grub-install --target=x86_64-efi
>> --efi-directory=/boot/efi --bootloader-id=grub --recheck --debug
>> /dev/sda
>> 3) This time something is generated in /boot/efi: /boot/efi/EFI/grub/grubx64.efi
>> 4) Copy the file /boot/efi/EFI/grub/grubx64.efi to
>> /boot/efi/EFI/boot/bootx64.efi
> 
>                ^^^^ is EFI/boot/ correct here?

If you want a fallback bootloader, yes.

> 
> If you're lucky then your BIOS will tell what path it will try to read for the boot code. For me that is /EFI/debian/grubx64.efi.

NVRAM is what does this. But if NVRAM becomes corrupt, or the entry is deleted for whatever reason, the proper fallback is boot<arch>.efi.



Chris Murphy

