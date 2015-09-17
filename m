Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60246 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbIQQCp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 12:02:45 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Zia Nayamuth <zedestructor@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: FYIO: A rant about btrfs
Date: Thu, 17 Sep 2015 17:57:09 +0200
Message-ID: <5147353.qIsJnOkqhM@merkaba>
In-Reply-To: <20150916232930.GD28645@carfax.org.uk>
References: <20150916144355.GA1285@invalid> <55F9BE3B.6070309@gmail.com> <20150916232930.GD28645@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 16. September 2015, 23:29:30 CEST schrieb Hugo Mills:
> > but even then having write-barriers
> > turned off is still not as safe as having them turned on.  Most of
> > the time when I've tried testing with 'nobarrier' (not just on BTRFS
> > but on ext* as well), I had just as many issues with data loss when
> > the system crashed as when it (simlated via killing the virtual
> > machine) lost power.  Both journaling and COW filesystems need to
> > ensure ordering of certain write operations to be able to maintain
> > consistency.  For example, the new/updated data blocks need to be on
> > disk before the metadata is updated to point to them, otherwise you
> > database can end up corrupted.
> 
>    Indeed. The barriers are an ordering condition. The FS relies on
> (i.e. *requires*) that ordering condition, in order to be truly
> consistent. Running with "nobarrier" is a very strong signal that you
> really don't care about the data on the FS.
> 
>    This is not a case of me simply believing that because I've been
> using btrfs for so long that I've got used to the peculiarities. The
> first time I heard about the nobarrier option, something like 6 years
> ago when I was first using btrfs, I thought "that's got to be a really
> silly idea". Any complex data structure, like a filesystem, is going
> to rely on some kind of ordering guarantees, somewhere in its
> structure. (The ordering might be strict, with a global clock, or
> barrier-based, or lattice-like, as for example a vector clock, but
> there's going to be _some_ concept of order). nobarrier allows the FS
> to ignore those guarantees, and even without knowing anything about
> the FS at all, doing so is a big red DANGER flag.

Official recommendation for XFS differs from that:

 Q. Should barriers be enabled with storage which has a persistent write 
cache?

Many hardware RAID have a persistent write cache which preserves it across 
power failure, interface resets, system crashes, etc. Using write barriers in 
this instance is not recommended and will in fact lower performance. 
Therefore, it is recommended to turn off the barrier support and mount the 
filesystem with "nobarrier", assuming your RAID controller is infallible and 
not resetting randomly like some common ones do. But take care about the hard 
disk write cache, which should be off. 

http://xfs.org/index.php/
XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.
3F

Thanks,
-- 
Martin
