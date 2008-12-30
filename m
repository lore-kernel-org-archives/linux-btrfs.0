From: Chris Samuel <chris@csamuel.org>
Subject: Re: A bug with multiple devices?
Date: Tue, 30 Dec 2008 23:19:35 +1100
Message-ID: <200812302319.38703.chris@csamuel.org>
References: <49597D06.1050806@cn.fujitsu.com> <200812302145.25796.chris@csamuel.org> <3d0408630812300335s4e7c6cf1x9a45ff187b80f83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2281575.XRr5xXY6u1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630812300335s4e7c6cf1x9a45ff187b80f83@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2281575.XRr5xXY6u1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 30 Dec 2008 10:35:17 pm Yan Zheng wrote:

> So it's difficult to compute the space in advance.

One thought would be to choose the most conservative RAID configuration for=
 the=20
number of devices in the system.   But then you have the opposite issue of=
=20
potentially showing too little space in some situations.

But my guess is that for most (>50%) people once they set a default RAID le=
vel=20
then most will have everything in that state.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart2281575.XRr5xXY6u1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVoR2o1yjaOTJg85AQImNAf+LDNVj+TDhsq9IMmymC4yYZmQGKIa7g7U
+Vq++mLN7EWMnhB8QZUEM7vhqmD+L7vr+fktG/c91bzWgjTZUS19Ctbe0kHDN4PP
6y3gRY3TYd5IUvw2iZisKpn+jOXVmUoMEUSW6UIh0TcZutsgPAq+N/SFIkN4+w+Z
NomfLezBPqgrpj9NG/Ezx34yUL+o+1vruT1iOnkMBSDh5DR2FdiH2UV5fK+JjNal
mCJ8/6RJTSyLiUkAFwsC7GHy28PZYAKqEjKmZXD/iZsq7fq7SAoadGya3KL+LSXE
VjnO/gaRDz6ztEaFDuDSAxqGB/ma9qQHnn+W3lU49NSL5UxWfPQZkw==
=QU3U
-----END PGP SIGNATURE-----

--nextPart2281575.XRr5xXY6u1--
