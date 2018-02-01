Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbeBAHtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 02:49:17 -0500
Subject: Re: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error
 and warning
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201064541.14603-4-wqu@suse.com>
 <a3275ec5-c4af-88e0-b1b6-022ff820a9b4@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56a60440-c066-4f24-257d-21e7efa0ff38@gmx.com>
Date: Thu, 1 Feb 2018 15:48:59 +0800
MIME-Version: 1.0
In-Reply-To: <a3275ec5-c4af-88e0-b1b6-022ff820a9b4@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JSQ7HEBWeiLa6vvjI1OU1MklTYsZNt20j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JSQ7HEBWeiLa6vvjI1OU1MklTYsZNt20j
Content-Type: multipart/mixed; boundary="VV0LZbIQlAKbxcNQQzrjUKiXl0uVQ14U0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <56a60440-c066-4f24-257d-21e7efa0ff38@gmx.com>
Subject: Re: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error
 and warning
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201064541.14603-4-wqu@suse.com>
 <a3275ec5-c4af-88e0-b1b6-022ff820a9b4@cn.fujitsu.com>
In-Reply-To: <a3275ec5-c4af-88e0-b1b6-022ff820a9b4@cn.fujitsu.com>

--VV0LZbIQlAKbxcNQQzrjUKiXl0uVQ14U0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8801=E6=97=A5 15:08, Su Yue wrote:
>=20
>=20
> On 02/01/2018 02:45 PM, Qu Wenruo wrote:
>> Since we're moving tons of codes, it's a good idea to fix all errors a=
nd
[snip]
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> @@ -2500,7 +2507,8 @@ static int repair_extent_data_item(struct
>> btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 eb =3D path.nod=
es[0];
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ei =3D btrfs_item_ptr(eb, =
path.slots[0], struct
>> btrfs_extent_item);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ei =3D btrfs_item_ptr(eb, =
path.slots[0],
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_extent_item);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_se=
t_extent_refs(eb, ei, 0);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_set_exten=
t_generation(eb, ei, generation);
>> @@ -2657,7 +2665,8 @@ static int check_extent_data_item(struct
>> btrfs_root *root,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (type =3D=3D=
 BTRFS_EXTENT_DATA_REF_KEY) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ref_root =3D btrfs_extent_data_ref_root(leaf, dref);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
f_objectid =3D btrfs_extent_data_ref_objectid(leaf, dref);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
f_objectid =3D btrfs_extent_data_ref_objectid(leaf,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 dref);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 ref_offset =3D btrfs_extent_data_ref_offset(leaf, dref);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ref_objectid =3D=3D fi_key.objectid &&
>> @@ -2820,8 +2829,8 @@ static int check_block_group_item(struct
>> btrfs_fs_info *fs_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (!(bg_flags & BTRFS_BLOCK_GROUP_DATA)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 "bad extent[%llu, %llu) type mismatch with chunk",
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_key.objectid,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_key.objectid + exten=
t_key.offset);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_key.obje=
ctid,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_key.obje=
ctid + extent_key.offset);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err |=3D CHUNK_TYPE_MISMATCH;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (flag=
s & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>> @@ -3175,7 +3184,8 @@ static int check_extent_data_backref(struct
>> btrfs_fs_info *fs_info,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 btrfs_header_owner(leaf) !=3D root_id)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto next;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_item_key_=
to_cpu(leaf, &key, slot);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.objectid !=3D obje=
ctid || key.type !=3D
>> BTRFS_EXTENT_DATA_KEY)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.objectid !=3D obje=
ctid || key.type !=3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BT=
RFS_EXTENT_DATA_KEY)
> if (key.objectid !=3D objectid ||
> =C2=A0=C2=A0=C2=A0 key.type !=3D BTRFS_EXTENT_DATA_KEY)
> is more better.
> Other changes are nice.

I also thought about that, but that leaves too much space in previous lin=
e.

Not sure what should be the best practice here.

Thank,
Qu
>=20
> Thanks,
> Su


--VV0LZbIQlAKbxcNQQzrjUKiXl0uVQ14U0--

--JSQ7HEBWeiLa6vvjI1OU1MklTYsZNt20j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpyxmsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjAegf+N0gbIntNdvromOOP4QohZvU+
sGXOitr90uqGKcSKYDC59LaKsu0fvdkEvaye7NUj5JvvYyX0jtnwmnY0xmNq0z+X
2fiDVXjeKxtOxzXsPZhcIebizGByBP77dwwTrktzINDeoPAcOKfOxgpuOxvUi3dg
rO13W++9Vxc/ivgb26DeJBdEO9qePdu004gFPxIR92pf13TMsCeo0C0zmsFvgoQ0
BBQ4ibF949yIR3Nti0FJ3BEx4cH6V825KvGa+voRQuRc0p67U4PpPOkzqyHlwY6h
Dc69gEzZOK5X5Bu8aR4uYlUPIOYmSfawd9Vo4q/ov8Z6nT49Z+KJvTnozGyPkQ==
=amDj
-----END PGP SIGNATURE-----

--JSQ7HEBWeiLa6vvjI1OU1MklTYsZNt20j--
