Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:56528 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdGGFsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Jul 2017 01:48:19 -0400
Date: Fri, 7 Jul 2017 10:48:17 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Daniel Brady <drbrady@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Chunk root problem
Message-ID: <20170707104817.3e2b6273@natsu>
In-Reply-To: <CABRvOkNWpaKB=mAEF9UvUUveFLBQroTWLpC5H=Fqc+okQ_BU3Q@mail.gmail.com>
References: <CABRvOkNWpaKB=mAEF9UvUUveFLBQroTWLpC5H=Fqc+okQ_BU3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 5 Jul 2017 22:10:35 -0600
Daniel Brady <drbrady@gmail.com> wrote:

> parent transid verify failed

Typically in Btrfs terms this means "you're screwed", fsck will not fix it, and
nobody will know how to fix or what is the cause either. Time to restore from
backups! Or look into "btrfs restore" if you don't have any.

In your case it's especially puzzling as the difference in transid numbers is
really significant (about 100K), almost like the FS was operating for months
without updating some parts of itself -- and no checksum errors either, so
all looks correct, except that everything is horribly wrong.

This kind of error seems to occur more often in RAID setups, either Btrfs
native RAID, or with Btrfs on top of other RAID setups -- i.e. where it
becomes a complex issue that all writes to multi devices DO complete IN order,
in case of an unclean shutdown. (which is much simpler on a single device FS).

Also one of your disks or cables is failing (was /dev/sde on that boot, but may
get a different index next boot), check SMART data for it and replace.

> [   21.230919] BTRFS info (device sdf): bdev /dev/sde errs: wr 402545, rd
> 234683174, flush 194501, corrupt 0, gen 0

-- 
With respect,
Roman
