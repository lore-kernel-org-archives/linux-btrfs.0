Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:39017 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387972AbeGMCTo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 22:19:44 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
 <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
Message-ID: <445da3ad-2bdc-696d-3e5d-a731f14a9f91@gmx.com>
Date: Fri, 13 Jul 2018 10:07:15 +0800
MIME-Version: 1.0
In-Reply-To: <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7IEleQfPpnjin4mSoIm53pwxuJYmhelvO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7IEleQfPpnjin4mSoIm53pwxuJYmhelvO
Content-Type: multipart/mixed; boundary="5evsYFNn1bvqIE5mqqd9dkkByd408ab6g";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <445da3ad-2bdc-696d-3e5d-a731f14a9f91@gmx.com>
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
 <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
In-Reply-To: <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>

--5evsYFNn1bvqIE5mqqd9dkkByd408ab6g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 08:20, Qu Wenruo wrote:
>=20
>=20
> [snip]
>>> In this case, it depends on when and how we mark the device resilveri=
ng.
>>> If we record the generation of write error happens, then just initial=
 a
>>> scrub for generation greater than that generation.
>>
>> =C2=A0If we record all the degraded transactions then yes. Not just th=
e last
>> =C2=A0failed transaction.
>=20
> The last successful generation won't be upgraded until the scrub succes=
s.
>=20
>>
>>> In the list, some guys mentioned that for LVM/mdraid they will record=

>>> the generation when some device(s) get write error or missing, and do=

>>> self cure.
>>>
>>>>
>>>> =C2=A0=C2=A0I have been scratching on fix for this [3] for some time=
 now. Thanks
>>>> =C2=A0=C2=A0for the participation. In my understanding we are missin=
g across-tree
>>>> =C2=A0=C2=A0parent transid verification at the lowest possible granu=
lar OR
>>>
>>> Maybe the newly added first_key and level check could help detect suc=
h
>>> mismatch?
>>>
>>>> =C2=A0=C2=A0other approach is to modify Liubo approach to provide a =
list of
>>>> =C2=A0=C2=A0degraded chunks but without a journal disk.
>>>
>>> Currently, DEV_ITEM::generation is seldom used. (only for seed sprout=

>>> case)
>>> Maybe we could reuse that member to record the last successful writte=
n
>>> transaction to that device and do above purposed LVM/mdraid style sel=
f
>>> cure?
>>
>> =C2=A0Record of just the last successful transaction won't help. OR it=
s an
>> =C2=A0overkill to fix a write hole.
>>
>> =C2=A0Transactions: 10 11 [12] [13] [14] <---- write hole ----> [19] [=
20]
>> =C2=A0In the above example
>> =C2=A0 disk disappeared at transaction 11 and when it reappeared at
>> =C2=A0 the transaction 19, there were new writes as well as the resilv=
er
>> =C2=A0 writes,
>=20
> Then the last good generation will be 11 and we will commit current
> transaction as soon as we find a device disappear, and won't upgrade th=
e
> last good generation until the scrub finishes.
>=20
>> so we were able to write 12 13 14 and 19 20 and then
>> =C2=A0 the disk disappears again leaving a write hole.
>=20
> Only if in above transactions, the auto scrub finishes, the device will=

> has generation updated, or it will stay generation 11.
>=20
>> Now next time when
>> =C2=A0 disk reappears the last transaction indicates 20 on both-disks
>> =C2=A0 but leaving a write hole in one of disk.
>=20
> That will only happens if auto-scrub finishes in transaction 20, or its=

> last successful generation will stay 11.
>=20
>> But if you are planning to
>> =C2=A0 record and start at transaction [14] then its an overkill becau=
se
>> =C2=A0 transaction [19 and [20] are already in the disk.
>=20
> Yes, I'm doing it overkilled.
> But it's already much better than scrub all block groups (my original p=
lan).

Well, my idea has a major problem, that's we don't have generation for
block group item, that's to say either we use free space cache
generation or add new BLOCK_GROUP_ITEM member for generation detection.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>>
>> Thanks, Anand
>>
>>
>>> Thanks,
>>> Qu
>>>
>>>> =C2=A0=C2=A0=C2=A0 [3] https://patchwork.kernel.org/patch/10403311/
>>>>
>>>> =C2=A0=C2=A0Further, as we do a self adapting chunk allocation in RA=
ID1, it needs
>>>> =C2=A0=C2=A0balance-convert to fix. IMO at some point we have to pro=
vide degraded
>>>> =C2=A0=C2=A0raid1 chunk allocation and also modify the scrub to be c=
hunk granular.
>>>>
>>>> Thanks, Anand
>>>>
>>>>> Any idea on this?
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>>>
>>>>>> ------------------------------------------------------------------=
-----
>>>>>>
>>>>>>
>>>>>> Thanks, Anand
>>>>>> --=C2=A0
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>>
>>>> --=C2=A0
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.h=
tml
>>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
>=20


--5evsYFNn1bvqIE5mqqd9dkkByd408ab6g--

--7IEleQfPpnjin4mSoIm53pwxuJYmhelvO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltICVMACgkQwj2R86El
/qhM9Qf+NWKR6IpI+Rlc9fXla+mzm9/l5uDUyto3W667pRpLjge+1aN8kH3piA8G
GbtO6C8n61YKCWSi9j/ilC76T8ZQ/i69z8bEe5jfh+z9Wx/ROg3qrO+kLur0eWXH
6mxIMf6WykLduujd66/jtxqkE+9D25uz3q3k05d6uNgsKqq4arhuyjBvpV9qa2sw
3LKG5oO/vGc0tIJ0AXYTCv713jAQUrq7Tw15JIwg3OXfxldB1mClEM8wBNz3SpVj
oP/4lPbEGYysQX3RTfjuoRP++/WMQCqmrVOqPFvG/gC3hBtXR/5STUslHx4RO1oz
G3CYypMBPKvuoDzmAB5N++B3mCguBA==
=zB5/
-----END PGP SIGNATURE-----

--7IEleQfPpnjin4mSoIm53pwxuJYmhelvO--
