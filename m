Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:43711 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751057AbeBPBz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 20:55:56 -0500
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
Date: Fri, 16 Feb 2018 09:55:38 +0800
MIME-Version: 1.0
In-Reply-To: <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EyDzqjiqUUIPPr6bYZaviihgpS5GWQJoV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EyDzqjiqUUIPPr6bYZaviihgpS5GWQJoV
Content-Type: multipart/mixed; boundary="BbpS7t0mevgRjaLlf2DRiwMEJKXDjAGco";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
 Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
Subject: Re: Status of FST and mount times
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
In-Reply-To: <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>

--BbpS7t0mevgRjaLlf2DRiwMEJKXDjAGco
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8816=E6=97=A5 00:30, Ellis H. Wilson III wrote:
> On 02/15/2018 06:12 AM, Hans van Kranenburg wrote:
>> On 02/15/2018 02:42 AM, Qu Wenruo wrote:
>>> Just as said by Nikolay, the biggest problem of slow mount is the siz=
e
>>> of extent tree (and HDD seek time)
>>>
>>> The easiest way to get a basic idea of how large your extent tree is
>>> using debug tree:
>>>
>>> # btrfs-debug-tree -r -t extent <device>
>>>
>>> You would get something like:
>>> btrfs-progs v4.15
>>> extent tree key (EXTENT_TREE ROOT_ITEM 0) 30539776 level 0=C2=A0 <<<
>>> total bytes 10737418240
>>> bytes used 393216
>>> uuid 651fcf0c-0ffd-4351-9721-84b1615f02e0
>>>
>>> That level is would give you some basic idea of the size of your exte=
nt
>>> tree.
>>>
>>> For level 0, it could contains about 400 items for average.
>>> For level 1, it could contains up to 197K items.
>>> ...
>>> For leven n, it could contains up to 400 * 493 ^ (n - 1) items.
>>> ( n <=3D 7 )
>>
>> Another one to get that data:
>>
>> https://github.com/knorrie/python-btrfs/blob/master/examples/show_meta=
data_tree_sizes.py
>>
>>
>> Example, with amount of leaves on level 0 and nodes higher up:
>>
>> -# ./show_metadata_tree_sizes.py /
>> ROOT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 336.00KiB 0(=
=C2=A0=C2=A0=C2=A0 20) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>> EXTENT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 123.52MiB 0(=C2=A0 787=
6) 1(=C2=A0=C2=A0=C2=A0 28) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>> CHUNK_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 112.00KiB 0(=C2=A0=
=C2=A0=C2=A0=C2=A0 6) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>> DEV_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8=
0.00KiB 0(=C2=A0=C2=A0=C2=A0=C2=A0 4) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>> FS_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1016.34M=
iB 0( 64113) 1(=C2=A0=C2=A0 881) 2(=C2=A0=C2=A0=C2=A0 52)
>> CSUM_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 777.42MiB 0(=
 49571) 1(=C2=A0=C2=A0 183) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>> QUOTA_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0.00B
>> UUID_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 16.00K=
iB 0(=C2=A0=C2=A0=C2=A0=C2=A0 1)
>> FREE_SPACE_TREE=C2=A0=C2=A0 336.00KiB 0(=C2=A0=C2=A0=C2=A0 20) 1(=C2=A0=
=C2=A0=C2=A0=C2=A0 1)
>> DATA_RELOC_TREE=C2=A0=C2=A0=C2=A0 16.00KiB 0(=C2=A0=C2=A0=C2=A0=C2=A0 =
1)
>=20
> Very helpful information.=C2=A0 Thank you Qu and Hans!
>=20
> I have about 1.7TB of homedir data newly rsync'd data on a single
> enterprise 7200rpm HDD and the following output for btrfs-debug:
>=20
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 543384862720 level 2
> total bytes 6001175126016
> bytes used 1832557875200
>=20
> Hans' (very cool) tool reports:
> ROOT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 624.00KiB 0(=C2=
=A0=C2=A0=C2=A0 38) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> EXTENT_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 327.31MiB 0( 20881) 1(=C2=
=A0=C2=A0=C2=A0 66) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)

Extent tree is not so large, a little unexpected to see such slow mount.

BTW, how many chunks do you have?

It could be checked by:

# btrfs-debug-tree -t chunk <device> | grep CHUNK_ITEM | wc -l

Unless we have tons of chunks, it should be too slow.

> CHUNK_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 208.00KiB 0(=C2=A0=
=C2=A0=C2=A0 12) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> DEV_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 144.00Ki=
B 0(=C2=A0=C2=A0=C2=A0=C2=A0 8) 1(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> FS_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 5.75GiB 0(375589) 1(=C2=A0=C2=A0 952) 2(=C2=A0=C2=A0=C2=A0=C2=A0 2=
) 3(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> CSUM_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
=2E75GiB 0(114274) 1(=C2=A0=C2=A0 385) 2(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> QUOTA_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00B
> UUID_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 16.00Ki=
B 0(=C2=A0=C2=A0=C2=A0=C2=A0 1)
> FREE_SPACE_TREE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> DATA_RELOC_TREE=C2=A0=C2=A0=C2=A0 16.00KiB 0(=C2=A0=C2=A0=C2=A0=C2=A0 1=
)
>=20
> Mean mount times across 5 tests: 4.319s (stddev=3D0.079s)
>=20
> Taking 100 snapshots (no changes between snapshots however) of the abov=
e
> subvolume doesn't appear to impact mount/umount time.

100 unmodified snapshots won't affect mount time.

It needs new extents, which can be created by overwriting extents in
snapshots.
So it won't really cause much difference if all these snapshots are all
unmodified.

> Snapshot creation
> and deletion both operate at between 0.25s to 0.5s.

IIRC snapshot deletion is delayed, so the real work doesn't happen when
"btrfs sub del" returns.

Thanks,
Qu

>=C2=A0 I am very impressed
> with snapshot deletion in particular now that qgroups is disabled.
>=20
> I will do more mount testing with twice and three times that dataset an=
d
> see how mount times scale.
>=20
> All done on 4.5.5.=C2=A0 I really need to move to a newer kernel.
>=20
> Best,
>=20
> ellis


--BbpS7t0mevgRjaLlf2DRiwMEJKXDjAGco--

--EyDzqjiqUUIPPr6bYZaviihgpS5GWQJoV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqGOhoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg3nwf/RGYyIiJ9J19LHi54kHTvC5yo
SOBCx8Y9FX5mFIaeXrQ6D2cvM522pE+H2f28fSfzKwe47Ywc7zS4R9h/kkTp9Brq
ysFDi+KDL7cUk3dCC3oi5igSoZYo9M2ZGThshqsN0LEJwwWnPSSbwxLrg7lQJvRB
mCIUfsqccHCjjlO5gN3KDIcFvwylslKmgLkh1TK4G0Twok4DcIsRQ0klZM6fgAjO
aPsnRDknHrhO2x8I71F7rQxXjJITBt3Hw6r7g66N9LYdbSTQV3JtWHsvDZXYZs5v
N2Ft5ItywmTkCuDNMe3M74Hin++o5TNeo7TwfCA2W0AF5h4Wg16BsMFuKp88dQ==
=DUcD
-----END PGP SIGNATURE-----

--EyDzqjiqUUIPPr6bYZaviihgpS5GWQJoV--
