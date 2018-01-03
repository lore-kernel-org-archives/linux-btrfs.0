Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54182 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750996AbeACCCW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 21:02:22 -0500
Subject: Re: Btrfs reserve metadata problem
To: robbieko <robbieko@synology.com>, pg@btrfs.list.sabi.co.uk
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
References: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
 <23115.33889.91390.589211@tree.ty.sabi.co.uk>
 <95211d8681c9335f2be2d8563839a492@synology.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0f371388-cb3f-5ed9-8cce-6cbd381d2615@gmx.com>
Date: Wed, 3 Jan 2018 10:01:59 +0800
MIME-Version: 1.0
In-Reply-To: <95211d8681c9335f2be2d8563839a492@synology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GhFlDijG7WtZ1SsKHnCOLvRRgFhG4OH2d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GhFlDijG7WtZ1SsKHnCOLvRRgFhG4OH2d
Content-Type: multipart/mixed; boundary="b2gIefDLtXhGu1SPotWuwj5KcOZFG9hXv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: robbieko <robbieko@synology.com>, pg@btrfs.list.sabi.co.uk
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
 linux-btrfs-owner@vger.kernel.org
Message-ID: <0f371388-cb3f-5ed9-8cce-6cbd381d2615@gmx.com>
Subject: Re: Btrfs reserve metadata problem
References: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
 <23115.33889.91390.589211@tree.ty.sabi.co.uk>
 <95211d8681c9335f2be2d8563839a492@synology.com>
In-Reply-To: <95211d8681c9335f2be2d8563839a492@synology.com>

--b2gIefDLtXhGu1SPotWuwj5KcOZFG9hXv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8803=E6=97=A5 09:55, robbieko wrote:
> Hi Qu,
>=20
> Do you have a patch to reduce meta rsv ?

Not exactly, only for qgroup.

[PATCH v2 10/10] btrfs: qgroup: Use independent and accurate per inode
qgroup rsv

But that could provide enough clue to implement a smaller meta rsv.

My current safe guess would be "(BTRFS_MAX_TREE_LEVEL + 2) * nodesize"
for each outstanding extent, and further step it with the number of
outstanding extents.
(Not always increase/decrease the meta rsv if outstanding extents
changes, but only increase/decrease if oustanding extents exceeds
certain amount)

Thanks,
Qu

>=20
>=20
> Hi Peter Grandi,
>=20
> 1. all files have been initialized with dd, No need to change any metad=
ata.
> 2. my test with Total volume size 190G, used 128G, available 60G, but
> only 60 MB dirty pages.
> =C2=A0=C2=A0=C2=A0 According to the meta rsv rules, 1GB free space up t=
o only 1MB dirty
> pages
> 3. cow enabled is also the same problem
>=20
> It is a serious performance issue.
>=20
> Thanks.
> robbieko
>=20
>=20
> pg@btrfs.list.sabi.co.UK =E6=96=BC 2018-01-02 21:08 =E5=AF=AB=E5=88=B0:=

