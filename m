From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Inefficient storing of ISO images with compress=lzo
Date: Mon, 19 Sep 2011 01:32:44 +0200
Message-ID: <1316388769.2499.4.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-KSX7Rz0DnTCGZBShav/I"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-KSX7Rz0DnTCGZBShav/I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've noticed that:

 - with x86-64 Fedora 15 DVD install images:
   - du -sh <ROOT VOLUME> was 36 GB
   - btrfs df | grep -i data have shown over 40 GB used
 - without
   - du -sh <ROOT VOLUME> is 34 GB
   - btrfs df | grep -i data have shown less then 34 GB used

It seems that iso files are considered compressable while they may not be (=
and penalty is severe - 3x).

Regards

=20


--=-KSX7Rz0DnTCGZBShav/I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOdn+hAAoJEJIdee2Vr4aPqxkP/27anNkTpd5IWMVqycFXEm2p
pxpxTp3WlJ7czRS7YvLocC6oOlodNrlProxRl9ZOWIgAOP9an8aeznzW+Hfp5ola
Ldvjefp95k+JZtFXLy+fu+dS3501uyDp09dMEXr62c0yc2tdmSY77BoaDtDhsevi
y/geY/vnzvwS+3z4mHEt5DG29PttrDtWOkW/SFQmifZ4+Qz9thEft3+Pw5xxBnMm
10tNNh1+RBu5HwE0VjYdLTkrUmGDeZN7N1ZYvF9htMUTCpQnJ0czu7pKeuhigZqM
vcKHrEHt9GJNIy20LJRAO3KgVwBiknPgXQeyd7cxdNhD9k7je1z92G+sYg316wv1
WQXmpIKTgk+D1LPYuDJOSmPYdLgouCvOPzMj1ca7gp58qDGLWoWzvKZC0uOsbmeS
xjRnm2WNohl2+IyUcvlHF06xs3T0vrlQ7YnVqnOlX3JXzQJuI5DabpCMKXfQLtrx
agM6/nrd0Jw78INkdAddJvqFMv2cLl/zo4cFLcJaEvq+8ZYo7ZKatt0//gS1CCbD
I/fjlsoCsew7KLsiAYXEnN3ZpCAcIhDhjxxkKXinkO96F/qfmtV6jmwHO53uGvbo
uRexKLaqpig8IVYB8y6GTqRcLCPw06laHGivPZ6gGOzmEf6sNUVEBAjHcd9kMWIL
MI7UgJpGSrPZOFzRpW+f
=RC1t
-----END PGP SIGNATURE-----

--=-KSX7Rz0DnTCGZBShav/I--


