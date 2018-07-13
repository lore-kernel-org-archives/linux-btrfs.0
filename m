Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43081 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbeGMFwQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 01:52:16 -0400
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a5635255-2aaa-7091-8723-93912ff126dd@gmx.com>
Date: Fri, 13 Jul 2018 13:39:05 +0800
MIME-Version: 1.0
In-Reply-To: <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YLLiiyv4Vxwpr68yI50O0PEGxf5nwjJSk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YLLiiyv4Vxwpr68yI50O0PEGxf5nwjJSk
Content-Type: multipart/mixed; boundary="SwKmnXKDUZ61rczyiRDoHOhLnqDqpqeDs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a5635255-2aaa-7091-8723-93912ff126dd@gmx.com>
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
 <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
 <940b5763-3144-954b-ee90-71270a348b21@oracle.com>
 <84f4c573-9831-8c2f-0370-78ea3018b569@gmx.com>
 <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>
In-Reply-To: <09411b1f-f92d-ed7e-2a12-b12d352f780a@oracle.com>

--SwKmnXKDUZ61rczyiRDoHOhLnqDqpqeDs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 13:32, Anand Jain wrote:
>=20
>=20
>=20
>=20
>=20
>>> But if you are planning to
>>> =C2=A0=C2=A0 record and start at transaction [14] then its an overkil=
l because
>>> =C2=A0=C2=A0 transaction [19 and [20] are already in the disk.
>>
>> Yes, I'm doing it overkilled.
>=20
> =C2=A0Ah. Ok.
>=20
>> But it's already much better than scrub all block groups (my original
>> plan).
>=20
> =C2=A0That's true. Which can be optimized later, but how? and scrub can=
't
> =C2=A0fix RAID1.

How could scrub not fix RAID1?

For metadata or data with csum, just goes normal scrub.
For data without csum, we know which device is resilvering, just use the
other copy.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
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
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 [3] https://patchwork.kernel.org/patch/104=
03311/
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0Further, as we do a self adapting chunk allocatio=
n in RAID1, it
>>>>> needs
>>>>> =C2=A0=C2=A0=C2=A0balance-convert to fix. IMO at some point we have=
 to provide
>>>>> degraded
>>>>> =C2=A0=C2=A0=C2=A0raid1 chunk allocation and also modify the scrub =
to be chunk
>>>>> granular.
>>>>>
>>>>> Thanks, Anand
>>>>>
>>>>>> Any idea on this?
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>> Unlock: btrfs_fs_info::chunk_mutex
>>>>>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>>>>>
>>>>>>> -----------------------------------------------------------------=
------
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Thanks, Anand
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
>>> --=C2=A0
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>


--SwKmnXKDUZ61rczyiRDoHOhLnqDqpqeDs--

--YLLiiyv4Vxwpr68yI50O0PEGxf5nwjJSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltIOvkACgkQwj2R86El
/qj8ygf8CgwfpA3ooD1o8upUJ+bcLuiM83/EhWOJA7p+mwtNNI84FtrqzfRnBzTG
ath7Mf5B2kZKTJkxgPnqeT83C6PrQfPNqD0rPLE8cJ+P663v1O8Mio1E5R3jnhoB
pg0tm6uqqg21zZlCGWfj3WBB+wRwkX3dUHnjYS1CHGfZXGHPAbd6iQ/nmpzBWLeD
4Uri1+X+AncJJbs3mu6OJsi+UPEHrpgsjY0Yb2/B/BEOP6ORgQmkBwNkG4F+AS/S
gKZzbvza0VZY8gElgsYipAnVii8zJcCWnHubmAKDOI2O+3ftgpx8nV4mLmKqwnuA
9aiSXPrE7+zRA9+t0xOP1H8UZv0XZw==
=Vvuz
-----END PGP SIGNATURE-----

--YLLiiyv4Vxwpr68yI50O0PEGxf5nwjJSk--
