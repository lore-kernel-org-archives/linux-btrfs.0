Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54735 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751808AbeAYMhY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 07:37:24 -0500
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
To: "^m'e" <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
Date: Thu, 25 Jan 2018 20:37:18 +0800
MIME-Version: 1.0
In-Reply-To: <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Qs2YnFcZ3thEyFNei712lYS4M2GDglUSj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qs2YnFcZ3thEyFNei712lYS4M2GDglUSj
Content-Type: multipart/mixed; boundary="SviGuqvW3IizT5NWmcDL8pII6Yp4QJnCK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ^m'e <marcoep@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <80321b99-a89c-fadf-8f1a-26ed8f598a66@gmx.com>
Subject: Re: btrfs check: backref lost, mismatch with its hash -- can't repair
References: <CAAxOLF8pwZ5jcZxB4=h-bPZBxsnCV7sB=LOghGfa0HhRqgJfSg@mail.gmail.com>
 <270851c6-7725-ec63-fa6d-6ff63e99c637@gmx.com>
 <CAAxOLF8GRV3ZX=cahf0szsvtyQO0Qv32PEKoMBzq+1R=imjzxw@mail.gmail.com>
 <c0f89fad-2c98-fd78-4bcb-7c19dd3c03b0@gmx.com>
 <08afcd3e-b365-b49f-55c6-770a2b560395@gmail.com>
 <a990d2db-a9ba-256b-1389-e9f350a94060@gmx.com>
 <CAAxOLF9Hqnbc6g20dPasrtXW+Es562mOBujc7ve7Fc6LzG7tcQ@mail.gmail.com>
 <03ba8382-3271-6c11-b217-a48d1423e684@gmx.com>
 <CAAxOLF_DB4_5wBem3qgU-B97Hq8xkmE67_qD-7Fe2=my-FN_iw@mail.gmail.com>
 <CAAxOLF8KgC=_LoaEaKft2Q7gUhKL3Fp8OLizbnnA9v4h_cSprQ@mail.gmail.com>
 <CAAxOLF9k3WJ-JPJsCEaW4ZD+XMzhRdaRXouaWLwX1JBSM1Xnxw@mail.gmail.com>
 <6d5bfa3f-3c49-1380-2bcf-d6eeca57020a@gmx.com>
 <CAAxOLF_wRCxgebwXUy7A5AqKtKchGLz46DKNiM-iPejVpfjbFg@mail.gmail.com>
 <0662a08f-5869-3eb3-5ab2-391ba9603095@gmx.com>
 <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>
In-Reply-To: <CAAxOLF8wt98KCONdEJXMvUuzxeB5_GwigGhCzEE6hSpmurXRNw@mail.gmail.com>

--SviGuqvW3IizT5NWmcDL8pII6Yp4QJnCK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8825=E6=97=A5 20:29, ^m'e wrote:
> No luck this time:
>=20
> # ./btrfs-corrupt-block.static -X /dev/sdb3
> ERROR: Failed to unlink the old file "Manifest": No such file or direct=
ory
> extent buffer leak: start 4210688 len 16384
> extent_io.c:607: free_extent_buffer_internal: BUG_ON `eb->flags &
> EXTENT_DIRTY` triggered, value 1
> [0x416a32]
> [0x41720e]
> [0x41725a]
> [0x40a6e1]
> [0x40aee3]
> [0x403245]
> [0x43ba83]
> [0x43bbdf]
> [0x400989]
> Aborted

Checked the dump again, no need to unlink, just remove the offending
item should be good enough.

Branch updated, please check again.

Thanks,
Qu

>=20
> On Thu, Jan 25, 2018 at 12:09 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>> Confirmed same problem as previous root.
>>
>> So branch updated to fix the same problem for root 257.
>>
>> Please try and see if the following error message is gone:
>>
>> ------
>> ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
>> INODE_ITEM[0] namelen 0 filename  filetype 0
>> ERROR: root 257 DIR_ITEM[30039322 4007295565] data_len shouldn't be 32=
907
>> ERROR: root 257 DIR_ITEM[30039322 4007295565] couldn't find relative
>> INODE_ITEM[0] namelen 3 filename  filetype 0
>> ------
>>
>> Thanks,
>> Qu
>>
>>
>=20
>=20
>=20


--SviGuqvW3IizT5NWmcDL8pII6Yp4QJnCK--

--Qs2YnFcZ3thEyFNei712lYS4M2GDglUSj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlppz34XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjaEAf9Ge1p+VUfLyEzheEXD+CUsdYB
BmRAqdc4r66vwo55HExI6OYTnI7oT1N+GZdM2CBmaxcbnHa+KlD1HJwB6ejpIXYo
5EL+G892YkYPQPMqJ+/mqki4zh3uS6xyWBwdkeqd0kQTy5u4H2ZUvfzw86+xSxag
+iM277mM8WO2BTBrIcMQiSQDYTvODsS5lbOuJSeGhskHWZFBstEYuCj7HXEvze3F
D3Cfe6B5GvxzPNw8ltU6Q9jd3ufBARtCzlY63rv02XToMX0++9JxHAPLcTiFo+32
737rgFA9TLRfb1QQmQjxHBkccb0IScsas379RduUVAWa8RNX0zCXTqNghJtf1Q==
=Fot4
-----END PGP SIGNATURE-----

--Qs2YnFcZ3thEyFNei712lYS4M2GDglUSj--
