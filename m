Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731734AbeG2BMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jul 2018 21:12:32 -0400
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
To: Nicholas D Steeves <nsteeves@gmail.com>, jkexcel <jkexcel@comcast.net>
Cc: linux-btrfs@vger.kernel.org
References: <1438689914.6655.1532811050018@connect.xfinity.com>
 <20180728213448.GA16016@DigitalMercury.dynalias.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6c37e7ef-5669-7464-c72a-69a2074ebfb1@gmx.com>
Date: Sun, 29 Jul 2018 07:44:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180728213448.GA16016@DigitalMercury.dynalias.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1nM0niQEXS38HPmQD4lx8IaQRIE5oTwyH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1nM0niQEXS38HPmQD4lx8IaQRIE5oTwyH
Content-Type: multipart/mixed; boundary="yBdBXgQG2w6Fb3HIvMJ3MV92AhyGcKH9K";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nicholas D Steeves <nsteeves@gmail.com>, jkexcel <jkexcel@comcast.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <6c37e7ef-5669-7464-c72a-69a2074ebfb1@gmx.com>
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
References: <1438689914.6655.1532811050018@connect.xfinity.com>
 <20180728213448.GA16016@DigitalMercury.dynalias.net>
In-Reply-To: <20180728213448.GA16016@DigitalMercury.dynalias.net>

--yBdBXgQG2w6Fb3HIvMJ3MV92AhyGcKH9K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8829=E6=97=A5 05:34, Nicholas D Steeves wrote:
> Resending because I forgot to CC list.
>=20
> Hi jkexcel,
>=20
> On 28 July 2018 at 16:50, jkexcel <jkexcel@comcast.net> wrote:
>>
>> I'm an end user trying to use btrfs-convert but when I installed
>> btrfs-tools and its dependency btrfs-progs on kubuntu 18.04, the
>> installation was successful, and it shows that v4.15.1-1build1 was
>> installed.
>>
>> However, when using the command  # brtfs-convert  /dev/sda4 (with the
>> drive unmounted) the resulting error appears "command not found"
>> I also tried command "btrfs convert" in case this was folded into the
>> main tool, but this also failed.
>>
>> 1. Is btrfs-convert still available?
>>
>> 2. Where can I find it?
>>
>> 3. Has btrfs-convert been replaced? what is it's new name?
>>
>> 4. Is it safe to use a downgraded version of btrfs-tools ie: 4.14 or
>> older?
>=20
> You can blame me for that.  In Debian several users had reported
> release-critical issues in btrfs-convert, so I submitted a patch to
> disable it for the forseable future, eg:
>=20
>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D864798
>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D854489

Both report looks pretty old (4.7~4.9).

In fact, just in v4.10 we had a big rework for convert.
It should work much better after that.

Furthermore, we have newer (but smaller) fixes to remove a lot of
BUG_ON(), and do graceful exit for ENOSPC case since then.

And the design of btrfs-convert (at least for the latest btrfs-convert)
is to ensure until everything goes well, we won't touch any bytes of the
ext* fs (in fact we open the ext* fs in RO mode).
So it at least won't corrupt the ext* fs.

>=20
> Also, please consider the official status "As of 4.0 kernels this featu=
re
> is not often used or well tested anymore, and there have been some repo=
rts
> that the conversion doesn't work reliably. Feel free to try it out, but=

> make sure you have backups" (
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3 ).

The wiki page looks needs to be updated.

Both btrfs-convert and base btrfs-progs are improving, especially after
v4.10 btrfs-convert goes through a big rework and works well so far, and
even added support for reiserfs under the same framwork.

So IMHO it's at least worth trying.

Thanks,
Qu

>=20
> I'm happy to hear it is still disabled in Ubuntu, where many more
> users would be affected.  IIRC OpenSUSE LEAP and SLED 15 reenabled it
> (it was previously disabled there), so maybe it needs specific kernel
> versions or patches to not trigger RC bugs, and/or very specific
> btrfs-progs versions, and/or very specific e2fslibs, and/or specific
> combinations?  While I very much look forward to the day when
> btrfs-convert can be relied on in Debian, I don't think we're there
> yet.  Please take this as an opportunity to test that your backups are
> restorable, mkfs.btrfs, and then restore from backup.  P.S. I have no
> idea if Ubuntu has additional btrfs support.
>=20
> Cheers,
> Nicholas
>=20


--yBdBXgQG2w6Fb3HIvMJ3MV92AhyGcKH9K--

--1nM0niQEXS38HPmQD4lx8IaQRIE5oTwyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltc/8YACgkQwj2R86El
/qgsRQf+NZc8/iQguMEsCeECM8zE+uVkIACIwshDammVeuWv0IfaYqzHuS7cbpnE
W/0TKYUQ5xdUPhk1fRKBNF8/okFXvzdQFVFDUNaDaQzbYNFiTSbmTsmJT9Hjc/KP
d/NK0AweZn3UlaHWjlQ2970whFMoCFDuME6LAk0tGtathxLT6vKmNr+FqeK5oezq
bqQpnC9qIFfBbe5tcfOKJJ3kBDtaPk/wDon/mWl8u9QC5/kplfbH0d5mRgLxczVD
zMgZjnLHBVsLKt4VictGS7JTgogR6t9lYXgN0wV5jq1LG6Qro816qUimtvBuyXYe
V7xK2W9i9EZMmj1fcwZjF35cB8oAKA==
=jsYH
-----END PGP SIGNATURE-----

--1nM0niQEXS38HPmQD4lx8IaQRIE5oTwyH--
