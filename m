Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56529 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbeH2FWe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 01:22:34 -0400
Subject: Re: Scrub aborts due to corrupt leaf
To: Chris Murphy <lists@colorremedies.com>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <03fb5f67-7b67-94b3-098b-05777f8de4f1@gmx.com>
Date: Wed, 29 Aug 2018 09:27:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1LW0MBoP6Iv39cxmCVt0V3RpoyXXE9mhK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1LW0MBoP6Iv39cxmCVt0V3RpoyXXE9mhK
Content-Type: multipart/mixed; boundary="Ue8LT3lXgOpbBUUTq5bu71t5RM1iKgpO3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <03fb5f67-7b67-94b3-098b-05777f8de4f1@gmx.com>
Subject: Re: Scrub aborts due to corrupt leaf
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
In-Reply-To: <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>

--Ue8LT3lXgOpbBUUTq5bu71t5RM1iKgpO3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/28 =E4=B8=8B=E5=8D=889:56, Chris Murphy wrote:
> On Tue, Aug 28, 2018 at 7:42 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018/8/28 =E4=B8=8B=E5=8D=889:29, Larkin Lowrey wrote:
>>> On 8/27/2018 10:12 PM, Larkin Lowrey wrote:
>>>> On 8/27/2018 12:46 AM, Qu Wenruo wrote:
>>>>>
>>>>>> The system uses ECC memory and edac-util has not reported any erro=
rs.
>>>>>> However, I will run a memtest anyway.
>>>>> So it should not be the memory problem.
>>>>>
>>>>> BTW, what's the current generation of the fs?
>>>>>
>>>>> # btrfs inspect dump-super <device> | grep generation
>>>>>
>>>>> The corrupted leaf has generation 2862, I'm not sure how recent did=
 the
>>>>> corruption happen.
>>>>
>>>> generation              358392
>>>> chunk_root_generation   357256
>>>> cache_generation        358392
>>>> uuid_tree_generation    358392
>>>> dev_item.generation     0
>>>>
>>>> I don't recall the last time I ran a scrub but I doubt it has been
>>>> more than a year.
>>>>
>>>> I am running 'btrfs check --init-csum-tree' now. Hopefully that clea=
rs
>>>> everything up.
>>>
>>> No such luck:
>>>
>>> Creating a new CRC tree
>>> Checking filesystem on /dev/Cached/Backups
>>> UUID: acff5096-1128-4b24-a15e-4ba04261edc3
>>> Reinitialize checksum tree
>>> csum result is 0 for block 2412149436416
>>> extent-tree.c:2764: alloc_tree_block: BUG_ON `ret` triggered, value -=
28
>>
>> It's ENOSPC, meaning btrfs can't find enough space for the new csum tr=
ee
>> blocks.
>=20
> Seems bogus, there's >4TiB unallocated.

Pretty strange.

This either means chunk allocator doesn't work or we have something else
wrong.

I'll take a look into this problem.

Thanks,
Qu

>=20
>> Label: none  uuid: acff5096-1128-4b24-a15e-4ba04261edc3
>>        Total devices 1 FS bytes used 66.61TiB
>>        devid    1 size 72.77TiB used 68.03TiB path /dev/mapper/Cached-=
Backups
>>
>> Data, single: total=3D67.80TiB, used=3D66.52TiB
>> System, DUP: total=3D40.00MiB, used=3D7.41MiB
>> Metadata, DUP: total=3D98.50GiB, used=3D95.21GiB
>> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> Even if all metadata is only csum tree, and ~200GiB needs to be
> written, there's plenty of free space for it.
>=20
>=20
>=20


--Ue8LT3lXgOpbBUUTq5bu71t5RM1iKgpO3--

--1LW0MBoP6Iv39cxmCVt0V3RpoyXXE9mhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluF9poACgkQwj2R86El
/qhLlwf8DwYWH93bOjCCCspvKw94VujIIM3GPQNaKEiEPs3gd8433l2lqoJOmfig
4WpXXCUKZX2tbC+vI3mJozXnYjm5p7pQxGOFTOjAdiGU8VVYJlUgy/1uCi/JPvnD
8zq0oc9Xl7VCq88mFHBr1AqfBewwjye9MyUQhLxd3FChrzVar4Mqf12fIphjoujV
2MwPK+AJpcp+p8qMOudtND/CCUo9L7IlUjbwBp3w9GtGffMjtD6ljOJACEYj+WA2
K9OyzUngYzYsPVsP57u4B6HW4A7Ys81PyOyXS8UxbgwrA1tY6Nb7Lsdus0inK5kR
O26qr07rD7OKJlgRaUE0WMozgMyrGg==
=HGyC
-----END PGP SIGNATURE-----

--1LW0MBoP6Iv39cxmCVt0V3RpoyXXE9mhK--
