Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbdKIJ7d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 04:59:33 -0500
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
To: Anand Jain <anand.jain@oracle.com>, bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b62482c7-1cd3-b203-ea85-3142cd44d803@gmx.com>
Date: Thu, 9 Nov 2017 17:59:21 +0800
MIME-Version: 1.0
In-Reply-To: <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eBWgn0tEWTxTGgEWd7t7ODiATE6IDsoGu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eBWgn0tEWTxTGgEWd7t7ODiATE6IDsoGu
Content-Type: multipart/mixed; boundary="sKEc8g761e86xffG8V2HgGNnxdA0PBeMQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <b62482c7-1cd3-b203-ea85-3142cd44d803@gmx.com>
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
In-Reply-To: <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>

--sKEc8g761e86xffG8V2HgGNnxdA0PBeMQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8809=E6=97=A5 17:29, Anand Jain wrote:
>=20
>=20
> On 11/09/2017 03:53 AM, Liu Bo wrote:
>> On Tue, Nov 07, 2017 at 04:32:55PM +0800, Anand Jain wrote:
>>>
>>>
>>> On 11/02/2017 08:54 AM, Liu Bo wrote:
>>>> With raid6 profile, btrfs can end up with data corruption by the
>>>> following steps.
>>>>
>>>> Say we have a 5 disks that are set up with raid6 profile,
>>>>
>>>> 1) mount this btrfs
>>>> 2) one disk gets pulled out
>>>> 3) write something to btrfs and sync
>>>> 4) another disk gets pulled out
>>>> 5) write something to btrfs and sync
>>>> 6) umount this btrfs
>>>> 7) bring the two disk back
>>>> 8) reboot
>>>> 9) mount this btrfs
>>>>
>>>> Chances are mount will fail (even with -odegraded) because of failur=
e
>>>> on reading metadata blocks, IOW, our raid6 setup is not able to
>>>> protect two disk failures in some cases.
>>>>
>>>> So it turns out that there is a bug in raid6's recover code, that is=
,
>>>>
>>>> if we have one of stripes in the raid6 layout as shown here,
>>>>
>>>> | D1(*)=C2=A0 | D2(*)=C2=A0 | D3 | D4 | D5=C2=A0=C2=A0=C2=A0 |
>>>> -------------------------------------
>>>> | data1=C2=A0 | data2=C2=A0 | P=C2=A0 | Q=C2=A0 | data0 |
>>>
>>>
>>>> D1 and D2 are the two disks which got pulled out and brought back.
>>>> When mount reads data1 and finds out that data1 doesn't match its cr=
c,
>>>> btrfs goes to recover data1 from other stripes, what it'll be doing =
is
>>>>
>>>> 1) read data2, parity P, parity Q and data0
>>>>
>>>> 2) as we have a valid parity P and two data stripes, it goes to
>>>> =C2=A0=C2=A0=C2=A0 recover in raid5 style.
>>>
>>>
>>>> (However, since disk D2 was pulled out and data2 on D2 could be stal=
e,
>>>
>>> =C2=A0 data2 should end up crc error, if not then raid5 recover is as=

>>> =C2=A0 expected OR this example is confusing to explain the context o=
f
>>> =C2=A0 two data stipe missing.
>>
>> The assumption you have is not true,=20
>=20
>> when doing reconstruction, we
>> don't verify checksum for each data stripe that is read from disk.

I have the question, why not verifying the data stripe's csum when doing
reconstruction?

I know it can be nasty for metadata, since until we fully rebuild the
stripe we won't be able to check if the reconstruction is correct.
(And if we reconstruction failed, we should try to rebuild the block
using other untried methods)

But for data (with csum), I think it's possible to verify the csum at
reconstruction time, and make allow btrfs to have better understanding
that which repair method should be applied.

So at least for data with csum (the easiest case), reconstruction should
be done for
case D1 corruption:
| D1(*)  | D2(*)  | D3 | D4 | D5    |
-------------------------------------
| data1  | data2  | P  | Q  | data0 |

0) D1 csum mismatch
   Goto repair procedure
1) Read out csum for data0~data2
2) Read out data0~data2, P, Q
3) Verify data0~data2
   And both data1 and 2 fails the check
4) Repair using P Q data0
5) Recheck csum
   If data1/2 matches csum, repair is done well.
   If data1/2 mismatches csum, return EIO.

Thanks,
Qu

