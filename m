Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62815 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaJ0NGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 09:06:39 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: nocow and compression
Date: Mon, 27 Oct 2014 14:06:36 +0100
Message-ID: <2583846.rYj5NyAvhi@fb07-iapwap2>
In-Reply-To: <2878318.cpxBgqOiao@vajra>
References: <2033879.2EPALEPetI@fb07-iapwap2> <2878318.cpxBgqOiao@vajra>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2042627.TiDYiu6PFX"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2042627.TiDYiu6PFX
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Montag, 27. Oktober 2014, 13:59:24 schrieb Sw=E2mi Petaramesh:
> Le lundi 27 octobre 2014, 13:56:07 Marc Dietrich a =E9crit :
> > oops, no compression.
> > Is this intended?
>=20
> =AB Compression does not work for NOCOW files =BB is clearly stated i=
n
>=20
> https://btrfs.wiki.kernel.org/index.php/Compression#How_does_compress=
ion_int
> eract_with_direct_IO_or_COW.3F

ah, sorry, I somehow overlooked this.

Thanks

Marc
--nextPart2042627.TiDYiu6PFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJUTkNcAAoJEKyeR39HFBtotqYIAIMxNB4jz9keyds2IPfm+TU8
P6b6felU+/hZ/f3TYu56bQ/8IKWt/sheLp537/tUgGVdcIsnQx8z8fzVM76PUY0o
3aN2TI8QL/+znplJFC9wbVOGPK02SL3FkdaqtlvPdCULZEPVE9xiA5IN9GWXLVLL
JLZryAHlcsZYUMytT0azrYCpRoPGlMr03kNtLdO5EI7FFr+7Mt6UtM0hYSkKr3mT
7qnhF0fqMuhUUUijUFZ0MPtNwbUvsGBcgHwm3BQig7DpgTvx55uQ8Gnjwj5I2tyg
2TN/PTPqC9Q6WuMaxxlhpojPe0742/5cIoRmFuXPQOqNB8D819ZGNRAeQ1+UwlY=
=IFUW
-----END PGP SIGNATURE-----

--nextPart2042627.TiDYiu6PFX--

