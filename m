Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:36951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbeGSGpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 02:45:21 -0400
Subject: Re: [PATCH] btrfs-progs: ins: Add v2 ioctl support in logical-resolve
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
 <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
 <20180719055904.GK575@fnst.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <98442027-887b-d787-1a6b-f4014f95b846@gmx.com>
Date: Thu, 19 Jul 2018 14:03:38 +0800
MIME-Version: 1.0
In-Reply-To: <20180719055904.GK575@fnst.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EWqRst6admEfWu6BV6623MXeHuU5O9jWK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EWqRst6admEfWu6BV6623MXeHuU5O9jWK
Content-Type: multipart/mixed; boundary="KaDvqzKgrA0uavoSqDLtTRZ7HJ9y2H74p";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <98442027-887b-d787-1a6b-f4014f95b846@gmx.com>
Subject: Re: [PATCH] btrfs-progs: ins: Add v2 ioctl support in logical-resolve
References: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
 <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
 <20180719055904.GK575@fnst.localdomain>
In-Reply-To: <20180719055904.GK575@fnst.localdomain>

--KaDvqzKgrA0uavoSqDLtTRZ7HJ9y2H74p
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8819=E6=97=A5 13:59, Lu Fengqi wrote:
> On Thu, Jul 19, 2018 at 01:51:59PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8819=E6=97=A5 13:15, Misono Tomohiro wrote:
>>> Add -i (ignore offset) option to logical-resolve command
>>> to show how BTRFS_IOC_LOGICAL_INO_V2 ioctl works
>>> (returns every ref to the extent of given logical address).
>>>
>>> [Example]
>>> $ mkfs.btrfs -f $DEV
>>> $ mount $DEV /mnt
>>>
>>> $ dd if=3Dev/urandom of=3D/mnt/file bs=3D4k count=100
>>> # split above extent
>>> $ dd if=3Dev/urandom of=3D/mnt/file bs=3D4k seek=10 count=3D1 conv=3D=
notrunc
>>> $ btrfs filesystem sync
>>>
>>> # v1
>>> $ btrfs inspect-internal logical-resolve -P 13631488 /mnt
>>> inode 257 offset 0 root 5
>>>
>>> # v2
>>> $ btrfs inspect-internal logical-resolve -iP 13631488 /mnt
>>> inode 257 offset 0 root 5
>>> inode 257 offset 45056 root 5
>>>
>>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>>  Documentation/btrfs-inspect-internal.asciidoc |  4 ++++
>>>  cmds-inspect.c                                | 17 +++++++++++++++--=

>>>  ioctl.h                                       | 10 +++++++++-
>>>  libbtrfsutil/btrfs.h                          | 10 +++++++++-
>>
>> Not related to this patch itself, but I'm wondering could we just use
>> /usr/include/linux/btrfs.h?
>>
>> So we could save 2 same copies of headers here.
>=20
> If we want to compile the newest btrfs-progs, but the older
> /usr/include/linux/btrfs.h maybe doesn't have already defined the ioctl=
,
> this will cause the compile error.

Makes sense.

> I am curious about why the
> libbtrfsutil need to copy the part of ioctl.h instead of including the
> ioctl.h directly?

Maybe for distribution purpose? Some binding may be delivered as
independent package just as Omar tries to do.
So in that case independent header makes sense.

Thanks,
Qu


--KaDvqzKgrA0uavoSqDLtTRZ7HJ9y2H74p--

--EWqRst6admEfWu6BV6623MXeHuU5O9jWK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltQKboACgkQwj2R86El
/qikBQf8D6Or6dx1puKfWRgbSuUjP0CSsrWfQk8biiecsrab3kBL97QxPd5t/q0J
Thm7qyNqoAvy1G69hlmRA6q6uJJBQ9xENBIiZlIP7Fnf6BKDsraR77JQugumnOst
VhK1GWsHCdgV9Cp2lrL12jXX+nEbo8kQrLnGULLLoXrwj7Ju2cCNc4GfB2B7NTWr
HCMGyv55Y9iA5iUA5HqmgisIUo/UDfY+3MrGI8tNJqH2Hna3fdqUeImUO7Cw1vsh
RVnjYUNzS1KsIAggMccJzdtOUFws6rPqmBtl2UOYMSexWOFsge6N5KJLqzEMlvDO
WRfWBSK5zYk5Av9R/JJmRLRNErHBCQ==
=Fbp1
-----END PGP SIGNATURE-----

--EWqRst6admEfWu6BV6623MXeHuU5O9jWK--
