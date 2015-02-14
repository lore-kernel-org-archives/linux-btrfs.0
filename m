Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:55460 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbbBNLwN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Feb 2015 06:52:13 -0500
Received: by mail-yh0-f49.google.com with SMTP id f10so10152772yha.8
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Feb 2015 03:52:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20150214T001556-40@post.gmane.org>
References: <loom.20150214T001556-40@post.gmane.org>
Date: Sat, 14 Feb 2015 04:52:12 -0700
Message-ID: <CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com>
Subject: Re: btrfs raid-1 uuid-fstab
From: Chris Murphy <lists@colorremedies.com>
To: James <wireless@tampabay.rr.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 13, 2015 at 7:31 PM, James <wireless@tampabay.rr.com> wrote:

>No swap for now (each system had 32G) if I need
> swap later, I can just setup a file and use swapon?

No. You should read the wiki.
https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files.3F

> What I want is if a drive fails,
> I can just replace it, or pull one drive out, replace it with a second
> blank, 2T new drive. Them move the removed drive into a second (identical)
> system to build a cloned workstation. From what I've read, uuid numbers
> are suppose to be use with fstab + btrfs Partuuid is still flaky. But the
> UUID numbers to not appear uniq (due to raid-1)? Do the only get listed once
> in fstab?

Once is enough. Kernel code will find both devices.

For degraded use, this gets tricky, you have to use boot param
rootflags=degraded to get it to mount, otherwise mount fails and
you'll be dropped to a pre-mount shell in the initramfs. Also, there's
a nasty little gotcha, there is no equivalent for mdadm bitmap. So
once one member drive is mounted degraded+rw, it's changed, and
there's no way to "catch up" the other drive - if you reconnect, it
might seem things are OK but there's a good chance of corruption in
such a case. You have to make sure you wipe the "lost" drive (the
older version one). wipefs -a should be sufficient, then use 'device
add' and 'device delete missing' to rebuild it.

This should not be formatted ext4, it's strictly for GRUB, it doesn't
get a file system. You should use wipefs -a on this.

This fstab has lots of problems. Based on your partition scheme it
should only have two entries total. A btrfs /boot UUID="d67a... and a
btrfs / UUID="b7753... There is no mountpoint for biosboot, it's used
by GRUB and is never formatted or mounted.

> First I notice the last partition (sdb1) seems to be missing the ext4 file
> system I guess when I exit the chroot I can just fix that to match sda1.

No the problem is sda1 is wrongly formatted ext4, you should use
wipefs -a on it.

> Any help or guidance would be keen,
> to help salvage the installation and get a few partitions installed
> with btrfs. Maybe I can somehow migrate to a raid-1 configuration
> under btrfs.

Good luck. Make backups often. Btrfs raid1 is not a backup. Btrfs
snapshots are not a backup. And use recent kernels. Recent on this
list means 3.18.3 or newer, and is listed unstable on this list
http://packages.gentoo.org/package/sys-kernel/gentoo-sources Based on
the kernel.org change log, you'd probably be fine running 3.14.31, but
if you have problems and ask about it on this list, there's a decent
chance the first question will be "can you reproduce the problem on a
current kernel?"

Anyway, I suggest reading the entire btrfs wiki.
