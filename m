Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54461 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754948AbdLOIxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:53:21 -0500
Subject: Re: [4.14.3] btrfs out of space error
To: Ian Kumlien <ian.kumlien@gmail.com>, Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
 <20171215103423.0fd678a6@natsu>
 <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com>
Date: Fri, 15 Dec 2017 16:53:01 +0800
MIME-Version: 1.0
In-Reply-To: <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6fU5xr75sXDDf0DuIc8NubwWO980uSXid"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6fU5xr75sXDDf0DuIc8NubwWO980uSXid
Content-Type: multipart/mixed; boundary="V24k050nWqiL4NhN2oEDAGe9jhEuOgsu1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Ian Kumlien <ian.kumlien@gmail.com>, Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <88ff9cce-fa9b-ef4e-e1ea-062e13eec833@gmx.com>
Subject: Re: [4.14.3] btrfs out of space error
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
 <20171215103423.0fd678a6@natsu>
 <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>
In-Reply-To: <CAA85sZsEf7T+9s_BKpzoFm4aNO6hHsXNTk86LQCOiFiuA3aJYw@mail.gmail.com>

--V24k050nWqiL4NhN2oEDAGe9jhEuOgsu1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8815=E6=97=A5 16:36, Ian Kumlien wrote:
> On Fri, Dec 15, 2017 at 6:34 AM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Fri, 15 Dec 2017 01:39:03 +0100
>> Ian Kumlien <ian.kumlien@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> Running a 4.14.3 kernel, this just happened, but there should have
>>> been another 20 gigs or so available.
>>>
>>> The filesystem seems fine after a reboot though
>>
>> What are your mount options, and can you show the output of "btrfs fi
>> df" and "btrfs fi us" for the filesystem? And what does
>> "cat /sys/block/sdb/queue/rotational" return.
>=20
> It's a btrfs raid1 mirror of two ssd:s
>=20
> mount options was:
> defaults,acl,noatime,space_cache,autodefrag,compress=3Dlzo
>=20
> btrfs fi df /
> Data, RAID1: total=3D459.25GiB, used=3D372.42GiB
> Data, single: total=3D8.00MiB, used=3D0.00B
> System, RAID1: total=3D8.00MiB, used=3D80.00KiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, RAID1: total=3D6.00GiB, used=3D3.69GiB

Both meta and data has a lot of space let.

> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> btrfs fi us /
> Overall:
>     Device size: 930.54GiB
>     Device allocated: 930.53GiB
>     Device unallocated:   20.05MiB
>     Device missing:      0.00B
>     Used: 752.22GiB
>     Free (estimated):   86.84GiB (min: 86.84GiB)
>     Data ratio:       2.00
>     Metadata ratio:       2.00
>     Global reserve: 512.00MiB (used: 0.00B)
>=20
> Data,single: Size:8.00MiB, Used:0.00B
>    /dev/sdb2    8.00MiB
>=20
> Data,RAID1: Size:459.25GiB, Used:372.42GiB
>    /dev/sdb2 459.25GiB
>    /dev/sdc2 459.25GiB
>=20
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/sdb2    8.00MiB
>=20
> Metadata,RAID1: Size:6.00GiB, Used:3.69GiB
>    /dev/sdb2    6.00GiB
>    /dev/sdc2    6.00GiB
>=20
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/sdb2    4.00MiB
>=20
> System,RAID1: Size:8.00MiB, Used:80.00KiB
>    /dev/sdb2    8.00MiB
>    /dev/sdc2    8.00MiB
>=20
> Unallocated:
>    /dev/sdb2   24.00KiB
>    /dev/sdc2   20.02MiB

Well, at least no new chunk can be allocated.


In v4.15, Josef introduced a new inode reservation system, which I think
it would enhance metadata related reservation.

If you're hitting the problem quite frequently, please consider to try
v4.15-rc* to see if it solves the problem.

Despite of that, there should be no damage to your fs.
(except some unwritten data in buffer)

Thanks,
Qu

>=20
> And as expected:
> cat /sys/block/sdb/queue/rotational
> 0
>=20
>> I wonder if it's the same old "ssd allocation scheme" problem, and no
>> balancing done in a long time or at all.
>=20
> I had something similar happen on a laptop a while ago - took a while
> before i could get it back in order
> (in that case i think it was actually a oops --- it kept saying "no
> space left" and switched to read only even
> if you removed a lot of data, invalidated the space cache and so on)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--V24k050nWqiL4NhN2oEDAGe9jhEuOgsu1--

--6fU5xr75sXDDf0DuIc8NubwWO980uSXid
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlozjW0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj1iwf/e4hv+q0C7f8eZTT+gJ09zRYr
8HwCUttsfGoPevYM1AAt7w0eYxpFiNcbDgXNEaQ+xnJtMrgmf4EEVlJrE/vOIxLr
jedxvK4BiK0pHJMC2JJXeHVtA/SqEld6sqQTLxGz85MrjdRKNnWiBy1y5zqQkYnU
ZbRdXCV6Ls0ZUPZWfh+0S483Nt0dOcgrqCLl0a+f0Aa7aXk74pNZrScn12SVs+me
0ojtk79JBCZOmpEKjAvRJsBUGwUjxFMBkegqEJ200pjPgtbKSOa5eOg0+WMtUDgY
kiux/ZZB7Z+nIu/JNvFn2BNyzpiRYmXrwFW7vkmhN395BBNzN2F/who15X+ckg==
=Zr32
-----END PGP SIGNATURE-----

--6fU5xr75sXDDf0DuIc8NubwWO980uSXid--