>=20
> =C2=A0Why ? what if data0 (which has InSync flag) was wrong ?
>=20
> =C2=A0I am wary about the In_sync approach. IMO we are loosing the
> =C2=A0advantage of FS being merged with volume manager - which is to
> =C2=A0know exactly which active stripes were lost for quicker reconstru=
ct.
>=20
> =C2=A0Lets say RAID6 is 50% full and disk1 is pulled out, and at 75%
> =C2=A0full disk2 is pulled out and reaches 90% full.
>=20
> =C2=A0So now when all the disks are back, two disks will not have
> =C2=A0In_sync flag? hope I understood this correctly.
>=20
> =C2=A0Now.
> =C2=A015% of the data have lost two stripes.
> =C2=A025% of the data have lost one stripe.
> =C2=A050% of the data did not loose any stripe at all.
>=20
> =C2=A0Now for read and reconstruct..
> =C2=A050% of the data does not need any reconstruction.
> =C2=A025% of the data needs RAID5 style reconstruction as they have los=
t only
> one stripe.
> =C2=A015% of the data needs RAID6 reconstruction since they have lost t=
wo
> stripes.
>=20
> =C2=A0Does InSync design here help to work like this ?
>=20
> =C2=A0Now for RAID1, lets say disk1 lost first 10% of the stripes and
> =C2=A0disk2 lost the last 10% of the stripes and these stripes are mutu=
ally
> =C2=A0exclusive. That means there is no single stripe which has lost
> =C2=A0completely.
>=20
> =C2=A0There is no code yet where I can see when the In_sync will be res=
et,
> =C2=A0which is fine for this eg. Assume no reconstruction is done. But =
now
> =C2=A0when both the disks are being mounted and as the In_sync will be =
based
> =C2=A0on dev_item.generation, one of it will get In_sync to me it looks=
 like
> =C2=A0there will be 10% of stripes which will fail even though its not
> =C2=A0practically true in this example.
>=20
>=20
> Thanks, Anand
>=20
>=20
>=20
>> Thanks,
>>
>> -liubo
>>>
>>> Thanks, Anand
>>>
>>>
>>>> we still get the wrong data1 from this reconstruction.)
>>>>
>>>> 3) btrfs continues to try to reconstruct data1 from parity Q, data2
>>>> =C2=A0=C2=A0=C2=A0 and data0, we still get the wrong one for the sam=
e reason.
>>>>
>>>> The fix here is to take advantage of the device flag, ie. 'In_sync',=

>>>> all data on a device might be stale if 'In_sync' has not been set.
>>>>
>>>> With this, we can build the correct data2 from parity P, Q and data1=
=2E
>>>>
>>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>>> ---
>>>> =C2=A0 fs/btrfs/raid56.c | 3 ++-
>>>> =C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>>>> index 67262f8..3c0ce61 100644
>>>> --- a/fs/btrfs/raid56.c
>>>> +++ b/fs/btrfs/raid56.c
>>>> @@ -1076,7 +1076,8 @@ static int rbio_add_io_page(struct
>>>> btrfs_raid_bio *rbio,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 disk_start =3D stripe->physical + (pa=
ge_index << PAGE_SHIFT);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* if the device is missing, just fai=
l this stripe */
>>>> -=C2=A0=C2=A0=C2=A0 if (!stripe->dev->bdev)
>>>> +=C2=A0=C2=A0=C2=A0 if (!stripe->dev->bdev ||
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !test_bit(In_sync, &stri=
pe->dev->flags))
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return fail_r=
bio_index(rbio, stripe_nr);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* see if we can add this page onto o=
ur existing bio */
>>>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--sKEc8g761e86xffG8V2HgGNnxdA0PBeMQ--

--eBWgn0tEWTxTGgEWd7t7ODiATE6IDsoGu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloEJvkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgxmgf/Y4b07RyCJcXE30jRXNoJE0ut
vWiOB2tEQvxJ//73JF2yvvX2Wb2qtCf3ADntZeWDsHvOHUdhTfTSC8op9PWhs+rf
kzAP71E9udF+kZPqojlmiTLyz3s10slH9OxCeeGxbCvcSpEUYavOuI7vjHrq9XQG
OFaMqscCtSRh4nhOBi/VoT9lwoGrU3yqyJwjqci7yrY5dCm2+mgwBonyxx/mPIox
jttDADMK5sSl0MUoYohCtPmf5XgKPaqvXOUzfHBB20t+Te8G6z+kUvkrO8FTA2FZ
iC3p1sJWOmdAh0JFDjsuYu2hez/YSD5jPYEJqB7EdxZZha6Z8Ri3okMP/FjYiw==
=HA9N
-----END PGP SIGNATURE-----

--eBWgn0tEWTxTGgEWd7t7ODiATE6IDsoGu--
