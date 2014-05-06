Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48317 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEFLTY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 07:19:24 -0400
Date: Tue, 6 May 2014 12:19:22 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs raid allocator
Message-ID: <20140506111922.GX24298@carfax.org.uk>
References: <5368BC62.2020701@googlemail.com>
 <20140506105907.GV24298@carfax.org.uk>
 <5368C412.8040908@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LmcuB6YxSMQAV95c"
In-Reply-To: <5368C412.8040908@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LmcuB6YxSMQAV95c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 06, 2014 at 01:14:26PM +0200, Hendrik Siedelmann wrote:
> On 06.05.2014 12:59, Hugo Mills wrote:
> >On Tue, May 06, 2014 at 12:41:38PM +0200, Hendrik Siedelmann wrote:
> >>Hello all!
> >>
> >>I would like to use btrfs (or anyting else actually) to maximize raid0
> >>performance. Basically I have a relatively constant stream of data that
> >>simply has to be written out to disk. So my question is, how is the block
> >>allocator deciding on which device to write, can this decision be dynamic
> >>and could it incorporate timing/troughput decisions? I'm willing to write
> >>code, I just have no clue as to how this works right now. I read somewhere
> >>that the decision is based on free space, is this still true?
> >
> >    For (current) RAID-0 allocation, the block group allocator will use
> >as many chunks as there are devices with free space (down to a minimum
> >of 2). Data is then striped across those chunks in 64 KiB stripes.
> >Thus, the first block group will be N GiB of usable space, striped
> >across N devices.
> 
> So do I understand this correctly that (assuming we have enough space) data
> will be spread equally between the disks independend of write speeds? So one
> slow device would slow down the whole raid?

   Yes. Exactly the same as it would be with DM RAID-0 on the same
configuration. There's not a lot we can do about that at this point.

> >    There's a second level of allocation (which I haven't looked at at
> >all), which is how the FS decides where to put data within the
> >allocated block groups. I think it will almost certainly be beneficial
> >in your case to use prealloc extents, which will turn your continuous
> >write into large contiguous sections of striping.
> 
> Why does prealloc change anything? For me latency does not matter, only
> continuous troughput!

   It makes the extent allocation algorithm much simpler, because it
can then allocate in larger chunks and do more linear writes

> >    I would recommend thoroughly benchmarking your application with the
> >FS first though, just to see how it's going to behave for you.
> >
> >    Hugo.
> >
> 
> Of course - it's just that I do not yet have the hardware, but I plan to
> test with a small model - I just try to find out how it actually works
> first, so I know what look out for.

   Good luck. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---     

--LmcuB6YxSMQAV95c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2jFOlheFHXiqx3kAQLXTg/+N76uCAtm8m1SWER5MHxcAb9sCTLskcl3
6dnYmhm59PHzeH0ko5omWu9Cb1Zg3za62AVBffADP7gg6CKlI23GwzLRZR7MlhvE
pvGsKIPxbzht5xXciCZ2PCvD1E2Su2Gcn4Oek9CnKJxqju7sv5zPtTRQQWa80DSE
GdxWkRBRUDY46KQJfYqv7oaIzlWq1exniqvviHDHTZclo5Pl21J81DFfu4o2/Gtq
vZFAc7rJBGTrpcWeyq4V1ZxQsGm9wULWRk3y8iiYDfToFK4K5SKRRH+IteH8OObO
WY9whXbUQYC354jvAHLYb7b/PHJagZq8Os8noUrvc73wEEwNmdNO8hXIwCWr5DHw
If3JFanZo060LWlQaIXxst8avaZeHmHhuhl3b7srwAVk47M/FSij6ka9Fa4dsSLi
8Fe1ejZ9XOVl5g7aOfcW1NhFV7hOIuUEHKJqOIVLR1cZl1ZhAxNGq/TiBB+v5ODR
zPHZyhyM/RTSCHeJgNauRJTyrayhe4vwA2M2Nskorjc4Z/HpmygLXwxPPlBgX6km
ybditHVFjoiZir5514BdvgXi9U2Wc3Jh1KzO906lFTWLX3KQEcv0+tfEYh+T07Wa
JKaGOHBIqWOR8Q5L0aUJA2clPe2XFtMUCrZM1Mh9t1T9ixyHXr1/bmUqTYKRWK3B
O6MvhAMe9yc=
=CnM9
-----END PGP SIGNATURE-----

--LmcuB6YxSMQAV95c--
