Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45653 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdEBUAD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 16:00:03 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d5dxg-00021s-1p
        for linux-btrfs@vger.kernel.org; Tue, 02 May 2017 21:59:52 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem
 by X hours?
Date: Tue, 2 May 2017 21:53:40 +0200
Message-ID: <20170502215340.5b0fe86f@jupiter.sol.kaishome.de>
References: <20170501170641.GG3516@merlins.org>
        <20170501180856.GH3516@merlins.org>
        <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
        <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
        <pan$e2463$2d3d82e9$144941f3$9eeef2a4@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 2 May 2017 05:01:02 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Of course on-list I'm somewhat known for my arguments propounding the 
> notion that any filesystem that's too big to be practically
> maintained (including time necessary to restore from backups, should
> that be necessary for whatever reason) is... too big... and should
> ideally be broken along logical and functional boundaries into a
> number of individual smaller filesystems until such point as each one
> is found to be practically maintainable within a reasonably practical
> time frame. Don't put all the eggs in one basket, and when the bottom
> of one of those baskets inevitably falls out, most of your eggs will
> be safe in other baskets. =:^)

Hehe... Yes, you're a fan of small filesystems. I'm more from the
opposite camp, preferring one big filesystem to not mess around with
size constraints of small filesystems fighting for the same volume
space. It also gives such filesystems better chances for data locality
of data staying in totally different parts across your fs mounts and
can reduce head movement. Of course, much of this is not true if you
use different devices per filesystem, or use SSDs, or SAN where you
have no real control over the physical placement of image stripes
anyway. But well...

In an ideal world, subvolumes of btrfs would be totally independent of
each other, just only share the same volume and dynamically allocating
chunks of space from it. If one is broken, it is simply not usable and
it should be destroyable. A garbage collector would grab the leftover
chunks from the subvolume and free them, and you could recreate this
subvolume from backup. In reality, shared extents will cross subvolume
borders so it is probably not how things could work anytime in the near
of far future.

This idea is more like having thinly provisioned LVM volumes which
allocate space as the filesystems on top need them, much like doing
thinly provisioned images with a VM host system. The problem here is,
unlike subvolumes, those chunks of space could never be given back to
the host as it doesn't know if it is still in use. Of course, there's
implementations available which allow thinning the images by passing
through TRIM from the guest to the host (or by other means of
communication channels between host and guest), but that is usually not
giving good performance, if even supported.

I tried once to exploit this in VirtualBox and hoped it would translate
guest discards into hole punching requests on the host, and it's even
documented to work that way... But (a) it was horrible slow, and (b) it
was incredibly unstable to the point of being useless. OTOH, it's not
announced as a stable feature and has to be enabled by manually editing
the XML config files.

But I still like the idea: Is it possible to make btrfs still work if
one subvolume gets corrupted? Of course it should have ways of telling
the user which other subvolumes are interconnected through shared
extents so those would be also discarded upon corruption cleanup - at
least if those extents couldn't be made any sense of any longer. Since
corruption is an issue mostly of subvolumes being written to, snapshots
should be mostly safe.

Such a feature would also only make sense if btrfs had an online repair
tool. BTW, are there plans for having an online repair tool in the
future? Maybe one that only scans and fixes part of the filesystems
(for obvious performance reasons, wrt Duncans idea of handling
filesystems), i.e. those parts that the kernel discovered having
corruptions? If I could then just delete and restore affected files,
this would be even better than having independent subvolumes like above.

-- 
Regards,
Kai

Replies to list-only preferred.

