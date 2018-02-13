Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37411 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933865AbeBMKj6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 05:39:58 -0500
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
 <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
 <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <752e8ca3-7996-14cf-733e-a03d4ca10acf@gmx.com>
Date: Tue, 13 Feb 2018 18:39:49 +0800
MIME-Version: 1.0
In-Reply-To: <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fRWE4tahT3wBrbnQ6Qdxd96NZor6p6fvd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fRWE4tahT3wBrbnQ6Qdxd96NZor6p6fvd
Content-Type: multipart/mixed; boundary="J2MKpF92XIaV8U6Nwy2sN28smh698EBTq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <752e8ca3-7996-14cf-733e-a03d4ca10acf@gmx.com>
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
 <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
 <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>
In-Reply-To: <500c44b5-0c99-100f-6a70-a79d3ad8a388@oracle.com>

--J2MKpF92XIaV8U6Nwy2sN28smh698EBTq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 18:27, Anand Jain wrote:
>=20
>=20
> On 02/13/2018 05:01 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 11:00, Anand Jain wrote:
>>> Fixes the endianness bug in the fs_info::super_copy by using its
>>> btrfs_set_super...() function to set values in the SB, as these
>>> functions manage the endianness compatibility nicely.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> Also went through all btrfs_super_block SETGET functions, greping usin=
g
>> \><member name>, seems that there are still some left here:
>>
>> fs/btrfs/sysfs.c:
>> In both btrfs_sectorsize_show() and btrfs_clone_alignment_show():
>> =C2=A0=C2=A0=C2=A0=C2=A0return snprintf(buf, PAGE_SIZE, "%u\n",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_=
info->super_copy->sectorsize);
>>
>> In btrfs_nodesize_show():
>> =C2=A0=C2=A0=C2=A0=C2=A0return snprintf(buf, PAGE_SIZE, "%u\n",
>> fs_info->super_copy->nodesize);
>=20
> =C2=A0Oh. Thanks. Will fix. Maybe it's a good idea to add sysfs fixes
> =C2=A0into a new patch.
>=20
>> And what about cc this to stable kernel?
>> IIRC it's a very critical problem for btrfs.
>>
>> Maybe cc: stable@vger.kernel.org # v3.2+?
>=20
> =C2=A0Thanks for the suggestion. Will do. Any idea what if the patch wh=
ich
> =C2=A0applied on mainline ends up conflict on LTS, so write a separate =
patch
> =C2=A0to stable?

In fact I'm not sure about this either.

But considering much of the offending code doesn't change since 2009, it
wouldn't cause much conflict IIRC.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>=20
>> Thanks,
>> Qu
>>
>>> ---
>>> v1->v2: Update change log. Update $Subject.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Old:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [PATCH] btrfs: use s=
et functions to update latest refs to
>>> the SB
>>> =C2=A0 fs/btrfs/transaction.c | 20 ++++++++++++--------
>>> =C2=A0 1 file changed, 12 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index 04f07144b45c..9220f004001c 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -1722,19 +1722,23 @@ static void update_super_roots(struct
>>> btrfs_fs_info *fs_info)
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 super =3D fs_info->super_copy;
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /* update latest btrfs_super_block::chunk_=
root refs */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root_item =3D &fs_info->chunk_root->ro=
ot_item;
>>> -=C2=A0=C2=A0=C2=A0 super->chunk_root =3D root_item->bytenr;
>>> -=C2=A0=C2=A0=C2=A0 super->chunk_root_generation =3D root_item->gener=
ation;
>>> -=C2=A0=C2=A0=C2=A0 super->chunk_root_level =3D root_item->level;
>>> +=C2=A0=C2=A0=C2=A0 btrfs_set_super_chunk_root(super, root_item->byte=
nr);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_set_super_chunk_root_generation(super,
>>> root_item->generation);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_set_super_chunk_root_level(super, root_item=
->level);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /* update latest btrfs_super_block::root r=
efs */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root_item =3D &fs_info->tree_root->roo=
t_item;
>>> -=C2=A0=C2=A0=C2=A0 super->root =3D root_item->bytenr;
>>> -=C2=A0=C2=A0=C2=A0 super->generation =3D root_item->generation;
>>> -=C2=A0=C2=A0=C2=A0 super->root_level =3D root_item->level;
>>> +=C2=A0=C2=A0=C2=A0 btrfs_set_super_root(super, root_item->bytenr);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_set_super_generation(super, root_item->gene=
ration);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_set_super_root_level(super, root_item->leve=
l);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_test_opt(fs_info, SPACE_CACH=
E))
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 super->cache_generation =3D=
 root_item->generation;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_super_cache_gen=
eration(super, root_item->generation);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(BTRFS_FS_UPDATE_UUID_TREE=
_GEN, &fs_info->flags))
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 super->uuid_tree_generati=
on =3D root_item->generation;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_super_uuid_tree=
_generation(super,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 root_item->generation);
>>> =C2=A0 }
>>> =C2=A0 =C2=A0 int btrfs_transaction_in_commit(struct btrfs_fs_info *i=
nfo)
>>>
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--J2MKpF92XIaV8U6Nwy2sN28smh698EBTq--

--fRWE4tahT3wBrbnQ6Qdxd96NZor6p6fvd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCwHUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgahAf9GR062nh8t1mN+TxuGDZNszLx
vDjI+DLnji/29lAG7yITU7PC1xFUHmJZaYkmH+84oolLRg//Xh6vPUgC+TAksXh+
tAiJkBPnHig0yjYJhy7RF8XT7ummieMSsvTITidj/vIR6MzMWotqLteUtgdBl9KP
A+Hl9CyI7/HRyU7WlnMPXTc6Pl1mBT844RWTl8OXOfHcVy22Alco41Mbzyj/jy4H
h9Of3JQtuNnADhWxqjnIjKhpo4Eb6q29NDbt/FE/YBrRO6y0U0ntSNboDhyygppo
+6wgnyFIjv0y5GiI1ECPRYAsuQsLOc8lbyVsCNuKsCvKVhu41OCZ8bPb1WsVWA==
=PhRf
-----END PGP SIGNATURE-----

--fRWE4tahT3wBrbnQ6Qdxd96NZor6p6fvd--
