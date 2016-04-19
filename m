Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37327 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbcDSUxj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 16:53:39 -0400
Received: by mail-wm0-f43.google.com with SMTP id n3so50271514wmn.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 13:53:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALq5X_hawW4gc3sbm7fa1MRk+cTGWv5URO+7ye2jc61ymT96sg@mail.gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
	<CALq5X_hawW4gc3sbm7fa1MRk+cTGWv5URO+7ye2jc61ymT96sg@mail.gmail.com>
Date: Tue, 19 Apr 2016 16:53:37 -0400
Message-ID: <CAD=QJKiuSQ4Ha3hP-y+XgGXRWWf+zLdBK6F9LxbV6CB1yCchyQ@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 April 2016 at 23:06, David Alcorn <nroclaed@gmail.com> wrote:
> Nicolas:
>
> My flash drive uses BTRFS and I am comfortable with your instructions
> with one exception.  What does "update /etc/default/grub" mean?
>
> Currently, I am waiting for a scrub to verify that all is in good
> order before fixing the problem.

I meant that more as a general precaution and good habit.  The most
common check/change would be to make sure the "resume=foo" option
matches the UUID or /dev/sdX of the swap partition; it's mostly
relevant to laptop users.

More to the point, as Austin and Chris mentioned the tricky bit is
going to get GRUB to boot from raid6 profile btrfs if your /boot is
part of your btrfs volume.  I honestly don't know if it will work...
Do you have a separate /boot partition?  What is your /dev/sda being
used for?  UEFI firmware loads GRUB's EFI payload, which loads the
different stages of grub that allow file system access, which is
necessary for grub to be able to find the kernel.  The EFI payload is
installed to your FAT-formatted ESP partition, which is usually
mounted to /boot/grub/efi/EFI.  I also suspect that without a separate
/boot partition GRUB won't be able to find the kernel
(/boot/vmlinuz-4.4.0-1-amd64).  If I remember correctly GRUB's stage1
talks to your motherboard's firmware, stage2 enables filesystem access
(/boot/grub/x86_64-efi/btrfs.mod), and stage3 loads the kernel.  En
bref, if GRUB has insufficient support for btrfs' raid6 profile then
grub will either be unable to access btrfs.mod, or btrfs.mod will be
unable to enable access /boot/vmlinuz-4.4.0-1-amd64.

I suspect the following worst-case scenario if you don't have a
partition you can use for /boot, and didn't leave any unallocated
space on any of your drives, and if you can't shrink something like a
swap partition to make room for /boot:  No need to backup/restore if
you have a usb port to dedicate to /boot.  A more exotic solution
would be using a small SATADOM to hold it, but then you lose a SATA
port ;-)  After sending the rootfs of your USB flash installation to a
subvolume of your raid6, you can manually use the GRUB command line on
your existing USB stick to attempt to boot the rootfs subvolume of
your raid6.

Cheers,
Nicholas
