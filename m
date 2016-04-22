Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36463 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbcDVKo6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 06:44:58 -0400
Received: by mail-yw0-f174.google.com with SMTP id o66so118317163ywc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 03:44:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
Date: Fri, 22 Apr 2016 18:44:57 +0800
Message-ID: <CALq5X_iJcbXeaQxPAoHPwXyDSSXSx7HnWPApbQcXB4s7utGG_g@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: David Alcorn <nroclaed@gmail.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/19/16, Nicholas D Steeves <nsteeves@gmail.com> wrote:
....
> Is your flash drive formatted btrfs?  If it is, you could always
> snapshot it, send the snapshot to your array, set property of that
> subvolume to RW, chroot, update fstab to mount / with the appropriate
> subvol=option, update /etc/default/grub, reinstall grub and
> update-grub, and reboot with your / as a subvolume on y>
....
>I'm
> in the process of documenting how to do this on the Debian wiki.
> Please let me know if I should put a rush on it.  It uses the subvol=
> option rather than changing the volume's default subvol.
>
> Cheers,
> Nicholas
>


First, I verified that while the Debian Installer will install to a
pre set default BTRFS RAID6 subvolume, the Grub install step fails.
The alternative to restore installation to a RAID6 subvolume requires
installation to a non RAID6 subvolume and then send|receive the
snapshotted installation to the array.  To prepare for this attempt, I
reinstalled BTRFS (Debian stable) to a flash drive using separate
partitions for efi, /boot/ and / (in a subvolume).  The default
subvolume was set to 5 for both the flash / partition and also the
RAID6 array.  I used a separate /boot partition to reduce complexity.
Both the kernel and btrfs tools were upgraded to 4.4.  I soon
thereafter got lost.

The steps "snapshot it, send the snapshot to your array, set property of that
subvolume to RW, chroot, update fstab to mount / with the appropriate
subvol=option," posed no problem, then I got confused.  Should the
next step "update /etc/default/grub" be done within the chroot
environment and  what does "update /etc/default/grub" mean?  I assume
update=grub is done outside the grub environment because it fails to
execute within the chroot/.  What am I missing?  Outside the chroot
environment I did both an update-grub and a grub-install.  My nas
still boots using root on the flash drive. How do I fix this?  I guess
I am requesting that you "put a rush" on you documentation effort.

I observe that "/boot/grub/grub.cfg" still references the flash drive
root rather than the array root.  The nas functions flawlessly but I
would sleep better with root on the RAID6 array rather than on a flash
drive.  Both the efi and /boot partitions are almost read only so
using cheap flash here is not a substantive risk.

Thanks in advance:
David Alcorn
