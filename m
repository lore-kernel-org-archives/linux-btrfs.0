From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: btrfs vs data deduplication
Date: Sun, 18 Sep 2011 23:01:31 +0200
Message-ID: <1316379701.27066.10.camel@picard>
References: <CACVpCE7ZSjgT9+h2DfHAR_n=4LqHguOSVaNzE3YcnZ5Bb00_Kw@mail.gmail.com>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-g5cR+Q8+VntvReUgs1IJ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACVpCE7ZSjgT9+h2DfHAR_n=4LqHguOSVaNzE3YcnZ5Bb00_Kw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-g5cR+Q8+VntvReUgs1IJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-07-09 at 08:19 +0200, Pawe=C5=82 Brodacki wrote:
> Hello,
>=20
> I've stumbled upon this article:
> http://storagemojo.com/2011/06/27/de-dup-too-much-of-good-thing/
>=20
> Reportedly Sandforce SF1200 SSD controller does internally block-level
> data de-duplication. This effectively removes the additional
> protection given by writing multiple metadata copies. This technique
> may be used, or can be used in the future by manufactureres of other
> drives too.
>=20
> I would like to ask, if the metadata copies written to a btrfs system
> with enabled metadata mirroring are identical, or is there something
> that makes them unique on-disk, therefore preventing their
> de-duplication. I tried googling for the answer, but didn't net
> anything that would answer my question.
>=20
> If the metadata copies are identical, I'd like to ask if it would be
> possible to change this without major disruption? I know that changes
> to on-disk format aren't a thing made lightly, but I'd be grateful for
> any comments.
>=20
> The increase of the risk of file system corruption introduced by data
> de-duplication on Sandforce controllers was down-played in the
> vendor's reply included in the article, but still, what's the point of
> duplicating metadata on file system level, if storage below can remove
> that redundancy?
>=20
> Regards,
> Pawe=C5=82

Hello,

Sorry I add my 0.03$. It is possible to workaround it by using
encryption. If something other then ebc is used the identical elements
in unecrypted mode are stored as different on hdd.

The drawbacks:

 - Encryption overhead (you may want to use non-secure mode as you're
not interested in security)
 - There is avalanche effect (whole [encryption] block gets corrupted
even if one bit of block is corrupted).

Regards

--=-g5cR+Q8+VntvReUgs1IJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOdlw1AAoJEJIdee2Vr4aPpsgQAJyqr1624r4SoQIvfmdfhWZm
R/u9i29xsAtgMCe8oAbpXCYXP1GAhWr9TNo1bca3cZh1b2TzW9H7ZU/syElE6uiL
VFDJx/rGFk6iIIPkiq99LAuR2eBKYY+pR7zBFBD2QBDyrZtCONdkBnrrqLTX5u3a
g5LpY0JHZLiOUP2oRs5qolx4aJb5I9hxaZRwnzlBNXG0Mi1HrGzJ/1a/sv814zZk
QQFP1pk1kucx7bXvgIPZFEjFwYvWrIjrolT2W0FFLDO5QBBhzZiTFYnaczVTG2jo
wxikYQXanhtlTQxQsn9QeP+nUkgtnbMeOOo0Yep7mOroQFXQU5vjQvBdub0Ai6WF
ZdZR041pZWX1zP35cATEbNRDkys+8xYOMowfJM5Ud1KPzrTdKtFfuWKVQB/o5Wpd
vPnc8HrkGvIK51oYRk5scku7PzdY/9zNuYFO868WnOC2wgEX+O+6vwK+SVeR0WRR
W1CLOsq/aaqXsC12vRWqQldmBVQULzSlvEYjZ0rWNGe1nsOOskNLaI9K0pFEUwn9
0wthtVDbgcY0gwxDbL/hNR/Qwx9esZGjDvqvEjBRmwr84Fqqz//McSD7MVj5R/JK
D+NzCS3xeunTw8vfvesK9Sc54lAke2XJL/6l79OxQEGZ8DLUN9kWY8YscPbapFaf
tImHR46k1v+QTUuknbSk
=TNPa
-----END PGP SIGNATURE-----

--=-g5cR+Q8+VntvReUgs1IJ--


