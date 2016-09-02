Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38985 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbcIBCEH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 22:04:07 -0400
Subject: Re: your mail
To: Kyle Gates <kylegates@live.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
 <20160901074415.pz32d72d4h6pk77t@invalid>
 <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
 <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <2c480ed1-dc46-2756-1e05-380d6dd3e0f9@suse.com>
Date: Thu, 1 Sep 2016 21:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VD5AQaNJWXLe5ueXS4gRTh126iQX4quuk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VD5AQaNJWXLe5ueXS4gRTh126iQX4quuk
Content-Type: multipart/mixed; boundary="14OlQosvoVxAmogV9xiWS3KpOsluMm2Ki";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Kyle Gates <kylegates@live.com>,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <2c480ed1-dc46-2756-1e05-380d6dd3e0f9@suse.com>
Subject: Re: your mail
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
 <20160901074415.pz32d72d4h6pk77t@invalid>
 <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
 <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>
In-Reply-To: <CY4PR06MB2726B15A26AA728457B155B9B0E20@CY4PR06MB2726.namprd06.prod.outlook.com>

--14OlQosvoVxAmogV9xiWS3KpOsluMm2Ki
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/1/16 12:44 PM, Kyle Gates wrote:
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Austin S. Hemmelgarn
>> Sent: Thursday, September 01, 2016 6:18 AM
>> To: linux-btrfs@vger.kernel.org
>> Subject: Re: your mail
>>
>> On 2016-09-01 03:44, M G Berberich wrote:
>>> Am Mittwoch, den 31. August schrieb Fennec Fox:
>>>> Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37
>> UTC
>>>> 2016 x86_64 GNU/Linux
>>>> btrfs-progs v4.7
>>>>
>>>> Data, single: total=3D30.01GiB, used=3D18.95GiB System, single:
>>>> total=3D4.00MiB, used=3D16.00KiB Metadata, single: total=3D1.01GiB,
>>>> used=3D422.17MiB GlobalReserve, single: total=3D144.00MiB, used=3D0.=
00B
>>>>
>>>> {02:50} Wed Aug 31
>>>> [fennectech@Titanium ~]$  sudo fstrim -v / [sudo] password for
>>>> fennectech:
>>>> Sorry, try again.
>>>> [sudo] password for fennectech:
>>>> /: 99.8 GiB (107167244288 bytes) trimmed
>>>>
>>>> {03:08} Wed Aug 31
>>>> [fennectech@Titanium ~]$  sudo fstrim -v / [sudo] password for
>>>> fennectech:
>>>> /: 99.9 GiB (107262181376 bytes) trimmed
>>>>
>>>>   I ran these commands minutes after echother ane each time it is
>>>> trimming the entire free space
>>>>
>>>> Anyone else seen this?   the filesystem is the root FS and is compre=
ssed
>>>
>>> You should be very happy that it is trimming at all. Typical situatio=
n
>>> on a used btrfs is
>>>
>>>   # fstrim -v /
>>>   /: 0 B (0 bytes) trimmed
>>>
>>> even if there is 33G unused space ob the fs:
>>>
>>>   # df -h /
>>>   Filesystem      Size  Used Avail Use% Mounted on
>>>   /dev/sda2        96G   61G   33G  66% /
>>>
>> I think you're using an old kernel, this has been working since at lea=
st 4.5, but
>> was broken in some older releases.
>=20
> M G is running 4.7.2
> The problem is that all space has been allocated by block groups and fs=
trim will only work on unallocated space.

Historically it was the opposite problem.  My fixes made it so it would
work on unallocated space.  We probably need some debugging to see why
it's not discarding extents that are allocated as block groups but
unallocated within them.

-Jeff

> On my system all space has been allocated on my root filesystem so 0 B =
are trimmed:
> kyle@home:~$  uname -a
> Linux home 4.7.2-040702-generic #201608201334 SMP Sat Aug 20 17:37:03 U=
TC 2016 x86_64 x86_64 x86_64 GNU/Linux
> kyle@home:~$  sudo btrfs fi show /
> Label: 'root'  uuid: 6af4ebde-81ef-428a-a45f-0e8480ad969a
>         Total devices 2 FS bytes used 13.44GiB
>         devid   14 size 20.00GiB used 20.00GiB path /dev/sde2
>         devid   15 size 20.00GiB used 20.00GiB path /dev/sdb2
> kyle@home:~$  btrfs fi df /
> Data, RAID1: total=3D18.97GiB, used=3D12.98GiB
> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> Metadata, RAID1: total=3D1.00GiB, used=3D473.83MiB
> GlobalReserve, single: total=3D160.00MiB, used=3D0.00B
> kyle@home:~$  sudo fstrim -v /
> [sudo] password for kyle:
> /: 0 B (0 bytes) trimmed
>=20
> But I do have space trimmed on my home filesystem:
> kyle@home:~$  sudo btrfs fi show /home/
> Label: 'home'  uuid: b75fb450-4a28-434a-a483-e784940d463a
>         Total devices 2 FS bytes used 18.63GiB
>         devid   11 size 64.00GiB used 29.03GiB path /dev/sde3
>         devid   12 size 64.00GiB used 29.03GiB path /dev/sdb3
> kyle@home:~$  btrfs fi df /home/
> Data, RAID1: total=3D27.00GiB, used=3D18.46GiB
> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> Metadata, RAID1: total=3D2.00GiB, used=3D168.62MiB
> GlobalReserve, single: total=3D64.00MiB, used=3D0.00B
> kyle@home:~$  sudo fstrim -v /home
> /home: 70 GiB (75092721664 bytes) trimmed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--14OlQosvoVxAmogV9xiWS3KpOsluMm2Ki--

--VD5AQaNJWXLe5ueXS4gRTh126iQX4quuk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyNskAAoJEB57S2MheeWyOv0P/ROLnM6BtHG+6Ye360UWEdhp
0PBCITPgMJ6foay9dj0FXp00g7FbqJtwRySsfMNXnvB16S/naYv6Og2bPGIsigOU
ISjLLEz0vC3gZIoL0kh7+MUJL5rYX++rDFoTRIH0muUZZjCq/rVBb93Yewywh78P
adzTAu2aX8Dd419RGo5t91YMZpHSHzdRTTyxB/WD2S9QLnz0p2Z+6AtlyIi10TpY
gGxl/FJXE4lqr7TrukdyyEe44mZJVstJk8y7oESdPC6uB3niCeLWsdRos2pwM2KD
mXmP3vt31BvIVgtxnyFFgNRAV0sMasYKR5q1RZ7jVKpY24uC/Mb5mmsMYtM6A8kU
8OV529TbEesgh5PRusqUviWEjKP/hgG+jQv/ucvt4MnaNhYZYiQE09XXlai0R9hy
bv6DVZSI92kARTCxAGjbsexhTvbGttRHn+AB0ihdfeceHI57LR704E0NNPy4O3q/
YClDyFE5IGR5VM/uINmPX3LZ4VxDQQn6hmQEI2I3oSDSBxdDdvhdVWA7M8VHoOEu
HZzek+q59OR0AapjE1aLDdMpQVeQcXDeE0gyVKFtwnBOkayD3Lm/3x7FESg2YyW0
dAsYsEozji7sLjMo2wRmBpbyYvh1QHDvH01v6YEIfN7NrvrNThbeATdE13luuchw
Su17rCdOy5K4tWk+BPmX
=tAyk
-----END PGP SIGNATURE-----

--VD5AQaNJWXLe5ueXS4gRTh126iQX4quuk--
