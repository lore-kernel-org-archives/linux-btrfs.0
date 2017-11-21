Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51482 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752904AbdKUGLF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 01:11:05 -0500
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
 <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com>
 <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com>
Date: Tue, 21 Nov 2017 14:10:56 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="shv0m8vgcTmFa3CPDbKunqAOdxMfq4pqH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--shv0m8vgcTmFa3CPDbKunqAOdxMfq4pqH
Content-Type: multipart/mixed; boundary="LfMqd142vBBuq3QkB6WuXO1GxB2o3QusV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com>
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
 <4b7a0fae-ca96-7583-90d0-37cabc78849b@gmx.com>
 <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>
In-Reply-To: <CAJCQCtSezvyBGBQJRwQ+aeJH+8_8QsihkFD-iZaEVFeoL-00+Q@mail.gmail.com>

--LfMqd142vBBuq3QkB6WuXO1GxB2o3QusV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 13:58, Chris Murphy wrote:
> On Mon, Nov 20, 2017 at 9:58 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 12:49, Chris Murphy wrote:
>>> On Mon, Nov 20, 2017 at 9:43 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>>>
>>>>> Apply in addition to previous patch? Or apply to clean v4.14?
>>>>
>>>> On previous patch.
>>>
>>> Refuses to apply with or without previous patch.
>>>
>>> $ git apply -v ~/qufstrim3.patch
>>> Checking patch fs/btrfs/extent-tree.c...
>>> error: while searching for:
>>>        int dev_ret =3D 0;
>>>        int ret =3D 0;
>>>
>>>        /*
>>>         * try to trim all FS space, our block group may start from no=
n-zero.
>>>         */
>>>
>>> error: patch failed: fs/btrfs/extent-tree.c:10972
>>> error: fs/btrfs/extent-tree.c: patch does not apply
>>>
>>
>> Please try this branch.
>>
>> It's just previous patch and diff merged together and applied on v4.14=

>> tag from torvalds.
>>
>> https://github.com/adam900710/linux/tree/tmp
>=20
> # fstrim -v /
> /: 38 GiB (40767586304 bytes) trimmed
> # dmesg
>=20
> ..snip...
> [   46.408792] BTRFS info (device nvme0n1p8): trimming btrfs, start=3D0=

> len=3D75161927680 minlen=3D512
> [   46.408800] BTRFS info (device nvme0n1p8): bg start=3D140882477056
> len=3D1073741824
> [   46.433867] BTRFS info (device nvme0n1p8): trimming done

Great (for the output, not for the trimming failure).

And the problem is very obvious now.
140882477056 << First chunk start
75161927680  << length of fstrim_range passed in

Obviously, fstrim_range passed in is using the filesystem size it
assumes to be.

While we stupidly use the range in fstrim_range without considering the
fact that, we're dealing with *btrfs logical address space*.
Where our chunk can start from any bytenr (well, at least aligned with
sectorsize).
When I read the code I also think the range check has nothing wrong at al=
l.

So the truth here is, we should not ever try to check the range from
fstrim_range.

And the problem means that, a normal btrfs with some usage and after
several full balance, fstrim will only trim the unallocated space for btr=
fs.

Now the fix should not be a hard to craft.

Great thanks for all your help to locate the problem.

Thanks,
Qu
>=20
> Attaching 'btrfs-debug -b /' to get an idea about the block groups pres=
ent.
>=20
>=20
>=20


--LfMqd142vBBuq3QkB6WuXO1GxB2o3QusV--

--shv0m8vgcTmFa3CPDbKunqAOdxMfq4pqH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloTw3AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qj7/Qf/RPQkAZ87/4843Vtf1qcrcAvT
Idk85k3OTAMS24Tv3l6IecjkGj4UDroDyF0PDtMcsG6Ms3oMh5Bgm/c6JPQNQ48/
XLAg5qmkSlu8n4QjQpiLuMDh8irrbcDJebYy496/KdWJUGsPrp3ZSC/eft5Dij6+
KiLo06shy/8tJdN4fLzzWZ7JoaEBeWOiBEpZ2CfEv9wxMkQg5Ine7ibyU7PZaCL2
ORtYXITsph15dFG5TDAucpXm3njFhdwBEqMF5DEoaS12TU7XNFBt6MUV0Obk3S89
oMx2unytX0Ak7v5eN9Bxdc2J3a8177uk6Q1PENKAhfOxdgGkt2eps4fXhUerFA==
=1BRX
-----END PGP SIGNATURE-----

--shv0m8vgcTmFa3CPDbKunqAOdxMfq4pqH--
