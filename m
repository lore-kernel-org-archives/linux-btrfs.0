Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64746 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753193AbdLHNKL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 08:10:11 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
 <fc69a05e-d0af-e9c6-1827-a9eb5ed742e0@gmx.com>
 <f1ff6ee7-4f0a-2d47-3d85-7955bf7b0198@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f0adbc28-5294-2c47-2fe5-bab70c35c3fa@gmx.com>
Date: Fri, 8 Dec 2017 21:09:49 +0800
MIME-Version: 1.0
In-Reply-To: <f1ff6ee7-4f0a-2d47-3d85-7955bf7b0198@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="c7Q8r7J5UKgIatlsp9tfnrTgv74s8M7OD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c7Q8r7J5UKgIatlsp9tfnrTgv74s8M7OD
Content-Type: multipart/mixed; boundary="UIcP67Soer9Fo3vBU4D378lVAangeh7Ia";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <f0adbc28-5294-2c47-2fe5-bab70c35c3fa@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ed75e747-4387-49a3-e62a-67e100dd4ea6@gmail.com>
 <fc69a05e-d0af-e9c6-1827-a9eb5ed742e0@gmx.com>
 <f1ff6ee7-4f0a-2d47-3d85-7955bf7b0198@gmail.com>
In-Reply-To: <f1ff6ee7-4f0a-2d47-3d85-7955bf7b0198@gmail.com>

--UIcP67Soer9Fo3vBU4D378lVAangeh7Ia
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 21:05, Austin S. Hemmelgarn wrote:=

> On 2017-12-08 07:59, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 20:51, Austin S. Hemmelgarn wro=
te:
>>> On 2017-12-08 02:57, Anand Jain wrote:
>>>> -EXPERIMENTAL-
>>>> As of now when primary SB fails we won't self heal and would fail
>>>> mount,
>>>> this is an experimental patch which thinks why not go and read backu=
p
>>>> copy.
>>> I like the concept, and actually think this should be default behavio=
r
>>> on a filesystem that's already mounted (we fix other errors, why not
>>> SB's), but I don't think it should be default behavior at mount time =
for
>>> the reasons Qu has outlined (picking up old BTRFS SB's after
>>> reformatting is bad).=C2=A0 However, I do think it's useful to be abl=
e to ask
>>> for this behavior on mount, so that you don't need to fight with the
>>> programs to get a filesystem to mount when the first SB is missing
>>> (perhaps add a 'usebackupsb' option to mirror 'usebackuproot'?).
>>
>> Yeah, I also like the idea of 'usebackupsuper'/'usebackupsuper=3Dn' mo=
unt
>> option than do it automatically.
> I still think there should be an option to do automatic detection (it's=

> not particularly hard, and it's not likely to do the wrong thing in mos=
t
> cases), but being able to explicitly specify a particular superblock fo=
r
> a mount is definitely a step in the right direction.

usebackupsuper <- Auto
usebackupsuper=3Dn <- Manual
usebackupsuper=3Dn,m <- Manual multi, in given order
(The last one seems a little overkilled though)

Thanks,
Qu

>>
>> Thanks,
>> Qu
>>
>>>>
>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>> ---
>>>> =C2=A0=C2=A0 fs/btrfs/disk-io.c |=C2=A0 8 +++++++-
>>>> =C2=A0=C2=A0 fs/btrfs/volumes.c | 10 +++++++---
>>>> =C2=A0=C2=A0 2 files changed, 14 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 9b20c1f3563b..a791b8dfe8a8 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struc=
t
>>>> block_device *bdev)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * So, we need to add a sp=
ecial mount option to scan for
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * later supers, using BTR=
FS_SUPER_MIRROR_MAX instead
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> -=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 1; i++) {
>>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {=

>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 btrfs_read_dev_one_super(bdev, i, &bh);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret=
)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 continue;
>>>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct
>>>> btrfs_fs_info *fs_info)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -EINVAL;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 +#if 0
>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Need a way to check for any copy of SB, =
as its not a
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * strong check, just ignore this for now.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr(sb) !=3D=
 BTRFS_SUPER_INFO_OFFSET) {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_e=
rr(fs_info, "super offset mismatch %llu !=3D %u",
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFS=
ET);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -EINVAL;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +#endif
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_chunk_array=
 corruptions, it must hold at least
>>>> one key
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index 9fa2539a8493..f368db94d62b 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path,
>>>> fmode_t flags, void *holder,
>>>> =C2=A0=C2=A0 {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *disk_=
super;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct block_device *bdev;
>>>> -=C2=A0=C2=A0=C2=A0 struct page *page;
>>>> +=C2=A0=C2=A0=C2=A0 struct buffer_head *sb_bh;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D -EINVAL;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 devid;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 transid;
>>>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path,
>>>> fmode_t flags, void *holder,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto er=
ror;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 if (btrfs_read_disk_super(bdev, byt=
enr, &page, &disk_super))
>>>> +=C2=A0=C2=A0=C2=A0 sb_bh =3D btrfs_read_dev_super(bdev);
>>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(sb_bh)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(sb_bh);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto er=
ror_bdev_put;
>>>> +=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0 disk_super =3D (struct btrfs_super_block *) sb_b=
h->b_data;
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid =3D btrfs_stack_de=
vice_id(&disk_super->dev_item);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D btrfs_super_generat=
ion(disk_super);
>>>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,
>>>> fmode_t flags, void *holder,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret && fs_devices_ret)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*fs_de=
vices_ret)->total_devices =3D total_devices;
>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_release_disk_super(page);
>>>> +=C2=A0=C2=A0=C2=A0 brelse(sb_bh);
>>>> =C2=A0=C2=A0 =C2=A0 error_bdev_put:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdev_put(bdev, flags);
>>>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--UIcP67Soer9Fo3vBU4D378lVAangeh7Ia--

--c7Q8r7J5UKgIatlsp9tfnrTgv74s8M7OD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloqjx0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgQcwf/dyg1j97lfEiJD9je16Y1Z4JY
5UcG//oKiCGFt13xHd8AExrBckHjrxBOcwGSsAshDQbfx7s3KjDsqLM13XW0B6St
raeOtiftD9Q1k/3MHZ7ByOSB+ZVSUqnNWyH8JCIPHtUmGXMPYSmYoFmHCvZLpJDW
KeD4iM6tZGpAdgu99yN3GlUyFpr0N25LHzVs8jjmfOuQPSahY4x78k2wUPVCrGS0
sbIERueh+4xmvcpUC1Afee+p+zd8GOLyWwfcJBBniCmyygh5K6ngZTBuctXE8a4Q
B9m1htwkEf4IjETlj3TQ5hpgnptsSRnMkChEODWZpF6ovXxsBdTuJl/b2rmemQ==
=bwWo
-----END PGP SIGNATURE-----

--c7Q8r7J5UKgIatlsp9tfnrTgv74s8M7OD--
