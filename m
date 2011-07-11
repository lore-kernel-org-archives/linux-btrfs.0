From: Chris Samuel <chris@csamuel.org>
Subject: Re: TRIM support
Date: Mon, 11 Jul 2011 15:53:13 +1000
Message-ID: <201107111553.17293.chris@csamuel.org>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com> <CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com> <CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7805707.pKaGZCQ3dB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart7805707.pKaGZCQ3dB
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jul 2011 07:59:54 AM Fajar A. Nugraha wrote:

> Sandforce-based SSDs have their own way of reducing writes
> (e.g. by using internal compression), so you don't have to
> do anything special

Not just compression, but also block level de-duplication too
(i.e. potentially removing the redundancy of btrfs's duplication
of metadata for safety).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart7805707.pKaGZCQ3dB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAThqPyY1yjaOTJg85AQLKyQgAsn+SbnACFPNQBueGtYGsj5zCTSKe6tfG
OzTUno6vTBELURqddaf3Y3Y5vyLk5nHnbQ0xMJaLYu/qQn0Kp/rUD9poyHnLNJxj
05WeNvjVWwz3REKdzxZL505qLYlWDdMjNI73Pjjplu4+kp2xp7/YHFtvYSHmRqQq
t92b4GxykqEm9HoKSmrqNPhhO5WspsZjOtqkgvRXTZ6O72UjhcXjW7sZfF0pjIPZ
bpDIAybHD/22ZmS5WahRHLKnm4zXcDhumBKqOlDXERncyeGSgZKMhY2STZTgzJmm
SmVa6EGzB+m14mWje4pV+edbbPHxLG4eq4Y1H8tFcS9Ia9SZaLqNWw==
=fPvG
-----END PGP SIGNATURE-----

--nextPart7805707.pKaGZCQ3dB--
