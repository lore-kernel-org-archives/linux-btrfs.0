Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbdLBA2D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 19:28:03 -0500
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
Date: Sat, 2 Dec 2017 08:27:56 +0800
MIME-Version: 1.0
In-Reply-To: <20171201161555.GA11892@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WrPVO3Q5QWAFKxqDjClS0Uejsu1s60qqw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WrPVO3Q5QWAFKxqDjClS0Uejsu1s60qqw
Content-Type: multipart/mixed; boundary="4Gnpc0ahbt42XqllTvp8P8PJrVUqtC1iv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
Message-ID: <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
In-Reply-To: <20171201161555.GA11892@polanet.pl>

--4Gnpc0ahbt42XqllTvp8P8PJrVUqtC1iv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8802=E6=97=A5 00:15, Tomasz Pala wrote:
> Hello,
>=20
> I got a problem with btrfs running out of space (not THE
> Internet-wide, well known issues with interpretation).
>=20
> The problem is: something eats the space while not running anything tha=
t
> justifies this. There were 18 GB free space available, suddenly it
> dropped to 8 GB and then to 63 MB during one night. I recovered 1 GB
> with rebalance -dusage=3D5 -musage=3D5 (or sth about), but it is being =
eaten
> right now, just as I'm writing this e-mail:
>=20
> /dev/sda2        64G   63G  452M 100% /
> /dev/sda2        64G   63G  365M 100% /
> /dev/sda2        64G   63G  316M 100% /
> /dev/sda2        64G   63G  287M 100% /
> /dev/sda2        64G   63G  268M 100% /
> /dev/sda2        64G   63G  239M 100% /
> /dev/sda2        64G   63G  230M 100% /
> /dev/sda2        64G   63G  182M 100% /
> /dev/sda2        64G   63G  163M 100% /
> /dev/sda2        64G   64G  153M 100% /
> /dev/sda2        64G   64G  143M 100% /
> /dev/sda2        64G   64G   96M 100% /
> /dev/sda2        64G   64G   88M 100% /
> /dev/sda2        64G   64G   57M 100% /
> /dev/sda2        64G   64G   25M 100% /
>=20
> while my rough calculations show, that there should be at least 10 GB o=
f
> free space. After enabling quotas it is somehow confirmed:
>=20
> # btrfs qgroup sh --sort=3Dexcl /=20
> qgroupid         rfer         excl=20
> --------         ----         ----=20
> 0/5          16.00KiB     16.00KiB=20
> [30 snapshots with about 100 MiB excl]
> 0/333        24.53GiB    305.79MiB=20
> 0/298        13.44GiB    312.74MiB=20
> 0/327        23.79GiB    427.13MiB=20
> 0/331        23.93GiB    930.51MiB=20
> 0/260        12.25GiB      3.22GiB=20
> 0/312        19.70GiB      4.56GiB=20
> 0/388        28.75GiB      7.15GiB=20
> 0/291        30.60GiB      9.01GiB <- this is the running one
>=20
> This is about 30 GB total excl (didn't find a switch to sum this up). I=

> know I can't just add 'excl' to get usage, so tried to pinpoint the
> exact files that occupy space in 0/388 exclusively (this is the last
> snapshots taken, all of the snapshots are created from the running fs).=


I assume there is program eating up the space.
Not btrfs itself.

>=20
>=20
> Now, the weird part for me is exclusive data count:
>=20
> # btrfs sub sh ./snapshot-171125
> [...]
>         Subvolume ID:           388
> # btrfs fi du -s ./snapshot-171125=20
>      Total   Exclusive  Set shared  Filename
>   21.50GiB    63.35MiB    20.77GiB  snapshot-171125

That's the difference between how sub show and quota works.

For quota, it's per-root owner check.
Means even a file extent is shared between different inodes, if all
inodes are inside the same subvolume, it's counted as exclusive.
And if any of the file extent belongs to other subvolume, then it's
counted as shared.

For fi du, it's per-inode owner check. (The exact behavior is a little
more complex, I'll skip such corner case to make it a little easier to
understand).

That's to say, if one file extent is shared by different inodes, then
it's counted as shared, no matter if these inodes belong to different or
the same subvolume.

That's to say, "fi du" has a looser condition for "shared" calculation,
and that should explain why you have 20+G shared.

Thanks,
Qu


>=20
>=20
> How is that possible? This doesn't even remotely relate to 7.15 GiB
> from qgroup.~The same amount differs in total: 28.75-21.50=3D7.25 GiB.
> And the same happens with other snapshots, much more exclusive data
> shown in qgroup than actually found in files. So if not files, where
> is that space wasted? Metadata?
>=20
> btrfs-progs-4.12 running on Linux 4.9.46.
>=20
> best regards,
>=20


--4Gnpc0ahbt42XqllTvp8P8PJrVUqtC1iv--

--WrPVO3Q5QWAFKxqDjClS0Uejsu1s60qqw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFKBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloh84wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjD4wf42m+UGo3vlfIbQdet91KyN0ul
o0V3Q1A0eJKU9NKEb9e7ilcjaBZi5FvMFgfqoOuvww3C826z1VdT3xlWgXCWef1P
ZPHi1yE77F1VjgY3jO8n2flewQ7n5mR55KYWbgsvNOZCOsSRdazP9iff0C17LMLQ
vl9IT2TPVGGUjYbZZs7Wip08pzQUCJ615xd6W1S/iiDWl2juXJA8P5qwgLn1Ir/n
DEDNy7NMJCNTT73Uog0JfT5nBqHrYQYO9z6URmuVySQxv92rtuM4n9dUFb3H4dOj
422F+T194ZMe/njXhccC8NnrhmT0lnGZIafeNDRioJEUREYtYMcieWlSZ/EJ
=q2OZ
-----END PGP SIGNATURE-----

--WrPVO3Q5QWAFKxqDjClS0Uejsu1s60qqw--
