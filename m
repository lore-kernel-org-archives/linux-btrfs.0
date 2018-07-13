Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:37263 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729647AbeGMPMV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 11:12:21 -0400
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180712061907.24783-1-wqu@suse.com>
 <20180713143418.GW3126@twin.jikos.cz>
 <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
 <20180713144638.GY3126@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c98db100-b124-8d1a-ccd8-34e1a9bfe50c@gmx.com>
Date: Fri, 13 Jul 2018 22:57:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180713144638.GY3126@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DIM7GshxVrWpeuOOU255ZZkHcH1rRRZYx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DIM7GshxVrWpeuOOU255ZZkHcH1rRRZYx
Content-Type: multipart/mixed; boundary="03BTZVexncFfz8JcP8BkeOpVqsKu4FqgS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <c98db100-b124-8d1a-ccd8-34e1a9bfe50c@gmx.com>
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
References: <20180712061907.24783-1-wqu@suse.com>
 <20180713143418.GW3126@twin.jikos.cz>
 <5f2369c6-c882-7ae6-04f5-6de98bf10f58@suse.de>
 <20180713144638.GY3126@twin.jikos.cz>
In-Reply-To: <20180713144638.GY3126@twin.jikos.cz>

--03BTZVexncFfz8JcP8BkeOpVqsKu4FqgS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 22:46, David Sterba wrote:
> On Fri, Jul 13, 2018 at 10:36:42PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8813=E6=97=A5 22:34, David Sterba wrote:
>>> On Thu, Jul 12, 2018 at 02:19:07PM +0800, Qu Wenruo wrote:
>>>> Introduce a new macro based compile time check for ioctl structures.=

>>>>
>>>> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
>>>> VMMDEV_ASSERT_SIZE().
>>>
>>> The macro should be generic, there's nothing specific to btrfs. There=
's
>>> a similar one in the progs.
>>>
>>>> Such check is only added to structure pended to power of 2.
>>>
>>> There's no constraint about power of 2 sizes, it works for any size.
>>
>> While some structure doesn't do padding at all, and it looks like they=

>> may get expanded later.
>> Do we really need to limit the size right now?
>=20
> The size of an ioctl structure is part of kernel<->userspace API and
> must not change once public. The ioctl number is calculated using the
> structure size.
>=20
>>>> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligne=
d
>>>> well.
>>>> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_=
STATS
>>>> ioctls to one").
>>>
>>> Yeah, that was an oversight, so the correct value to check against is=

>>> 1024 + 8 =3D032, see ioctl.h in progs.
>>
>> Can't we just revert to 1024?
>=20
> Answered by the above, we absolutely cannot change the numbers now.
>=20
>> That plus 8 doesn't really look well, and shrink the size shouldn't
>> bring any problem AFAIK.
>=20
> See
>=20
> https://elixir.bootlin.com/linux/latest/source/include/uapi/asm-generic=
/ioctl.h#L88
>=20
> for _IOWR definition,
>=20
> btrfs-progs:ioctl.h
>=20
> 817 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
> 818                                       struct btrfs_ioctl_get_dev_st=
ats)
>=20
> kernel:fs/btrfs/ioctl.c
>=20
> 5914         case BTRFS_IOC_GET_DEV_STATS:
> 5915                 return btrfs_ioctl_get_dev_stats(fs_info, argp);
>=20
> The values must match, otherwise dev stats will randomly break on
> old/new kernel and progs combinations.

Ok, for old kernel and new progs, if that 1024 bytes from progs is
allocated from stack we indeed could screw up user space stack memory.

While for old progs and new kernel it won't cause any problem though.

I'll keep the ugly unaligned number in next version.

But really, we should have such alignment check way before we find the
mismatch.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--03BTZVexncFfz8JcP8BkeOpVqsKu4FqgS--

--DIM7GshxVrWpeuOOU255ZZkHcH1rRRZYx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltIvcMACgkQwj2R86El
/qhOiggAmpe+4p2fe82aBUUzb8fQtSKIPleUDTZgXIncbBAwNKTV4aGhm7QiqnMl
1KB/DECXXWgJWsGtzO8nPhY4bG63ug+Acmkog7wtxwX6vu2+scqlXJRDzehL/suF
u26YxXdG/5JpC0AYHDFOGbUgy0BYBEoPBS8IpoQmXNAK+zXdoNNCIuj2Dv0jL5du
nh73+Il94oG/4FI93xghtDdUs6Hf0h4OR/li8ofImMRVH3FxYdThaFf3kneWxraD
TnQYFP66AEVqFF4JQeBJtekKv4TXL5UPoZS5ZfdSLWnQhJAxk7v1dZdyxjUWdpCk
GXPbYOaC8CwIn4BzMNjf8k3UoV1GyA==
=AreS
-----END PGP SIGNATURE-----

--DIM7GshxVrWpeuOOU255ZZkHcH1rRRZYx--
