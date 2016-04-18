Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36113 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbcDRUnB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 16:43:01 -0400
Received: by mail-wm0-f41.google.com with SMTP id v188so136409829wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 13:43:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
Date: Mon, 18 Apr 2016 16:42:59 -0400
Message-ID: <CAD=QJKi5oL3a6rt9YkUBe55DpAQoohTGyF+UxpoX9Bv-SUOcGQ@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: David Alcorn <nroclaed@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 April 2016 at 01:22, David Alcorn <nroclaed@gmail.com> wrote:
> The goal is to install to a subvolume on the array
> without disturbing date on other array subvolumes.
>
> I erred and shutdown my NAS during a balance.  Grub lost track of my
> root.  Root was on RAID 6 array subvolid 257.  I can boot a different
> root from a USB flash drive but neither update-grub not install-grub
> sees my old root on array subvolid 257.  I am happy to either recover
> or lose array subvolid 257 but do not want to lose data on other array
> subvol's.  I prefer to have my root on the array rather than a flash
> drive.  The balance completed successfully after I booted from the
> flash drive.

Is your flash drive formatted btrfs?  If it is, you could always
snapshot it, send the snapshot to your array, set property of that
subvolume to RW, chroot, update fstab to mount / with the appropriate
subvol=option, update /etc/default/grub, reinstall grub and
update-grub, and reboot with your / as a subvolume on your array.  I'm
in the process of documenting how to do this on the Debian wiki.
Please let me know if I should put a rush on it.  It uses the subvol=
option rather than changing the volume's default subvol.

Cheers,
Nicholas
