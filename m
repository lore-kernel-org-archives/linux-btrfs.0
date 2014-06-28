Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39458 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaF1HoM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 03:44:12 -0400
Date: Sat, 28 Jun 2014 08:43:53 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: russell@coker.com.au, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: RAID1 3+ drives
Message-ID: <20140628074353.GJ31096@carfax.org.uk>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com>
 <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net>
 <1403953457.BS00mAsj6N@xev>
 <3863278.VRAxdhjX0B@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gJNQRAHI5jiYqw2y"
In-Reply-To: <3863278.VRAxdhjX0B@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gJNQRAHI5jiYqw2y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 28, 2014 at 09:38:00AM +0200, Martin Steigerwald wrote:
> Am Samstag, 28. Juni 2014, 16:28:23 schrieb Russell Coker:
> > > So look for N-way-mirroring when you go RAID shopping, and no, btrfs does
> > > not have it at this time, altho it is roadmapped for implementation after
> > > completion of the raid5/6 code.
> > >
> > > 
> > >
> > > FWIW, N-way-mirroring is my #1 btrfs wish-list item too, not just for
> > > device redundancy, but to take full advantage of btrfs data integrity
> > > features, allowing to "scrub" a checksum-mismatch copy with the content
> > > of a checksum-validated copy if available.  That's currently possible,
> > > but due to the pair-mirroring-only restriction, there's only one
> > > additional copy, and if it happens to be bad as well, there's no
> > > possibility of a third copy to scrub from.  As it happens my personal
> > > sweet-spot between cost/performance and reliability would be 3-way
> > > mirroring, but once they code beyond N=2, N should go unlimited, so N=3,
> > > N=4, N=50 if you have a way to hook them all up... should all be possible.
> > 
> > What I want is the ZFS copies= feature.
> 
> Something like this, even more flexible, was planned to be added. There were 
> some discussion on how to specificy complex redundancy patterns totally flexibly 
> exactly with how much redundancy, how much spares and so on.
> 
> I didn't read any of this since a long time. I wonder what happened to this 
> idea.

   It's moving slowly in fits and starts. I haven't forgotten it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--gJNQRAHI5jiYqw2y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU65yOVheFHXiqx3kAQLZbA//Y7UMHlZYyCF+/saiRsqHv4bpe3cC40Zz
qStGeXA2HfFai9lQH4JHY69PlIMFyD/XNlBTtGHCtJdFmffvUcVfHjINdlNzqeWg
BAXYKOnnCVS4HQi6WTjfEnOTSL5w8wpdlzcEbbx9DoXDotgZu1n/fZJjF+BUrNuu
5r4HkO42b679DRmxcFPpajeJgxPh2TJJ2TyjBhyaTLQJBQ2a2g9HmagG8ZMRDxOX
Ci7yE3XBYYEpXhzAWYYqxMgA1QTMHnE4GiB+dzuaOMGcsW1zMFiws9ePMkn1rBF6
T1lasbECR51XMOJbbrGEGYjFK8ilC3ox00I2paLOA4q0i+yFECl1ItCl6vq/npdW
CA8qlcp0b0NY472sh0ftuUGlv5SrTUcO4wfNeVNdCvbhwMADGjikxi6hrvtovFC/
97ut0ft7Jf4VV9Z3w3gTABv0LUhNNqU2WsUSB4Jocq3skY7M9MS76CQd1KULb+HL
EIuZflKjpsbsprtuOFC9euy2L3fnEUCx1ueRbh4ykXoDqT5Lz41zyph5YyJJqlSP
EtiNLeS0+90PzBnK+79tYeDDZ33M88eKPIBaFE1bay3DM/QtaLsVB14SGSf+KlFz
13CQTSAcMKbdUUan6DH4LTEzbUVphaJcmUCU5npCCw4Q1i9iSjBB5MZeAmpGui4A
MIV7OVOEacE=
=A/og
-----END PGP SIGNATURE-----

--gJNQRAHI5jiYqw2y--
