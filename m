Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbeITP2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 11:28:16 -0400
Subject: Re: Punch hole on full fs
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
 <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
 <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ca9bdc6f-e248-5a7d-385c-221d986c245d@gmx.com>
Date: Thu, 20 Sep 2018 17:45:30 +0800
MIME-Version: 1.0
In-Reply-To: <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FErb8pRps5eEba1ntupaGq58ig5jNXKk7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FErb8pRps5eEba1ntupaGq58ig5jNXKk7
Content-Type: multipart/mixed; boundary="PARW42rNFHxdgFdNtA7CILE6DPXDqoY74";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <ca9bdc6f-e248-5a7d-385c-221d986c245d@gmx.com>
Subject: Re: Punch hole on full fs
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
 <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
 <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
In-Reply-To: <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>

--PARW42rNFHxdgFdNtA7CILE6DPXDqoY74
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/20 =E4=B8=8B=E5=8D=885:04, Anand Jain wrote:
>=20
>=20
> On 09/20/2018 04:45 PM, Qu Wenruo wrote:
>>
>>
>> On 2018/9/20 =E4=B8=8B=E5=8D=881:26, anand.jain@oracle.com wrote:
>>>
>>>
>>> Test script [1] tries to punch hole on a full FS and it works fine as=

>>> long as the hole size and the offset is aligned with the sectorsize a=
nd
>>> the extent, so that it could just drop the relevant extent to create =
the
>>> hole.
>>>
>>> The reason why this test fails for non aligned hole size and offset i=
s
>>> because, as it rightfully tries to truncate the non aligned extent at=

>>> the front and back of the hole, it tries to create new extent which e=
nds
>>> up with ENOSPC.
>>
>> This is what btrfs should do, I don't see any problem though.
>>
>>>
>>> Any idea, how do we solve this?
>>
>> I don't really think this is a problem though.
>>
>> As long as we need to do data COW, such ENOSPC would happen.
>=20
> It happens even with '-o max_inline=3D0 -o nodatacow' so certainly ther=
e
> is some problem, but looking at btrfs_punch_hole() it apparently looks
> like there is no way to fix this as sub-sectorsize hole-size depends on=

> the truncate which needs to alloc space.

Forgot to mention, in your test script, it only fills data space, so we
should still have enough free metadata space to fulfill fs/extent/root
tree operations.

Although the problem is, btrfs_truncate_block() will call
btrfs_delalloc_reserve_space() even the inode has NODATACOW flag.
(buffered write part does the extra check, although not completely
perfect check).

So in short, you could still fix it false ENOSPC problem by enhance
btrfs_truncate_block() to follow NODATACOW check.

Thanks,
Qu

>=20
>>>
>>> xfs is fine.
>>
>> Of course xfs is fine, XFS defaults to do NODATACOW, in contrast to
>> btrfs' default DATACOW.
>>
>> Have you tried to do the same when the file is reflinked?
>=20
> =C2=A0No but I presume it will rightfully fail.
>=20
> Thanks, -Anand
>=20
>> Thanks,
>> Qu
>>
>>>
>>> [1]
>>> cat ./punch-hole-on-full-fs
>>> ------------------------
>>> cleanup()
>>> {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0umount /dev/sdb > /dev/null 2>&1
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0btrfs_reload
>>> }
>>>
>>> full_fs_setup()
>>> {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0btrfs-dyndbg disable
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkfs.$fs -b 200M -fq $mkfs_options /dev=
/sdb || exit
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mount $mount_options /dev/sdb /mnt/scra=
tch || exit
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dd status=3Dnone if=3D/dev/zero of=3D/m=
nt/scratch/filler bs=3D512 >
>>> /dev/null 2>&1
>>> }
>>>
>>> test()
>>> {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cleanup
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0full_fs_setup
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0btrfs-dyndbg enable
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0echo "---- fallocate -p -o 0 -l $punch_=
hole_size
>>> /mnt/scratch/filler
>>> ----"
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fallocate -p -o 0 -l $punch_hole_size /=
mnt/scratch/filler
>>> }
>>>
>>> fs=3Dbtrfs; mkfs_options=3D""; mount_options=3D"";
>>> [[ $1 ]] || { echo "usage: $0 <hole-len>"; exit; }
>>> punch_hole_size=3D$1 && test
>>> ------------------------
>>>
>>> ./punch-hole-on-full-fs 512
>>> -- fallocate -p -o 0 -l 512 /mnt/scratch/filler --
>>> fallocate: /mnt/scratch/filler: fallocate failed: No space left on
>>> device
>>>
>>> ./punch-hole-on-full-fs 8000
>>> -- fallocate -p -o 0 -l 8000 /mnt/scratch/filler --
>>> fallocate: /mnt/scratch/filler: fallocate failed: No space left on
>>> device
>>>
>>>
>>> Thanks, Anand
>>


--PARW42rNFHxdgFdNtA7CILE6DPXDqoY74--

--FErb8pRps5eEba1ntupaGq58ig5jNXKk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlujbDoACgkQwj2R86El
/qgX0Af/V+db6dWC0o+fWEib6hiCbpcum5Vtb3iB+ZXPE7TU1wwvY4xVLY6NMJve
lOdjCRS0a+nL/kyeae4/pJk3pX9fZlPejIEnz/S51OgHBy6u8SIvscYY9UBsw0ll
xSjf6oSNf1vy4tBKeojRkih3/KRVe4XrVVIHpHaWNjz7m+AYnq7JHOjh02MVNVs3
yz1Y1rvU39bbfZj9g5J9aavjDxQClS54CpsWAvcqSSpys928SG6xcNe2JZ7nzRno
wAeFXLiX+mFTuvr6Z2e8kIyVzsFPfZNSw/kY5MEq64FjykcVh0kg0TU9PKT6jqNA
+NCMi1qvffgG9EIBd9H1I6Ikn5atjA==
=uxbr
-----END PGP SIGNATURE-----

--FErb8pRps5eEba1ntupaGq58ig5jNXKk7--
