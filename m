Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51485 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751732AbdJYHV1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Oct 2017 03:21:27 -0400
Subject: Re: check: "warning line 4144"
To: Tom Hale <tom@hale.ee>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <82b863c8-ef92-736c-2a9d-51102db07919@hale.ee>
 <c9a41b3b-16d8-e504-bfd1-79295cc465a7@gmx.com>
 <101d5f86-acd1-8d94-4d10-df49335465dc@hale.ee>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0a8a5ba6-f6f0-abec-e4fc-2ac470dfe3e4@gmx.com>
Date: Wed, 25 Oct 2017 15:21:17 +0800
MIME-Version: 1.0
In-Reply-To: <101d5f86-acd1-8d94-4d10-df49335465dc@hale.ee>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QkIpOIsaFkiIWphq9OcMD9Hv8coO2BdF2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QkIpOIsaFkiIWphq9OcMD9Hv8coO2BdF2
Content-Type: multipart/mixed; boundary="90IkD34V4O6bo5Sq7CjKINFMreFW3ISNR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tom Hale <tom@hale.ee>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <0a8a5ba6-f6f0-abec-e4fc-2ac470dfe3e4@gmx.com>
Subject: Re: check: "warning line 4144"
References: <82b863c8-ef92-736c-2a9d-51102db07919@hale.ee>
 <c9a41b3b-16d8-e504-bfd1-79295cc465a7@gmx.com>
 <101d5f86-acd1-8d94-4d10-df49335465dc@hale.ee>
In-Reply-To: <101d5f86-acd1-8d94-4d10-df49335465dc@hale.ee>

--90IkD34V4O6bo5Sq7CjKINFMreFW3ISNR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8825=E6=97=A5 14:54, Tom Hale wrote:
>=20
>=20
> On 19/10/17 15:58, Qu Wenruo wrote:
>> On 2017=E5=B9=B410=E6=9C=8819=E6=97=A5 16:53, Tom Hale wrote:
>>> In running btrfs check, I got the following message:
>>>
>>>     warning line 4144
>>>
>>> Could this be a little more descriptive?
>>>
>>> * Does it mean I should rebuild my FS from scratch?
>>> * Is there anything I can do to remove this warning?
>>>
>>
>> --repair is dangerous, use it unless you're sure the problem can be
>> fixed by it.
>>
>> What's the output of "btrfs check" and "btrfs check --mode=3Dlowmem" a=
fter
>> doing the repair?
>=20
> Plain `btrfs check` gives me:
>=20
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/mapper/vg_svelte-home
> UUID: 93722fa7-7e8f-418a-a7ca-080aca8db94b
> found 192318169092 bytes used, no error found
> total csum bytes: 185482112
> total tree bytes: 1924104192
> total fs tree bytes: 1597767680
> total extent tree bytes: 102514688
> btree space waste bytes: 325265468
> file data blocks allocated: 6169163599872
>  referenced 575636733952

At least your fs is good to go.

>=20
> Could somebody please answer my initial questions about this obscure
> warning?

Only two places will output this warning, and they are both used by
original mode.

So at least if you're using lowmem mode, you won't encounter this
warning line.


And for your line at 4144, git blames shows it's from the ancient day of
btrfs-progs.

According to a quick glance of it, it seems that during the check, it
encountered a shared node, which is quite common for fs with snapshots,
but it doesn't do the cleanup correctly.

I think it's caused by some extent tree problem, which lacks some
backref or has some mismatch backref, to cause the shared node checking
code behaved unexpectedly.
(runtime glitch)

Thanks,
Qu


>=20
> Thanks,
>=20


--90IkD34V4O6bo5Sq7CjKINFMreFW3ISNR--

--QkIpOIsaFkiIWphq9OcMD9Hv8coO2BdF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnwO20XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh91gf/fcMwauUNORZ1yT/KPUbt73b7
FVRhMwbDTaF2ttLoCOgHDBniFHAzW2Kgyrr+8FvUwXQqLs1JbaVazDXDxAIGD2Fj
X878u7u97UndFN5pTQZi10I34wdIEdHrn3KzIlN/SN6K5aVDxzmSh3Wf99vapXgP
zUZD2c6jRrX94fK+YWdWffJgmXdZ2sgTrsN8q0SahrCek/v0lzN0U168loCSLrSW
QYjySKAt7HzS2hHprd/7AiBICiyRUA6ILENJI9+EiKhknq83+ZWP1XzKzij0IRIE
yPZEO0yF3nEv921xvnkCFI1I0abqdpHbFjGmcfGkki1vgK/pEXl1EM7l4g6/HQ==
=bFhf
-----END PGP SIGNATURE-----

--QkIpOIsaFkiIWphq9OcMD9Hv8coO2BdF2--
