Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54369 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbeD2AeF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 20:34:05 -0400
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180426062425.8574-1-wqu@suse.com>
 <20180428164206.GI21272@twin.jikos.cz> <20180428174511.GL21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fd2d7c13-2999-bb7a-99fc-d8b6839f8558@gmx.com>
Date: Sun, 29 Apr 2018 08:33:49 +0800
MIME-Version: 1.0
In-Reply-To: <20180428174511.GL21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4HURxbdOanoQTQXg2xAhQHlnAc6ZohHoD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4HURxbdOanoQTQXg2xAhQHlnAc6ZohHoD
Content-Type: multipart/mixed; boundary="oWLpPga0g3tH3xPnJnFJONU9SV5kG5wHm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fd2d7c13-2999-bb7a-99fc-d8b6839f8558@gmx.com>
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
References: <20180426062425.8574-1-wqu@suse.com>
 <20180428164206.GI21272@twin.jikos.cz> <20180428174511.GL21272@twin.jikos.cz>
In-Reply-To: <20180428174511.GL21272@twin.jikos.cz>

--oWLpPga0g3tH3xPnJnFJONU9SV5kG5wHm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 01:45, David Sterba wrote:
> On Sat, Apr 28, 2018 at 06:42:06PM +0200, David Sterba wrote:
>> On Thu, Apr 26, 2018 at 02:24:25PM +0800, Qu Wenruo wrote:
>>> fs_info can be extracted from btrfs_block_group_cache, and all
>>> btrfs_block_group_cache is created by btrfs_create_block_group_cache(=
)
>>> with fs_info initialized, no need to worry about NULL pointer
>>> dereference.
>>
>> Famous last words.
>=20
> And it's a false alert, it's caused by another patch yet to be
> identified.

Yep, I also spent serval minutes to find this out.
As in that test there is nothing related to btrfs_reserve_extent() trace
event.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--oWLpPga0g3tH3xPnJnFJONU9SV5kG5wHm--

--4HURxbdOanoQTQXg2xAhQHlnAc6ZohHoD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrlEu0ACgkQwj2R86El
/qhW4AgAmsDdGKgOlNN0uu9wke+mlWP2+XE6hOFiN5Yy1KKTQRYl3NHVHWLUSzjm
Bo5YW4kA+RkR33hr3XxB3jmcun8UXTBpo2vA8fugCOd5b+IdtsvDaGL+/Qa7IMvs
ssn2KK1LeqkUvIsNcuWHMvykd44F91rWMOpPhcSn+jXLXrUFtPBn+W2lTmUOrRFn
O8bVh50hLY1C07I9Umse2h2zJ0KtZBoHv7llQtiVztjC+oUhd+UMOUssovQwdMxv
I1Lh3PFA6ibCJKugyhkiBmLoiPnViWmS0Ixvyb/Z6awulv6EZmYxCJuJ88e8RU8N
pLLgE8AK5pGEc3u31xVGDLXfn2+uhA==
=hMfZ
-----END PGP SIGNATURE-----

--4HURxbdOanoQTQXg2xAhQHlnAc6ZohHoD--
