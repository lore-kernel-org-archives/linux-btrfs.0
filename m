Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730934AbeIXSEb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 14:04:31 -0400
Subject: Re: [PATCH 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
 <1537784193-24431-2-git-send-email-anand.jain@oracle.com>
 <c770f3ed-a813-74c9-0b9d-04a3ce740185@gmx.com>
 <bdd780f8-8c50-c859-30ba-53c68d81bb72@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <80c6fc3d-4c30-34b7-ecc1-31eddb12fe59@gmx.com>
Date: Mon, 24 Sep 2018 20:02:34 +0800
MIME-Version: 1.0
In-Reply-To: <bdd780f8-8c50-c859-30ba-53c68d81bb72@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DK5TdeRDcFjvfYG0Oqk0mhGoQiGDdU5bb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DK5TdeRDcFjvfYG0Oqk0mhGoQiGDdU5bb
Content-Type: multipart/mixed; boundary="Dsk3WqGcCpYiVAI0NSGOMjrMtesBZm0u8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <80c6fc3d-4c30-34b7-ecc1-31eddb12fe59@gmx.com>
Subject: Re: [PATCH 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
 <1537784193-24431-2-git-send-email-anand.jain@oracle.com>
 <c770f3ed-a813-74c9-0b9d-04a3ce740185@gmx.com>
 <bdd780f8-8c50-c859-30ba-53c68d81bb72@oracle.com>
In-Reply-To: <bdd780f8-8c50-c859-30ba-53c68d81bb72@oracle.com>

--Dsk3WqGcCpYiVAI0NSGOMjrMtesBZm0u8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/24 =E4=B8=8B=E5=8D=887:53, Anand Jain wrote:
>=20
>=20
> On 09/24/2018 06:58 PM, Qu Wenruo wrote:
>>
>>
>> On 2018/9/24 =E4=B8=8B=E5=8D=886:16, Anand Jain wrote:
>>> As of now _scratch_mkfs_sized check if the requested size is below 1G=

>>> and forces the --mixed option for the mkfs.btrfs. Well the correct si=
ze
>>> at which we need to force the mixed option is 114294784bytes. Fix tha=
t.
>>
>> How this size is get from?
>> If it's from btrfs_min_dev_size(), I strongly recommend to add referen=
ce
>> here, and don't use the ugly intermediate number.
>>
>>
>> BTW, this number is related to mkfs profile.
>> If you really want to use some maximum number, please follow the max
>> possible value in btrfs_min_dev_size(), which should be 229M other tha=
n
>> 106M.
>=20
> =C2=A0Thanks for the comments. I completely missed out the point of oth=
er
> =C2=A0group profile requiring more than ~115 bytes. Will fix.

I'd go a rounded number, like 256M.

Non of the number from btrfs_min_dev_size() is really easy to remember
nor makes sense out of btrfs realm.

And this also leaves a little more headroom for later modification
(although I hope such modification never happen)

Thanks,
Qu

> =C2=A0Yep the ref for the size is btrfs_min_dev_size().
>=20
> -Anand
>=20
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>> =C2=A0 common/rc | 4 +++-
>>> =C2=A0 1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/common/rc b/common/rc
>>> index d5bb1feee2c3..bcdbf03e1bf0 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -969,7 +969,9 @@ _scratch_mkfs_sized()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ;;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local mixed_opt=3D
>>> -=C2=A0=C2=A0=C2=A0 (( fssize <=3D 1024 * 1024 * 1024 )) && mixed_opt=
=3D'--mixed'
>>> +=C2=A0=C2=A0=C2=A0 # minimum size that's needed without the mixed op=
tion.
>>> +=C2=A0=C2=A0=C2=A0 # Non mixed mode is also the default option.
>>> +=C2=A0=C2=A0=C2=A0 (( fssize < 114294784 )) && mixed_opt=3D'--mixed'=

>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 $MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_=
opt -b $fssize $SCRATCH_DEV
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ;;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 jfs)
>>>
>>


--Dsk3WqGcCpYiVAI0NSGOMjrMtesBZm0u8--

--DK5TdeRDcFjvfYG0Oqk0mhGoQiGDdU5bb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluo0loACgkQwj2R86El
/qgvLAgAnjF2lvXZODJ4j4+hvaTNYkRTFrrZvob9OJWCbsuNv+aH5iD5JTbDQ/qf
v0ZMp72FDG5hkL4YKQLGgIabThgIuZwv1G5xky4+gnBm2n3VP03+dSGXhB37NEOA
TX4UO2YXTFG8Prbuo/KemqYr/RqlBRb/tqOHtHj07JFbOrIJwTvHIiRXztNBHy8W
pZ9DEQrTULVRIg9L0u3jqf+4o83t1obf8t2Q7UwR0Kq9rmvf92hin0jodZGXm8uV
v09OEr5QT4U3qVu1e3I0qkzHqxeVFo1NyNrifQgUe/t5DF5unJKHAyazEV/35/Ip
3ZsbOvstHdlsN+Gad8bfvrAiMZoszQ==
=7Ycq
-----END PGP SIGNATURE-----

--DK5TdeRDcFjvfYG0Oqk0mhGoQiGDdU5bb--
