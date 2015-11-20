Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39272 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbbKTN1R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 08:27:17 -0500
Date: Fri, 20 Nov 2015 13:27:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs@vger.kernel.org
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Message-ID: <20151120132714.GK24333@carfax.org.uk>
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk>
 <564D1AE5.3000700@cn.fujitsu.com>
 <pan$61583$65d817c9$bfda2de6$465dca20@cox.net>
 <564F0671.8060402@mail.ru>
 <564F1E5B.6040004@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CMebLzmeJATad/OR"
In-Reply-To: <564F1E5B.6040004@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CMebLzmeJATad/OR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 20, 2015 at 08:21:31AM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-20 06:39, Dmitry Katsubo wrote:
> >If I may add:
> >
> >Information for "System"
> >
> >   System, DUP: total=32.00MiB, used=16.00KiB
> >
> >is also quite technical, as for end user system = metadata (one can call
> >it "filesystem metadata" perhaps). For simplicity the numbers can be
> >added to "Metadata" thus eliminating that line as well.
> >
> >For those power users who really want to see the tiny details like
> >"System" and "GlobalReserve" I suggest to implement "-v" flag:
> >
> ># btrfs fi usage -v
> Actually, I really like this idea, one of the questions I get asked
> when I show people BTRFS is the difference between System and
> Metadata, and it's not always easy to explain to somebody who
> doesn't have a background in filesystem development.  For some
> reason, people seem to have trouble with the concept that the system
> tree is an index of the other trees.

   Actually, it's not that in the system chunks. :)

   System chunks contain the chunk tree, not the tree of tree roots.
They're special (and small) because they're listed explicitly by devid
and physical offset at the end of the superblock, and allow the FS to
read them first so that it can bootstrap the logical:physical mapping
table before it starts reading all the other metadata like the tree of
tree roots (which is "normal" metadata).

   Hugo.

>  In general, it doesn't make
> sense for most non-debugging cases to have it listed separate from
> the Metadata (they always have the same profile unless you're part
> way through a conversion, and it really is metadata, just slightly
> higher level than the usual metadata chunks).
> >
> >On 2015-11-19 03:16, Duncan wrote:
> >>Qu Wenruo posted on Thu, 19 Nov 2015 08:42:13 +0800 as excerpted:
> >>
> >>>Although the metadata output is showing that you still have about 512M
> >>>available, but the 512M is Global Reserved space, or the unknown one.
> >>
> >>Unknown here, as the userspace (btrfs-progs) is evidently too old to show
> >>it as global reserve, as it does in newer versions...
> >>
> >>>The output is really a little confusing. I'd like the change the output
> >>>by adding global reserved into metadata used space and make it a sub
> >>>item for metadata.
> >>
> >>Thanks for the clarification.  It's most helpful, here. =:^)
> >>
> >>I've at times wondered if global reserve folded into one of the other
> >>settings.  Apparently it comes from the metadata allocation, but while
> >>metadata is normally dup (single-device btrfs) or raid1 (multi-device),
> >>global reserve is single.
> >>
> >>It would have been nice if that sort of substructure was described a bit
> >>better when global reserve first made its appearance, at least in the
> >>patch descriptions and release announcement, if not then yet in btrfs fi
> >>df output, first implementations being what they are.  But regardless,
> >>now at least it should be clear for list regulars who read this thread
> >>anyway, since the above reasonably clarifies things.
> >>
> >>As for btrfs fi df, making global reserve a metadata subentry there would
> >>be one way to deal with it, preserving the exposure of the additional
> >>data provided by that line (here, the fact that global reserve is
> >>actually being used, underlining the fact that the filesystem is severely
> >>short on space).
> >>
> >>Another way of handling it would be to simply add the global reserve into
> >>the metadata used figure before printing it, eliminating the separate
> >>global reserve line, and changing the upthread posted metadata line from
> >>8.48 GiB of 9 GiB used, to 8.98 of 9 GiB used, which is effectively the
> >>case if the 512 MiB of global reserve indeed comes from the metadata
> >>allocation.  This would more clearly show how full metadata actually is
> >>without the added complexity of an additional global reserve line, but
> >>would lose the fact that global reserve is actually in use, that the
> >>broken out global reserve line exposes.
> >>
> >>I'd actually argue in favor of the latter, directly folding global
> >>reserve allocation into metadata used, since it'd both be simpler, and
> >>more consistent if for instance btrfs fi usage didn't report separate
> >>global reserve in the overall stats, but fail to report it in the per-
> >>device stats and in btrfs dev usage.
> >>
> >>Either way would make much clearer that metadata is actually running out
> >>than the current report layout does, since "metadata used" would then
> >>either explicitly or implicitly include the global reserve.
> >>
> >
> >
> 
> 



-- 
Hugo Mills             | Startle, startle, little twink. How I wonder what
hugo@... carfax.org.uk | you think.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--CMebLzmeJATad/OR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWTx+yAAoJEFheFHXiqx3kS1AQALWA27eoNKzg4DLkKtZO2lkB
HX2ar4B7O7RCGTKoHw5IXK6GixR8bN3EoKWx8gMcVsZXWfNuujfPmtosMGiHOkLx
xek8V4ZubAzBaMwFdp6OnALKvv+fgNvUVKCs/zCkXf1lWLikxDHcTh0gVon0PWtI
FHQXqoYc1k1jGW7QC4S2L3IJvgbBBtZIjn1Xi5MZvP727gMC6DNF8oxgw4Wko9kV
8UfAEpnpep1xTwvij6qb0RaRWPj58pRJtcDBNH0YJJBeWjfVmdOo6wyQ1HE/7ibm
aE3Ji+MPJYmm8epttd7aUEeFWDEzxzGb8/sXL8ZOzEtfNSzxYGMeSpd99biCyNnl
cfkd31Xw565NFZVXcvSx/DWI3itonXQmIeI6YMrw2hR0JBE0VYY1zuIO6e4EFdkl
YdjeP9rOO8sgLZNbCuzBB7UtpGLKEjuGPcCJ4Syr21JTgigq1Xf0AWkWimBmP4Yn
Aeg+EFBkbxsqojWckHpmpv/nqUt8kqvkPU6a7BPGq1tiDPgZQu9lkc68AgApZZnz
1A0enrPplvqUEhRSOWkutGn5p5v5xEGpoNsql9Zy/gc9/E+D0mJvzafxRkq4uvwa
uY0hxusckWJbIa4ElWcTRq08dQ/ZUWuaUFbOZ+YWDeLM0d1ZcPmqdsZu6oyrwB2Z
g7x0mN6wMuqxik7gJETV
=HnM/
-----END PGP SIGNATURE-----

--CMebLzmeJATad/OR--
