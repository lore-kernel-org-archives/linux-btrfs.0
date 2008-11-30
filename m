From: Chris Samuel <chris@csamuel.org>
Subject: Re: compile error on Ubuntu 8.10
Date: Sun, 30 Nov 2008 22:38:31 +1100
Message-ID: <200811302238.35625.chris@csamuel.org>
References: <1227684613.19460.99.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2048770.irzKz9uu2I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1227684613.19460.99.camel@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2048770.irzKz9uu2I
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 26 Nov 2008 6:30:13 pm Gabor MICSKO wrote:

> on the recently released Ubuntu 8.10 "Interpid Ibex", i get the
> following error messages:

If you're compiling against the 2.6.27 kernel in Ubuntu I think you'll need=
 to=20
use the standalone git tree instead:

http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable-
standalone.git;a=3Dsummary

See Chris's email of the 20th:

http://kerneltrap.org/mailarchive/linux-btrfs/2008/11/20/4179304

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart2048770.irzKz9uu2I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASTJ7O41yjaOTJg85AQKQQwgAvTtdNjCPld+CbnK1RFHzBMtDHE3E1F6c
65rP6x38i6CjxqgzOKQKvHITvDVh60nVmSy6+S7FCTZf9jxedQEnt21DqBsEcV51
RvIn6frBvJV6+AJR0KcM5Xe13HtHWPK2UvelGRudRf9MOFrrdzsB3lqqBtFL9siK
AH0PTi57hzIR+c5wjxTQKvDq2d0G4/Q01n6p+IHMooPO7mAw40cF0JfNhmIJaytn
Y9Ot++I0jVC8gZkMuEa4Nd/SygPJQSNcuB3IlZI3GkDT5PJOzqBMfqDj6bG+l9Y6
zvgfO97hQpZNrdMGMXmn8agNcxJC5RqERtC0jZS6CTIsnv8atOfnPQ==
=K0rA
-----END PGP SIGNATURE-----

--nextPart2048770.irzKz9uu2I--
