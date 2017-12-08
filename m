Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51574 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752883AbdLHMCu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 07:02:50 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
 <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
 <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4b9827d7-13dc-a07e-284e-e2f3e055b14c@gmx.com>
Date: Fri, 8 Dec 2017 20:02:39 +0800
MIME-Version: 1.0
In-Reply-To: <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TnUchmM7uu43JUVafNLdedBafWvFAbjiU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TnUchmM7uu43JUVafNLdedBafWvFAbjiU
Content-Type: multipart/mixed; boundary="MRWoGeCwuUshk4exiK2AV38f4M8FgtRrw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <4b9827d7-13dc-a07e-284e-e2f3e055b14c@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
 <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
 <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>
In-Reply-To: <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>

--MRWoGeCwuUshk4exiK2AV38f4M8FgtRrw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 19:48, Anand Jain wrote:
>=20
>=20
> On 12/08/2017 07:01 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 18:39, Anand Jain wrote:
>>>
>>>
>>> On 12/08/2017 04:17 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 15:57, Anand Jain wrote:
>>>>> -EXPERIMENTAL-
>>>>> As of now when primary SB fails we won't self heal and would fail
>>>>> mount,
>>>>> this is an experimental patch which thinks why not go and read back=
up
>>>>> copy.
>>>>
>>>> Just curious about in which real world case that backup super block =
can
>>>> help.
>>>> At least from what I see in mail list, only few cases where backup
>>>> super
>>>> helps.
>>>
>>> =C2=A0=C2=A0Theoretical design helps. I ended up in this situation th=
ough. And
>>> =C2=A0=C2=A0ext4 has -o sb flag to manage this part. When we can expe=
ct EIO on
>>> =C2=A0=C2=A0any part of the disk block why not on the LBA which conta=
ins primary
>>> =C2=A0=C2=A0SB. And should we fail the mount for that reason ? No.
>>
>> And how do you ensure it's a btrfs?
>=20
> =C2=A0Hmm. You mean outside of btrfs ? I did experiment with wipe and t=
hen
> =C2=A0using /etc/fstab to mount, and it did lead to btrfs, is that your=

> =C2=A0concern that it shouldn't have been. That looked surprising to me=
 as
> =C2=A0well, but then problem points at wipefs instead.

It's closer, but still doesn't reach the point.
It can be a mkfs, other than wipefs.

It's can be another case like:

One user used btrfs for a while
But bugs made him/her unhappy, and he/she turned to use xfs (whatever
the fs is) instead.

While he/she forgot to change its fstab, and rebooted the system.

And suddenly, it's btrfs again!
What a surprise.


>=20
>>
>>>
>>>> Despite that self super heal seems good, although I agree with
>>>> David, we
>>>> need a weaker but necessary check (magic and fsid from primary super=
?)
>>>> to ensure it's a valid btrfs before we use the backup supers.
>>>
>>> =C2=A0=C2=A0Of course, we already have btrfs_check_super_valid() to v=
erify the SB,
>>> =C2=A0=C2=A0I don't understand why - how do we verify the SB should b=
e the
>>> point of
>>> =C2=A0=C2=A0concern here, at all.
>>
>> The point here is, to distinguish an old and invalid btrfs (some other=

>> valid fs mkfs beyond the old fs) from a valid btrfs with corrupted
>> primary fs.
>=20
> =C2=A0Ok. When you check all the SBs you would pick the one which has p=
assed
> =C2=A0btrfs_check_super_valid() and has highest generation. Did I ans y=
our
> =C2=A0concern ? If a SB does not pass btrfs_check_super_valid() its not=
 a
> =C2=A0valid btrfs SB at all.

No, not really.

What if the first SB is a XFS one or even a fs you didn't ever hear?

Skip it and use the 2nd one?
This filesystem is not even btrfs anymore.

Thanks,
Qu

>=20
>=20
>> This the main concern here.
>> The difference between recovery and recognizing a bad btrfs is quite
>> important.
>=20
> =C2=A0btrfs_check_super_valid() is already doing that right ? The point=
 here
