Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbeGMHzP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 03:55:15 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
 <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
 <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>
 <a5635255-2aaa-7091-8723-93912ff126dd@gmx.com>
 <369f812e-b82a-a0f7-a6b1-b5259d24a728@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <33ce9269-3e46-fcd0-e3d2-6f8adf44c1ea@gmx.com>
Date: Fri, 13 Jul 2018 15:41:41 +0800
MIME-Version: 1.0
In-Reply-To: <369f812e-b82a-a0f7-a6b1-b5259d24a728@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YZgJ5bYnHwNQmQ51qCHSXSWAdTdYVWBnO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YZgJ5bYnHwNQmQ51qCHSXSWAdTdYVWBnO
Content-Type: multipart/mixed; boundary="aegnoVFTBStQrrPFjACV0PJkIcUlRuIXm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <33ce9269-3e46-fcd0-e3d2-6f8adf44c1ea@gmx.com>
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
 <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
 <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>
 <a5635255-2aaa-7091-8723-93912ff126dd@gmx.com>
 <369f812e-b82a-a0f7-a6b1-b5259d24a728@oracle.com>
In-Reply-To: <369f812e-b82a-a0f7-a6b1-b5259d24a728@oracle.com>

--aegnoVFTBStQrrPFjACV0PJkIcUlRuIXm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 15:24, Anand Jain wrote:
>=20
>=20
> On 07/13/2018 01:39 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 13:32, Anand Jain wrote:
>>>
>>>
>>>
>>>
>>>
>>>>> But if you are planning to
>>>>> =C2=A0=C2=A0=C2=A0 record and start at transaction [14] then its an=
 overkill because
>>>>> =C2=A0=C2=A0=C2=A0 transaction [19 and [20] are already in the disk=
=2E
>>>>
>>>> Yes, I'm doing it overkilled.
>>>
>>> =C2=A0=C2=A0Ah. Ok.
>>>
>>>> But it's already much better than scrub all block groups (my origina=
l
>>>> plan).
>>>
>>> =C2=A0=C2=A0That's true. Which can be optimized later, but how? and s=
crub can't
>>> =C2=A0=C2=A0fix RAID1.
>>
>> How could scrub not fix RAID1?
>=20
> =C2=A0Because degraded RAID1 allocates and writes data to the single ch=
unks.

Isn't that what you're working on?
Degraded RAID1 chunk allocation.

> =C2=A0There is no mirrored copy of these data and it would remain as it=
 is
> =C2=A0even after the scrub.
>=20
>> For metadata or data with csum, just goes normal scrub.
>=20
> =C2=A0Still need to fix the generation check for bg/parent transit
> =C2=A0verification across the trees/disks part. IMO.

Did you mean since scrub is just reading out each copy and verify its
metadata csum, it's possible that one old metadata passes csum check and
scrub can't detect it unless we also try to read the other copy?

That's indeed a problem, and unlike normal tree read routine, we have
transid/first_key/level check which can expose such problem.

>=20
>> For data without csum, we know which device is resilvering, just use t=
he
>> other copy.
>=20
> =C2=A0If its a short term fix then its ok. But I think the approach is
> =C2=A0similar to Liubo's InSync patch. Problem with this is, we will fa=
il
> =C2=A0to recover any data when the good disk throws media errors.

That's a trade-off between the recovery granularity.
In fact even for written bitmap, during RAID1 resilvering if we have a
copy failed to read, we can still hit the same problem.
Although with smaller granularity, we are less possible to hit such probl=
em.

The main point of my bg-based recovery is we could reuse scrub and block
group is already the middle level granularity in btrfs.

This makes me re-think about the possibility to use written bitmap for
each device extent.
Although it still takes a lot of space and can't fit into one tree leaf.
(Needs 32K for 1G dev extent).

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Thanks, Anand
>>>
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Thanks, Anand
>>>>>
>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [3] https://patchwork.kernel.org/p=
atch/10403311/
>>>>>>>
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0Further, as we do a self adapting chunk a=
llocation in RAID1, it
>>>>>>> needs
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0balance-convert to fix. IMO at some point=
 we have to provide
>>>>>>> degraded
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0raid1 chunk allocation and also modify th=
e scrub to be chunk
>>>>>>> granular.
>>>>>>>
>>>>>>> Thanks, Anand
>>>>>>>
>>>>>>>> Any idea on this?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>>>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>>>>>>
>>>>>>>>> ---------------------------------------------------------------=
--------
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thanks, Anand
>>>>>>>>> --=C2=A0
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-btrfs" in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-i=
nfo.html
>>>>>>>>
>>>>>>> --=C2=A0
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-btrfs" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-inf=
o.html
>>>>>>
>>>>> --=C2=A0
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.=
html
>>>>
>>


--aegnoVFTBStQrrPFjACV0PJkIcUlRuIXm--

--YZgJ5bYnHwNQmQ51qCHSXSWAdTdYVWBnO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltIV7UACgkQwj2R86El
/qiGfQf/VdHHjrzx/KHQlbWOUbi6R3qTpmUG0GWHZUJjBs0K/Y0BpLvkg3iUpxRL
WGpF8kyHxsg6FafmZsIaSC+xZvBKcgqDY162WYzMnv7cMqHt81Wnvn+c3p4Nxegz
3uYjwEoWIG5uOEmyDlFXMf/yTztyaPpfSI4mh6HUAoSZmqM2d7W83CtDhFpvYnGW
f+ZO6DjfQ9pLAHeMYB5jHi6LMLG8ZP37N/yxNH1D3yhoAvRDD+ra5AVP/k6nIoLO
jyxtqjnN5Tjip1g+SyWyfD6dJjFrvKxtEdKuxP6j1p4Ko0YRSMPyqE4aVG8OAYtS
pn/1a3WDJ8DYDkd87kVNUDQN2eXYDA==
=8+Gq
-----END PGP SIGNATURE-----

--YZgJ5bYnHwNQmQ51qCHSXSWAdTdYVWBnO--
