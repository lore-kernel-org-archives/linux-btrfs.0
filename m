From: Chris Samuel <chris@csamuel.org>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Thu, 16 Feb 2012 21:31:35 +1100
Message-ID: <201202162131.38463.chris@csamuel.org>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com> <CAFDW0jLfLtEpnijsratvGho8RzC9D7nJD8H2y0SdZ6AxYeGpYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1410197.UbgOHglJpB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAFDW0jLfLtEpnijsratvGho8RzC9D7nJD8H2y0SdZ6AxYeGpYw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1410197.UbgOHglJpB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 16 February 2012 19:06:52 Ahmet Inan wrote:

> and got ENOSPC again :(
>=20
> so it doesnt matter if lzo or zlib: ENOSPC with compression
> enabled!
>=20
> my kernel: vanilla 3.2.5

I know that there has been an ENOSPC fix go in to the 3.3 RC kernels=20
since the 3.2 release, any chance you'd be able to see if it still=20
happens with the current 3.3 RC ?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1410197.UbgOHglJpB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATzzbCI1yjaOTJg85AQLdtQgAmn4UglHEUhxOg+tVH+Rrd6OevsKtD01x
3BlW/HKmX9ZboEGxiPlPWQx295sDOpQttGCFX0Fo6u+0mvT/6WtVrNzTm2XmcXQV
SaqAA6PcwUk+D4MRBCk5MbFeg0iDThm9+JrGcJv6vw94PyZS7M/hw8EqZa7CtUAx
KX5UrkPDZZkI4KNmG9cMC6yh/82A9TzjxF3K2L6pQOHGytlLP9GcLqg8oj8xEwYg
ZLKc4JE3INm1dnnJMJRt0DEIqd4TLveqVqsVpQSDWRZjMj4tZjX1XlQdR9CRJfiu
1jgXN05Zp1lKF35qMjtIEcfd1QI1vZ6MSEFLpnxk2jTgdm7+Jw7lvA==
=M8t8
-----END PGP SIGNATURE-----

--nextPart1410197.UbgOHglJpB--
