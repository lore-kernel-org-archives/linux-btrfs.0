From: Chris Samuel <chris@csamuel.org>
Subject: Re: Bonnie++ run with RAID-1 on a single SSD (2.6.29-rc4-224-g4b6136c)
Date: Tue, 24 Mar 2009 21:41:32 +1100
Message-ID: <200903242141.32323.chris@csamuel.org>
References: <200902132331.12928.chris@csamuel.org> <1234535171.17533.9.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1314145.L8YPE0I48b";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234535171.17533.9.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1314145.L8YPE0I48b
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 14 February 2009, Chris Mason wrote:

> On Fri, 2009-02-13 at 23:31 +1100, Chris Samuel wrote:

[Bonnie++]
> > This is on a Dell E4200 with Core 2 Duo U9300 (1.2GHz), 2GB RAM
> > and a Samsung SSD (128GB Thin uSATA SSD).
>
> Thanks for posting these, it is especially good to see the metadata ops
> are still fast on this ssd.

Not a problem - sorry for the delay in responding.. :-(

> So, btrfs is doing ~28MB/s writes while writing the data  twice and XFS
> is doing 62MB writing it once.  That's not too bad really.

Yup, I'm very happy!

> But, one important thing about the ssds is they stripe internally across
> a bunch of flash storage, and then they have the FTL managing all the
> writes.

Ah...

> So, if you make two partitions on a single device, a raid1 data write
> from btrfs is very likely to result in two large IOs, which the FTL very
> well might put directly adjacent to each other on the SSD.

=2E..yes, I can see that could well happen.  Bugger.. :-(

> Duplicating the data does make it more likely you'll recover something
> if the device goes bad, but two devices are still safer than one.

Yeah, but pretty hard to do in a very light laptop!

> I'm not saying the test isn't valid, I just want to make sure people
> reading the list don't run off and partition their ssds in hopes of
> getting raid ;)

Agreed - I'm just hoping to be a bit safer than not having it.. ;-)

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart1314145.L8YPE0I48b
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUASci43I1yjaOTJg85AQKKLggAkTT3oPa7vlD96vs0i6dIRqbJOab3Iuxm
dLVjDWEeDwEih7SrH0o5V4pqYyHTLaMloASQI7Ix37LC4nNxG/4vKLMQEmAmBoFy
O+84UhSIxAhyBLsaxoF3/mcjHvRO5IpUbhzTZs/RaWu9RqoXEncPLgdy2ZvZU3pG
EkI2eYgwZAkEr/XgBKuXTKjLOkc2SiKWzlQ2AWZjjBP4BouYDtI+iv+r1aU+qm7N
LSdyzGovgZvtgzZRGU2XO1PeQbQlu6vWvr3o7Pe4INEqSPwRySlKO5PezIHheiAB
qZATPOp8PgW7N3DwKN14I4pDwhGr65+eP1nlOzHx+WVje5UW44cI/w==
=LJPx
-----END PGP SIGNATURE-----

--nextPart1314145.L8YPE0I48b--
