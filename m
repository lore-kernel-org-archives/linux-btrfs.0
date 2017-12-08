Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54459 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753746AbdLHLB7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 06:01:59 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
Date: Fri, 8 Dec 2017 19:01:45 +0800
MIME-Version: 1.0
In-Reply-To: <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nTL8hLCoX6UIJD1naNAIAe3NKBasqk1sB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nTL8hLCoX6UIJD1naNAIAe3NKBasqk1sB
Content-Type: multipart/mixed; boundary="xBP7sMi43VxaexRdh2bi5VJPcm9Hd4VpE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
In-Reply-To: <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>

--xBP7sMi43VxaexRdh2bi5VJPcm9Hd4VpE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 18:39, Anand Jain wrote:
>=20
>=20
> On 12/08/2017 04:17 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 15:57, Anand Jain wrote:
>>> -EXPERIMENTAL-
>>> As of now when primary SB fails we won't self heal and would fail mou=
nt,
>>> this is an experimental patch which thinks why not go and read backup=

>>> copy.
>>
>> Just curious about in which real world case that backup super block ca=
n
>> help.
>> At least from what I see in mail list, only few cases where backup sup=
er
>> helps.
>=20
> =C2=A0Theoretical design helps. I ended up in this situation though. An=
d
> =C2=A0ext4 has -o sb flag to manage this part. When we can expect EIO o=
n
> =C2=A0any part of the disk block why not on the LBA which contains prim=
ary
> =C2=A0SB. And should we fail the mount for that reason ? No.

And how do you ensure it's a btrfs?

>=20
>> Despite that self super heal seems good, although I agree with David, =
we
>> need a weaker but necessary check (magic and fsid from primary super?)=

>> to ensure it's a valid btrfs before we use the backup supers.
>=20
> =C2=A0Of course, we already have btrfs_check_super_valid() to verify th=
e SB,
> =C2=A0I don't understand why - how do we verify the SB should be the po=
int of
> =C2=A0concern here, at all.

The point here is, to distinguish an old and invalid btrfs (some other
valid fs mkfs beyond the old fs) from a valid btrfs with corrupted
primary fs.

This the main concern here.
The difference between recovery and recognizing a bad btrfs is quite
important.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>> Thanks,
>> Qu
>>
>>
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
>>> =C2=A0 +#if 0
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
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
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
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 if (btrfs_read_disk_super(bdev, bytenr, &p=
age, &disk_super))
>>> +=C2=A0=C2=A0=C2=A0 sb_bh =3D btrfs_read_dev_super(bdev);
>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(sb_bh)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(sb_bh);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto error_bde=
v_put;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 disk_super =3D (struct btrfs_super_block *) sb_bh=
->b_data;
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid =3D btrfs_stack_device_id=
(&disk_super->dev_item);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D btrfs_super_generation(dis=
k_super);
>>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,
>>> fmode_t flags, void *holder,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret && fs_devices_ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*fs_devices_r=
et)->total_devices =3D total_devices;
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_release_disk_super(page);
>>> +=C2=A0=C2=A0=C2=A0 brelse(sb_bh);
>>> =C2=A0 =C2=A0 error_bdev_put:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdev_put(bdev, flags);
>>>
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--xBP7sMi43VxaexRdh2bi5VJPcm9Hd4VpE--

--nTL8hLCoX6UIJD1naNAIAe3NKBasqk1sB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloqcRoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh9KwgAiznjWOzORdVvIQ3zanf5kR2m
QVCTD4Ou9K44JtW+FdkPh/zXXAA6FzhGg3ZZUs9xLFfLhhUCH2W0TZsFYsKyB/Az
SBK3KfTTtSoUnDq8s6NCbeuhEVPM1fOd8Iff/qfRDo28Illn9xbJ71/obro+Wotf
Z+7dYPDPVIWDqg3Lld3sn2oKtm9bIucgbJoSE8jx4hb1WzJtG9Q7jKadQNdFOK2A
TJaPDAesWDtii0SpUDlGTB9hM99HA95wiEhLrh1TDxxZnfTWWhuBAHThMYTn1Evg
ITqt/GRBimc3VcjdsSP4/n9+fV40GqFF4uFskM7qhN8AgJKW/m/gOQrg7tWgsQ==
=a/uN
-----END PGP SIGNATURE-----

--nTL8hLCoX6UIJD1naNAIAe3NKBasqk1sB--
