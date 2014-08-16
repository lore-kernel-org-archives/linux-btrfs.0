Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:49688 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaHPNZG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Aug 2014 09:25:06 -0400
Message-ID: <53EF5B9A.5090407@dergleichrichter.de>
Date: Sat, 16 Aug 2014 15:24:42 +0200
From: Justus Seifert <justus.seifert@dergleichrichter.de>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Limitation of nocow set via chattr +C?
References: <CAH-HCWUonzQ0ynToWOf3FBayUVWbwcx6JZsAN+OXfCpo0RjDZg@mail.gmail.com>
In-Reply-To: <CAH-HCWUonzQ0ynToWOf3FBayUVWbwcx6JZsAN+OXfCpo0RjDZg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uKFQLjec8cXackmkHmUFT6CBu1aB6ftFL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uKFQLjec8cXackmkHmUFT6CBu1aB6ftFL
Content-Type: multipart/mixed;
 boundary="------------040606000809010706050805"

This is a multi-part message in MIME format.
--------------040606000809010706050805
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 16.08.2014 12:15, Shriramana Sharma wrote:
> [=E2=80=A6]> So nocow via chattr +C only means "don't do COW unless thi=
s file
> exists in another snapshot", right?

yes


--------------040606000809010706050805
Content-Type: text/x-vcard; charset=utf-8;
 name="justus_seifert.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="justus_seifert.vcf"

begin:vcard
fn:Justus Seifert
n:Seifert;Justus
adr:;;;Dresden;Saxony;;Germany
email;internet:justus.seifert@dergleichrichter.de
tel;cell:+4915730640509
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------040606000809010706050805--

--uKFQLjec8cXackmkHmUFT6CBu1aB6ftFL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT71ubAAoJELFJh75Z+IvIaHUP/0ztB3Rd5ffbsdjtc7h+cVVv
6MiSfIabTzY45UGYRWDeLnMg/ajFInztdxvMBQ8hU846TZK5fzHAr5mwvt5+6uLG
wo5KMm11z7m9Ox6Jzd4TeLkRXYipZweVIZqit8WbTmVjkD4e7urE7JnULhLaUbiR
1+/Iah+nt/xKQTIqY0Bb0rF51usb49sTot7yTjc1JjCQf7RMr7EZpYV3gkQWPohP
0rRiuoYjXPNCMkibIwdoLh/9ZP6QUifS2e58QJhNEq49mxCnUIDls3ILI9X5Hm6X
AwpdeTk2iZRixlr71rjxXUSZKkYe6UKg6eOlgDAaPUxopMY+8Pkb3Vt6QEmm6Jww
d5KY4bB+UyHfHh1OEMZNXgUWworUBI5ifcx0CK9GOyORd4fQN2eS9cdvnP9XrmVy
3EdVh7MLIX1hGO3P4Z6jG0K6Ubu9GYSIga1r9ajM7Ym4fS1Z7HDRb1Oj1F7ye+W/
ZnldD9fJxkwGvij02z30ytCnhPOOIfyPjc7wvXKLK4IeQMev9d545wsuVlWO3gvQ
DuiSFs4bVlRxrcRBiVhM4SUd6O3pJL2XRkmvVU8BwTy2hD5HqhIxrSMgONYwjxRX
fCmO15nSqI4/Wjb04IITFhRK2AvG4pZahg9E63MwjrMA4AfuG+gnabnyXmY3R600
MmYB2rp1prexuC2WYPCv
=jFOy
-----END PGP SIGNATURE-----

--uKFQLjec8cXackmkHmUFT6CBu1aB6ftFL--
