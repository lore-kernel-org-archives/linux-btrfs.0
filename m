Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55594 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753339AbdLHMwd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 07:52:33 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
 <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
 <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>
 <4b9827d7-13dc-a07e-284e-e2f3e055b14c@gmx.com>
 <0565fd10-2c6d-5b11-105d-b5f5e12a7de3@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <eb25f728-43f3-63af-72d4-d31a6702d872@gmx.com>
Date: Fri, 8 Dec 2017 20:52:08 +0800
MIME-Version: 1.0
In-Reply-To: <0565fd10-2c6d-5b11-105d-b5f5e12a7de3@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9Toqmd1sPve1eoPpNq7sDnWRcRoP5uv0B"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9Toqmd1sPve1eoPpNq7sDnWRcRoP5uv0B
Content-Type: multipart/mixed; boundary="02GmCwd0XwWPIl0MGF9ok64Dng2qtsipD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <eb25f728-43f3-63af-72d4-d31a6702d872@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
 <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
 <9228f06c-e22e-5ee5-fb73-382f67589463@oracle.com>
 <c415973b-5d5e-3f2e-ae15-a0d379d2c1af@gmx.com>
 <ba8db856-94cb-ce8c-58bf-8cacbec83f72@oracle.com>
 <4b9827d7-13dc-a07e-284e-e2f3e055b14c@gmx.com>
 <0565fd10-2c6d-5b11-105d-b5f5e12a7de3@oracle.com>
In-Reply-To: <0565fd10-2c6d-5b11-105d-b5f5e12a7de3@oracle.com>

--02GmCwd0XwWPIl0MGF9ok64Dng2qtsipD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 20:41, Anand Jain wrote:
>=20
>=20
> On 12/08/2017 08:02 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 19:48, Anand Jain wrote:
>>>
>>>
>>> On 12/08/2017 07:01 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 18:39, Anand Jain wrote:
>>>>>
>>>>>
>>>>> On 12/08/2017 04:17 PM, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 15:57, Anand Jain wrote:
>>>>>>> -EXPERIMENTAL-
>>>>>>> As of now when primary SB fails we won't self heal and would fail=

>>>>>>> mount,
>>>>>>> this is an experimental patch which thinks why not go and read
>>>>>>> backup
>>>>>>> copy.
>>>>>>
>>>>>> Just curious about in which real world case that backup super
>>>>>> block can
>>>>>> help.
>>>>>> At least from what I see in mail list, only few cases where backup=

>>>>>> super
>>>>>> helps.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0Theoretical design helps. I ended up in this situ=
ation though. And
>>>>> =C2=A0=C2=A0=C2=A0ext4 has -o sb flag to manage this part. When we =
can expect EIO on
>>>>> =C2=A0=C2=A0=C2=A0any part of the disk block why not on the LBA whi=
ch contains
>>>>> primary
>>>>> =C2=A0=C2=A0=C2=A0SB. And should we fail the mount for that reason =
? No.
>>>>
>>>> And how do you ensure it's a btrfs?
>>>
>>> =C2=A0=C2=A0Hmm. You mean outside of btrfs ? I did experiment with wi=
pe and then
>>> =C2=A0=C2=A0using /etc/fstab to mount, and it did lead to btrfs, is t=
hat your
>>> =C2=A0=C2=A0concern that it shouldn't have been. That looked surprisi=
ng to me as
>>> =C2=A0=C2=A0well, but then problem points at wipefs instead.
>>
>> It's closer, but still doesn't reach the point.
>> It can be a mkfs, other than wipefs.
>>
>> It's can be another case like:
>>
>> One user used btrfs for a while
>> But bugs made him/her unhappy, and he/she turned to use xfs (whatever
>> the fs is) instead.
>>
>> While he/she forgot to change its fstab, and rebooted the system.
>>
>> And suddenly, it's btrfs again!
>> What a surprise.
>>
>=20
> =C2=A0I have worked quite a lot on defining the problem statements befo=
re
> =C2=A0btrfs. Here the user has to be blamed to have forgotten to update=

