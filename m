Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:35905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753379AbeDAKed (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Apr 2018 06:34:33 -0400
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
 <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com>
 <CAJCQCtSAfYxZigvrgAq=vw3anMKiPK=ZWnOvC+mbR__XUW8ugA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3247ca88-4ea6-f5a7-d21c-0b3105e9a7f3@gmx.com>
Date: Sun, 1 Apr 2018 18:34:27 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSAfYxZigvrgAq=vw3anMKiPK=ZWnOvC+mbR__XUW8ugA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tAJfKXzLR7EXVp7Ee86HVYoyk4NhRKFx0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tAJfKXzLR7EXVp7Ee86HVYoyk4NhRKFx0
Content-Type: multipart/mixed; boundary="1eRnGRsQv9GwplZtkHu4VS4MpFftaZ70K";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <3247ca88-4ea6-f5a7-d21c-0b3105e9a7f3@gmx.com>
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
 <a95813ad-d87e-bd5a-a258-c3d241fa5181@gmx.com>
 <CAJCQCtSAfYxZigvrgAq=vw3anMKiPK=ZWnOvC+mbR__XUW8ugA@mail.gmail.com>
In-Reply-To: <CAJCQCtSAfYxZigvrgAq=vw3anMKiPK=ZWnOvC+mbR__XUW8ugA@mail.gmail.com>

--1eRnGRsQv9GwplZtkHu4VS4MpFftaZ70K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8801=E6=97=A5 11:28, Chris Murphy wrote:
> On Mon, Nov 20, 2017 at 11:10 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wr=
ote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 13:58, Chris Murphy wrote:
>>> On Mon, Nov 20, 2017 at 9:58 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>
>>>>
>>>> On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 12:49, Chris Murphy wrote:
>>>>> On Mon, Nov 20, 2017 at 9:43 PM, Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Apply in addition to previous patch? Or apply to clean v4.14?
>>>>>>
>>>>>> On previous patch.
>>>>>
>>>>> Refuses to apply with or without previous patch.
>>>>>
>>>>> $ git apply -v ~/qufstrim3.patch
>>>>> Checking patch fs/btrfs/extent-tree.c...
>>>>> error: while searching for:
>>>>>        int dev_ret =3D 0;
>>>>>        int ret =3D 0;
>>>>>
>>>>>        /*
>>>>>         * try to trim all FS space, our block group may start from =
non-zero.
>>>>>         */
>>>>>
>>>>> error: patch failed: fs/btrfs/extent-tree.c:10972
>>>>> error: fs/btrfs/extent-tree.c: patch does not apply
>>>>>
>>>>
>>>> Please try this branch.
>>>>
>>>> It's just previous patch and diff merged together and applied on v4.=
14
>>>> tag from torvalds.
>>>>
>>>> https://github.com/adam900710/linux/tree/tmp
>>>
>>> # fstrim -v /
>>> /: 38 GiB (40767586304 bytes) trimmed
>>> # dmesg
>>>
>>> ..snip...
>>> [   46.408792] BTRFS info (device nvme0n1p8): trimming btrfs, start=3D=
0
>>> len=3D75161927680 minlen=3D512
>>> [   46.408800] BTRFS info (device nvme0n1p8): bg start=3D140882477056=

>>> len=3D1073741824
>>> [   46.433867] BTRFS info (device nvme0n1p8): trimming done
>>
>> Great (for the output, not for the trimming failure).
>>
>> And the problem is very obvious now.
>> 140882477056 << First chunk start
>> 75161927680  << length of fstrim_range passed in
>>
>> Obviously, fstrim_range passed in is using the filesystem size it
>> assumes to be.
>>
>> While we stupidly use the range in fstrim_range without considering th=
e
>> fact that, we're dealing with *btrfs logical address space*.
>> Where our chunk can start from any bytenr (well, at least aligned with=

>> sectorsize).
>> When I read the code I also think the range check has nothing wrong at=
 all.
>>
>> So the truth here is, we should not ever try to check the range from
>> fstrim_range.
>>
>> And the problem means that, a normal btrfs with some usage and after
>> several full balance, fstrim will only trim the unallocated space for =
btrfs.
>>
>> Now the fix should not be a hard to craft.
>>
>> Great thanks for all your help to locate the problem.
>=20
> I still see this problem in 4.16.0-0.rc7.git1.1.fc29.x86_64. Are there
> any patches to test?
>=20
> [chris@f27h mnt]$ sudo btrfs fi us /
> Overall:
>     Device size:          70.00GiB
>     Device allocated:          60.06GiB
>     Device unallocated:           9.94GiB
>     Device missing:             0.00B
>     Used:              36.89GiB
>     Free (estimated):          29.75GiB    (min: 24.78GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:         107.77MiB    (used: 12.38MiB)
>=20
> Data,single: Size:55.00GiB, Used:35.19GiB
>    /dev/nvme0n1p9      55.00GiB
>=20
> Metadata,single: Size:5.00GiB, Used:1.70GiB
>    /dev/nvme0n1p9       5.00GiB
>=20
> System,DUP: Size:32.00MiB, Used:16.00KiB
>    /dev/nvme0n1p9      64.00MiB
>=20
> Unallocated:
>    /dev/nvme0n1p9       9.94GiB
> [chris@f27h mnt]$ sudo fstrim -v /
> [sudo] password for chris:
> /: 10 GiB (10669260800 bytes) trimmed

The latest version is here
https://patchwork.kernel.org/patch/10078773/
https://patchwork.kernel.org/patch/10083979/

And I didn't see it in misc-next either, I may need to ping it soon.

Thanks,
Qu


--1eRnGRsQv9GwplZtkHu4VS4MpFftaZ70K--

--tAJfKXzLR7EXVp7Ee86HVYoyk4NhRKFx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrAtbMACgkQwj2R86El
/qjyIgf/VMXOQuKbafw5l10qQ+Lm8ClUJJbBd71xGz1Zbu/jffAKLljUhGsjIhgI
agGNkZL1c2Vzcj7J49GCq0qC/WAZewIH57pNpj2VnjP2TUb4i9bwYjG0QcJEdLQH
ocS6dnxhFXkhYeP0NfNgFeTZvi5tRPoXMYQODuGaNQkVaadtzrkOK2SerE20KMY5
ajcSIJrZLKlxqzR3jDVC1ZMjwGnbe25AX3hrwnjj/zv6lN+EdhXUbVY3fY23+eNy
pzb7wiOWx3y8/GMYRcx7YfZ+nPkzcS0mkjzn7kbDGH/Aso35MyRNCzWexuxGZ8m9
BKJRQAkLhSTgn66kcHox6Ka6ASVnrQ==
=Jv6r
-----END PGP SIGNATURE-----

--tAJfKXzLR7EXVp7Ee86HVYoyk4NhRKFx0--
