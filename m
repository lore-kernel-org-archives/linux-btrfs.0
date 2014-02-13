Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45522 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBMThv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:37:51 -0500
Received: by mail-bk0-f43.google.com with SMTP id mx11so3200161bkb.16
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:37:50 -0800 (PST)
Received: from system (e180191041.adsl.alicedsl.de. [85.180.191.41])
        by mx.google.com with ESMTPSA id rf10sm2840545bkb.3.2014.02.13.11.37.48
        for <linux-btrfs@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Thu, 13 Feb 2014 11:37:49 -0800 (PST)
Date: Thu, 13 Feb 2014 20:37:47 +0100
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot
 when removing drive)
Message-ID: <20140213203747.4e65e708@system>
In-Reply-To: <15ABD3CE-BF67-42B5-9EF0-BE1823CB54CE@colorremedies.com>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com>
	<E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com>
	<CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com>
	<52FC8769.9030405@kingswood-consulting.co.uk>
	<CAJbEPe5fMYNOLJ_A=fwu4-mxrXvCcZc2adOJSBRJd-X8vb=LWA@mail.gmail.com>
	<15ABD3CE-BF67-42B5-9EF0-BE1823CB54CE@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 13 Feb 2014 10:43:08 -0700, Chris Murphy
<lists@colorremedies.com> wrote :
> >>> sda3 = 1 TiB root partition (BTRFS), mounted on /
> >>> sda4 = 6 GiB swap partition
> >>> (that way I should be able to be compatible with both CSM or UEFI)
> >>> 
> >>> B) normal Debian installation on sdas, activate the CSM on the
> >>> motherboard and reboot.
> >>> 
> >>> C) apt-get install grub-efi-amd64 and grub-install /dev/sda
> >>> 
> >>> And the problems begin:
> >>> 1) grub-install doesn't give any error but using the --debug I
> >>> can see that it is not using EFI.
> >>> 2) Ok I force with grub-install --target=x86_64-efi
> >>> --efi-directory=/boot/efi --bootloader-id=grub --recheck --debug
> >>> /dev/sda
> >>> 3) This time something is generated in /boot/efi:
> >>> /boot/efi/EFI/grub/grubx64.efi
> >>> 4) Copy the file /boot/efi/EFI/grub/grubx64.efi to
> >>> /boot/efi/EFI/boot/bootx64.efi
> >> 
> >> 
> >>                ^^^^ is EFI/boot/ correct here?
> >> 
> >> If you're lucky then your BIOS will tell what path it will try to
> >> read for the boot code. For me that is /EFI/debian/grubx64.efi.
> >> 
> > 
> > I followed the advices here (first result on Google with "grub uefi
> > debian"): http://tanguy.ortolo.eu/blog/article51/debian-efi
> > 
> >>> 5) Reboot and disable the CSM on the motherboard
> >>> 6) No boot possible, I always go directly to the UEFI-BIOS
> >>> 
> >>> I am currently stuck there. I read a lot of conflicting advises
> >>> which doesn't work:
> >>>   - use "modprobe efivars" and efibootmgr: not possible because I
> >>> have not booted in EFI (chicken-egg problem)
> >> 
> >> 
> >> Not exactly. Boot in EFI mode into your favourite installer rescue
> >> mode, then chroot into the target filesystem and run efibootmgr
> >> there.
> >> 
> > 
> > In the end I managed to do it like this:
> > 1) Make a USB stick with FAT32 partition
> > 2) Install grub on it with:
> > grub-install --target=x86_64-efi --efi-directory=/media/usb0
> > --removable 3) Note on a paper the grub commands to start the
> > kernel in /boot/grub/grub.cfg 3) Reboot, Disable CSM in the
> > motherboard boot utility (BIOS?), Reboot with the USB stick
> > connected 4) Normally it should have started on the USB stick grub
> > command-line 5) Enter the necessary command to start the kernel (if
> > you have some problem with video mode, use "insmod efi_gop")
> > 6) Normally your operating system should start normally
> > 7) Check that efibootmgr is installed and working (normally efivars
> > should be loaded in the modules already)
> > 8) grub-install --efi-directory=/boot/efi --recheck --debug
> > (with the debug info you should see that it is using grub-efi and
> > not grub-pc) 9) efibootmgr -c -d /dev/sda -p 2 -w -L "Debian
> > (GRUB)" -l '\EFI\Debian\grubx64.efi'
> > (replace -p 2 with yout correct ESP partition number)
> > 10) Reboot and enjoy !
> 
> OK at least with GRUB 2.00 I never have to use any options with
> grub-install when installing to a chrooted system. It also even
> writes the proper entry into NVRAM for me, I don't have to use
> efibootmgr.

Yes you are right, this is probably unnecessary (see below).

> 
> Also I've never had single \ work with efibootmgr from shell. I have
> to use \\. Try typing efibootmgr -v to see the actual entry you
> created and whether it has the \ in the path.
> 

Here is the output:
BootCurrent: 0001
Timeout: 1 seconds
BootOrder: 0001,0000
Boot0000* debian        HD(2,7d8,106430,5d012c09-b70d-4225-ae18-9831f997c493)File(\EFI\debian\grubx64.efi)
Boot0001* Debian (GRUB) HD(2,7d8,106430,5d012c09-b70d-4225-ae18-9831f997c493)File(\EFI\Debian\grubx64.efi)

Ah the joy of FAT32 and the case sensitivity !
So it seems that grub-install automatically install the correct entry
 and using efibootmgr was unnecessary.
However it seems that single '\' works.

> But one thing that explains why the UEFI bootloading stuff is
> confusing for you is that every distro keeps their own grub patches.
> So there is very possibly a lot of difference between the downstream
> grub behaviors, and upstream.
> 

Understood. That is why I took the step to describe what I did.
Perhaps it will be useful for others (most info on the topic was
not for Debian...).

Thanks again for your insights !
