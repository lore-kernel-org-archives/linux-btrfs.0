Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:65136 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752993AbdL1Bxs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 20:53:48 -0500
Subject: Re: Hand Patching a BTRFS Superblock?
To: swestrup@gmail.com, linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
Date: Thu, 28 Dec 2017 09:53:42 +0800
MIME-Version: 1.0
In-Reply-To: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JWB1jP0Crk3Emr3XexvDmWJ3W6Oj1iABI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JWB1jP0Crk3Emr3XexvDmWJ3W6Oj1iABI
Content-Type: multipart/mixed; boundary="41kksSFpqsp8MyoUqC74TvnMEZ8y2TQIa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: swestrup@gmail.com, linux-btrfs@vger.kernel.org
Message-ID: <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
Subject: Re: Hand Patching a BTRFS Superblock?
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
In-Reply-To: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>

--41kksSFpqsp8MyoUqC74TvnMEZ8y2TQIa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 09:46, Stirling Westrup wrote:
> Here's my situation: I have a network file server containing a 12TB
> BTRFS spread out over four devices (sda-sdd) which I am trying to
> recover. I do have a backup, but it's about 3 months old, and while I
> could certainly rebuild everything from that if I really had to, I
> would far rather not have to rerip my latest DVDs. So, I am willing to
> experiment if it might save me a few hundred hours of reconstruction.
> I don't currently have another 12 TB of space anywhere for making a
> scratch copy.
>=20
> A few days ago sdb developed hard errors and I can no longer mount the
> filesystem. sdb is no longer even recognized as a valid btrfs drive.
> However, when I ran ddrescue over the drive I managed to make a clone
> (sdf) which contains all but 12K of the original drive. However, those
> missing 12K are all in the various superblocks, so the cloned drive is
> still unreadable.
>=20
> In the hopes that I was only missing a few bits of the superblocks, I
> started out by dd-ing the first 4M of sdd into sdf in the hopes that
> ddrescue would overwrite much of the superblocks, and the final bits
> from sdd would make things usable.
>=20
> No such luck. I now have a drive sdf which claims to be identical to
> sdd but which is a clone of sdb. In case it matters, sda and sdc are
> each 4TB while sdb and sdd are each 2TB drives; sde is my boot drive
> and sdf is a 2TB clone of sdb.
>=20
> What I need to do is to somehow patch sdf's primary superblock so it
> contains the correct device number and UUID_SUB for sdb, so that I can
> attempt some sort of recovery. Right now my linux is (understandably)
> quite confused by the situation:

Did you tried "btrfs rescue super-recover"?

Remember to use the devel branch from git, as there is a small bug
prevent it report correct result.

super-recover will try to use the backup superblock to recover the
primary one.

Thanks,
Qu

>=20
> videon:~ # uname -a
> Linux videon 4.4.103-18.41-default #1 SMP Wed Dec 13 14:06:33 UTC 2017
> (f66c68c) x86_64 x86_64 x86_64 GNU/Linux
>=20
> videon:~ # btrfs --version
> btrfs-progs v4.5.3+20160729
>=20
> videon:~ # btrfs fi show
> Label: 'Storage'  uuid: 33d2890d-f07d-4ba8-b1fc-7b4f14463b1f
>         Total devices 4 FS bytes used 10.69TiB
>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdd
>         devid    3 size 3.64TiB used 3.54TiB path /dev/sdc
>         devid    4 size 3.64TiB used 3.54TiB path /dev/sda
>         *** Some devices missing
>=20
> Any suggestions on how to proceed would be appreciated.
>=20


--41kksSFpqsp8MyoUqC74TvnMEZ8y2TQIa--

--JWB1jP0Crk3Emr3XexvDmWJ3W6Oj1iABI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpETqYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjAiwf+OBc32BFEbQWPFVlVNsjZUf1R
xj5rKS5bBwJHigGg9dYG+QxNuZvoVtgg6tG9PJFhN3LAhxSNDdy6MyUHtci3keWM
yuNL3eficoMlFS34iH23nsK5BOSMp25pPI9xxPZu2cC16F39pl/0nXC+AuzOV0ez
6zYwP2N04D3qTFh5rvnUvSxrl31uyAKh/WnnpIcXUxU61sZYJ9B+tmSCBCAAWKkb
PitHl9mA5t7KPWxUbwBxZNXvYu/oLNODorIceAJmkPThWXnPFRN5k6LlEHDr98D/
/sGr6Ds5rMNrBgaRFqBfAFxGJw96C7PUOTkTZKlXhdeQixYjxl7vqkYAhHMghA==
=xW/3
-----END PGP SIGNATURE-----

--JWB1jP0Crk3Emr3XexvDmWJ3W6Oj1iABI--
