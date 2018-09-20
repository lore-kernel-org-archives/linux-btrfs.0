Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:45041 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbeITPIq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 11:08:46 -0400
Subject: Re: Punch hole on full fs
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
 <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
 <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a04ecfd1-9577-5ff0-92f0-fdf9c23e41e9@gmx.com>
Date: Thu, 20 Sep 2018 17:26:02 +0800
MIME-Version: 1.0
In-Reply-To: <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="crD9l8kfg1HQlqN6UZ9MWOfPL9l4T4Efq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--crD9l8kfg1HQlqN6UZ9MWOfPL9l4T4Efq
Content-Type: multipart/mixed; boundary="dFKKhbQl2Veq4PPXoH6kUaxR9gcgszLp7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <a04ecfd1-9577-5ff0-92f0-fdf9c23e41e9@gmx.com>
Subject: Re: Punch hole on full fs
References: <58b447dc-1872-4231-f1d4-5cd4274d3e87@oracle.com>
 <45f18cb2-37f7-3b69-4b4e-94103226b8f5@gmx.com>
 <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>
In-Reply-To: <59747a61-9e41-750c-f3e8-6a518695ff33@oracle.com>

--dFKKhbQl2Veq4PPXoH6kUaxR9gcgszLp7
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

Well, at least in my test, that's not the case.

I did a pretty simpler test, and for NODATACOW inode, the sub-sectorsize
part didn't get COWed, just as what we expect:

# mkfs.btrfs -f $dev
# mount $dev -o nodatacow $dev $mnt
# xfs_io -f -c "pwrite 0 16K" -c sync $mnt/file
# btrfs ins dump-tree -t 5 $dev
# xfs_io -c "fpunch 2K 6K" $mnt/file
# btrfs ins dump-tree -t 5 $dev

The last punch hole did created a 4K hole as expect, but the 0~4K extent
doesn't get COWed at all.

	item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
		generation 6 type 1 (regular)
		extent data disk byte 13631488 nr 16384 <<<
		extent data offset 0 nr 4096 ram 16384
		extent compression 0 (none)
	item 7 key (257 EXTENT_DATA 4096) itemoff 15760 itemsize 53
		generation 8 type 1 (regular)
		extent data disk byte 0 nr 0
		extent data offset 0 nr 4096 ram 4096
		extent compression 0 (none)
	item 8 key (257 EXTENT_DATA 8192) itemoff 15707 itemsize 53
		generation 6 type 1 (regular)
		extent data disk byte 13631488 nr 16384 <<<
		extent data offset 8192 nr 8192 ram 16384
		extent compression 0 (none)

So the failure even with nodatacow mount option looks a little
suspicious now.

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


--dFKKhbQl2Veq4PPXoH6kUaxR9gcgszLp7--

--crD9l8kfg1HQlqN6UZ9MWOfPL9l4T4Efq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlujZ6oACgkQwj2R86El
/qhr5Qf9G7CpGxGACsW6xPcgjqFaYX2AWz2mwSGgwOPjug8SnsI1VVc0T1eiuZ6n
EWu8gkly9bCNePNp7J5K7K42jFri4Q2TQq+pAePCEXy7usnlIJC6idLrm6+lJqGo
mZFgddv/LSiBio3axR26v3G7pGMqkSYuuxPKwjxDbb3bvjjcG0KqRKc9QSMxW2YF
WDkZcITd/BTkBzxU5/I0d35YMRxRLIC1cp9+777Z4qIrb2knntoG3HUoTuh7+/tl
SS9dcchaRp1PRDrODgUc0tBGfw4IU664mpwIQkPa1oBW1f+e9LhUnhqnVqePaOKT
IIUs3jhIM9YjPJqafLfEhubd5mNysQ==
=qToP
-----END PGP SIGNATURE-----

--crD9l8kfg1HQlqN6UZ9MWOfPL9l4T4Efq--
