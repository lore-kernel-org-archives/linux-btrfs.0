Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:47553 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751645AbeBVBnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 20:43:52 -0500
Subject: Re: [PATCH v2 06/10] btrfs-progs: kernel-lib: Port kernel sort() to
 btrfs-progs
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-8-wqu@suse.com> <20180221154033.GG1469@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <46b36af2-c071-adad-18c0-de4868a4986b@gmx.com>
Date: Thu, 22 Feb 2018 09:43:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180221154033.GG1469@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3TelMmmPztEhnN4UBStWD0BZFSfmDvHdo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3TelMmmPztEhnN4UBStWD0BZFSfmDvHdo
Content-Type: multipart/mixed; boundary="1Fe297Fma6jZUpPCF00Hvcq6vpzAnjciJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <46b36af2-c071-adad-18c0-de4868a4986b@gmx.com>
Subject: Re: [PATCH v2 06/10] btrfs-progs: kernel-lib: Port kernel sort() to
 btrfs-progs
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-8-wqu@suse.com> <20180221154033.GG1469@twin.jikos.cz>
In-Reply-To: <20180221154033.GG1469@twin.jikos.cz>

--1Fe297Fma6jZUpPCF00Hvcq6vpzAnjciJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8821=E6=97=A5 23:40, David Sterba wrote:
> On Fri, Feb 09, 2018 at 03:44:24PM +0800, Qu Wenruo wrote:
>> Used by later btrfs_alloc_chunk() rework.
>=20
> We have the libc provided qsort, so please don't pull another
> implementation but rather add a wrapper.

Thanks for pointing this out.

Another 100 lines saved.

>=20
>> --- /dev/null
>> +++ b/kernel-lib/sort.c
>> @@ -0,0 +1,104 @@
>> +/*
>> + * taken from linux kernel lib/sort.c, removed kernel config code and=
 adapted
>> + * for btrfsprogs
>> + */
>> +
>> +#include "sort.h"
>> +
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * A fast, small, non-recursive O(nlog n) sort for the Linux kernel
>> + *
>> + * Jan 23 2005  Matt Mackall <mpm@selenic.com>
>> + */
>=20
> When taking files from kernel: take the file as is and insert notes for=

> btrfs-progs below the comments. The SPDX line must be first.

Will keep that in mind.

Although quite a lot of kernel-libs doesn't follow this behavior.

Maybe we should put some README into kernel-libs/?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--1Fe297Fma6jZUpPCF00Hvcq6vpzAnjciJ--

--3TelMmmPztEhnN4UBStWD0BZFSfmDvHdo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqOIEkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgJlAgAjuDPTptXnXM7ytifDuTvpAQ6
9oipkDp6C3swkaiATq1gYXtTgVEw4rMWChQyQZ+1OARtyeNA1vMnJx2aYjAiVm2+
YF5yYBLSaVDqq+ALdIufTPDMC8HpDMsRgpPSBtcqxFfWCqW3b6U3sVkq1rUk1fMe
Qu5mD8wScNZ3BVb0VOD5QHBXrgIC8/naDDeaHnablR7wx9m0i9UG1EzsA6AlpWF4
Vd5fOQQLWxxsGTsP6xBxGAY5qk876f1f1E+Dp6L7RN1cfjE1K5UX1RNsyrXY/yjs
qGPaAYp+y0963OIRcN4VvQST9Qp/tqmuEXLDCq+hIKcHpI9KZuHDZKFT5evqXg==
=fTHG
-----END PGP SIGNATURE-----

--3TelMmmPztEhnN4UBStWD0BZFSfmDvHdo--
