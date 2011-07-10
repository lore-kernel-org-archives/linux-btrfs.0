From: Chris Samuel <chris@csamuel.org>
Subject: Re: TRIM support
Date: Sun, 10 Jul 2011 18:33:28 +1000
Message-ID: <201107101833.31450.chris@csamuel.org>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com> <1309635918.3774.7.camel@nayuki>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2977095.WJ55d2GMuM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1309635918.3774.7.camel@nayuki>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2977095.WJ55d2GMuM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Jul 2011 05:45:17 AM Calvin Walton wrote:

> The discard option is not currently automatically enabled; I think
> there may have been some performance issues in certain cases with
> drives that have slow trim implementations. But feel free to give
> it a try.

This LWN article from 2009 explains why it can be problematic
(especially on SATA drives where TRIM is a non-queued command):

https://lwn.net/Articles/347511/

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2977095.WJ55d2GMuM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAThlj2I1yjaOTJg85AQIScgf/TwFoMKdvq2QU1rr9ZyP99vJH6VmQWVhz
JO/pvz7Qzd7JV55vxhJwoWNmqDREEvtWD2VPJ/SmS/KG2S1izH1tyGsJJBHA13mf
XORooJa+1SwT4C39etIP9kjrZLaukB+g1xh2fEUf5ISohLPiOcTHrW94bG3hd07X
3tbLGQNALkqy5ED7wA5zVnV1pQbLgMfacbTO4u5HV/+KVo5YQKyarHr8oVfsIZLG
ODvZ4m3BRtTFVPPRRIjlzsKRMwSK85s8v8nRLPVIfHXG0ePYkS5uaW216CuKkzZA
AYRCaGnTYl1FurSgjFRVAPt+2X6Zi1jMnmRtdkjPb7jUndjv/l33tg==
=TOB3
-----END PGP SIGNATURE-----

--nextPart2977095.WJ55d2GMuM--
