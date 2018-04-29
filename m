Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:48055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753255AbeD2KAY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 06:00:24 -0400
Subject: Re: Problems with btrfs
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
        linux-btrfs@vger.kernel.org
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
 <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
 <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk>
 <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com>
 <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk>
 <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com>
 <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk>
 <0dba3a1c-434a-dc23-5d5d-75151121ffbf@gmx.com>
 <001701d3df0a$55d7cf30$01876d90$@perdrix.co.uk>
 <275af8f8-4997-5246-d2a4-99ab2bf299fb@gmx.com>
 <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk>
 <c26c307a-75ce-d0f5-ca29-75854c34280c@gmx.com>
 <002a01d3df93$74b7b760$5e272620$@perdrix.co.uk>
 <126b8a98-384e-af68-8a36-ad702f07fad2@gmx.com>
 <000b01d3df9b$40f17fd0$c2d47f70$@perdrix.co.uk>
 <2471e5c7-fcb6-947e-359a-a59f634c02ca@gmx.com>
 <003101d3dfa0$35ba0060$a12e0120$@perdrix.co.uk>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0e55fced-b634-2887-8535-9d2a23f43c57@gmx.com>
Date: Sun, 29 Apr 2018 18:00:08 +0800
MIME-Version: 1.0
In-Reply-To: <003101d3dfa0$35ba0060$a12e0120$@perdrix.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ClBxd9obsmsrWufFkuvO8poEXlHLn9ASE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ClBxd9obsmsrWufFkuvO8poEXlHLn9ASE
Content-Type: multipart/mixed; boundary="RfL8HBYvFyvm05XHe3t6EuM6BRYk2geaN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <0e55fced-b634-2887-8535-9d2a23f43c57@gmx.com>
Subject: Re: Problems with btrfs
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk>
 <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com>
 <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk>
 <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com>
 <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk>
 <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com>
 <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk>
 <0dba3a1c-434a-dc23-5d5d-75151121ffbf@gmx.com>
 <001701d3df0a$55d7cf30$01876d90$@perdrix.co.uk>
 <275af8f8-4997-5246-d2a4-99ab2bf299fb@gmx.com>
 <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk>
 <c26c307a-75ce-d0f5-ca29-75854c34280c@gmx.com>
 <002a01d3df93$74b7b760$5e272620$@perdrix.co.uk>
 <126b8a98-384e-af68-8a36-ad702f07fad2@gmx.com>
 <000b01d3df9b$40f17fd0$c2d47f70$@perdrix.co.uk>
 <2471e5c7-fcb6-947e-359a-a59f634c02ca@gmx.com>
 <003101d3dfa0$35ba0060$a12e0120$@perdrix.co.uk>
In-Reply-To: <003101d3dfa0$35ba0060$a12e0120$@perdrix.co.uk>

--RfL8HBYvFyvm05XHe3t6EuM6BRYk2geaN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 17:55, David C. Partridge wrote:
> Yes I did use seek=3D
>=20
> I attach the new dump-tree - it seems very short compared to the last o=
ne you requested ???

Well, my fault, wrong spell.

# btrfs inspect dump-tree -t extent <device>

Which should give a lengthy dump.

Thanks,
Qu

>=20
> Dave
>=20
> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]=20
> Sent: 29 April 2018 10:36
> To: David C. Partridge; linux-btrfs@vger.kernel.org
> Subject: Re: Problems with btrfs
>=20
>=20
>=20
> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 17:20, David C. Partridge wrote:=

>> Here is the result of btrfs check after applying the patch
>=20
> Doesn't work as expected.
>=20
> Did you apply the patched tree block with "seek=3D"?
>=20
> If so, please dump extent tree again to verify if the modification is d=
one correct.
>=20
> # btrfs inspect dump-tree -t extent <device>
>=20
> Thanks,
> Qu
>=20
>>
>> Dave
>> -----Original Message-----
>> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
>> Sent: 29 April 2018 09:36
>> To: David C. Partridge
>> Subject: Re: Problems with btrfs
>>
>> Here is the patched binary tree block.
>>
>> You could apply them by the following command (copy1 and copy2 are the=
 same).
>>
>> # dd if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D2594208153=
6 # dd=20
>> if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D26478952448
>>
>> And after that, try btrfs check to see if it reports new error.
>>
>> Thanks,
>> Qu
>>
>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:24, David C. Partridge wrote=
:
>>> Attached as requested
>>>
>>> -----Original Message-----
>>> From: linux-btrfs-owner@vger.kernel.org=20
>>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
>>> Sent: 29 April 2018 03:08
>>> To: David C. Partridge; linux-btrfs@vger.kernel.org
>>> Subject: Re: Problems with btrfs
>>>
>>>
>>>
>>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 09:55, David C. Partridge wrot=
e:
>>>> Not a problem
>>>>
>>>> See attached
>>>
>>> The final binary dump:
>>>
>>> # dd if=3D<device> of=3D/tmp/copy1.img bs=3D1 count=3D16K skip=3D2594=
2081536 #=20
>>> dd if=3D<device> of=3D/tmp/copy2.img bs=3D1 count=3D16K skip=3D264789=
52448
>>>
>>> Thanks,
>>> Qu
>>>
>=20


--RfL8HBYvFyvm05XHe3t6EuM6BRYk2geaN--

--ClBxd9obsmsrWufFkuvO8poEXlHLn9ASE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrll6gACgkQwj2R86El
/qjyBgf/entGAVlOYoCslXZzIw/KYVMUvSOjFxyRqJlX7KaTXJa+9tJEep2V80V6
E4F6iuCzyTV8oLq3b756b9wtmpw5ADe1Oj34fM+nu03+lSS5loPYOD4gUqNheuDd
N+Pgj1aSsfIs89gcJH0bGcvFyY2Y+VJCcl8y2kZhSNsvnnqohwOUEr1jSNfTyFEM
KELLPUeNyn1o1vhhs75Ju+UK5CTDzaftwpA9HlaoGqFoYdqCTPyiHX5WZpvp5nhE
gApRVSi1xND8uLmM4ZITiiuryCJF3C1C6fAuIqpqX7qFi/azkLIzHiYi3jWiHnNI
i0G88gpdBqsI6kFwi5xMDU6xOiZR2A==
=Rxi9
-----END PGP SIGNATURE-----

--ClBxd9obsmsrWufFkuvO8poEXlHLn9ASE--
