Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36480 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750800AbcISPeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 11:34:09 -0400
Date: Mon, 19 Sep 2016 11:33:42 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke? (wiki updated)
Message-ID: <20160919153341.GA4703@hungrycats.org>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <20160919034701.GE21290@hungrycats.org>
 <8dc842dc-c9a9-5662-1222-2d6785a66359@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
In-Reply-To: <8dc842dc-c9a9-5662-1222-2d6785a66359@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 19, 2016 at 08:32:14AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-18 23:47, Zygo Blaxell wrote:
> >On Mon, Sep 12, 2016 at 12:56:03PM -0400, Austin S. Hemmelgarn wrote:
> >>4. File Range Cloning and Out-of-band Dedupe: Similarly, work fine if the FS
> >>is healthy.
> >
> >I've found issues with OOB dedup (clone/extent-same):
> >
> >1.  Don't dedup data that has not been committed--either call fsync()
> >on it, or check the generation numbers on each extent before deduping
> >it, or make sure the data is not being actively modified during dedup;
> >otherwise, a race condition may lead to the the filesystem locking up and
> >becoming inaccessible until the kernel is rebooted.  This is particularly
> >important if you are doing bedup-style incremental dedup on a live system.
> >
> >I've worked around #1 by placing a fsync() call on the src FD immediately
> >before calling FILE_EXTENT_SAME.  When I do an A/B experiment with and
> >without the fsync, "with-fsync" runs for weeks at a time without issues,
> >while "without-fsync" hangs, sometimes in just a matter of hours.  Note
> >that the fsync() doesn't resolve the underlying race condition, it just
> >makes the filesystem hang less often.
> >
> >2.  There is a practical limit to the number of times a single duplicate
> >extent can be deduplicated.  As more references to a shared extent
> >are created, any part of the filesystem that uses backref walking code
> >gets slower.  This includes dedup itself, balance, device replace/delete,
> >FIEMAP, LOGICAL_INO, and mmap() (which can be bad news if the duplicate
> >files are executables).  Several factors (including file size and number
> >of snapshots) are involved, making it difficult to devise workarounds or
> >set up test cases.  99.5% of the time, these operations just get slower
> >by a few ms each time a new reference is created, but the other 0.5% of
> >the time, write operations will abruptly grow to consume hours of CPU
> >time or dozens of gigabytes of RAM (in millions of kmalloc-32 slabs)
> >when they touch one of these over-shared extents.  When this occurs,
> >it effectively (but not literally) crashes the host machine.
> >
> >I've worked around #2 by building tables of "toxic" hashes that occur too
> >frequently in a filesystem to be deduped, and using these tables in dedup
> >software to ignore any duplicate data matching them.  These tables can
> >be relatively small as they only need to list hashes that are repeated
> >more than a few thousand times, and typical filesystems (up to 10TB or
> >so) have only a few hundred such hashes.
> >
> >I happened to have a couple of machines taken down by these issues this
> >very weekend, so I can confirm the issues are present in kernels 4.4.21,
> >4.5.7, and 4.7.4.
> OK, that's good to know.  In my case, I'm not operating on a very big data
> set (less than 40GB, but the storage cluster I'm doing this on only has
> about 200GB of total space, so I'm trying to conserve as much as possible),
> and it's mostly static data (less than 100MB worth of changes a day except
> on Sunday when I run backups), so it makes sense that I've not seen either
> of these issues.

I ran into issue #2 on an 8GB filesystem last weekend.  The lower limit
on filesystem size could be as low as a few megabytes if they're arranged
in *just* the right way.

> The second one sounds like the same performance issue caused by having very
> large numbers of snapshots, and based on what's happening, I don't think
> there's any way we could fix it without rewriting certain core code.

find_parent_nodes is the usual culprit for CPU usage.  Fixing this is
required for in-band dedup as well, so I assume someone has it on their
roadmap and will get it done eventually.


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfgBVUACgkQgfmLGlazG5zaQwCfQntgWFM/DKQqfLbdZirOmu2v
s5kAoN+meMc14loYQzqArLIB2ownYW6F
=GqnZ
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
