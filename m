From: Mck <mick@wever.org>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Mon, 18 Jul 2011 17:37:18 +0000
Message-ID: <1311010638.6713.5.camel@localhost>
References: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D4kxStrZlsNzpQf6+UOq"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Nirbheek Chauhan <nirbheek@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-D4kxStrZlsNzpQf6+UOq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-06-07 at 04:28 +0530, Nirbheek Chauhan wrote:
> Every few minutes, (I guess) when applications do fsync (firefox,
> xchat, vim, etc), all applications that use fsync() hang for several
> seconds, and applications that use general IO suffer extreme
> slowdowns. iotop shows various combinations of the processes listed
> below doing writes, and the total write as 2-3MB/s.=20

I have experienced this too. It /seemed/ to help removing a lot of
snapshots (i have hundreds that i didn't really need).

Would it be stupid to try disabling fsync like described at=20
 http://ubuntuforums.org/archive/index.php/t-1103926.html ?

I don't know of the consequences... but it would prove your theory?

~mck

--=20
=E2=80=9CDon=E2=80=99t worry about people stealing your ideas. If your idea=
s are any
good, you=E2=80=99ll have to ram them down people=E2=80=99s throats.=E2=80=
=9D - Howard Aiken=20
| http://semb.wever.org | http://sesat.no
| http://tech.finn.no       | Java XSS Filter

--=-D4kxStrZlsNzpQf6+UOq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk4kb04ACgkQkdPrePiuutOmigCfQBBRXSIstsbUvZ4CXgFAws+m
WKgAnj5Ee5+y8lyQP4IXZrTjbM4+BBAx
=B6Ko
-----END PGP SIGNATURE-----

--=-D4kxStrZlsNzpQf6+UOq--

