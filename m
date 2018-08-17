Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:40739 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbeHQIyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 04:54:35 -0400
Subject: Re: btrfsck out of memory for big fs
To: "litaibaichina@gmail.com" <litaibaichina@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <201808171044160880896@gmail.com>
 <64a443c8-a041-ad07-3f16-2de616580a67@gmx.com>
 <2018081713260089574410@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <87d763ed-147a-e5fb-e596-74f63c9dfbbd@gmx.com>
Date: Fri, 17 Aug 2018 13:52:22 +0800
MIME-Version: 1.0
In-Reply-To: <2018081713260089574410@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VUMUb8UJ5XLsdt6K9vxXzItdHyXkwiNYA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VUMUb8UJ5XLsdt6K9vxXzItdHyXkwiNYA
Content-Type: multipart/mixed; boundary="Y4iXTxW2UzuclCgvvx7aSrRwkNKHkboxL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "litaibaichina@gmail.com" <litaibaichina@gmail.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <87d763ed-147a-e5fb-e596-74f63c9dfbbd@gmx.com>
Subject: Re: btrfsck out of memory for big fs
References: <201808171044160880896@gmail.com>
 <64a443c8-a041-ad07-3f16-2de616580a67@gmx.com>
 <2018081713260089574410@gmail.com>
In-Reply-To: <2018081713260089574410@gmail.com>

--Y4iXTxW2UzuclCgvvx7aSrRwkNKHkboxL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/17 =E4=B8=8B=E5=8D=881:26, litaibaichina@gmail.com wrote:
> thanks Qu.
> I am runing 4.12.
> /# btrfs --version
> btrfs-progs v4.12
>=20
> Do you think btrfsck can fix the fs issue ?

Nope, transid is pretty tricky especially for super old corruption.

> =C2=A0Or we better backup data and re-do the fs ?=20

I'd recommend to backup data asap.

Thanks,
Qu

>=20
> _______________________________________________________________________=
_________________________________________________________________________=
______________________
> From:=C2=A0Qu Wenruo
> Date:=C2=A02018-08-17=C2=A012:34
> To:=C2=A0litaibaichina@gmail.com; linux-btrfs@vger.kernel.org
> Subject:=C2=A0Re: btrfsck out of memory for big fs
> =C2=A0
> =C2=A0
> On 2018/8/17 =E4=B8=8A=E5=8D=8810:44, litaibaichina@gmail.com wrote:
>> Hi Guys,
>>
>> I had a big btrfs on a md device, =C2=A0it be mounted , but after a wh=
ile it will become ready only:
>> # btrfs fi df /data/
>> Data, single: total=3D24.46TiB, used=3D24.46TiB
>> System, DUP: total=3D8.00MiB, used=3D2.59MiB
>> System, single: total=3D4.00MiB, used=3D0.00B
>> Metadata, DUP: total=3D81.00GiB, used=3D79.71GiB
>> Metadata, single: total=3D8.00MiB, used=3D0.00B
>> GlobalReserve, single: total=3D512.00MiB, used=3D264.28MiB
>>
>> # dmesg -T
>> [Thu Aug 16 18:16:31 2018] BTRFS error (device md127): parent transid =
verify failed on 26603622694912 wanted 185320 found 207817
>> [Thu Aug 16 18:16:31 2018] BTRFS error (device md127): parent transid =
verify failed on 26603622694912 wanted 185320 found 207817
> =C2=A0
> Transaction id mismatch, normally this means some of the fs is already
> corrupted before.
> =C2=A0
> And considering the transid gap, the corruption happened quite a long
> time ago.
> =C2=A0
>> [Thu Aug 16 18:16:31 2018] BTRFS warning (device md127): Skipping comm=
it of aborted transaction.
>> [Thu Aug 16 18:16:31 2018] BTRFS: error (device md127) in cleanup_tran=
saction:1864: errno=3D-5 IO failure
>> [Thu Aug 16 18:16:31 2018] BTRFS info (device md127): forced readonly
>> [Thu Aug 16 18:16:31 2018] BTRFS info (device md127): delayed_refs has=
 NO entry
>>
>> I want to use btrfsck to check it, =C2=A0but it will OOM :
>> # btrfsck /dev/md127
>> Checking filesystem on /dev/md127
>> UUID: 6b87a52f-9a5f-4d03-b345-9d954c2ce259
>> checking extents
>> Killed
>>
>> I am trying to use lowmem mode, =C2=A0but as I tried before, it may OO=
M too, =C2=A0 =C2=A0any ideas ?
> =C2=A0
> This depends on which version you tried before.
> =C2=A0
> Lowmem mode used to do partial lowmem and partial normal mode check, an=
d
> normal mode caused the OOM.
> =C2=A0
> Latest lowmem mode should not cause OOM, but please ger ready for the
> super long run time.
> =C2=A0
> Thanks,
> Qu
>>
>> Thanks.
>>
> =C2=A0
>=20


--Y4iXTxW2UzuclCgvvx7aSrRwkNKHkboxL--

--VUMUb8UJ5XLsdt6K9vxXzItdHyXkwiNYA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt2YpYACgkQwj2R86El
/qh3yQf9H1kJ3EDvDWMDv3fswiqBIaFg/gMY1yqhUecjtxtHPII96VCDEGs5WaDj
OC9qD/VcVLtG2u4RwUyGbNlOmKjt1JrQLquUsJA8pDr2BmC3Y3W80iYlHrqUXL6Y
Ld87Rjz3ADADl0YUKzrOB+u2ehL9oV7jCVKGF4G4haIJZDanrCd2Qg6gGjiA4gye
91pNu0AVt+dos96qCn22rXFTRBF2pWmMot9dg6eYJgfGh38nrUZlqrbwpTuzRRig
b7iVzybC6VroLU2P6rlqtuYuia/YA60E29UHFUwWb30ahCRIeHigaTSmYHzGEXh6
5586xJQcey8mkc5/f995J2BJU1KeAw==
=gXT/
-----END PGP SIGNATURE-----

--VUMUb8UJ5XLsdt6K9vxXzItdHyXkwiNYA--
