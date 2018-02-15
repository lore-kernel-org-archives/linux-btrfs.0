Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43565 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966421AbeBOEci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 23:32:38 -0500
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
 <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <58ea1e02-6f38-97f7-34aa-e993a1aa261b@gmx.com>
Date: Thu, 15 Feb 2018 12:32:27 +0800
MIME-Version: 1.0
In-Reply-To: <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VDLnKmXsSGhPwpoFZDRsm60DrJEzVI7VG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VDLnKmXsSGhPwpoFZDRsm60DrJEzVI7VG
Content-Type: multipart/mixed; boundary="ey0vEaBdrzK4RzkpC8stZk7ClWtaifnpR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <58ea1e02-6f38-97f7-34aa-e993a1aa261b@gmx.com>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
 <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
In-Reply-To: <f77a1a28c2cbf08efd24577088a29de0@virtall.com>

--ey0vEaBdrzK4RzkpC8stZk7ClWtaifnpR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8815=E6=97=A5 12:19, Tomasz Chmielewski wrote:
> On 2018-02-15 10:47, Qu Wenruo wrote:
>> On 2018=E5=B9=B402=E6=9C=8814=E6=97=A5 22:19, Tomasz Chmielewski wrote=
:
>>> Just FYI, how dangerous running btrfs can be - we had a fatal,
>>> unrecoverable MySQL corruption when btrfs decided to do one of these =
"I
>>> have ~50 GB left, so let's do out of space (and corrupt some files at=

>>> the same time, ha ha!)".
>>
>> I'm recently looking into unexpected corruption problem of btrfs.
>>
>> Would you please provide some extra info about how the corruption
>> happened?
>>
>> 1) Is there any power reset?
>> =C2=A0=C2=A0 Btrfs should be bullet proof, but in fact it's not, so I'=
m here to
>> =C2=A0=C2=A0 get some clue.
>=20
> No power reset.
>=20
>=20
>> 2) Are MySQL files set with nodatacow?
>> =C2=A0=C2=A0 If so, data corruption is more or less expected, but shou=
ld be
>> =C2=A0=C2=A0 handled by checkpoint of MySQL.
>=20
> Yes, MySQL files were using "nodatacow".
>=20
> I've seen many cases of "filesystem full" with ext4, but none lead to
> database corruption (i.e. the database would always recover after
> releasing some space)
>=20
> On the other hand, I've seen a handful of "out of space" with gigabytes=

> of free space with btrfs, which lead to some light, heavy or
> unrecoverable MySQL or mongo corruption.

Is there any kernel message like kernel warning or backtrace?

>=20
>=20
> Can it be because of of how "predictable" out of space situations are
> with btrfs and other filesystems?

It's possible.
As other filesystem doesn't really dynamically allocate its metadata
space, (ext4/xfs just have limited inode numbers) and btrfs strictly
split metadata and data usage, it's possible that we still have gigas of
data space, but run out of meta space.

>=20
> - in short, ext4 will report out of space when there is 0 bytes left
> (perhaps slightly faster for non-root users) - the application trying t=
o
> write data will see "out of space" at some point, and it can stay like
> this for hours (i.e. until some data is removed manually)
>=20
> - on the other hand, btrfs can report out of space when there is still
> 10, 50 or 100 GB left, meaning, any capacity planning is close to
> impossible; also, the application trying to write data can be seeing th=
e
> fs as transitioning between "out of space" and "data written
> successfully" many times per minute/second?
>=20
>=20
>> 3) Is the filesystem metadata corrupted? (AKA, btrfs check report erro=
r)
>> =C2=A0=C2=A0 If so, that should be the problem I'm looking into.
>=20
> I don't think so, there are no scary things in dmesg. However, I didn't=

> unmount the filesystem to run btrfs check.

If no scary kernel warning, then it may be less serious.

One of my assumption is, snapshots are used in your btrfs setup (well,
more or less the only two selling points of btrfs), and even your DB is
using nodatacow, due to snapshot, it still does data CoW.

And when the DB fails to write some critical data, maybe write ahead log
or similiar things, due to ENOSPC, it causes inconsistency.

The problem here is, most DB assumes the filesystem is defaulted to do
overwrite successfully, while it's not always true to btrfs.

If that's the case, would you please remove all snapshots of your DB
subvolume? Or just put all DB into one subvolume and never snapshot it?
Then nodatacow should work as expected, so it would be more or less more
similar to ext4/xfs. (Although still slower than ext4/xfs)

