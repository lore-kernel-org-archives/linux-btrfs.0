Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48439 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaEFLqn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 07:46:43 -0400
Date: Tue, 6 May 2014 12:46:40 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs raid allocator
Message-ID: <20140506114640.GY24298@carfax.org.uk>
References: <5368BC62.2020701@googlemail.com>
 <20140506105907.GV24298@carfax.org.uk>
 <5368C412.8040908@googlemail.com>
 <20140506111922.GX24298@carfax.org.uk>
 <5368C6F4.1010008@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XiX5sJQOWZsNRXst"
In-Reply-To: <5368C6F4.1010008@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XiX5sJQOWZsNRXst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 06, 2014 at 01:26:44PM +0200, Hendrik Siedelmann wrote:
> On 06.05.2014 13:19, Hugo Mills wrote:
> >On Tue, May 06, 2014 at 01:14:26PM +0200, Hendrik Siedelmann wrote:
> >>On 06.05.2014 12:59, Hugo Mills wrote:
> >>>On Tue, May 06, 2014 at 12:41:38PM +0200, Hendrik Siedelmann wrote:
> >>>>Hello all!
> >>>>
> >>>>I would like to use btrfs (or anyting else actually) to maximize raid0
> >>>>performance. Basically I have a relatively constant stream of data that
> >>>>simply has to be written out to disk. So my question is, how is the block
> >>>>allocator deciding on which device to write, can this decision be dynamic
> >>>>and could it incorporate timing/troughput decisions? I'm willing to write
> >>>>code, I just have no clue as to how this works right now. I read somewhere
> >>>>that the decision is based on free space, is this still true?
> >>>
> >>>    For (current) RAID-0 allocation, the block group allocator will use
> >>>as many chunks as there are devices with free space (down to a minimum
> >>>of 2). Data is then striped across those chunks in 64 KiB stripes.
> >>>Thus, the first block group will be N GiB of usable space, striped
> >>>across N devices.
> >>
> >>So do I understand this correctly that (assuming we have enough space) data
> >>will be spread equally between the disks independend of write speeds? So one
> >>slow device would slow down the whole raid?
> >
> >    Yes. Exactly the same as it would be with DM RAID-0 on the same
> >configuration. There's not a lot we can do about that at this point.
> 
> So striping is fixed but which disk takes part with a chunk is dynamic? But
> for large workloads slower disks could 'skip a chunk' as chunk allocation is
> dynamic, correct?

   You'd have to rewrite the chunk allocator to do this, _and_ provide
different RAID levels for different subvolumes. The chunk/block group
allocator right now uses only one rule for allocating data, and one
for allocating metadata. Now, both of these are planned, and _might_
between them possibly cover the use-case you're talking about, but I'm
not certain it's necessarily a sensible thing to do in this case.

   My question is, if you actually care about the performance of this
system, why are you buying some slow devices to drag the performance
of your fast devices down? It seems like a recipe for disaster...

> >>>    There's a second level of allocation (which I haven't looked at at
> >>>all), which is how the FS decides where to put data within the
> >>>allocated block groups. I think it will almost certainly be beneficial
> >>>in your case to use prealloc extents, which will turn your continuous
> >>>write into large contiguous sections of striping.
> >>
> >>Why does prealloc change anything? For me latency does not matter, only
> >>continuous troughput!
> >
> >    It makes the extent allocation algorithm much simpler, because it
> >can then allocate in larger chunks and do more linear writes
> 
> Is this still true if I do very large writes? Or do those get broken down by
> the kernel somewhere?

   I guess it'll depend on the approach you use to do these "very
large" writes, and on the exact definition of "very large". This is
not an area I know a huge amount about.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---     

--XiX5sJQOWZsNRXst
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2jLoFheFHXiqx3kAQIKzQ//f1/Pv9gy4eCs8RG7oOIHuv2FKb+bp5MG
wiNaQUg0t59Bxu/w+VSBCjXdVO9t/970H/g814+VIuN1jKpYHe6syAYCoZt08cK7
vrtnR064dJql+/RjkM14iDpk66byu0vwF7OtQ888lYn0wqqgDvzLM9XP+aByyNah
ccpyPPeNkadvxiJZM7AAeR+p5uQ2pLUCv5NoF5MXPK9W0v+DU0uhA7ysx6iAZrDW
98yUsaMhu4MqhZX+ZvFpArpojr4MWhBQAoCQPMuiWpiE/QcGxECooJIlVNNnlj+4
6S6Fhtk0GNAU4SgEuGKeVq2+VVh2vcP95r68G+sjRysDW/tlb9RooYIa0okwIzrf
yiQsrY6PjQszoH11CFhGFJm0QZeRSKxeUfj3FB8xcf0rf6QkG5qMHuX7dihcNn3S
bzr3CD7C2BDR1auqu0Ce2TLNSKPPmoH9olg8FN5mAYA5mWrsi6MTqQMayzKMYtKA
nA6aiRYiLzyN1E2dRahmjOtDRFEvMXjmUSjTJeWWGscg2PyNzPgtrNKL42ZxiVy9
bN8yiFD7UmLqj18QkSA/DEAfp6Ry2ZGDqmiQCDP8X2KAegnCXeD3vSMPFO9knmmq
LAvkKmPrOAPah2OCyrgIVlHXWGOTVSqevpRhz/tDm0blBhtCkxhgSYUeTS4ICzfM
4ACmPuplgBA=
=wn1X
-----END PGP SIGNATURE-----

--XiX5sJQOWZsNRXst--
