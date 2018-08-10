Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:58274
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727570AbeHJQC4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 12:02:56 -0400
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20180809180450.5091-1-naota@elisp.net>
 <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <af160fd3-89dd-f54e-a1df-2a3cbc65a28d@mendix.com>
Date: Fri, 10 Aug 2018 15:32:41 +0200
MIME-Version: 1.0
In-Reply-To: <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="MpHEqdTr6acAqho4ueKXbv8uEn175JS5O"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MpHEqdTr6acAqho4ueKXbv8uEn175JS5O
Content-Type: multipart/mixed; boundary="A4uHv5nBwjF1mDUMfF02Ta6WLE84sZQ03";
 protected-headers="v1"
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <af160fd3-89dd-f54e-a1df-2a3cbc65a28d@mendix.com>
Subject: Re: [RFC PATCH 00/17] btrfs zoned block device support
References: <20180809180450.5091-1-naota@elisp.net>
 <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>
In-Reply-To: <d5473558-47a1-708e-551b-fabb4ea0842e@gmx.com>

--A4uHv5nBwjF1mDUMfF02Ta6WLE84sZQ03
Content-Type: text/plain; charset=utf-8
Content-Language: en_US
Content-Transfer-Encoding: quoted-printable

On 08/10/2018 09:28 AM, Qu Wenruo wrote:
>=20
>=20
> On 8/10/18 2:04 AM, Naohiro Aota wrote:
>> This series adds zoned block device support to btrfs.
>>
>> [...]
>=20
> And this is the patch modifying extent allocator.
>=20
> Despite that, the support zoned storage looks pretty interesting and
> have something in common with planned priority-aware extent allocator.

Priority-aware allocator? Is someone actually working on that, or is it
planned like everything is 'planned' (i.e. nice idea, and might happen
or might as well not happen ever, SIYH)?

--=20
Hans van Kranenburg


--A4uHv5nBwjF1mDUMfF02Ta6WLE84sZQ03--

--MpHEqdTr6acAqho4ueKXbv8uEn175JS5O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEESWyddwNaG9637koYssHfcmNhX2wFAlttlAMACgkQssHfcmNh
X2zf0RAAzGPTFn7ekJenEibazp67Y7B9X7n+Zc8rfVOrkNk+CedrICz9MSJhCDSp
U9+wK7w9HNkfkmYTjJccNY4KDjZgjkCaxGBRnnn2VBiwB7ZkxHgUbptW7MfOdwmT
90YaxtOfMBVGaFC9wU0cWdXRXP5hntBVYUDVAsVrQ/3pHphfD3oEv94nh1tEfHQ6
BFt60FS1xhN1xyKFncrUjAgN5f5+NM3B/neOby/fyH4uxH0Iyp2P2tTGKKsxqM4T
eH4EywJlVDdKBbJMkbHdNHKI1qidT+EREH9lqOs9cOW7Q286HXRp4KohSnFfCPWq
4qZbnirz39XhNECotakXozazMFAyCUA1NTml35JnsnBRxESAA/YsyyDhQifKhYJ1
e/WyKeoU2mh9GpX2vSUx1y69LygFNBZ/GeLXkpx3vYrw0Ph0tcPucGqTte6gIa8Y
XOnCalmCr59uJtUiVIaZD4TUTqQ7cJvqhtwk6W+wonXWThv7f3HViPwMjarpUj12
SRz5rhVKsoEkZ4P0xlqPz57Fn7zB4joqzBf1I8AFTtcXHmr1vFcGD+Ux/5whGeNJ
Ztz2QE/ZfOPe8yssJK5NXSJ1Rpr1KnTXZLJZyZD54zA6NTH27RVJIBIPYTfmZt6Y
2lRII9HanTErK/WLRxfNKfSau3TuBx1doy0SoBDLE+D3xsTPEus=
=aZOr
-----END PGP SIGNATURE-----

--MpHEqdTr6acAqho4ueKXbv8uEn175JS5O--
