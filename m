Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbeH2J2R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 05:28:17 -0400
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
Message-ID: <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
Date: Wed, 29 Aug 2018 13:32:50 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="e7qb13md20jV7YGeDrtfkeYRBfuCdkvdM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e7qb13md20jV7YGeDrtfkeYRBfuCdkvdM
Content-Type: multipart/mixed; boundary="tuq5r4GTowJh44uKrH0PNuUnum3y3GPzE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
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

--tuq5r4GTowJh44uKrH0PNuUnum3y3GPzE
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

What a shame.
Btrfs won't try to allocate new chunk if we're allocating new tree
blocks for metadata trees (extent, csum, etc).

One quick (and dirty) way to avoid such limitation is to use the
following patch
------
diff --git a/extent-tree.c b/extent-tree.c
index 5d49af5a901e..0a1d21a8d148 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2652,17 +2652,15 @@ int btrfs_reserve_extent(struct
btrfs_trans_handle *trans,
                profile =3D BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
        }

-       if (root->ref_cows) {
-               if (!(profile & BTRFS_BLOCK_GROUP_METADATA)) {
-                       ret =3D do_chunk_alloc(trans, info,
-                                            num_bytes,
-                                            BTRFS_BLOCK_GROUP_METADATA);=

-                       BUG_ON(ret);
-               }
+       if (!(profile & BTRFS_BLOCK_GROUP_METADATA)) {
                ret =3D do_chunk_alloc(trans, info,
-                                    num_bytes + SZ_2M, profile);
+                                    num_bytes,
+                                    BTRFS_BLOCK_GROUP_METADATA);
                BUG_ON(ret);
        }
+       ret =3D do_chunk_alloc(trans, info,
+                            num_bytes + SZ_2M, profile);
+       BUG_ON(ret);

        WARN_ON(num_bytes < info->sectorsize);
        ret =3D find_free_extent(trans, root, num_bytes, empty_size,
------

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


--tuq5r4GTowJh44uKrH0PNuUnum3y3GPzE--

--e7qb13md20jV7YGeDrtfkeYRBfuCdkvdM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluGMAIACgkQwj2R86El
/qj9GAf/WVp6/SoCag03fyrg3qse6t1Rp2bOC76LANGS/QnP2V94FjbiqhFSiOWV
hd2AB5J7kPuCPW1i6xDS5tTyJ74wvkn/xeMReaHaz1i5kyiYZBZaX1DWQQzERC/Q
250/VSvhiV9qCEd8XMTsH4uP5dgi9Fvam5NSNkb6qvYfUxaUU0Rqq/wymWLjn4uG
iQXiIE5CO+XPP6x7wdkgZy3bAUTdfgsvY8G5EW7YtN9zaqAIpiZykjhuKNIcAWiC
ROp02qK4AovXrKwZOleaUQcZuDbDjgAbmdJvQKdOpmZQBRTeF2kWsc1ExZAN68c7
L034Fp9i1fu8cHBT6LOjKgED/cmaLg==
=pAph
-----END PGP SIGNATURE-----

--e7qb13md20jV7YGeDrtfkeYRBfuCdkvdM--
