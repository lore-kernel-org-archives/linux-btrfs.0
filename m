Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33612 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdACKFt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 05:05:49 -0500
Received: by mail-lf0-f41.google.com with SMTP id c13so282675290lfg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 02:05:48 -0800 (PST)
Subject: Re: Will fstrim discard unused parts of chunks?
To: Jeff Mahoney <jeffm@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
 <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <28c382e1-541b-1355-5aa5-692efc6453c9@gmail.com>
Date: Tue, 3 Jan 2017 13:05:39 +0300
MIME-Version: 1.0
In-Reply-To: <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gaJJWbBH3n5H1tKhMAbo4S59naDX33Xf0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gaJJWbBH3n5H1tKhMAbo4S59naDX33Xf0
Content-Type: multipart/mixed; boundary="KrRfMaIISSrrUKOCWSIN8iVXjDk5fJVcu"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <28c382e1-541b-1355-5aa5-692efc6453c9@gmail.com>
Subject: Re: Will fstrim discard unused parts of chunks?
References: <d538b76e-ecdc-19bb-2395-281a5c7c44e5@gmail.com>
 <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com>
In-Reply-To: <08b63d21-820e-6e69-bb5f-c9f94d8fc8ac@suse.com>

--KrRfMaIISSrrUKOCWSIN8iVXjDk5fJVcu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

03.01.2017 00:02, Jeff Mahoney =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 1/2/17 4:55 AM, Andrei Borzenkov wrote:
>> I try to understand what exactly is trimmed in case of btrfs. Using
>> installation in QEMU I see that host file size is about 9GB, allocated=

>> size in guest approximately matches it and used space in guest is 7.6G=
B.
>> After some experimenting it looks like host size follows "Device
>> allocated" value in "btrfs filesystem usage" which leads me to believe=

>> trim only considers space outside of allocated chunks. Is it correct?
>=20
> It should consider all available space.  The code iterates over all
> block groups and trims free space and then iterates over free dev
> extents, which is all of the unallocated space.
>=20
> Which kernel version are you using?  This stuff was broken for a while
> but was fixed in 4.3.
>=20

openSUSE TW 4.9.0-2-default.


--KrRfMaIISSrrUKOCWSIN8iVXjDk5fJVcu--

--gaJJWbBH3n5H1tKhMAbo4S59naDX33Xf0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlhrd3MACgkQR6LMutpd94yF/wCgntCDMt11aFYf1MkqzFjFrCrM
faYAnifKWv/ZykpHEOxUiH2PaR3gSV85
=fmNo
-----END PGP SIGNATURE-----

--gaJJWbBH3n5H1tKhMAbo4S59naDX33Xf0--
