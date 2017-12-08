Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49808 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752470AbdLHM7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 07:59:52 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fc69a05e-d0af-e9c6-1827-a9eb5ed742e0@gmx.com>
Date: Fri, 8 Dec 2017 20:59:41 +0800
MIME-Version: 1.0
In-Reply-To: <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q3htnGTA0qDmMUOcQG2ODNXThSb1rKxjS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q3htnGTA0qDmMUOcQG2ODNXThSb1rKxjS
Content-Type: multipart/mixed; boundary="xlDIO7g3QRaFUn8QlgaEO7MKeFhxGbBhE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <fc69a05e-d0af-e9c6-1827-a9eb5ed742e0@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
In-Reply-To: <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>

--xlDIO7g3QRaFUn8QlgaEO7MKeFhxGbBhE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 20:51, Austin S. Hemmelgarn wrote:=

> On 2017-12-08 02:57, Anand Jain wrote:
>> -EXPERIMENTAL-
>> As of now when primary SB fails we won't self heal and would fail moun=
t,
>> this is an experimental patch which thinks why not go and read backup
>> copy.
> I like the concept, and actually think this should be default behavior
> on a filesystem that's already mounted (we fix other errors, why not
> SB's), but I don't think it should be default behavior at mount time fo=
r
> the reasons Qu has outlined (picking up old BTRFS SB's after
> reformatting is bad).=C2=A0 However, I do think it's useful to be able =
to ask
> for this behavior on mount, so that you don't need to fight with the
> programs to get a filesystem to mount when the first SB is missing
> (perhaps add a 'usebackupsb' option to mirror 'usebackuproot'?).

Yeah, I also like the idea of 'usebackupsuper'/'usebackupsuper=3Dn' mount=

option than do it automatically.

Thanks,
Qu

>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> =C2=A0 fs/btrfs/disk-io.c |=C2=A0 8 +++++++-
>> =C2=A0 fs/btrfs/volumes.c | 10 +++++++---
>> =C2=A0 2 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 9b20c1f3563b..a791b8dfe8a8 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct
>> block_device *bdev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * So, we need to add a special mo=
unt option to scan for
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * later supers, using BTRFS_SUPER=
_MIRROR_MAX instead
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 1; i++) {
>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_r=
ead_dev_one_super(bdev, i, &bh);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 continue;
>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct
>> btrfs_fs_info *fs_info)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 +#if 0
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Need a way to check for any copy of SB, as=
 its not a
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * strong check, just ignore this for now.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr(sb) !=3D BTRFS_S=
UPER_INFO_OFFSET) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_in=
fo, "super offset mismatch %llu !=3D %u",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +#endif
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_chunk_array corrupt=
ions, it must hold at least
>> one key
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 9fa2539a8493..f368db94d62b 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path,
>> fmode_t flags, void *holder,
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *disk_super;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct block_device *bdev;
>> -=C2=A0=C2=A0=C2=A0 struct page *page;
>> +=C2=A0=C2=A0=C2=A0 struct buffer_head *sb_bh;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D -EINVAL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 devid;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 transid;
>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path,
>> fmode_t flags, void *holder,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto error;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 if (btrfs_read_disk_super(bdev, bytenr, &pa=
ge, &disk_super))
>> +=C2=A0=C2=A0=C2=A0 sb_bh =3D btrfs_read_dev_super(bdev);
>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(sb_bh)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(sb_bh);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto error_bdev=
_put;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 disk_super =3D (struct btrfs_super_block *) sb_bh-=
>b_data;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid =3D btrfs_stack_device_id(=
&disk_super->dev_item);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D btrfs_super_generation(disk=
_super);
>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,
>> fmode_t flags, void *holder,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret && fs_devices_ret)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*fs_devices_re=
t)->total_devices =3D total_devices;
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_release_disk_super(page);
>> +=C2=A0=C2=A0=C2=A0 brelse(sb_bh);
>> =C2=A0 =C2=A0 error_bdev_put:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdev_put(bdev, flags);
>>
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--xlDIO7g3QRaFUn8QlgaEO7MKeFhxGbBhE--

--Q3htnGTA0qDmMUOcQG2ODNXThSb1rKxjS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloqjL0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjnqgf7BBGtlyTkDzq8xguMw1f4QBkV
VQy8mg0QyYNIuz54KwqSJahYfrxpXsCEU3lCHI+BQ/UR2ryH7TojBSQaW3m30rGA
/59/lJ0ccq4m/FjBfzgyrolFe1WVT6+vd1mwBRIHMa1wGdp9DRXCpvTwGOe6VzFu
/dIyfjIOdzEHMlnXBLqvIMtmxfUxrlb/1WYfkJkfpIbAxWWgNcVyTPPN/gWeS4pO
RYApXJmCUx5lg0lKLNtfCRWYhb/IqmSH0UdCqBthRlzf0vh4c+fSiZdbi9QPYAQi
zjSNobJ2v8FQ30B4WvnLwVJsYYS6L6Jr2y+twzbjAcEasJM0ODsQLjeuEkBA9A==
=wGEp
-----END PGP SIGNATURE-----

--Q3htnGTA0qDmMUOcQG2ODNXThSb1rKxjS--