>>> When testing Btrfs with fio 4k random write,
>>
>> That's an exceptionally narrowly defined workload. Also it is
>> narrower than that, because it must be without 'fsync' after
>> each write, or else there would be no accumulation of dirty
>> blocks in memory at all.
>>
>>> I found that volume with smaller free space available has
>>> lower performance.
>>
>> That's an inappropriate use of "performance"... The speed may be
>> lower, the performance is another matter.
>>
>>> It seems that the smaller the free space of volume is, the
>>> smaller amount of dirty page filesystem could have.
>>
>> Is this a problem? Consider: all filesystems do less well when
>> there is less free space (smaller chance of finding spatially
>> compact allocations), it is usually good to minimize the the
>> amont of dirty pages anyhow (even if there are reasons to keep
>> delay writing them out).
>>
>>> [ ... ] btrfs will reserve metadata for every write.=C2=A0 The
>>> amount to reserve is calculated as follows: nodesize *
>>> BTRFS_MAX_LEVEL(8) * 2, i.e., it reserves 256KB of metadata.
>>> The maximum amount of metadata reservation depends on size of
>>> metadata currently in used and free space within volume(free
>>> chunk size /16) When metadata reaches the limit, btrfs will
>>> need to flush the data to release the reservation.
>>
>> I don't understand here: under POSIX semantics filesystems are
>> not really allowed to avoid flushing *metadata* to disk for most
>> operations, that is metadata operations have an implied 'fsync'.
>> Your case of the "4k random write" with "cow disabled" the only
>> metadata that should get updated is the last-modified timestamp,
>> unless the user/application has been so amazingly stupid to not
>> preallocate the file, and then they deserve whatever they get.
>>
>>> 1. Is there any logic behind the value (free chunk size /16)
>>
>>> =C2=A0 /*
>>> =C2=A0=C2=A0 * If we have dup, raid1 or raid10 then only half of the =
free
>>> =C2=A0=C2=A0 * space is actually useable. For raid56, the space info =
used
>>> =C2=A0=C2=A0 * doesn't include the parity drive, so we don't have to
>>> =C2=A0=C2=A0 * change the math
>>> =C2=A0=C2=A0 */
>>> =C2=A0 if (profile & (BTRFS_BLOCK_GROUP_DUP |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GR=
OUP_RAID1 |
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_BLOCK_GR=
OUP_RAID10))
>>> =C2=A0=C2=A0 avail >>=3D 1;
>>
>> As written there is a plausible logic, but it is quite crude.
>>
>>> =C2=A0 /*
>>> =C2=A0=C2=A0 * If we aren't flushing all things, let us overcommit up=
 to
>>> =C2=A0=C2=A0 * 1/2th of the space. If we can flush, don't let us over=
commit
>>> =C2=A0=C2=A0 * too much, let it overcommit up to 1/8 of the space.
>>> =C2=A0=C2=A0 */
>>> =C2=A0 if (flush =3D=3D BTRFS_RESERVE_FLUSH_ALL)
>>> =C2=A0=C2=A0 avail >>=3D 3;
>>> =C2=A0 else
>>> =C2=A0=C2=A0 avail >>=3D 1;
>>
>> Presumably overcommitting beings some benefits on other workloads.
>>
>> In particular other parts of Btrfs don't behave awesomely well
>> when free space runs out.
>>
>>> 2. Is there any way to improve this problem?
>>
>> Again, is it a problem? More interestingly, if it is a problem
>> is a solution available that does not impact other workloads?
>> It is simply impossible to optimize a filesystem perfectly for
>> every workload.
>>
>> I'll try to summarize your report as I understand it:
>>
>> * If:
>> =C2=A0 - The workload is "4k random write" (without 'fsync').
>> =C2=A0 - On a "cow disabled" file.
>> =C2=A0 - The file is not preallocated.
>> =C2=A0 - There is not much free space available.
>> * Then allocation overcommitting results in a higher frequency
>> =C2=A0 of unrequested metadata flushes, and those metadata flushes
>> =C2=A0 slow down a specific benchmark.
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--b2gIefDLtXhGu1SPotWuwj5KcOZFG9hXv--

--GhFlDijG7WtZ1SsKHnCOLvRRgFhG4OH2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpMOZgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjCOgf/cjwuVlDVfdvGjf4mo5p6orD6
SIVIQL/QB0GzoJL91VXpQ1sQgIofrEy1yWk4hcwB7FVdTjXVy+jKIrNrugCr8iv8
GT7hZh30v7sGnHVbnKbyy8o6Bgu7fkBn2woEO0pqtgxsaXmgbEA8Al/SBBAoVkfa
B3NlTjmEUXdjFwcOjzCq4vzuDnrF7iKa1n5ZQ501JkMNEN7zB8JrPIClam2mL0j3
e/gqeJz6CVW9R5MJgyb1Yj9d7hN31SXn8qRdbWxlDa7OS/EoUDdmERQjEZAjJRZO
QJH6/OsvGiyH4AqYqu6GY9FIu/jVLI7r1JSdAL+yR/V8+u90r5Atc24vFQrLRw==
=WyUc
-----END PGP SIGNATURE-----

--GhFlDijG7WtZ1SsKHnCOLvRRgFhG4OH2d--
