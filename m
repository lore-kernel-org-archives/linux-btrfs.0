Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49942 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdGMN7A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 09:59:00 -0400
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
To: Jeffrey Mahoney <jeffm@suse.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170713041642.27125-1-anand.jain@oracle.com>
 <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
Date: Thu, 13 Jul 2017 15:58:57 +0200
MIME-Version: 1.0
In-Reply-To: <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DEA0OD8dmhFeoRC7HQQm4SHICNLT4SPfP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DEA0OD8dmhFeoRC7HQQm4SHICNLT4SPfP
Content-Type: multipart/mixed; boundary="kGLUuIabXPoQH3ILIWO9vH6XrHxrIGTCl";
 protected-headers="v1"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: Jeffrey Mahoney <jeffm@suse.com>, Anand Jain <anand.jain@oracle.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <1f6b1556-9b52-b976-ded1-3a77e37e1559@applied-asynchrony.com>
Subject: Re: [PATCH] btrfs-progs: add support to sort by topid
References: <20170713041642.27125-1-anand.jain@oracle.com>
 <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>
In-Reply-To: <d329b0b6-b8ab-1173-8084-0d5c31ce1981@suse.com>

--kGLUuIabXPoQH3ILIWO9vH6XrHxrIGTCl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07/13/17 15:25, Jeffrey Mahoney wrote:
> On 7/13/17 12:16 AM, Anand Jain wrote:
>> As users generally organize the subvols and snapshots based on the sub=
vol
>> directory hierarchy. So providing an ability to sort them by topid wou=
ld
>> help. Thanks.
>=20
> What is a topid?  I needed to look at the code to discover this and it'=
s
> not even documented as part of the root_info structure.  Users are goin=
g
> to have no idea what this means.

The idea seems similar to my attempt to add listing of toplevel-only
(i.e. non-snapshot) subvolumes, which can be found here:

https://github.com/hhoffstaette/btrfs-progs/commit/f0a065e02b

I ended up not submitting it since nobody seemed interested at the time
and I could work around it for my own purposes by filtering manually on
parent uuid (more precisely the lack thereof).

cheers
Holger


--kGLUuIabXPoQH3ILIWO9vH6XrHxrIGTCl--

--DEA0OD8dmhFeoRC7HQQm4SHICNLT4SPfP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHwEARECADwWIQSvMMXkF4alyejNm0QPgTQJ2NzuzQUCWWd8oR4caG9sZ2VyQGFw
cGxpZWQtYXN5bmNocm9ueS5jb20ACgkQD4E0Cdjc7s0xLwCgkf4vN9W9i5rkbgL9
a8u6/xI+K0AAn20hSLTCDV3F27ddA4dFsApSmo9v
=LqyN
-----END PGP SIGNATURE-----

--DEA0OD8dmhFeoRC7HQQm4SHICNLT4SPfP--
