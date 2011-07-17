From: Mck <mick@wever.org>
Subject: Re: corruption. notreelog has no effect? anything else to try?
Date: Sun, 17 Jul 2011 00:28:20 +0000
Message-ID: <1310862500.6144.4.camel@localhost>
References: <1310763102.3972.31.camel@ubuntu>
	 <CAG1y0sc-D1-5zkgsovtZG6emOc78GoZ64gQ1Lhufm=6Z3huEAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XF6nZ/8vXQOE78XFHQh2"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sc-D1-5zkgsovtZG6emOc78GoZ64gQ1Lhufm=6Z3huEAg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-XF6nZ/8vXQOE78XFHQh2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> does btrfsck -s1 complete without error?=20
> If yes, you can try btrfs-select-super.
> [snip]
> if there's something mentioning "log", I'd try btrfs-zero-log first.

`btrfsck -s1 /dev/sda4` gave errors too.=20
So i skipped to running btrfs-zero-log. It ran without errors.
But running btrfsck again still gave the same errors.

So i went back and tried btrfs-select-super...

# ./btrfs-select-super -s1 /dev/sda4
using SB copy 1, bytenr 67108864

After this i tried mounting and it worked for all subvolumes!
I am ever so grateful for your help Fajar.
=20
Unfortunately I didn't try mounting after the btrfs-zero-log so i don't
know if it or btrfs-select-super was actually the cure.

Knowing very little about zero-log and select-super should i continue
using my laptop like normal now?
Or is this filesystem still considered corrupt and i should backup and
format it all from scratch?


~mck


--=20
=E2=80=9CDon=E2=80=99t worry about people stealing your ideas. If your idea=
s are any
good, you=E2=80=99ll have to ram them down people=E2=80=99s throats.=E2=80=
=9D - Howard Aiken=20
| http://semb.wever.org | http://sesat.no
| http://tech.finn.no       | Java XSS Filter

--=-XF6nZ/8vXQOE78XFHQh2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk4iLKQACgkQkdPrePiuutP7/QCgyGyf8+soPha8z2a0FZf6Zvah
HGMAoM1qcgke9+h88DLTSAHHox4zG4Ph
=l7EP
-----END PGP SIGNATURE-----

--=-XF6nZ/8vXQOE78XFHQh2--

