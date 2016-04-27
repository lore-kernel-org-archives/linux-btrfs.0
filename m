Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:53785 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbcD0RXZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 13:23:25 -0400
Subject: Re: Add device while rebalancing
To: Juan Alberto Cirez <jacirez@rdcsafety.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
 <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net> <571DFCF2.6050604@gmail.com>
 <pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net> <571E154C.9060604@gmail.com>
 <CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
 <571F4CD0.9050004@gmail.com>
 <CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
 <CAJCQCtQbCbR9V7z4jZCejbKLJyhBbtrZJmcQBkX=VnxReBf46g@mail.gmail.com>
 <5720A0E8.5000407@gmail.com>
 <CAHaPQf3cR4jXKziSCqp0CnrB6oKQoO=2kywsKuo7BLqHqBjBRw@mail.gmail.com>
 <5720E8FE.2000407@googlemail.com>
 <CAHaPQf1vpOqcXwM41_0U-vh9njtserYhydZHC9phCemiCptVPA@mail.gmail.com>
 <CAHaPQf1=rGHLTR17Q5e08X195KsErDrnjX38VOVPQw3jJY8kbQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5720F58A.40904@googlemail.com>
Date: Wed, 27 Apr 2016 19:23:22 +0200
MIME-Version: 1.0
In-Reply-To: <CAHaPQf1=rGHLTR17Q5e08X195KsErDrnjX38VOVPQw3jJY8kbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/16 18:40, Juan Alberto Cirez wrote:
> If this is so, then it leaves even confused. I was under the
> impression that the driving imperative for the creation of btrfs was
> to address the shortcomings of current filesystems (within the context
> of distributed data). That the idea was to create a low level
> filesystem that would be the primary choice as a block/brick layer for a
> scale-out, distributed data storage...

I can't speak for who was or is motivated by what. Btrfs was a necessary
reaction to ZFS, and AFAIK this had nothing to do with distributed storage
but rather growing concerns around reliability (checksumming), scalability
and operational ease: snapshotting, growing/shrinking etc.

It's true that some of btrfs' capabilities make it look like a a good
candidate, and e.g. Ceph started out using it. For many reasons that
didn't work out (AFAIK btrfs maturity + extensibility) - but it also
did not address a fundamental mismatch in requirements, which other
filesystems (ext4, xfs) could not address either. btrfs simply
does "too much" because it has to; you cannot remove or turn off half
of what makes a kernel-based filesystem a usable filesystem. This is
kind of sad because at its core btrfs *is* an object store with
various trees for metadata handling and whatnot - but there's no
easy way to turn off all the "Unix is stupid" stuff.

AFAIK Gluster will soon also start managing xattrs differently,
so this is not limited to Ceph.

I've been following this saga for several years now and it's
absolutely *astounding* how many bugs and performance problems
Ceph has unearthed in existing filesystems, simply because it
stresses them in ways they never have been stressed before..only to
create the illusion of a distributed key/value store, badly.
I don't want to argue about details, you can read more about some
of the reasons in [1].

[grumble grumble exokernels and composable things in userland grumble]

cheers
Holger

[1] http://www.slideshare.net/sageweil1/ceph-and-rocksdb

