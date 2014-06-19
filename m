Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6088 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbaFSBNs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:13:48 -0400
Date: Thu, 19 Jun 2014 11:13:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Message-ID: <20140619011333.GH4453@dastard>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <pan$22693$6b452195$976b783a$e4956372@cox.net>
 <20140612232453.GR9508@dastard>
 <539B78F3.9070607@libero.it>
 <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
 <539BFF47.8060006@libero.it>
 <20140615221307.GE24386@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140615221307.GE24386@tango.0pointer.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2014 at 12:13:07AM +0200, Lennart Poettering wrote:
> On Sat, 14.06.14 09:52, Goffredo Baroncelli (kreijack@libero.it) wrote:
> 
> > > Which effectively means that by the time the 8 MiB is filled, each 4 KiB 
> > > block has been rewritten to a new location and is now an extent unto 
> > > itself.  So now that 8 MiB is composed of 2048 new extents, each one a 
> > > single 4 KiB block in size.
> > 
> > Several people pointed fallocate as the problem. But I don't
> > understand the reason.
> 
> BTW, the reason we use fallocate() in journald is not about trying to
> optimize anything. It's only used for one reason: to avoid SIGBUS on
> disk/quota full, since we actually write everything to the files using
> mmap().

FWIW, fallocate() doesn't absolutely guarantee you that. When at
ENOSPC, a write into that reserved range can still require
un-reserved metadata blocks to be allocated. e.g. splitting a
"reserved" data extent into two extents (used and reserved) requires
an extra btree record, which can cause a split, which can require
allocation. This tends to be pretty damn rare, though, and some
filesystems have reserved block pools specifically for handling this
sort of ENOSPC corner case. Hence, in practice the filesystems
never actually fail with ENOSPC in ranges that have been
fallocate()d.

> I mean, writing things with mmap() is always problematic, and
> handling write errors is awfully difficult, but at least two of the most
> common reasons for failure we'd like protect against in advance, under
> the assumption that disk/quota full will be reported immediately by the
> fallocate(), and the mmap writes later on will then necessarily succeed.
> 
> I am not really following though why this trips up btrfs though. I am
> not sure I understand why this breaks btrfs COW behaviour. I mean,
> fallocate() isn't necessarily supposed to write anything really, it's
> mostly about allocating disk space in advance. I would claim that
> journald's usage of it is very much within the entire reason why it
> exists...
> 
> Anyway, happy to change these things around if necesary, but first I'd
> like to have a very good explanation why fallocate() wouldn't be the
> right thing to invoke here, and a suggestion what we should do instead
> to cover this usecase...

fallocate() of 8MB should be more than sufficient for non-COW
filesystems - 1MB would be enough to prevent performance degradation
due to fragmentation in most cases. The current problems seem to be
with the way btrfs does rewrites, not the use of fallocate() in
systemd.

Thanks for explanation, Lennart.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
