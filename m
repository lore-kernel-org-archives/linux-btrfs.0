Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:37622 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaBMKD6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 05:03:58 -0500
Received: by mail-qa0-f42.google.com with SMTP id k4so16077003qaq.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 02:03:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52FC8769.9030405@kingswood-consulting.co.uk>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com>
	<E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com>
	<CAJbEPe4FFBemxf289aRn8M2DKH6sZYVi=fpST8Jp-fd6_ot0mQ@mail.gmail.com>
	<52FC8769.9030405@kingswood-consulting.co.uk>
Date: Thu, 13 Feb 2014 11:03:57 +0100
Message-ID: <CAJbEPe5fMYNOLJ_A=fwu4-mxrXvCcZc2adOJSBRJd-X8vb=LWA@mail.gmail.com>
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when
 removing drive)
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13 February 2014 09:50, Frank Kingswood
<frank@kingswood-consulting.co.uk> wrote:
> On 12/02/14 17:13, Saint Germain wrote:
>>
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
>
> I'm curious, why so big? There's only one file of about 100kb there, and I
> was considering shrinking mine to the minimum possible (which seems to be
> about 33 MB).
>

It is quite difficult to find reliable information on this whole UEFI
boot with linux (info you can find for sure, but which ones to follow
? there are so many different info out there).

So I don't know if this 550 MiB is an urban legend or not, but you can
find several people recommending it and the reason why:
http://askubuntu.com/questions/336439/any-problems-with-this-partition-scheme
http://askubuntu.com/questions/287441/different-uses-of-term-efi-partition
https://bbs.archlinux.org/viewtopic.php?pid=1306753
http://forums.gentoo.org/viewtopic-p-7352214.html

Other people recommend around 200-300 MiB, so I basically took the
upper limit to see what happen.
If you have more reliable info on the topic I would be interested !

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
>> 3) This time something is generated in /boot/efi:
>> /boot/efi/EFI/grub/grubx64.efi
>> 4) Copy the file /boot/efi/EFI/grub/grubx64.efi to
>> /boot/efi/EFI/boot/bootx64.efi
>
>
>                 ^^^^ is EFI/boot/ correct here?
>
> If you're lucky then your BIOS will tell what path it will try to read for
> the boot code. For me that is /EFI/debian/grubx64.efi.
>

I followed the advices here (first result on Google with "grub uefi debian"):
http://tanguy.ortolo.eu/blog/article51/debian-efi

>> 5) Reboot and disable the CSM on the motherboard
>> 6) No boot possible, I always go directly to the UEFI-BIOS
>>
>> I am currently stuck there. I read a lot of conflicting advises which
>> doesn't work:
>>    - use "modprobe efivars" and efibootmgr: not possible because I have
>> not booted in EFI (chicken-egg problem)
>
>
> Not exactly. Boot in EFI mode into your favourite installer rescue mode,
> then chroot into the target filesystem and run efibootmgr there.
>

In the end I managed to do it like this:
1) Make a USB stick with FAT32 partition
2) Install grub on it with:
grub-install --target=x86_64-efi --efi-directory=/media/usb0 --removable
3) Note on a paper the grub commands to start the kernel in /boot/grub/grub.cfg
3) Reboot, Disable CSM in the motherboard boot utility (BIOS?), Reboot
with the USB stick connected
4) Normally it should have started on the USB stick grub command-line
5) Enter the necessary command to start the kernel (if you have some
problem with video mode, use "insmod efi_gop")
6) Normally your operating system should start normally
7) Check that efibootmgr is installed and working (normally efivars
should be loaded in the modules already)
8) grub-install --efi-directory=/boot/efi --recheck --debug
(with the debug info you should see that it is using grub-efi and not grub-pc)
9) efibootmgr -c -d /dev/sda -p 2 -w -L "Debian (GRUB)" -l
'\EFI\Debian\grubx64.efi'
(replace -p 2 with yout correct ESP partition number)
10) Reboot and enjoy !

I made a lot of mistakes during these steps. The good thing is that
error are quire verbose, so you can easily see what is going wrong.
I hope that it will be easier for the next Debian user.

So now I can continue on this BTRFS RAID1 adventure... Let's see if my
setup is resilient to a hard drive failure.

Thanks for the help. Most comments here are quite on the spot and
reliable, that is very helpful !
