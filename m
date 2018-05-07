Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43895 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751831AbeEGCVK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 6 May 2018 22:21:10 -0400
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
 <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
 <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9c7668bf-e5e1-44df-183f-e12b0d990422@gmx.com>
Date: Mon, 7 May 2018 10:20:57 +0800
MIME-Version: 1.0
In-Reply-To: <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pS7X4cm2GaRSs7jk8y9TNQgkYfyoiqt0e"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pS7X4cm2GaRSs7jk8y9TNQgkYfyoiqt0e
Content-Type: multipart/mixed; boundary="y6jtQwOhhnn0K4RkoIJ82cH1eSIofpdXo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Message-ID: <9c7668bf-e5e1-44df-183f-e12b0d990422@gmx.com>
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
 <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
 <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>
In-Reply-To: <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>

--y6jtQwOhhnn0K4RkoIJ82cH1eSIofpdXo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8807=E6=97=A5 10:03, Lu Fengqi wrote:
> On Wed, Apr 18, 2018 at 01:12:10PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
>>> The function is used to determine whether the subvolume is intact.
>>>
>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> ---
>>> =C2=A0Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0 3 ++-
>>> =C2=A0undelete-subvol.c | 53
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>> =C2=A0undelete-subvol.h | 17 +++++++++++++++++
>>> =C2=A03 files changed, 72 insertions(+), 1 deletion(-)
>>> =C2=A0create mode 100644 undelete-subvol.c
>>> =C2=A0create mode 100644 undelete-subvol.h
>>>
>>> diff --git a/Makefile b/Makefile
>>> index 6065522a615f..cb38984c7386 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -116,7 +116,8 @@ objects =3Dtree.o disk-io.o kernel-lib/radix-tree=
=2Eo
>>> extent-tree.o print-tree.o \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qgroup.o free-space-cache.o kern=
el-lib/list_sort.o props.o \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kernel-shared/ulist.o qgroup-ver=
ify.o backref.o string-table.o
>>> task-utils.o \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode.o file.o find-root.o free-=
space-tree.o help.o send-dump.o \
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsfeatures.o kernel-lib/tables.o kern=
el-lib/raid56.o
>>> transaction.o
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fsfeatures.o kernel-lib/tables.o kern=
el-lib/raid56.o
>>> transaction.o \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 undelete-subvol.o
>>> =C2=A0cmds_objects =3Dmds-subvolume.o cmds-filesystem.o cmds-device.o=

>>> cmds-scrub.o \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cm=
ds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cm=
ds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
>>> diff --git a/undelete-subvol.c b/undelete-subvol.c
>>> new file mode 100644
>>> index 000000000000..00fcc4895778
>>> --- /dev/null
>>> +++ b/undelete-subvol.c
>>> @@ -0,0 +1,53 @@
>>> +/*
>>> + * Copyright (C) 2018 Fujitsu.=C2=A0 All rights reserved.
>>
>> IIRC David will remove all such copy right line.
>> Is there some principle about this, David?
>=20
> Are you referring to this patchset that replace GPL boilerplate by SPDX=
?
> https://patchwork.kernel.org/patch/10321621/
>=20
> However, I haven't seen a similar patch in btrfs-progs.
>=20

Nope, I mean David will remove the Copyright (C) line when applying.
Although I'm not completely sure.

Thanks,
Qu

>>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public
>>> + * License v2 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See th=
e GNU
>>> + * General Public License for more details.
>>> + */
>>> +
>>> +#include "ctree.h"
>>> +
>>> +/*
>>> + * Determines whether the subvolume is intact, according to the
>>> drop_progress
>>> + * of the root item specified by subvol_id.
>>> + *
>>> + * Return true if the subvolume is intact, otherwise return false.
>>> + */
>>> +static bool is_subvol_intact(struct btrfs_root *root, u64 subvol_id)=

>>
>> Here we have 2 parameters which can represent a root, so please explai=
n
>> the meaning of each parameter.
>>
>> And after looking into the code, @root should be tree root, and in tha=
t
>> case, I prefer passing @fs_info here to get rid of any confusion.
>=20
> Make sense.
>=20
>>
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path path;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *leaf;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root_item root_item;
>>> +=C2=A0=C2=A0=C2=A0 u64 offset;
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 key.objectid =3Dubvol_id;
>>> +=C2=A0=C2=A0=C2=A0 key.type =3DTRFS_ROOT_ITEM_KEY;
>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 btrfs_init_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_search_slot(NULL, root, &key, &path, =
0, 0);
>>
>> Instead of setting up keys and search manually, what about using
>> btrfs_read_fs_root()?
>=20
> Indeed looks better.
>=20
>>
>>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3Dalse;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 leaf =3Dath.nodes[0];
>>> +=C2=A0=C2=A0=C2=A0 offset =3Dtrfs_item_ptr_offset(leaf, path.slots[0=
]);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 read_extent_buffer(leaf, &root_item, offset, size=
of(root_item));
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* the subvolume is intact if the objectid of dro=
p_progress =3D0 */
>>> +=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_disk_key_objectid(&root_item.drop_pro=
gress) ? false :
>>> true;
>>> +
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> diff --git a/undelete-subvol.h b/undelete-subvol.h
>>> new file mode 100644
>>> index 000000000000..7cfd100cce37
>>> --- /dev/null
>>> +++ b/undelete-subvol.h
>>> @@ -0,0 +1,17 @@
>>> +/*
>>> + * Copyright (C) 2018 Fujitsu.=C2=A0 All rights reserved.
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public
>>> + * License v2 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See th=
e GNU
>>> + * General Public License for more details.
>>> + */
>>> +
>>> +#ifndef __BTRFS_UNDELETE_SUBVOLUME_H__
>> I think the empty header is not really needed here.
>> What about introducing it when we have something here?
>=20
> That's OK.
>=20
> Thanks for your review.
>=20
> --=20
> Thanks,
> Lu
>=20
>>
>> Thanks,
>> Qu
>>
>>> +#define __BTRFS_UNDELETE_SUBVOLUME_H__
>>> +
>>> +#endif
>>>
>>
>=20
>=20
>=20
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--y6jtQwOhhnn0K4RkoIJ82cH1eSIofpdXo--

--pS7X4cm2GaRSs7jk8y9TNQgkYfyoiqt0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrvuAkACgkQwj2R86El
/qj0pQf9EOcSAMV150PmeC4nBHTuUAIwBT3DXWoQFqSqzmIwJsGcQNINzc+seWXJ
doN+1V+hHj+4eft1tpuWe+tzEceOXGbISScJPun3EnjxOIMChfmm6vrvPCy6bPuj
Je6Vd//DekFkM5+++zHzQvJtE3aGURUROFvh43iKLX0jmz+DEK0wdGrU8HMrvYps
jcd4NhKHRXgszLjLBivSX/krs4TcCXi80zCV53VfuN9lzPkV41pxp2Hwb+qu18rt
SjGVRHUkx++L1fP//6yJviX/7FjieMfgWOo4+gltHin8wmftkq17svdClpdwdXo8
uXWW3HQs/uhOgaCKGj12jjybsGgAnA==
=SPTw
-----END PGP SIGNATURE-----

--pS7X4cm2GaRSs7jk8y9TNQgkYfyoiqt0e--
