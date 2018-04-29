Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:41009 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753167AbeD2Jgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 05:36:32 -0400
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2471e5c7-fcb6-947e-359a-a59f634c02ca@gmx.com>
Date: Sun, 29 Apr 2018 17:36:26 +0800
MIME-Version: 1.0
In-Reply-To: <000b01d3df9b$40f17fd0$c2d47f70$@perdrix.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="so15Sc4zAciixzG9m1wz7MstdNdWn2ejW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--so15Sc4zAciixzG9m1wz7MstdNdWn2ejW
Content-Type: multipart/mixed; boundary="m7KYHzsvYK6wicxoqyLpJx7FkdRHWK8EV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "David C. Partridge" <david.partridge@perdrix.co.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <2471e5c7-fcb6-947e-359a-a59f634c02ca@gmx.com>
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
In-Reply-To: <000b01d3df9b$40f17fd0$c2d47f70$@perdrix.co.uk>

--m7KYHzsvYK6wicxoqyLpJx7FkdRHWK8EV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 17:20, David C. Partridge wrote:
> Here is the result of btrfs check after applying the patch

Doesn't work as expected.

Did you apply the patched tree block with "seek=3D"?

If so, please dump extent tree again to verify if the modification is
done correct.

# btrfs inspect dump-tree -t extent <device>

Thanks,
Qu

>=20
> Dave
> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]=20
> Sent: 29 April 2018 09:36
> To: David C. Partridge
> Subject: Re: Problems with btrfs
>=20
> Here is the patched binary tree block.
>=20
> You could apply them by the following command (copy1 and copy2 are the =
same).
>=20
> # dd if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D25942081536=
 # dd if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D26478952448
>=20
> And after that, try btrfs check to see if it reports new error.
>=20
> Thanks,
> Qu
>=20
> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:24, David C. Partridge wrote:=

>> Attached as requested
>>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org=20
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
>> Sent: 29 April 2018 03:08
>> To: David C. Partridge; linux-btrfs@vger.kernel.org
>> Subject: Re: Problems with btrfs
>>
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 09:55, David C. Partridge wrote=
:
>>> Not a problem
>>>
>>> See attached
>>
>> The final binary dump:
>>
>> # dd if=3D<device> of=3D/tmp/copy1.img bs=3D1 count=3D16K skip=3D25942=
081536 #=20
>> dd if=3D<device> of=3D/tmp/copy2.img bs=3D1 count=3D16K skip=3D2647895=
2448
>>
>> Thanks,
>> Qu
>>


--m7KYHzsvYK6wicxoqyLpJx7FkdRHWK8EV--

--so15Sc4zAciixzG9m1wz7MstdNdWn2ejW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrlkhoACgkQwj2R86El
/qin5Qf/cwJ7Qb0ori/e1IJ/l067dOR7AfhV7UZPSbATLBR8sX1NBKQBI94oVKLK
4SAyhM4UFb5MmaEND6tVom0F6Mq/N8Iobkoft3UB7gjDsojrDR0FWZYcxZLTtO/v
z8l+KAi3S+gKF2j5uw1sgCIZbwGe9qm6CfZ5S666xiWmERHr9+9FiRB0JJk1eOeZ
pZwQaaLGhttTSsyFWyXEhuHFVT9TN4RTafnwMmSJXFeRgIEkh1twc0K9hI4QGtBi
BAY84KtDIRSw+Otn+vDMyv+zUo1eMw8K6U9N91LVs4gdRoHUQT6Q7F+PgJ7KxdBM
mfsTyzyzQiI31UbAJZxDt3cShbZ4gw==
=+7ip
-----END PGP SIGNATURE-----

--so15Sc4zAciixzG9m1wz7MstdNdWn2ejW--