> =C2=A0the fstab. I don't understand why should we workaround in btrfs f=
or
> =C2=A0the reason that user may miss to update fstab. We don't design
> =C2=A0a stuff that like that, we design for the purpose, here backup SB=

> =C2=A0is for the purpose that we all know, if we don't use backup SB, t=
hen
> =C2=A0its an incomplete design.

Then implement something like ext*, using explicit mount option sb=3Dn.

And since it's already called "backup", it's something used for
recovery, not for normal operation.
We already have rescue tool to recover sb from backup, so it's not a
incomplete design.

Personally speaking, I prefer the current way and leave backup just as
backup.
You can my example of a user fault, but the real world needs us to
handle user's fault.

Or there will be no need for mkfs -f options or rm --no-preserve-root
options at all.

Thanks,
Qu

>=20
>>>
>>>>
>>>>>
>>>>>> Despite that self super heal seems good, although I agree with
>>>>>> David, we
>>>>>> need a weaker but necessary check (magic and fsid from primary
>>>>>> super?)
>>>>>> to ensure it's a valid btrfs before we use the backup supers.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0Of course, we already have btrfs_check_super_vali=
d() to verify
>>>>> the SB,
>>>>> =C2=A0=C2=A0=C2=A0I don't understand why - how do we verify the SB =
should be the
>>>>> point of
>>>>> =C2=A0=C2=A0=C2=A0concern here, at all.
>>>>
>>>> The point here is, to distinguish an old and invalid btrfs (some oth=
er
>>>> valid fs mkfs beyond the old fs) from a valid btrfs with corrupted
>>>> primary fs.
>>>
>>> =C2=A0=C2=A0Ok. When you check all the SBs you would pick the one whi=
ch has passed
>>> =C2=A0=C2=A0btrfs_check_super_valid() and has highest generation. Did=
 I ans your
>>> =C2=A0=C2=A0concern ? If a SB does not pass btrfs_check_super_valid()=
 its not a
>>> =C2=A0=C2=A0valid btrfs SB at all.
>>
>> No, not really.
>>
>> What if the first SB is a XFS one or even a fs you didn't ever hear?
>>
>> Skip it and use the 2nd one?
>> This filesystem is not even btrfs anymore.
>=20
> =C2=A0There is no problem is user does the correct thing that is to
> =C2=A0update the fstab. OR using a complete mount command. If user
> =C2=A0using -t btrfs OR unupdated btrfs then it indicates his intention=
s.
>=20
> Thanks, Anand
>=20
>> Thanks,
>> Qu
>>
>>>
>>>
>>>> This the main concern here.
>>>> The difference between recovery and recognizing a bad btrfs is quite=

