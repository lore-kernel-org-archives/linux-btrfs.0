Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50474 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbeAPLVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 06:21:25 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
References: <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
 <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
 <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <acf4b795-0fb9-c9c8-63a9-5d888afa9419@gmx.com>
Date: Tue, 16 Jan 2018 19:20:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4GR9wOFLsmbIi8Bi6zpMx7BlEs8faS5K5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4GR9wOFLsmbIi8Bi6zpMx7BlEs8faS5K5
Content-Type: multipart/mixed; boundary="Lae5wHvcjD3pfrspveIXyRM86lQuCV5gE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Message-ID: <acf4b795-0fb9-c9c8-63a9-5d888afa9419@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
 <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
 <b926ecdb-94da-1067-ff74-7d5392a7fe46@gmx.com>
 <20180116101058.wtcdjnqldcb5q3a7@breakpoint.cc>
 <4b929845-beae-9e13-2df9-ddc3232ad39a@gmx.com>
 <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>
In-Reply-To: <20180116104949.7qtf67mrdvyxrvs4@breakpoint.cc>

--Lae5wHvcjD3pfrspveIXyRM86lQuCV5gE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8816=E6=97=A5 18:49, Sebastian Andrzej Siewior w=
rote:
> On 2018-01-16 18:22:14 [+0800], Qu Wenruo wrote:
>> Btrfs check is always recommended before really mount it.
>=20
>  # btrfs check -p /dev/sdb4=20
>  Checking filesystem on /dev/sdb4
>  UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
>  checking extents [O]
>  cache and super generation don't match, space cache will be invalidate=
d
>  root 5 inode 57648595 errors 200, dir isize wrong

This is a very minor problem.

btrfs check --repair should handle it without problem.

Or just ignore it if you don't trust check --repair.

>=20
>  ERROR: errors found in fs roots
>  found 64009740288 bytes used, error(s) found
>  total csum bytes: 61644600
>  total tree bytes: 865746944
>  total fs tree bytes: 693469184
>  total extent tree bytes: 84905984
>  btree space waste bytes: 225096302
>  file data blocks allocated: 63203807232
>   referenced 63142268928
>=20
>> However as long as there is no other problem, btrfs check should not
>> report anything wrong.
>=20
> Is it important to note that the filesystem is a raid1 one?

Nope, the repair code handles any chunk profile well.

Thanks,
Qu

>=20
>> Thanks,
>> Qu
>=20
> Sebastian
>=20


--Lae5wHvcjD3pfrspveIXyRM86lQuCV5gE--

--4GR9wOFLsmbIi8Bi6zpMx7BlEs8faS5K5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpd4BkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgQKQf/cdQW1tx/kuX37BiOT1UIWof5
3K8aTkjW26KMgiDrDnQ6BwCtGRpCgRrZEjX0SeyP0nF2gHoNHV4xwPIT5M2qeOmc
TB0Z8N+dDfJhs3SLghd7NeoWACp7cq+y/sNwmyCjLutZSsZI4NIvgX9nhPtVLUIG
O95UwIKBgrtNnWs7MzHzFq4Da2go5/ZKFBWY9ER+F/gYP1ehB2TUVzHAXKG4cWnB
mkb5R5b7Kz4KdzbISXECpwC8nnWsgJQBPisyN3Rdqd/Mvs9+TkJbeiGRCkXpvv1l
VwALJncRmqC9psvhCruhGunAbnyNbMCGNXPJhbUOD/0BVSUa/NYXeRRXh+JynA==
=lncO
-----END PGP SIGNATURE-----

--4GR9wOFLsmbIi8Bi6zpMx7BlEs8faS5K5--
