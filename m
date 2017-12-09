Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59929 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbdLIBsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 20:48:38 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Anand Jain <anand.jain@oracle.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
 <474dfc45-1d77-35ec-66e1-5391592fccc0@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <aeadd575-240c-f1d8-cf88-fe77a537265a@gmx.com>
Date: Sat, 9 Dec 2017 09:48:28 +0800
MIME-Version: 1.0
In-Reply-To: <474dfc45-1d77-35ec-66e1-5391592fccc0@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PqEeuOcMHF2GpIFoaoXARA2PhhwDwmUPB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PqEeuOcMHF2GpIFoaoXARA2PhhwDwmUPB
Content-Type: multipart/mixed; boundary="FUBgmoBkgtM6ddltxcsHTqEj8mVSBnSdw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <aeadd575-240c-f1d8-cf88-fe77a537265a@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
 <474dfc45-1d77-35ec-66e1-5391592fccc0@oracle.com>
In-Reply-To: <474dfc45-1d77-35ec-66e1-5391592fccc0@oracle.com>

--FUBgmoBkgtM6ddltxcsHTqEj8mVSBnSdw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 22:02, Anand Jain wrote:
>=20
>=20
> On 12/08/2017 08:51 PM, Austin S. Hemmelgarn wrote:
>> On 2017-12-08 02:57, Anand Jain wrote:
>>> -EXPERIMENTAL-
>>> As of now when primary SB fails we won't self heal and would fail mou=
nt,
>>> this is an experimental patch which thinks why not go and read backup=

>>> copy.
>> I like the concept, and actually think this should be default behavior=

>> on a filesystem that's already mounted (we fix other errors, why not
>> SB's),=20
>=20
>=20
>> but I don't think it should be default behavior at mount time for the
>> reasons Qu has outlined (picking up old BTRFS SB's after reformatting
>> is bad).
>=20
> =C2=A0If the primary SB is not btrfs, then unless forced with -t btrfs
> =C2=A0option, this mount won't be in btrfs at all. That means it goes t=
o
> =C2=A0the respective FS by default.
>=20
> =C2=A0If the old btrfs is over written with newer btrfs SB, and if mkfs=
=2Ebtrfs
> =C2=A0is not overwriting all the copies of SB then its a mkfs.btrfs bug=
=2E

Nope.

If the new btrfs is a smaller one than original btrfs, the 2nd super can
still be there.

(AFAIK all these examples have been given by David for several times)

Thanks,
Qu
>=20
> =C2=A0Which means there is already mount -t option to redirect to the F=
S
> =C2=A0module that is needed by the user, when primary SB is corrupted.
> =C2=A0We should use this feature.
>=20
> Thanks, Anand
>=20
>=20
>> However, I do think it's useful to be able to ask for this behavior on=

>> mount, so that you don't need to fight with the programs to get a
>> filesystem to mount when the first SB is missing (perhaps add a
>> 'usebackupsb' option to mirror 'usebackuproot'?).
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> =C2=A0 fs/btrfs/disk-io.c |=C2=A0 8 +++++++-
>>> =C2=A0 fs/btrfs/volumes.c | 10 +++++++---
>>> =C2=A0 2 files changed, 14 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 9b20c1f3563b..a791b8dfe8a8 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct=

>>> block_device *bdev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * So, we need to add a special m=
ount option to scan for
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * later supers, using BTRFS_SUPE=
R_MIRROR_MAX instead
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 1; i++) {
>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_=
read_dev_one_super(bdev, i, &bh);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 continue;
>>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct
>>> btrfs_fs_info *fs_info)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVA=
L;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +#if 0
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Need a way to check for any copy of SB, a=
s its not a
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * strong check, just ignore this for now.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr(sb) !=3D BTRFS_=
SUPER_INFO_OFFSET) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_i=
nfo, "super offset mismatch %llu !=3D %u",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVA=
L;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +#endif
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_chunk_array corrup=
tions, it must hold at least
>>> one key
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 9fa2539a8493..f368db94d62b 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path,
>>> fmode_t flags, void *holder,
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *disk_super;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct block_device *bdev;
>>> -=C2=A0=C2=A0=C2=A0 struct page *page;
>>> +=C2=A0=C2=A0=C2=A0 struct buffer_head *sb_bh;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D -EINVAL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 devid;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 transid;
>>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path,
>>> fmode_t flags, void *holder,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto error;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_read_disk_super(bdev, bytenr, &page, &d=
isk_super))
>>> +=C2=A0=C2=A0=C2=A0 sb_bh =3D btrfs_read_dev_super(bdev);
>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(sb_bh)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(sb_bh);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto error_bde=
v_put;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 disk_super =3D (struct btrfs_super_block *) sb_bh=
->b_data;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid =3D btrfs_stack_device_id(&disk_=
super->dev_item);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D btrfs_super_generation(dis=
k_super);
>>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,
>>> fmode_t flags, void *holder,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret && fs_devices_ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*fs_devices_r=
et)->total_devices =3D total_devices;
>>> -=C2=A0=C2=A0=C2=A0 btrfs_release_disk_super(page);
>>> +=C2=A0=C2=A0=C2=A0 brelse(sb_bh);
>>> =C2=A0 error_bdev_put:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdev_put(bdev, flags);
>>>
>>
>> --=C2=A0
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--FUBgmoBkgtM6ddltxcsHTqEj8mVSBnSdw--

--PqEeuOcMHF2GpIFoaoXARA2PhhwDwmUPB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlorQOwXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi0nQf/TOnoJtxYfE/DMY/a8n1nRI8i
hcgGOJbu6m+A5YFyJyZFaCA1lNHI8F3OV3cVbicAWXKZeijAbtraZ/CkLEfEO9KO
DuEJFn+KZ+yNWHQghG/qmIkSjLfeA4dE8wywXVKrJrnmOuMKLSsRzVLh7hVN4yt9
wg9kAO24H86jIWHhlVaq72NOr8ZDiUe29jmh8ISWkiph9Wuv6EpeZz8eAOZDauN+
ryceCb6e1l8xZd+ZwSxa/yU51Jmp7PTvX6Ai3KxP6/YKwOrtnjfk43Qo016gwTul
INA2RZl4Iyc+lOb2Fv3Sp3H66xzQbrS7EjXvBLcEp19VtH0gWOUU3e/BXXS18w==
=hC20
-----END PGP SIGNATURE-----

--PqEeuOcMHF2GpIFoaoXARA2PhhwDwmUPB--
