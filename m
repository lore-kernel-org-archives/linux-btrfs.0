Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:39321 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387780AbeGMAcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 20:32:48 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
Date: Fri, 13 Jul 2018 08:20:39 +0800
MIME-Version: 1.0
In-Reply-To: <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GZsLqUMbFw4mtNRsUMPFCiFwvaZT3Um3h"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GZsLqUMbFw4mtNRsUMPFCiFwvaZT3Um3h
Content-Type: multipart/mixed; boundary="6nxmumoiU7Un4sLRTrYk8jin0t2CgPTYA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
In-Reply-To: <940b5763-3144-954b-ee90-71270a348b21@oracle.com>

--6nxmumoiU7Un4sLRTrYk8jin0t2CgPTYA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



[snip]
>> In this case, it depends on when and how we mark the device resilverin=
g.
>> If we record the generation of write error happens, then just initial =
a
>> scrub for generation greater than that generation.
>=20
> =C2=A0If we record all the degraded transactions then yes. Not just the=
 last
> =C2=A0failed transaction.

The last successful generation won't be upgraded until the scrub success.=


>=20
>> In the list, some guys mentioned that for LVM/mdraid they will record
>> the generation when some device(s) get write error or missing, and do
>> self cure.
>>
>>>
>>> =C2=A0=C2=A0I have been scratching on fix for this [3] for some time =
now. Thanks
>>> =C2=A0=C2=A0for the participation. In my understanding we are missing=
 across-tree
>>> =C2=A0=C2=A0parent transid verification at the lowest possible granul=
ar OR
>>
>> Maybe the newly added first_key and level check could help detect such=

>> mismatch?
>>
>>> =C2=A0=C2=A0other approach is to modify Liubo approach to provide a l=
ist of
>>> =C2=A0=C2=A0degraded chunks but without a journal disk.
>>
>> Currently, DEV_ITEM::generation is seldom used. (only for seed sprout
>> case)
>> Maybe we could reuse that member to record the last successful written=

>> transaction to that device and do above purposed LVM/mdraid style self=

>> cure?
>=20
> =C2=A0Record of just the last successful transaction won't help. OR its=
 an
> =C2=A0overkill to fix a write hole.
>=20
> =C2=A0Transactions: 10 11 [12] [13] [14] <---- write hole ----> [19] [2=
0]
> =C2=A0In the above example
> =C2=A0 disk disappeared at transaction 11 and when it reappeared at
> =C2=A0 the transaction 19, there were new writes as well as the resilve=
r
> =C2=A0 writes,

Then the last good generation will be 11 and we will commit current
transaction as soon as we find a device disappear, and won't upgrade the
last good generation until the scrub finishes.

> so we were able to write 12 13 14 and 19 20 and then
> =C2=A0 the disk disappears again leaving a write hole.

Only if in above transactions, the auto scrub finishes, the device will
has generation updated, or it will stay generation 11.

> Now next time when
> =C2=A0 disk reappears the last transaction indicates 20 on both-disks
> =C2=A0 but leaving a write hole in one of disk.

That will only happens if auto-scrub finishes in transaction 20, or its
last successful generation will stay 11.

> But if you are planning to
> =C2=A0 record and start at transaction [14] then its an overkill becaus=
e
> =C2=A0 transaction [19 and [20] are already in the disk.

Yes, I'm doing it overkilled.
But it's already much better than scrub all block groups (my original pla=
n).

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>=20
>> Thanks,
>> Qu
>>
>>> =C2=A0=C2=A0=C2=A0 [3] https://patchwork.kernel.org/patch/10403311/
>>>
>>> =C2=A0=C2=A0Further, as we do a self adapting chunk allocation in RAI=
D1, it needs
>>> =C2=A0=C2=A0balance-convert to fix. IMO at some point we have to prov=
ide degraded
>>> =C2=A0=C2=A0raid1 chunk allocation and also modify the scrub to be ch=
unk granular.
>>>
>>> Thanks, Anand
>>>
>>>> Any idea on this?
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>>
>>>>> -------------------------------------------------------------------=
----
>>>>>
>>>>>
>>>>> Thanks, Anand
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



--6nxmumoiU7Un4sLRTrYk8jin0t2CgPTYA--

--GZsLqUMbFw4mtNRsUMPFCiFwvaZT3Um3h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltH8FcACgkQwj2R86El
/qigswf+KZxI7jARHdOgK9NANJ0QZLq9KZj4dIFjSRlDWrc2gfN1gT78p8dMEQNt
6aW9aBHpIWQbA1DPEyEy+QkGV9Y/gODgOYN2NphmYVGY+xwyLtLg3ay4ymilpiZQ
rMwlW69ELC5mOPTHxkPGpKUJ8lONAJulClitEfmWjY520o7XduP7Vblv2dFIbG4e
RwUngs5A24kHrFoj+i2VpmDrkIVu4n+ZUNQlQAjznUVvtJXshUdcweLpnRowPwkE
kJvWxciz8nstvwhGVqqWiwAKyEMYjjPwVvDSqMk/HOwcm0RamkW3xpuEXfRXLxEs
GhFNWgead+x80XkgfDTJTyz2yH2L/A==
=6LMv
-----END PGP SIGNATURE-----

--GZsLqUMbFw4mtNRsUMPFCiFwvaZT3Um3h--
