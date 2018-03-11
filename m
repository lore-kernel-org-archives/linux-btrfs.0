Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41536 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbeCKRrU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 13:47:20 -0400
Date: Sun, 11 Mar 2018 18:47:13 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Andreas Hild <a.t.hild@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Raid1 volume stuck as read-only: How to dump, recreate and
 restore its content?
Message-ID: <20180311174713.53tqlmjn6t3d4gwh@angband.pl>
References: <CAEm4ggntj1ccp6PXvECDVrj0_RXrzn6fX7mu+CWtHNwCAoXbvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAEm4ggntj1ccp6PXvECDVrj0_RXrzn6fX7mu+CWtHNwCAoXbvg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 11, 2018 at 11:28:08PM +0700, Andreas Hild wrote:
> Following a physical disk failure of a RAID1 array, I tried to mount
> the remaining volume of a root partition with "-o degraded". For some
> reason it ended up as read-only as described here:
> https://btrfs.wiki.kernel.org/index.php/Gotchas#raid1_volumes_only_mountable_once_RW_if_degraded
> 
> 
> How to precisely do this: dump, recreate and restore its contents?
> Could someone please provided more details how to recover this volume
> safely?

> Linux debian 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3 (2017-12-03) x86_64 GNU/Linux

> [ 1313.279140] BTRFS warning (device sdb2): missing devices (1)
> exceeds the limit (0), writeable mount is not allowed

I'd recommend instead going with kernel 4.14 or newer (available in
stretch-backports), which handles this case well without the need to
restore.  If there's no actual data loss (there shouldn't be, it's RAID1
with only a single device missing), you can mount degraded normally, then
balance the data onto the new disk.

Recovery with 4.9 is unpleasant.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
