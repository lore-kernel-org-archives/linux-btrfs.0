Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41854 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbaGOKBc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 06:01:32 -0400
Date: Tue, 15 Jul 2014 11:01:25 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS claims that empty directory is not empty and refuses to
 delete it
Message-ID: <20140715100125.GA4834@carfax.org.uk>
References: <5988448.153L8540y0@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
In-Reply-To: <5988448.153L8540y0@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 11:09:53AM +0200, Martin Steigerwald wrote:
> Hello!
>=20
> This is with 3.16-rc4 =E2=80=93 stepped back to this one after having two=
 hangs in one=20
> day with 3.16-rc5, see other thread started by me:
>=20
> martin@merkaba:~/Zeit/undeletable/db_data> ls -lid akonadi
> 450598 drwx------ 1 martin martin 1232 Jun 22 14:11 akonadi
> martin@merkaba:~/Zeit/undeletable/db_data> ls -lai akonadi=20
> insgesamt 0
> 450598 drwx------ 1 martin martin 1232 Jun 22 14:11 .
> 450595 drwxr-xr-x 1 martin martin   14 Jun 22 14:11 ..
> martin@merkaba:~/Zeit/undeletable/db_data> LANG=3DC rmdir akonadi
> rmdir: failed to remove 'akonadi': Directory not empty
> martin@merkaba:~/Zeit/undeletable/db_data#1> LANG=3DC rm -r akonadi
> rm: cannot remove 'akonadi': Directory not empty
> martin@merkaba:~/Zeit/undeletable/db_data#1> LANG=3DC rm -rf akonadi
> rm: cannot remove 'akonadi': Directory not empty
> martin@merkaba:~/Zeit/undeletable/db_data#1>
>=20
>=20
> Whats this?
>=20
> I had this weeks ago already and just moved it out of the way at that tim=
e,=20
> just now stumbled upon it again.

   That is symptomatic of a bug from a couple of kernel versions ago
(now fixed, so it won't happen again). It it is that bug, then btrfs
check will report something along the lines of "directory isize
wrong", and the problem can be fixed by running a btrfs check
--repair. If you get anything else from btrfs check (or it checks
cleanly), then let us know first.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If you see something, say nothing and drink to forget ---     =20

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU8T79VheFHXiqx3kAQIb0A/9HoG2ifzWFqWPxz49NtAMzbRK2WabbsLu
Vd33CvtsiK3qDKC3XHGF39tij06FwQ1I9iDhH3NXf0/9Gs+iFH7Ic2Ll7NG9MqCJ
rZiv/5pdJ8leNVv3oFQBUHQhWF8S7gLTHin55JrKZft3Fa/FY2y6fTdXEK6nCHVe
2RWV7Y5bjuNjLqAfbj8uCrURoeVRcoW9Ec09RyP00vwaWys11YickKREhhzzf+vq
aP1/MQ6bwdiyZ5Oe5ltFMzKrN1nt7KqCTA1KpbkfJnc4hT04/utiCQY7T3iQ/o7X
hTNayR+UdClRz2M/LUxWZRavE4pF3uRx6nZ16nUi0OmtGCEsYnRWNBBbGPKo7CdS
SovlsOPbR61aobtrBC3OL3z7anKVrY/LdFiySNuN937qGpl8I96iWRtbu+ACdQ3B
CfJCAS0JkxvXhDTZuTVesWF9Wke+ttbsArux7NtdF1f6yMjur2fgsfDrunX7sD/6
RQsw+GVhmC6TdjEz106CBWzbtQAjhoUvzebL+/ROO18lG9YHQL1vR6Ubj4PtQ88O
wfMX3VQltJG9lPbOpIh04inefSQYMU+SGL8jN3csKwfyVpuR0j1TlVuaCLZjqDqD
FAmo8FBu+avhG9aeXyEQVq0H5Tjh9PThxjZd/tI75mDoS8W8j4ea2tqt7KhLYjIg
uGlwY8iJYwU=
=4/fr
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
