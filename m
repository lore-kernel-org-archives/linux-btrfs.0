From: Bruce Guenter <bruce@untroubled.org>
Subject: Check snapshot delete progress?
Date: Thu, 1 Sep 2011 15:32:30 -0600
Message-ID: <20110901213230.GA456@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Is there any way to monitor the progress of outstanding 'btrfs subvolume
delete' commands?  I realize that figuring out when they complete is
somewhat non-linear in nature given the tree structures involved, but
even some information about forward progress would be useful at times.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJOX/nuAAoJEFFRvcnBTTxnsdAP/0G7m0eVB8JL9XnttMFYLxuk
XGGvJplCdjGp/st3yL+NfmjKQL1p2Cv91JLqAyAjy9jBGGltCNZuWVHrzs89aRaP
PoqK5R8lzmKjrQpHWAWtNgGbbAhm00W8TcChNGyITFWlpdx8uEsv3Mn8L/P6pTs4
tdhgl9E3NPa283hHIuXoM5J4JtXbqyQy53q7JQBb8UanHWpCczLYdS/XcmKEcNC1
ckWGnvMkoI3j2MVmXiN20I5lJg0Y9dQIOHicXAQCMoGWST7MfrIOteTrAOMwxFJB
hV4QwMJ1pE618GxWbbVdRhaqV90XN/u4UhlMat2OIRXxG2rfvQ5qm6uXTG/hvDsw
I/c+8o4uZ5ckokgVZQrJlLeZXZyW20z/CuTnGhvBtUB/gvzttdKmtieONgGZq0v6
4cLsP1JU4YXldXmFmuaR4ocOTdr/zZlP58xS7H5qEb1FiCBLdhfj18UViD4310zu
MLoQEmqk2t4v/8KssT4L6cCi/iFOjzrAp5dUiPI7hUDcgBibVpsozW7uNWD6Esag
LduW9Kep1Aa4hS0x2t0cdqp7TUpIt/DTFM7GR4J7vlq2CO/Vg52V+NOEORcrBMPi
iUUvWtV2bLwWRT9R8spvOeBbHl1UBGtChf9sTaA9Ae+aeWmqRPEMvjmX5Ce/61LR
8kEam6qgI6SPqpseL8c/
=5q0s
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
