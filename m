Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbeDQJ7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 05:59:11 -0400
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180417014719.3799-1-wqu@suse.com>
 <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a0bb0231-8cb0-03de-876b-f902a89d7d4c@gmx.com>
Date: Tue, 17 Apr 2018 17:58:55 +0800
MIME-Version: 1.0
In-Reply-To: <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tcSwhNxACWiPh1gjUhAkphDUMAwu5INfG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tcSwhNxACWiPh1gjUhAkphDUMAwu5INfG
Content-Type: multipart/mixed; boundary="5xwddBlSK7qnAA7K7fLrQggKwdC9weeIC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <a0bb0231-8cb0-03de-876b-f902a89d7d4c@gmx.com>
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
References: <20180417014719.3799-1-wqu@suse.com>
 <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
In-Reply-To: <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>

--5xwddBlSK7qnAA7K7fLrQggKwdC9weeIC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8817=E6=97=A5 17:05, Anand Jain wrote:
>=20
>> v3:
>> =C2=A0=C2=A0 Update commit message to show the corruption in details.
>> =C2=A0=C2=A0 Modify the kernel error message to show corruption is det=
ected before
>> =C2=A0=C2=A0 transaction commitment.
> =C2=A0Nice. Thanks. more below.
>=20
>> @@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_device=

>> *device,
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_se=
t_super_bytenr(sb, bytenr);
>> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* check the valida=
tion of the primary sb before writing */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (i =3D=3D 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_check_super_valid(device->fs_info, sb);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_err(device->fs_info,
>> +"superblock corruption detected before transaction commitment for
>> device %llu",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device->devid);=

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EUCLEAN;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> =C2=A0Why not move this entire check further below, after we have the r=
eady
> =C2=A0crc and use btrfs_check_super_csum(), instead of
> =C2=A0btrfs_check_super_valid()? so that we verify only what is known t=
o be
> =C2=A0corrupted that is ..

The problem is, we don't know the cause yet, so we must check the whole
superblock.

For example, if the corruption is caused by some wild pointer of other
kernel module, and we're just unlucky that one day it corrupts nodesize,
then we can't detect it if we only check certain members.

>=20
> btrfs_super_block {
> ::
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 incompat_flags;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le16 csum_type;
> ::
> }
>=20
> =C2=A0And also can you dump contents of incompat_flags and csum_type at=
 both
> =C2=A0=C2=A0 fs_info->super_copy
> =C2=A0and
> =C2=A0=C2=A0 fs_info->super_for_commit

Not really needed, as when corruption happens, it's super_copy
corrupted, not something went wrong after we called memcpy()

Thanks,
Qu

>=20
> =C2=A0Because at each commit transaction we
>=20
> btrfs_commit_transaction()
> {
> =C2=A0 ::
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(fs_info->super_for_co=
mmit, fs_info->super_copy,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 sizeof(*fs_info->super_copy));
> =C2=A0 ::
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D write_all_supers(fs_=
info, 0);
>=20
> }
>=20
> =C2=A0And also the sync log can write the
>=20
> btrfs_sync_log()
> {
> ::
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D write_all_supers(fs_=
info, 1);
>=20
>=20
> =C2=A0Finally locks between these two threads needs a review as well.
>=20
> Thanks, Anand
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--5xwddBlSK7qnAA7K7fLrQggKwdC9weeIC--

--tcSwhNxACWiPh1gjUhAkphDUMAwu5INfG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrVxV8ACgkQwj2R86El
/qjwAAf9F1s5KkE8b/QGoGOSgxsGx7d8fJTRmVr7QD6NRJG01Ol9Jb2raIsRiTQB
d/ZpTkl59lfqyYKP2mrdfKn5z5NdOJ70l6t0hOAe4WdBYmTyqhXHJwnRhjwKahIy
UVsXm/Wynq/w5Rk6QUPQ9bckUlf4O2qz3GCGllo6XCeP4xcAoyGjFicQglm9j4JU
5SdZ5V5oCFW96Q79Fq89cm70gsCuBWnkrwyFiyupheYuqWHpn/k/HBt0M6sD9iqr
yyC3EuV+8dksQDlTEF5RlAiB8sEZGyLyllieiIsMhVZqY77dCg1Mu7KX6CM/A4Fx
NMcEkRprIyJOxymgbJVqgjRmJlWjCg==
=kaU1
-----END PGP SIGNATURE-----

--tcSwhNxACWiPh1gjUhAkphDUMAwu5INfG--