>>>> important.
>>>
>>> =C2=A0=C2=A0btrfs_check_super_valid() is already doing that right ? T=
he point here
>>> =C2=A0=C2=A0is, should we use the backup SB when btrfs_check_super_va=
lid()
>>> fails on
>>> =C2=A0=C2=A0primary SB.
>>>
>>> Thanks, Anand
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Thanks, Anand
>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>>>>> ---
>>>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/disk-io.c |=C2=A0 8 +++++++-
>>>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/volumes.c | 10 +++++++---
>>>>>>> =C2=A0=C2=A0=C2=A0 2 files changed, 14 insertions(+), 4 deletions=
(-)
>>>>>>>
>>>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>>>> index 9b20c1f3563b..a791b8dfe8a8 100644
>>>>>>> --- a/fs/btrfs/disk-io.c
>>>>>>> +++ b/fs/btrfs/disk-io.c
>>>>>>> @@ -3190,7 +3190,7 @@ struct buffer_head
>>>>>>> *btrfs_read_dev_super(struct
>>>>>>> block_device *bdev)
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * So, we need to=
 add a special mount option to scan for
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * later supers, =
using BTRFS_SUPER_MIRROR_MAX instead
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>>>> -=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 1; i++) {
>>>>>>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++=
) {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3D btrfs_read_dev_one_super(bdev, i, &bh);
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (ret)
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>>>>>> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct=

>>>>>>> btrfs_fs_info *fs_info)
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3D -EINVAL;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>> =C2=A0=C2=A0=C2=A0 +#if 0
>>>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Need a way to check for any copy of S=
B, as its not a
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * strong check, just ignore this for no=
w.
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr=
(sb) !=3D BTRFS_SUPER_INFO_OFFSET) {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 btrfs_err(fs_info, "super offset mismatch %llu !=3D %u",
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_=
INFO_OFFSET);
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3D -EINVAL;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>> +#endif
>>>>>>> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_ch=
unk_array corruptions, it must hold at
>>>>>>> least
>>>>>>> one key
>>>>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>>>>> index 9fa2539a8493..f368db94d62b 100644
>>>>>>> --- a/fs/btrfs/volumes.c
>>>>>>> +++ b/fs/btrfs/volumes.c
>>>>>>> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path,=

>>>>>>> fmode_t flags, void *holder,
>>>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_super_blo=
ck *disk_super;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct block_device *b=
dev;
>>>>>>> -=C2=A0=C2=A0=C2=A0 struct page *page;
>>>>>>> +=C2=A0=C2=A0=C2=A0 struct buffer_head *sb_bh;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D -EINVAL;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 devid;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 transid;
>>>>>>> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path=
,
>>>>>>> fmode_t flags, void *holder,
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto error;
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>> =C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 if (btrfs_read_disk_super(=
bdev, bytenr, &page,
>>>>>>> &disk_super))
>>>>>>> +=C2=A0=C2=A0=C2=A0 sb_bh =3D btrfs_read_dev_super(bdev);
>>>>>>> +=C2=A0=C2=A0=C2=A0 if (IS_ERR(sb_bh)) {
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(sb_bh=
);
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto error_bdev_put;
>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>> +=C2=A0=C2=A0=C2=A0 disk_super =3D (struct btrfs_super_block *) s=
b_bh->b_data;
>>>>>>> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid =3D btrfs=
_stack_device_id(&disk_super->dev_item);
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 transid =3D btrfs_supe=
r_generation(disk_super);
>>>>>>> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path,=

>>>>>>> fmode_t flags, void *holder,
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret && fs_devices=
_ret)
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 (*fs_devices_ret)->total_devices =3D total_devices;
>>>>>>> =C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_release_disk_super(p=
age);
>>>>>>> +=C2=A0=C2=A0=C2=A0 brelse(sb_bh);
>>>>>>> =C2=A0=C2=A0=C2=A0 =C2=A0 error_bdev_put:
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdev_put(bdev, flags=
);
>>>>>>>
>>>>>>
>>>>> --=C2=A0
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.=
html
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



--02GmCwd0XwWPIl0MGF9ok64Dng2qtsipD--

--9Toqmd1sPve1eoPpNq7sDnWRcRoP5uv0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloqivgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiNiQf/Tnb5zDqsCvwQbwfuP+xuc1cQ
eLkgdN0V1UPUFUvzRbsU41oGn8X+jowyh6+/xaOvFcPx4Y2F3WigW5YhZiW/nBs6
wxRuSI7x2PViXVFrDIddIbdIbbWE3GeAVQgMqtHed2WXZl5yZzHopmX1aVNjQF+P
b8ekNIZ0/SrtJrlb61do0BkSSj7a+bY8Y0rB/vr6vNThoppbckksEBPoR9Me8VOg
1DqaqNcWIIqc9gznPkcRIstkvClYYtZdufkiiwg2SMFJZ5rchhoowdXg7WdFnrOC
C1H8uqL/tucz9ApeARIrl5zjHmRnuHo/8zXIm5GgK9f5r9pHi5Sv/p4YxAPO1g==
=6nhS
-----END PGP SIGNATURE-----

--9Toqmd1sPve1eoPpNq7sDnWRcRoP5uv0B--
