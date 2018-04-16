Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:36373 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbeDPNA7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 09:00:59 -0400
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180416020227.18528-1-wqu@suse.com>
 <59af2ff4-b8d9-c1df-2053-c180c5533d2d@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8cc34db9-0d09-38de-ac59-ed2be758de58@gmx.com>
Date: Mon, 16 Apr 2018 21:00:38 +0800
MIME-Version: 1.0
In-Reply-To: <59af2ff4-b8d9-c1df-2053-c180c5533d2d@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xq4j6o2UT7vUBzod2uuBlaVbiokHfssn9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xq4j6o2UT7vUBzod2uuBlaVbiokHfssn9
Content-Type: multipart/mixed; boundary="aBlS5FNmBwJVOGuNaOvx7OfotaEwdQNOR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <8cc34db9-0d09-38de-ac59-ed2be758de58@gmx.com>
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
References: <20180416020227.18528-1-wqu@suse.com>
 <59af2ff4-b8d9-c1df-2053-c180c5533d2d@oracle.com>
In-Reply-To: <59af2ff4-b8d9-c1df-2053-c180c5533d2d@oracle.com>

--aBlS5FNmBwJVOGuNaOvx7OfotaEwdQNOR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8816=E6=97=A5 20:55, Anand Jain wrote:
>=20
>=20
> On 04/16/2018 10:02 AM, Qu Wenruo wrote:
>> There are already 2 reports about strangely corrupted super blocks,
>> where csum type and incompat flags get some obvious garbage, but csum
>> still matches and all other vitals are correct.
>>
>> This normally means some kernel memory corruption happens, although th=
e
>> cause is unknown, at least detect it and prevent further corruption.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>=20
> =C2=A0Can you help point those 2 cases here?

Did you mean the reported-by tags?
If so, no problem.

Thanks,
Qu
>=20
> Thanks, Anand
>=20
>=20
>> =C2=A0 fs/btrfs/disk-io.c | 24 ++++++++++++++++++++----
>> =C2=A0 1 file changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 23803102aa0d..10d814f03f13 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -68,7 +68,8 @@
>> =C2=A0 static const struct extent_io_ops btree_extent_io_ops;
>> =C2=A0 static void end_workqueue_fn(struct btrfs_work *work);
>> =C2=A0 static void free_fs_root(struct btrfs_root *root);
>> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
>> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *sb);
>> =C2=A0 static void btrfs_destroy_ordered_extents(struct btrfs_root *ro=
ot);
>> =C2=A0 static int btrfs_destroy_delayed_refs(struct btrfs_transaction =
*trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct=
 btrfs_fs_info *fs_info);
>> @@ -2680,7 +2681,7 @@ int open_ctree(struct super_block *sb,
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(fs_info->fsid, fs_info->s=
uper_copy->fsid,
>> BTRFS_FSID_SIZE);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_check_super_valid(fs_info);
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_check_super_valid(fs_info, fs_info->=
super_copy);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_in=
fo, "superblock contains fatal errors");
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -EINVAL=
;
>> @@ -3575,6 +3576,21 @@ int write_all_supers(struct btrfs_fs_info
>> *fs_info, int max_mirrors)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb =3D fs_info->super_for_commit;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_item =3D &sb->dev_item;
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /* Do extra check on the sb to be written *=
/
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_check_super_valid(fs_info, sb);
>> +=C2=A0=C2=A0=C2=A0 if (ret) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "fatal =
superblock corrupted detected");
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EUCLEAN;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Unknown incompat flags can't be mounted, s=
o newly developed flags
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * means corruption
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATUR=
E_INCOMPAT_SUPP) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "fatal =
superblock corrupted detected");
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EUCLEAN;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->fs_devices->device=
_list_mutex);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 head =3D &fs_info->fs_devices->devices;=

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 max_errors =3D btrfs_super_num_devices(=
fs_info->super_copy) - 1;
>> @@ -3985,9 +4001,9 @@ int btrfs_read_buffer(struct extent_buffer *buf,=

>> u64 parent_transid, int level,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 level, first_key);
>> =C2=A0 }
>> =C2=A0 -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_in=
fo)
>> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *sb)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *sb =3D fs_info->super_co=
py;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 nodesize =3D btrfs_super_nodesize(s=
b);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 sectorsize =3D btrfs_super_sectorsi=
ze(sb);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--aBlS5FNmBwJVOGuNaOvx7OfotaEwdQNOR--

--xq4j6o2UT7vUBzod2uuBlaVbiokHfssn9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrUnnYACgkQwj2R86El
/qjBZgf9FxdT7RxVpRQBzjra2ltJNSfkLXTzGg2vWaDY0cnpp9m3EtPTfl4Q4wd+
qUqDF3Cr1WX9Ge0mF2rBnRv4yirv8NymzOKvd3OORK5ozgGmhlztBMfH9MJY0ENI
8ysM9cAaCY8cepxCkkBeLIVeo+DBoKPGa1Xt81inHYZCUK5uUdOUJ+Tg+vqVuUJ+
D2XNxEaxXcZT9cOiflCnwSbpt3nsmqWjxD1Q+Lxy8UW+wB2wRPww6ry9yk9eBvAG
5FLnXcBw4/ZgvdgE4ttb1nzMpJ1UKtit6zJp8b1Igvg9MVdRwkVFPWBY+DZ7UkWr
wFjJWR7IvqYfcjB5+VcIRVg3XwgfDQ==
=3MOi
-----END PGP SIGNATURE-----

--xq4j6o2UT7vUBzod2uuBlaVbiokHfssn9--
