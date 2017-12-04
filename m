Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59262 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751104AbdLDAee (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Dec 2017 19:34:34 -0500
Subject: Re: exclusive subvolume space missing
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
Date: Mon, 4 Dec 2017 08:34:28 +0800
MIME-Version: 1.0
In-Reply-To: <20171202093301.GA28256@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f8LxDL3WK2baAUmBpqxeq0QVpXKDppwVK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f8LxDL3WK2baAUmBpqxeq0QVpXKDppwVK
Content-Type: multipart/mixed; boundary="eEXbf3o207TgVAg3PQUGAW702J0Re8loC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
Subject: Re: exclusive subvolume space missing
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
In-Reply-To: <20171202093301.GA28256@polanet.pl>

--eEXbf3o207TgVAg3PQUGAW702J0Re8loC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8802=E6=97=A5 17:33, Tomasz Pala wrote:
> OK, I seriously need to address that, as during the night I lost
> 3 GB again:
>=20
> On Sat, Dec 02, 2017 at 10:35:12 +0800, Qu Wenruo wrote:
>=20
>>> #  btrfs fi sh /
>>> Label: none  uuid: 17a3de25-6e26-4b0b-9665-ac267f6f6c4a
>>>         Total devices 2 FS bytes used 44.10GiB
>            Total devices 2 FS bytes used 47.28GiB
>=20
>>> #  btrfs fi usage /
>>> Overall:
>>>     Used:                         88.19GiB
>        Used:                         94.58GiB
>>>     Free (estimated):             18.75GiB      (min: 18.75GiB)
>        Free (estimated):             15.56GiB      (min: 15.56GiB)
>>>
>>> #  btrfs dev usage /
> - output not changed
>=20
>>> #  btrfs fi df /   =20
>>> Data, RAID1: total=3D51.97GiB, used=3D43.22GiB
>    Data, RAID1: total=3D51.97GiB, used=3D46.42GiB
>>> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
>>> Metadata, RAID1: total=3D2.00GiB, used=3D895.69MiB
>>> GlobalReserve, single: total=3D131.14MiB, used=3D0.00B
>    GlobalReserve, single: total=3D135.50MiB, used=3D0.00B
>>>
>>> # df
>>> /dev/sda2        64G   45G   19G  71% /
>    /dev/sda2        64G   48G   16G  76% /
>>> However the difference is on active root fs:
>>>
>>> -0/291        24.29GiB      9.77GiB
>>> +0/291        15.99GiB     76.00MiB
>     0/291        19.19GiB      3.28GiB
>>
>> Since you have already showed the size of the snapshots, which hardly
>> goes beyond 1G, it may be possible that extent booking is the cause.
>>
>> And considering it's all exclusive, defrag may help in this case.
>=20
> I'm going to try defrag here, but have a bunch of questions before;
> as defrag would break CoW, I don't want to defrag files that span
> multiple snapshots, unless they have huge overhead:
> 1. is there any switch resulting in 'defrag only exclusive data'?

IIRC, no.

> 2. is there any switch resulting in 'defrag only extents fragmented mor=
e than X'
>    or 'defrag only fragments that would be possibly freed'?

No, either.

> 3. I guess there aren't, so how could I accomplish my target, i.e.
>    reclaiming space that was lost due to fragmentation, without breakin=
g
>    spanshoted CoW where it would be not only pointless, but actually ha=
rmful?

What about using old kernel, like v4.13?

> 4. How can I prevent this from happening again? All the files, that are=

>    written constantly (stats collector here, PostgreSQL database and
>    logs on other machines), are marked with nocow (+C); maybe some new
>    attribute to mark file as autodefrag? +t?

Unfortunately, nocow only works if there is no other subvolume/inode
referring to it.

That's to say, if you're using snapshot, then NOCOW won't help as much
as you expected, but still much better than normal data cow.

>=20
> For example, the largest file from stats collector:
>      Total   Exclusive  Set shared  Filename
>  432.00KiB   176.00KiB   256.00KiB  load/load.rrd
>=20
> but most of them has 'Set shared'=3D=3D0.
>=20
> 5. The stats collector is running from the beginning, according to the
> quota output was not the issue since something happened. If the problem=

> was triggered by (guessing) low space condition, and it results in even=

> more space lost, there is positive feedback that is dangerous, as makes=

> any filesystem unstable ("once you run out of space, you won't recover"=
).
> Does it mean btrfs is simply not suitable (yet?) for frequent updates u=
sage
> pattern, like RRD files?

Hard to say the cause.

But in my understanding, btrfs is not suitable for such conflicting
situation, where you want to have snapshots of frequent partial updates.

IIRC, btrfs is better for use case where either update is less frequent,
or update is replacing the whole file, not just part of it.

So btrfs is good for root filesystem like /etc /usr (and /bin /lib which
is pointing to /usr/bin and /usr/lib) , but not for /var or /run.

>=20
> 6. Or maybe some extra steps just before taking snapshot should be take=
n?
> I guess 'defrag exclusive' would be perfect here - reclaiming space
> before it is being locked inside snapshot.

Yes, this sounds perfectly reasonable.

Thanks,
Qu

> Rationale behind this is obvious: since the snapshot-aware defrag was
> removed, allow to defrag snapshot exclusive data only.
> This would of course result in partial file defragmentation, but that
> should be enough for pathological cases like mine.


--eEXbf3o207TgVAg3PQUGAW702J0Re8loC--

--f8LxDL3WK2baAUmBpqxeq0QVpXKDppwVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlokmBQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhdnwf/TajBmNpioZ3F7n2/FMqQ8+W4
GfFLpc76XN48RPgYQ0/uRzzTYzDiAC7SjzvYkT/1K0zQP6jDLo+BZq0g0P+p9Z3P
t4pkSOBGU4dv8LhKrA0C8o+0g1Z/vKn8qxIoSEjb4XfsMg2E0SiULmPd5IUoHQOo
HPrEgDBuVYFiUxXOU/+v2Zk9/3fjixB+OZ3fm+Mj5xXKs5Re2L6boanDvDLh5/kV
5Bj/SJ1wkMfkdxYQcGoXKtHTwyUnTopIlZnw6Bykj5YKyo/n665AmAzvvY6hYHt2
IwR84GPui4OBtCldAhgWEsd9i9Hlz0okWzHJ5u6gM1AI8dfIyw0n4I4oA0qawg==
=wz2z
-----END PGP SIGNATURE-----

--f8LxDL3WK2baAUmBpqxeq0QVpXKDppwVK--
