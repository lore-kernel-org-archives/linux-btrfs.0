Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51310 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752429AbdKUE6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 23:58:25 -0500
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
 <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
 <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
 <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com>
 <CAJCQCtS6tXcKRuwZiAfB8eUkENz6secVcvxYS=syCFp_VH_+Vw@mail.gmail.com>
 <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com>
 <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com>
Date: Tue, 21 Nov 2017 12:58:05 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K5iBSVglpOH2W9KIFCLFlv0PuSQr0w6q0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K5iBSVglpOH2W9KIFCLFlv0PuSQr0w6q0
Content-Type: multipart/mixed; boundary="OxTO9Aa7Q9uDJcwn3Jv2J0xONJs4XqJaE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com>
 <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com>
 <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
 <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
 <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com>
 <CAJCQCtS6tXcKRuwZiAfB8eUkENz6secVcvxYS=syCFp_VH_+Vw@mail.gmail.com>
 <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com>
 <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>
In-Reply-To: <CAJCQCtQiTt78svzzdcV_Pm2iPK6RgYLXsvMda7H6aQeMf2w07g@mail.gmail.com>

--OxTO9Aa7Q9uDJcwn3Jv2J0xONJs4XqJaE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 12:49, Chris Murphy wrote:
> On Mon, Nov 20, 2017 at 9:43 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>>>
>>> Apply in addition to previous patch? Or apply to clean v4.14?
>>
>> On previous patch.
>=20
> Refuses to apply with or without previous patch.
>=20
> $ git apply -v ~/qufstrim3.patch
> Checking patch fs/btrfs/extent-tree.c...
> error: while searching for:
>        int dev_ret =3D 0;
>        int ret =3D 0;
>=20
>        /*
>         * try to trim all FS space, our block group may start from non-=
zero.
>         */
>=20
> error: patch failed: fs/btrfs/extent-tree.c:10972
> error: fs/btrfs/extent-tree.c: patch does not apply
>=20

Please try this branch.

It's just previous patch and diff merged together and applied on v4.14
tag from torvalds.

https://github.com/adam900710/linux/tree/tmp

Thanks,
Qu


--OxTO9Aa7Q9uDJcwn3Jv2J0xONJs4XqJaE--

--K5iBSVglpOH2W9KIFCLFlv0PuSQr0w6q0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloTsl0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg3UggAjwxdHvp/CKoaIsNSxAdCLgZm
tTZJLzVjOwK/QCylB1mKgBOHmqIBBVg0+j+ORCs7gNxe6PT6KqaW9YkHWy92bhEl
akypEGjmFiq4UUTW2WLXLM0FRfBmSJYAeOMpuU5C+QU1mz0mlyy0vn7EEYHjIFIp
w6eVPCV5yg9IUJzAAcv4HacVUny1R14geaDoIiijSydCbKZy4NyGnEdi47QA802C
2FN9is4oKrKJbcmTA7js3nnraN3Luvnp89BKLXZp9g57IeHR0P+4TcuddYUjLP6K
/KXMgsvXzOoMoRWy+2TP/AXiOhwXBAF4xqN9QMzYlIhrQgpXVhtPWo2kvYFBsw==
=YJsC
-----END PGP SIGNATURE-----

--K5iBSVglpOH2W9KIFCLFlv0PuSQr0w6q0--
