Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64575 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbeAIHo1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 02:44:27 -0500
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
 <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
 <c70b76c8-61c8-999a-158f-667fa9c86b5f@gmx.com>
 <45d9878a-b6cd-fd0d-5309-05e17c9db51a@cn.fujitsu.com>
 <87e23c3c-73a9-47c6-e68c-b79186678bfa@gmx.com>
 <262f2016-4b63-49db-11d1-83e4ab964957@cn.fujitsu.com>
 <802a5de7-c058-ac24-2ba7-dbe911f858a3@gmx.com>
 <0804626a-eaa4-9958-c4bc-27c16f596b30@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <48c2d3e9-7b9b-f133-64cf-cb69ca0da763@gmx.com>
Date: Tue, 9 Jan 2018 15:44:16 +0800
MIME-Version: 1.0
In-Reply-To: <0804626a-eaa4-9958-c4bc-27c16f596b30@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kqIt9AnOS793HYkjkVfxtWLHvhPgzwQIL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kqIt9AnOS793HYkjkVfxtWLHvhPgzwQIL
Content-Type: multipart/mixed; boundary="PLvfjlQeyKBP2srVA8QV19Y4WQ039J2Jg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <48c2d3e9-7b9b-f133-64cf-cb69ca0da763@gmx.com>
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
 <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
 <c70b76c8-61c8-999a-158f-667fa9c86b5f@gmx.com>
 <45d9878a-b6cd-fd0d-5309-05e17c9db51a@cn.fujitsu.com>
 <87e23c3c-73a9-47c6-e68c-b79186678bfa@gmx.com>
 <262f2016-4b63-49db-11d1-83e4ab964957@cn.fujitsu.com>
 <802a5de7-c058-ac24-2ba7-dbe911f858a3@gmx.com>
 <0804626a-eaa4-9958-c4bc-27c16f596b30@cn.fujitsu.com>
In-Reply-To: <0804626a-eaa4-9958-c4bc-27c16f596b30@cn.fujitsu.com>

--PLvfjlQeyKBP2srVA8QV19Y4WQ039J2Jg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8827=E6=97=A5 09:11, Su Yue wrote:
>=20
>=20
[snip]
>>>>
>>>> Manually allocation in advance has its advantage, like we can determ=
ine
>>>> if there is enough space for new chunk instead of checking every ret=
urn
>>>> value with ENOSPC.
>>>>
>>>>
>>>> However in current case, your metadata usage is limited to the new
>>>> chunk
>>>> only.
>>>> If there extent tree has quite a lot of problem, and the chunk
>>>> allocated
>>>> is small (if using single profile and small fs), it can easily hit
>>>> ENOSPC again, since btrfs doesn't allocate new chunk for later metad=
ata
>>>> write.
>>>>
>>> SAD. After I tried to implement above nice idea, infinite recursive
>>> brings me back to the reality.
>>>
>>> Here is the reason why btrfs_reserve_extent can not allocate chunk
>>> by itself if ENOSPC hints:
>>>
>>> btrfs_cow_block
>>> ...
>>> =C2=A0=C2=A0 btrfs_reserve_extent
>>> =C2=A0=C2=A0=C2=A0=C2=A0 btrfs_alloc_chunk
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_alloc_dev_extent
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_insert_empty_i=
tem
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_cow_block
>>
>> The order is just wrong.
>>
>> We should first check for the new chunk space, not doing the insert
>> right now.
>>
>> I'll take over the work if you're OK with it.
>>
> OK. Thanks a lot.
>=20
> Thanks,
> Su

Well, even after my preparation patches, the situation is still much
complex than my expectation.

Yes, We could delay chunk/extent tree modification so newer chunk
allocation can be used for extent tree CoW.


But a lot of other infrastructure can't handle it well
The main problem is, we break a lot of ctree.c assumption.

For case like a normal tree CoW:

btrfs_search_slot(root=3Dextent_root)
|- btrfs_cow_block()
   |- btrfs_alloc_tree_block()
      |- btrfs_reserve_extent()
         |- btrfs_alloc_chunk()
            |- insert block group item
               *CoW* extent tree

In above case, extent_root changed even before we cow the extent root.
And will cause later (b =3D=3D root->node) check fail and trigger a SEGV.=


To really address it, we may need a large code rework with dynamic chunk
allocation in mind, which seems to expensive for a rarely used case.

So in short, I'm totally wrong and too optimistic about the feature.
Please use the original way, which is to alloc a new meta chunk manually.=


Thanks,
Qu


--PLvfjlQeyKBP2srVA8QV19Y4WQ039J2Jg--

--kqIt9AnOS793HYkjkVfxtWLHvhPgzwQIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpUctAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjC8wf9ENHZ00c7HqpM8x+eIdMnw3Ke
OUWB5BReBzb6abRQeONQxeT9I03dra9n9wBSV9avQQERTeINXv4oId/F68W/ffbB
uY4Rtw0AUkqIW5PpgwNehnFHMc1qANJNQMM6rshdI1aEdLe9aiREDgA49dlnloUA
Md/sWEsoIJQ4fhcNY8U6q9wnzXxO6USl3w7TUF3WTV0+SLgYfat8LvzGPYTfuyjc
T332g0sOM3SxLG0x2LuocaTpHzSUYzT0giPuyoqYP9JvK8lL8219m4+IZske9Z9W
R5062FInGAfRTS2LXdmW19dFpQMWtIkvs2qDUBgH1zfUc/xPPL8Qnf4E/zSwXw==
=Ch5H
-----END PGP SIGNATURE-----

--kqIt9AnOS793HYkjkVfxtWLHvhPgzwQIL--
