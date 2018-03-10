Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:36932 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932075AbeCJOpI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 09:45:08 -0500
Date: Sat, 10 Mar 2018 19:37:22 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Adam Borowski <kilobyte@angband.pl>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: zerofree btrfs support?
Message-ID: <20180310193722.2d6b494a@natsu>
In-Reply-To: <1520691545.24363.10.camel@scientia.net>
References: <1520650525.5641.47.camel@scientia.net>
        <20180310081606.7c2u2dtopijujhbz@angband.pl>
        <1520691545.24363.10.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 10 Mar 2018 15:19:05 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> TRIM/discard... not sure how far this is really a solution.

It is the solution in a great many of usage scenarios, don't know enough about
your particular one, though.

Note you can use it on HDDs too, even without QEMU and the like: via using LVM
"thin" volumes. I use that on a number of machines, the benefit is that since
TRIMed areas are "stored nowhere", those partitions allow for incredibly fast
block-level backups, as it doesn't have to physically read in all the free
space, let alone any stale data in there. LVM snapshots are also way more
efficient with thin volumes, which helps during backup.

> dm-crypt per default blocks discard.

Out of misguided paranoia. If your crypto is any good (and last I checked AES
was good enough), there's really not a lot to gain for the "attacker" knowing
which areas of the disk are used and which are not.

> Some longer time ago I had a look at whether qemu would support that on
> it's own,... i.e. the guest and it's btrfs would normally use discard,
> but the image file below would mark the block as discarded and later on
> e can use some qemu-img command to dig holes into exactly those
> locations.
> Back then it didn't seem to work.

It works, just not with some of the QEMU virtualized disk device drivers.
You don't need to use qemu-img to manually dig holes either, it's all
automatic.

> But even if it would in the meantime, a proper zerofree implementation
> would be beneficial for all non-qemu/qcow2 users (e.g. if one uses raw
> images in qemu, the whole thing couldn't work but with really zeroing
> the blocks inside the guest.

QEMU deallocates parts of its raw images for those areas which have been
TRIM'ed by the guest. In fact I never use qcow2, always raw images only.
Yet, boot a guest, issue fstrim, and see the raw file while still having the
same size, show much lower actual disk usage in "du".

-- 
With respect,
Roman