>=20
>=20
>> 4) Metadata/data ratio?
>> =C2=A0=C2=A0 "btrfs fi usage" could have quite good result about it.
>> =C2=A0=C2=A0 And "btrfs fi df" also helps.
>=20
> Here it is - however, that's after removing some 80 GB data, so most
> likely doesn't reflect when the failure happened.
>=20
> # btrfs fi usage /var/lib/lxd
> Overall:
> =C2=A0=C2=A0=C2=A0 Device size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 846.25GiB
> =C2=A0=C2=A0=C2=A0 Device allocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 840.05GiB
> =C2=A0=C2=A0=C2=A0 Device unallocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.20GiB

That's should prevent further ENOSPC, as long as this number is beyond 1G=
=2E

> =C2=A0=C2=A0=C2=A0 Device missing:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> =C2=A0=C2=A0=C2=A0 Used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 498.26GiB
> =C2=A0=C2=A0=C2=A0 Free (estimated):=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 167.96GiB=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (m=
in: 167.96GiB)
> =C2=A0=C2=A0=C2=A0 Data ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 2.00
> =C2=A0=C2=A0=C2=A0 Metadata ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.0=
0
> =C2=A0=C2=A0=C2=A0 Global reserve:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512.00MiB=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 (used: 0.00B)
>=20
> Data,RAID1: Size:411.00GiB, Used:246.14GiB
> =C2=A0=C2=A0 /dev/sda3=C2=A0=C2=A0=C2=A0=C2=A0 411.00GiB
> =C2=A0=C2=A0 /dev/sdb3=C2=A0=C2=A0=C2=A0=C2=A0 411.00GiB
>=20
> Metadata,RAID1: Size:9.00GiB, Used:2.99GiB
> =C2=A0=C2=A0 /dev/sda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9.00GiB
> =C2=A0=C2=A0 /dev/sdb3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9.00GiB
>=20
> System,RAID1: Size:32.00MiB, Used:80.00KiB
> =C2=A0=C2=A0 /dev/sda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32.00MiB
> =C2=A0=C2=A0 /dev/sdb3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0 /dev/sda3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.10GiB
> =C2=A0=C2=A0 /dev/sdb3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.10GiB
>=20
>=20
>=20
> # btrfs fi df /var/lib/lxd
> Data, RAID1: total=3D411.00GiB, used=3D246.15GiB
> System, RAID1: total=3D32.00MiB, used=3D80.00KiB
> Metadata, RAID1: total=3D9.00GiB, used=3D2.99GiB

Not sure if the removal of 80G has anything to do with this, but this
seems that your metadata (along with data) is quite scattered.

It's really recommended to keep some unallocated device space, and one
of the method to do that is to use balance to free such scattered space
from data/metadata usage.

And that's why balance routine is recommened for btrfs.

Thanks,
Qu

> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
>=20
>=20
> # btrfs fi show /var/lib/lxd
> Label: 'btrfs'=C2=A0 uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes use=
d 249.15GiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 423.13GiB used 420.03GiB path /dev/sda3
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 si=
ze 423.13GiB used 420.03GiB path /dev/sdb3
>=20
>=20
>=20
> Tomasz Chmielewski
> https://lxadm.com


--ey0vEaBdrzK4RzkpC8stZk7ClWtaifnpR--

--VDLnKmXsSGhPwpoFZDRsm60DrJEzVI7VG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqFDVsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiOEwf9HEcd+yrVTPoTLgZLpoH4l1Xq
vZuaLJJ3/V487domj0hnA243lKwIEpRfs64SYbdb2wefYkXSytm9m9LryrMFb99f
4300ztz3dglX18tghtScwi5iln1L0tHZkOlVy/QQ23kdzlSCn7AU76imeLVZn7bg
gyunupHvVD3BYbng8y7XQWPH952CxK5NI9Sf+avSZukU6OyXrDbb2944v9GphAG7
z9816odZDv3NVAJrr4MEMLnI00Op+iTEvpwagR2cfU+st8GuoXti11ZsOIg4ST2c
zcndnZxI/jAY08/cZp1WijRuGbnRm2a1MUmYR5Lz3sac3GvNsinBgTfkEEKy3g==
=xL8T
-----END PGP SIGNATURE-----

--VDLnKmXsSGhPwpoFZDRsm60DrJEzVI7VG--
