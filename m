Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62558 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbeAHF0V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 00:26:21 -0500
Subject: Re: [PATCH v2 1/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108030512.22344-2-anand.jain@oracle.com>
 <20180108050409.727-1-anand.jain@oracle.com>
 <dffaa3c8-30d9-2ec0-4fac-3bb6457c7136@gmx.com>
 <dff5d2d7-ca88-393d-b33f-12368042358d@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <23789f5a-e572-a1ae-52ae-263fc2fc3aeb@gmx.com>
Date: Mon, 8 Jan 2018 13:25:35 +0800
MIME-Version: 1.0
In-Reply-To: <dff5d2d7-ca88-393d-b33f-12368042358d@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PGdLSoyEwK4whIFsnVWoHTrW9F8aDBH8a"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PGdLSoyEwK4whIFsnVWoHTrW9F8aDBH8a
Content-Type: multipart/mixed; boundary="mT01qX0mRIxxVFSaMPcvCI6VfHAY5jmff";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <23789f5a-e572-a1ae-52ae-263fc2fc3aeb@gmx.com>
Subject: Re: [PATCH v2 1/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
References: <20180108030512.22344-2-anand.jain@oracle.com>
 <20180108050409.727-1-anand.jain@oracle.com>
 <dffaa3c8-30d9-2ec0-4fac-3bb6457c7136@gmx.com>
 <dff5d2d7-ca88-393d-b33f-12368042358d@oracle.com>
In-Reply-To: <dff5d2d7-ca88-393d-b33f-12368042358d@oracle.com>

--mT01qX0mRIxxVFSaMPcvCI6VfHAY5jmff
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 13:13, Anand Jain wrote:
>=20
>=20
> On 01/08/2018 01:08 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 13:04, Anand Jain wrote:
>>> Userland sets SUPER_FLAG_CHANGING_FSID and resets it only when changi=
ng
>>> fsid is complete. Its not a good idea to mount the device anything in=

>>> between, so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID=

>>> is set.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> =C2=A0=C2=A0 cc: wqu@suse.com
>>> ---
>>> v1->v2: Oops. Fix cut and paste error, remove ~. My bad.
>>>
>>> =C2=A0 fs/btrfs/disk-io.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 7 ++++++-
>>> =C2=A0 include/uapi/linux/btrfs_tree.h | 1 +
>>> =C2=A0 2 files changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index a69e5944dc08..0dd215258ff9 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -61,7 +61,8 @@
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_HEADER_FLAG_RELOC |\
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_SUPER_FLAG_ERROR |\
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_SUPER_FLAG_SEEDING |\
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_SUPER_FLAG_METADUMP)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_SUPER_FLAG_METADUMP |\
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_SUPER_FLAG_CHANGING_FSID)
>>
>> Still the same problem here.
>>
>> Since that super flag is excluded in btrfs_check_super_valid(), I didn=
't
>> see any meaning including it into BTRFS_SUPER_FLAG_SUPP, and it will
>> confuse later BTRFS_SUPER_FLAG_SUPP users.
>=20
>=20
> =C2=A0Anyway BTRFS_SUPER_FLAG_SUPP as such does not stop to mount, it
> =C2=A0just warns. So when there is a new flag which is not supported
> =C2=A0we get this warning. As in the case with BTRFS_SUPER_FLAG_METADUM=
P_V2.
> =C2=A0BTRFS_SUPER_FLAG_METADUMP_V2 in kernel is defined but not support=
ed.
> =C2=A0However since we are supporting BTRFS_SUPER_FLAG_CHANGING_FSID, s=
o
> =C2=A0adding to BTRFS_SUPER_FLAG_SUPP make sense to me. ?

We still refuse to mount the fs if CHANGING_FSID is set, which I believe
should be called "unsupported"

On the other hand it would be better to include METADUMP_V2 into SUPP,
as we allow it to be mounted and now kernel knows that flag, output a
warning doesn't seems necessary now.

It would be even better to change the later SUPP flags checks, into
something not only output some meaningless numeric flags, but also
output the human readable flags if it's recognized but unsupported. (For
CHANGIND_FSID).

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>=20
>> Thanks,
>> Qu
>>
>>> =C2=A0 =C2=A0 static const struct extent_io_ops btree_extent_io_ops;
>>> =C2=A0 static void end_workqueue_fn(struct btrfs_work *work);
>>> @@ -3906,6 +3907,10 @@ static int btrfs_check_super_valid(struct
>>> btrfs_fs_info *fs_info)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_i=
nfo, "no valid FS found");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVA=
L;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_CHAN=
GING_FSID) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "SUPER=
_FLAG_CHANGING_FSID is set");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_super_flags(sb) & ~BTRFS_SUP=
ER_FLAG_SUPP)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_=
info, "unrecognized super flag: %llu",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_super_flags(sb) & ~BTRFS_SUPER_FL=
AG_SUPP);
>>> diff --git a/include/uapi/linux/btrfs_tree.h
>>> b/include/uapi/linux/btrfs_tree.h
>>> index 38ab0e06259a..aff1356c2bb8 100644
>>> --- a/include/uapi/linux/btrfs_tree.h
>>> +++ b/include/uapi/linux/btrfs_tree.h
>>> @@ -457,6 +457,7 @@ struct btrfs_free_space_header {
>>> =C2=A0 #define BTRFS_SUPER_FLAG_SEEDING=C2=A0=C2=A0=C2=A0 (1ULL << 32=
)
>>> =C2=A0 #define BTRFS_SUPER_FLAG_METADUMP=C2=A0=C2=A0=C2=A0 (1ULL << 3=
3)
>>> =C2=A0 #define BTRFS_SUPER_FLAG_METADUMP_V2=C2=A0=C2=A0=C2=A0 (1ULL <=
< 34)
>>> +#define BTRFS_SUPER_FLAG_CHANGING_FSID=C2=A0=C2=A0=C2=A0 (1ULL << 35=
)
>>> =C2=A0 =C2=A0 =C2=A0 /*
>>>
>>


--mT01qX0mRIxxVFSaMPcvCI6VfHAY5jmff--

--PGdLSoyEwK4whIFsnVWoHTrW9F8aDBH8a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpTAM8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgupwf/bVehkmGJzFuFNGUoNCUJTljb
OXl8smOPeeJHG2WhIxTYVKp9nZCKyPLkf/TgJ2ivCLsi1Qqq+doH8s/HeJMelQFY
PP1uoPVaXunBVjp46lKtmk/px4Go84VatbMJXlnj5jknqjMR7YBlf93Diok2G1bu
AE5ZYcGS+YqqekKQ/RrFvDok0H36D0TS+p1Q5IGGLSmx6BG4t0MAPi5lqp3FERIw
Ig5ZS5rozhk9f9e8oMDdlQgIkSO4yzFxUyzi7oYkAsPMR3H+UM2jtPkokttGw74o
M/xCwum6tZ/ALyVSsb/4ZqiLesr6U7Ml0oTEDcO7KZ6ssA99XpOkVRsyIq5arg==
=nYzB
-----END PGP SIGNATURE-----

--PGdLSoyEwK4whIFsnVWoHTrW9F8aDBH8a--