> =C2=A0is, should we use the backup SB when btrfs_check_super_valid() fa=
ils on
> =C2=A0primary SB.
>=20
> Thanks, Anand
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Thanks, Anand
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>>
>>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>>> ---
>>>>> =C2=A0=C2=A0 fs/btrfs/disk-io.c |=C2=A0 8 +++++++-
>>>>> =C2=A0=C2=A0 fs/btrfs/volumes.c | 10 +++++++---
>>>>> =C2=A0=C2=A0 2 files changed, 14 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>> index 9b20c1f3563b..a791b8dfe8a8 100644
>>>>> --- a/fs/btrfs/disk-io.c
>>>>> +++ b/fs/btrfs/disk-io.c
>>>>> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(stru=
ct
>>>>> block_device *bdev)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * So, we need to add a s=
pecial mount option to scan for
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * later supers, using BT=
RFS_SUPER_MIRROR_MAX instead
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> -=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 1; i++) {
>>>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) =
{
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 btrfs_read_dev_one_super(bdev, i, &bh);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (re=
t)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 continue;
>>>>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct
>>>>> btrfs_fs_info *fs_info)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +#if 0
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Need a way to check for any copy of SB,=
 as its not a
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * strong check, just ignore this for now.=

>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr(sb) !=3D=
 BTRFS_SUPER_INFO_OFFSET) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_=
err(fs_info, "super offset mismatch %llu !=3D %u",
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFS=
ET);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +#endif
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_chunk_arra=
y corruptions, it must hold at least
>>>>> one key
>>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>>> index 9fa2539a8493..f368db94d62b 100644
>>>>> --- a/fs/btrfs/volumes.c
>>>>> +++ b/fs/btrfs/volumes.c
>>>>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path,
>>>>> fmode_t flags, void *holder,
>>>>> =C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *disk=
_super;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct block_device *bdev;
>>>>> -=C2=A0=C2=A0=C2=A0 struct page *page;
>>>>> +=C2=A0=C2=A0=C2=A0 struct buffer_head *sb_bh;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 devid;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 transid;
>>>>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path,
>>>>> fmode_t flags, void *holder,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto e=
rror;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 if (btrfs_read_disk_super(bdev, by=
tenr, &page, &disk_super))
>>>>> +=C2=A0=C2=A0=C2=A0 sb_bh =3D btrfs_read_dev_super(bdev);
>>>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(sb_bh)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(sb_bh);=

>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto e=
rror_bdev_put;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0 disk_super =3D (struct btrfs_super_block *) sb_=
bh->b_data;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid =3D btrfs_stack_d=
evice_id(&disk_super->dev_item);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D btrfs_super_genera=
tion(disk_super);
>>>>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,
>>>>> fmode_t flags, void *holder,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret && fs_devices_ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (*fs_d=
evices_ret)->total_devices =3D total_devices;
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_release_disk_super(page);
>>>>> +=C2=A0=C2=A0=C2=A0 brelse(sb_bh);
>>>>> =C2=A0=C2=A0 =C2=A0 error_bdev_put:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdev_put(bdev, flags);
>>>>>
>>>>
>>> --=C2=A0
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--MRWoGeCwuUshk4exiK2AV38f4M8FgtRrw--

--TnUchmM7uu43JUVafNLdedBafWvFAbjiU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloqf18XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhtFwf/a4F03g68Tczj9VMWTBMXNuqz
9YWXz4QAUkCtAJKfs3cHNpUBJ7bn3RfhptlXgHTW+axUMImJQ5CWe1A8o/++M/Nq
7feMo3glX9u/4EM7TqZ4/hh09neAwVMLGOFpgRUz4sT072Sgp5KU0dylcIkDufCz
BwsiZbibuEC2lGEK7PBe9xYlstqZleLofvpykqs/CaCPEAz563hj3pEj6RdO9cQs
iIrIbsOW142YGcN91Q9U8LDUfmi60Y69MWsMVGlLAN3qFvy8EDQ0QYeU3QrjXOvP
4EiMthQC3Xu6iwBWzntuZHZnEss2gaRgIWOY7bnRaidDEEmDLHTknRbAu8WzJg==
=u05m
-----END PGP SIGNATURE-----

--TnUchmM7uu43JUVafNLdedBafWvFAbjiU--
