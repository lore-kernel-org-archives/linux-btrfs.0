From: Niklas Schnelle <niklas@komani.de>
Subject: mv across subvolumes temporarily needs a lot of space
Date: Fri, 21 Jan 2011 00:40:48 +0100
Message-ID: <1295566848.7321.5.camel@mercury.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Izoef8v8csp2jbBolH3a"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-Izoef8v8csp2jbBolH3a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I was just moving a 40 GB directory across subvolume boundaries, that is
/mnt/extern/mac to /mnt/extern/backup/homes/mac backup being a
subvolume.
I noticed that df will start to show more used space (starting at 130 GB
going slowly to 165 GB for the whole disk) then shortly after the
operation is done it will show 130 GB again.
So I was wondering will I always need as much as 80% of free space
available to move some big directory or is it just wrong information by
df?
Greetings Niklas

--=-Izoef8v8csp2jbBolH3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJNOMf7AAoJEDAdc1vlpxWMv9wIAI3wPYYGvcMsdWcMC7E21W+X
n4yk/EQ/ND3+yDlen5Lx+m5AeHmk3bXyoN6/Qn7rvCHHa73H6iKetSmZ7eDVl3Ur
S+0hljfmQa6VzNsIewvmQtFB6D1vC99qDWbE3YL6sXvP6ivktaKru8BnUbN+q9DN
qCtrXbIZK0OOWwljHY8yyVl5nKZfMGfdaNmUqV6N1+AbYC1aAep+wC9yJP6AYbHZ
Om0f0PIF8UQGapgod+Mp3EV5Nf/djWmL9JXeGnl2AItdTrkpYxYHkL+Huf+YmD2D
pumNWvq8ZUJMOVKsJ/Y+M1D8zHybBOmz9pUWAXfijQ+KXtfXKbu7TQ9rTlhLyvo=
=TFN/
-----END PGP SIGNATURE-----

--=-Izoef8v8csp2jbBolH3a--

