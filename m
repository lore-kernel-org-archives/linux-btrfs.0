From: Chris Samuel <chris@csamuel.org>
Subject: Re: [Btrfs-devel] [patch] O_DIRECT: fix the splitting up of contiguous I/O
Date: Sun, 5 Sep 2010 22:56:08 +1000
Message-ID: <201009052256.12386.chris@csamuel.org>
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com> <20100902142501.GA14932@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3814862.Uf0HDgYkgA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	"btrfs-devel" <btrfs-devel@oss.oracle.com>,
	Andrew Morton <akpm@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100902142501.GA14932@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3814862.Uf0HDgYkgA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Sep 2010 12:25:01 am Christoph Hellwig wrote:

> Andrew, can you please send this on to Linus and -stable ASAP?
> It's causing massive problems for our users.

Did this patch get dropped ?   I don't see it in Linus's git..

https://patchwork.kernel.org/patch/119333/

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart3814862.Uf0HDgYkgA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATIOTaY1yjaOTJg85AQIdWAf+PyOtvyZrLrZ2dWaI4/gRgKeadsxp6Mb6
Gc3wUhwUTeb/ZrVtrRQsAashDHYyLK/BNj5b+v36Z5vBMqqNps/0/+bqK+1uqpHz
rIdqJU5OdL16b8vKKu8MKhTsGzJckec7j302houg9s+xSRBVX8B+urP4ygcHHBhU
FonKoqMpwybtFeyJxRetOsOT3SC69LrqWP0zrd91XiwCuAoehHhn9aiyajveGn0I
mHg+hOx236Bkmw77vp7f+XFQwaoFuZMzxH+fuf0PzLwlmGYTINlBJy5RxCLY4QQt
mnoGj6G4Nc9wlcPwTMLRAtaHG0xD7jrYA0oXdtQnBV7z/0T8SpV3EA==
=sTOa
-----END PGP SIGNATURE-----

--nextPart3814862.Uf0HDgYkgA--
