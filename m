Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729670AbeGMOvr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 10:51:47 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F1FDACED
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 14:36:51 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180712061907.24783-1-wqu@suse.com>
 <20180713143418.GW3126@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
Date: Fri, 13 Jul 2018 22:36:42 +0800
MIME-Version: 1.0
In-Reply-To: <20180713143418.GW3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OX3UYMkQpvjc4ywUDVZJmGTvh3H3OvFmc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OX3UYMkQpvjc4ywUDVZJmGTvh3H3OvFmc
Content-Type: multipart/mixed; boundary="o4cEm8U8NguUCiJNQG7SBK6GfBXarcBAC";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
References: <20180712061907.24783-1-wqu@suse.com>
 <20180713143418.GW3126@twin.jikos.cz>
In-Reply-To: <20180713143418.GW3126@twin.jikos.cz>

--o4cEm8U8NguUCiJNQG7SBK6GfBXarcBAC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 22:34, David Sterba wrote:
> On Thu, Jul 12, 2018 at 02:19:07PM +0800, Qu Wenruo wrote:
>> Introduce a new macro based compile time check for ioctl structures.
>>
>> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
>> VMMDEV_ASSERT_SIZE().
>=20
> The macro should be generic, there's nothing specific to btrfs. There's=

> a similar one in the progs.
>=20
>> Such check is only added to structure pended to power of 2.
>=20
> There's no constraint about power of 2 sizes, it works for any size.

While some structure doesn't do padding at all, and it looks like they
may get expanded later.
Do we really need to limit the size right now?

>=20
>> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligned
>> well.
>> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_ST=
ATS
>> ioctls to one").
>=20
> Yeah, that was an oversight, so the correct value to check against is
> 1024 + 8 =3D 1032, see ioctl.h in progs.

Can't we just revert to 1024?
That plus 8 doesn't really look well, and shrink the size shouldn't
bring any problem AFAIK.

Thanks,
Qu


>=20


--o4cEm8U8NguUCiJNQG7SBK6GfBXarcBAC--

--OX3UYMkQpvjc4ywUDVZJmGTvh3H3OvFmc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltIuPoACgkQwj2R86El
/qhvKAf9E05TQKwNM2NalU+NLfDV9/o/cjYYNOdXGghOf1W2wa/u8XOiHk0zmgcB
8o1ymdbSDiChvnj4fxVOqB3p5RYWCqvsdPC36i9mdWfc061g6EbrjspIRb7Vc398
U6He5m2GtxLNoMlhoC8GpP7Vp9uLfAvZLc7yGkgX8ZGBz7TTnp38kf+FBatGQ0bx
wTO8nwpI2CezSe8nI+LJOaQDm6GtYqT1v96QQtuhl2vpQf4s5arohmJGSDRao6rK
ok7GRphK9fb3jcUT+eSErtjYK3YMeQ6/3bGjByjebCXeTxEY4ObvufRBuoUnKIB8
55sS4fAAN3Rp8xnwSAJNSSWqGXBu2A==
=wP/+
-----END PGP SIGNATURE-----

--OX3UYMkQpvjc4ywUDVZJmGTvh3H3OvFmc--
