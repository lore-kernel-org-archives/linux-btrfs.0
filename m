Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55593 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755190AbeCSBvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Mar 2018 21:51:18 -0400
Subject: Re: Crashes running btrfs scrub
To: waxhead@dirtcellar.net, Liu Bo <obuil.liubo@gmail.com>,
        Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9a2148df-f158-dbf1-63f1-5e5c74e82d93@gmx.com>
Date: Mon, 19 Mar 2018 09:51:04 +0800
MIME-Version: 1.0
In-Reply-To: <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JYnmuMwdKtsOIY7R0Q5N4f0AoUbiPa7gx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JYnmuMwdKtsOIY7R0Q5N4f0AoUbiPa7gx
Content-Type: multipart/mixed; boundary="Pq8d4sFeseb92Ft8a9m7xMQQSMDU2j39Q";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: waxhead@dirtcellar.net, Liu Bo <obuil.liubo@gmail.com>,
 Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <9a2148df-f158-dbf1-63f1-5e5c74e82d93@gmx.com>
Subject: Re: Crashes running btrfs scrub
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
In-Reply-To: <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>

--Pq8d4sFeseb92Ft8a9m7xMQQSMDU2j39Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8819=E6=97=A5 06:52, waxhead wrote:
> Liu Bo wrote:
>> On Sat, Mar 17, 2018 at 5:26 PM, Liu Bo <obuil.liubo@gmail.com> wrote:=

>>> On Fri, Mar 16, 2018 at 2:46 PM, Mike Stevens
>>> <michael.stevens@bayer.com> wrote:
>>>>> Could you please paste the whole dmesg, it looks like it hit
>>>>> btrfs_abort_transaction(),
>>>>> which should give us more information about where goes wrong.
>>>>
>>>> The whole thing is here https://pastebin.com/4ENq2saQ
>>>
>>> Given this,
>>>
>>> [=C2=A0 299.410998] BTRFS: error (device sdag) in
>>> btrfs_create_pending_block_groups:10192: errno=3D-27 unknown
>>>
>>> it refers to -EFBIG, so I think the warning comes from
>>>
>>> btrfs_add_system_chunk()
>>> {
>>> ...
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (array_size + ite=
m_size + sizeof(disk_key)
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&fs_info->chunk_mutex);
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFBIG;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> If that's the case, we need to check this earlier during mount.
>>>
>>
>> I didn't realize this until now,=C2=A0 we do have a limitation on up t=
o how
>> many disks btrfs could handle, in order to make balance/scrub work
>> properly (where system chunks may be set readonly),
>>
>> ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE / 2) - sizeof(struct btrfs_chunk)) /
>> sizeof(struct btrfs_stripe) + 1
>>
>> will be the number of disks btrfs can handle at most.
>=20
> Am I understanding this correct, BTRFS have limit to the number of
> physical devices it can handle?! (max 30 devices?!)

Not exactly.

System chunk array is only used to store system chunk (tree blocks of
chunk tree).
For data chunks, it's completely unrelated.

And for certain system chunk type (raid1/dup) it's fixed to have 2
stripes for each chunk, so it won't take so much space.


Furthermore, system chunk should not be that much, as it's only
containing chunk tree.
For large fs, one chunk can be up to 10G for data or 1G for metadata.

10TB only needs about 100 chunk items, which doesn't even need to
allocate extra system chunk space.


But if one is using RAID0/5/6/10, it's pretty possible one will hit that
device number max.
But that's still pretty strange.
Correct calculation should be (I hardly see more than 2 system chunks in
real world)

2048 =3D 80 + 32 + 80 + n * 32 (For old mkfs which still has temporary sy=
s
chunk)

Or

2048 =3D 80 + n * 32 (For new mkfs which doesn't have temporary sys chunk=
)

n should be the total number of disks if using RAID0/10/5/6 as metadata
profile.

So n will be 58, which is quite large at least for mkfs time limit.

Although for runtime, especially for relocation case, we need half of
the system chunk array to store the new system chunk, which makes the
number half.

But it should still be possible if we convert system chunk profile from
RAID0/10/5/6 to RAID1, which only takes 80 + 32 * 2.

Thanks,
Qu


>=20
> Or are this referring to the number of devices BTRFS can utilize in a
> stripe (in which case 30 actually sounds like a high number).
>=20
> 30 devices is really not that much, heck you get 90 disks top load JBOD=

> storage chassis these days and BTRFS does sound like an attractive
> choice for things like that.
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--Pq8d4sFeseb92Ft8a9m7xMQQSMDU2j39Q--

--JYnmuMwdKtsOIY7R0Q5N4f0AoUbiPa7gx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqvF4gXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiEqwf9FlbiG0u6u/XW+ArTVnyQ8uuG
i1804JsnR0zHeZRpl2gW0FQeeiae04DaOjTAo2YheBmLTX7cHt42IPZk8zPsy6GY
Ln6CMZyZ4lxAzSsksx1hSRg9tUcg2PAwI8mmVdvhreJ2ToK2C2QETMjGCCkN5F4P
z5U9vQRO9kqd4NEugMldLfcYqqrXmNlUakuRc+iMloYh2dRXkrF23au7ZI52edNS
vt/yO74rUVskWUwxMWwkD2l/UcNQKlqyGrt7CoetwlfFDzKPPxxaDpcLGI+nhhXg
GvemDL0vdodvxoDwQ1QGyAbA9L/Ayz3I6jPakow/IF7TWyrHLOr1XVoyUC03Rg==
=ciEB
-----END PGP SIGNATURE-----

--JYnmuMwdKtsOIY7R0Q5N4f0AoUbiPa7gx--
