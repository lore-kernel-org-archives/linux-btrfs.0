Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:53028 "EHLO
        avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752647AbeD2JUE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 05:20:04 -0400
From: "David C. Partridge" <david.partridge@perdrix.co.uk>
To: "'Qu Wenruo'" <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk> <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com> <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk> <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com> <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk> <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com> <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk> <0dba3a1c-434a-dc23-5d5d-75151121ffbf@gmx.com> <001701d3df0a$55d7cf30$01876d90$@perdrix.co.uk> <275af8f8-4997-5246-d2a4-99ab2bf299fb@gmx.com> <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk> <c26c307a-75ce-d0f5-ca29-75854c34280c@gmx.com> <002a01d3df93$74b7b760$5e272620$@perdrix.co.uk> <126b8a98-384e-af68-8a36-ad702f07fad2@gmx.com>
In-Reply-To: <126b8a98-384e-af68-8a36-ad702f07fad2@gmx.com>
Subject: RE: Problems with btrfs
Date: Sun, 29 Apr 2018 10:20:01 +0100
Message-ID: <000b01d3df9b$40f17fd0$c2d47f70$@perdrix.co.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_000C_01D3DFA3.A2B635F0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_000C_01D3DFA3.A2B635F0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Here is the result of btrfs check after applying the patch

Dave
-----Original Message-----
From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]=20
Sent: 29 April 2018 09:36
To: David C. Partridge
Subject: Re: Problems with btrfs

Here is the patched binary tree block.

You could apply them by the following command (copy1 and copy2 are the =
same).

# dd if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D25942081536 =
# dd if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D26478952448

And after that, try btrfs check to see if it reports new error.

Thanks,
Qu

On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:24, David C. Partridge wrote:
> Attached as requested
>=20
> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org=20
> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: 29 April 2018 03:08
> To: David C. Partridge; linux-btrfs@vger.kernel.org
> Subject: Re: Problems with btrfs
>=20
>=20
>=20
> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 09:55, David C. Partridge =
wrote:
>> Not a problem
>>
>> See attached
>=20
> The final binary dump:
>=20
> # dd if=3D<device> of=3D/tmp/copy1.img bs=3D1 count=3D16K =
skip=3D25942081536 #=20
> dd if=3D<device> of=3D/tmp/copy2.img bs=3D1 count=3D16K =
skip=3D26478952448
>=20
> Thanks,
> Qu
>=20

------=_NextPart_000_000C_01D3DFA3.A2B635F0
Content-Type: application/octet-stream;
	name="btrfs-check1.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="btrfs-check1.log"

root@ubuntu:/home/amonra# btrfs check /dev/mapper/Charon--vg-root=0A=
Checking filesystem on /dev/mapper/Charon--vg-root=0A=
UUID: a0a6c5a6-061f-4c86-bc14-7f9abf3cb57e=0A=
checking extents=0A=
owner ref check failed [224304857088 16384]=0A=
checking free space cache=0A=
Wanted bytes 32768, found 65536 for off 236453888000=0A=
Wanted bytes 536870912, found 65536 for off 236453888000=0A=
cache appears valid but isn't 236453888000=0A=
Wanted bytes 16384, found 557056 for off 279384162304=0A=
Wanted bytes 536870912, found 557056 for off 279384162304=0A=
cache appears valid but isn't 279384162304=0A=
found 26552209419 bytes used err is -22=0A=
total csum bytes: 23801264=0A=
total tree bytes: 2076573696=0A=
total fs tree bytes: 1966374912=0A=
total extent tree bytes: 77348864=0A=
btree space waste bytes: 571022401=0A=
file data blocks allocated: 192698281984=0A=
 referenced 132292960256=0A=
root@ubuntu:/home/amonra# =0A=

------=_NextPart_000_000C_01D3DFA3.A2B635F0--

