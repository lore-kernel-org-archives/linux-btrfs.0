Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60982 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932150AbeCJPu0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 10:50:26 -0500
Date: Sat, 10 Mar 2018 16:50:22 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Roman Mamedov <rm@romanrm.net>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: zerofree btrfs support?
Message-ID: <20180310155022.wtdmwiyxu7mxt74s@angband.pl>
References: <1520650525.5641.47.camel@scientia.net>
 <20180310081606.7c2u2dtopijujhbz@angband.pl>
 <1520691545.24363.10.camel@scientia.net>
 <20180310193722.2d6b494a@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180310193722.2d6b494a@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 10, 2018 at 07:37:22PM +0500, Roman Mamedov wrote:
> Note you can use it on HDDs too, even without QEMU and the like: via using LVM
> "thin" volumes. I use that on a number of machines, the benefit is that since
> TRIMed areas are "stored nowhere", those partitions allow for incredibly fast
> block-level backups, as it doesn't have to physically read in all the free
> space, let alone any stale data in there. LVM snapshots are also way more
> efficient with thin volumes, which helps during backup.

Since we're on a btrfs mailing list, if you use qemu, you really want
sparse format:raw instead of qcow2 or preallocated raw.  This also works
great with TRIM.

> > Back then it didn't seem to work.
> 
> It works, just not with some of the QEMU virtualized disk device drivers.
> You don't need to use qemu-img to manually dig holes either, it's all
> automatic.

It works only with scsi and virtio-scsi drivers.  Most qemu setups use
either ide (ouch!) or virtio-blk.

You'd obviously want virtio-scsi; note that defconfig enables virtio-blk but
not virtio-scsi; I assume most distribution kernels have both.  It's a bit
tedious to switch between the two as -blk is visible as /dev/vda while -scsi
as /dev/sda.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
