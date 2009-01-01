From: Chris Samuel <chris@csamuel.org>
Subject: Re: A bug with multiple devices?
Date: Thu, 1 Jan 2009 11:52:37 +1100
Message-ID: <200901011152.43405.chris@csamuel.org>
References: <49597D06.1050806@cn.fujitsu.com> <2c3b11250812301717q7d54a8cdt6417d32468ea2eee@mail.gmail.com> <495ACE31.3050209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1563067.qgIHiRCJgj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <495ACE31.3050209@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1563067.qgIHiRCJgj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 31 Dec 2008 12:43:13 pm Shen Feng wrote:

> The problem still exists with -d option.

As Chris Mason wrote in response to my query on this it's a known issue tha=
t's=20
a consequence of different chunks potentially having different RAID levels.

The RAID level itself does appear to work - I tested it by copying a kernel=
=20
image onto it, unmounted it, used debug-tree to work out the offset for it =
on=20
one device of the RAID and blew a section away with dd.  I remounted it and=
=20
verified that the MD5 checksums still agreed with the original and there we=
re=20
kernel messages complaining about checksum mismatches showing that the dama=
ge=20
had been detected and worked around.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart1563067.qgIHiRCJgj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVwT241yjaOTJg85AQKRsQgAkUxXsw3m+AqTUMyUWnPuI2PZfmOSm9sL
duZxgrbXYne3P+bMtu1R7A9dM9meERqauGuW5uK5I1rRHdfeyETlIFOKwHbMtbg+
7470HYpDFsLVVwbJ+/WqlUd6l74Dcd2TNWtr7nh9QkLQxUJag7fj08EjTgEKWODA
bQIPo1Ni9ejRNYmiIxHl8lGUWZpNuHgcREBfdMU/qkv9yuRqOr/70oZA3XEpr7uE
SoAX2I4pXvqlNKuhvVxmLUZFpxJlrmdE5H/s2UFp0nSd9ny6g3fqGBUqE4XmYhuV
s2S8J4Nzn8ql69dNNjNE+DSdN1NN3uZI+NatR6qLfl2GUMIQML6VIA==
=FKDg
-----END PGP SIGNATURE-----

--nextPart1563067.qgIHiRCJgj--
