Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62465 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbeASFyK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 00:54:10 -0500
Subject: Re: [PATCH 04/16] btrfs-progs: check: Move node_ptr structure to
 check/common.h
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180119053731.10795-1-wqu@suse.com>
 <20180119053731.10795-5-wqu@suse.com>
 <b1c88e8b-81ce-c22b-75a7-757f6a8c793f@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a96fce3e-b107-3ba6-afef-1147c398b2cf@gmx.com>
Date: Fri, 19 Jan 2018 13:53:49 +0800
MIME-Version: 1.0
In-Reply-To: <b1c88e8b-81ce-c22b-75a7-757f6a8c793f@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZRfj9qQ5Tc3ZfXfLUI0umdCpAhGwCQnDM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZRfj9qQ5Tc3ZfXfLUI0umdCpAhGwCQnDM
Content-Type: multipart/mixed; boundary="BE53uEnv19AOfSbuuJIyjoCOq118SzspR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <a96fce3e-b107-3ba6-afef-1147c398b2cf@gmx.com>
Subject: Re: [PATCH 04/16] btrfs-progs: check: Move node_ptr structure to
 check/common.h
References: <20180119053731.10795-1-wqu@suse.com>
 <20180119053731.10795-5-wqu@suse.com>
 <b1c88e8b-81ce-c22b-75a7-757f6a8c793f@cn.fujitsu.com>
In-Reply-To: <b1c88e8b-81ce-c22b-75a7-757f6a8c793f@cn.fujitsu.com>

--BE53uEnv19AOfSbuuJIyjoCOq118SzspR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8819=E6=97=A5 13:52, Su Yue wrote:
> The structure name is 'node_refs' not 'node_ptr'.
> Misspelt the patch name?
>=20

You got me!

I'll just update the title in github.

Thanks,
Qu

> Thanks,
> Su
>=20
> On 01/19/2018 01:37 PM, Qu Wenruo wrote:
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 check/common.h | 39 +++++++++++++++++++++++++++++++++++++++
>> =C2=A0 check/main.c=C2=A0=C2=A0 | 11 +----------
>> =C2=A0 2 files changed, 40 insertions(+), 10 deletions(-)
>> =C2=A0 create mode 100644 check/common.h
>>
>> diff --git a/check/common.h b/check/common.h
>> new file mode 100644
>> index 000000000000..25874aec597b
>> --- /dev/null
>> +++ b/check/common.h
>> @@ -0,0 +1,39 @@
>> +/*
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See the=
 GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
>> +
>> +/*
>> + * Defines and function declarations for code shared by both lowmem a=
nd
>> + * original mode
>> + */
>> +#ifndef __BTRFS_CHECK_COMMON_H__
>> +#define __BTRFS_CHECK_COMMON_H__
>> +#include "ctree.h"
>> +
>> +/*
>> + * Use for tree walk to walk through trees whose leaves/nodes can be
>> shared
>> + * between different trees. (Namely subvolume/fs trees)
>> + */
>> +struct node_refs {
>> +=C2=A0=C2=A0=C2=A0 u64 bytenr[BTRFS_MAX_LEVEL];
>> +=C2=A0=C2=A0=C2=A0 u64 refs[BTRFS_MAX_LEVEL];
>> +=C2=A0=C2=A0=C2=A0 int need_check[BTRFS_MAX_LEVEL];
>> +=C2=A0=C2=A0=C2=A0 /* field for checking all trees */
>> +=C2=A0=C2=A0=C2=A0 int checked[BTRFS_MAX_LEVEL];
>> +=C2=A0=C2=A0=C2=A0 /* the corresponding extent should be marked as fu=
ll backref or
>> not */
>> +=C2=A0=C2=A0=C2=A0 int full_backref[BTRFS_MAX_LEVEL];
>> +};
>> +
>> +#endif
>> diff --git a/check/main.c b/check/main.c
>> index dbd2b755c48f..fbd73c42bee8 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -45,6 +45,7 @@
>> =C2=A0 #include "help.h"
>> =C2=A0 #include "check/original.h"
>> =C2=A0 #include "check/lowmem.h"
>> +#include "check/common.h"
>> =C2=A0 =C2=A0 enum task_position {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 TASK_EXTENTS,
>> @@ -1667,16 +1668,6 @@ static int process_one_leaf(struct btrfs_root
>> *root, struct extent_buffer *eb,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> =C2=A0 -struct node_refs {
>> -=C2=A0=C2=A0=C2=A0 u64 bytenr[BTRFS_MAX_LEVEL];
>> -=C2=A0=C2=A0=C2=A0 u64 refs[BTRFS_MAX_LEVEL];
>> -=C2=A0=C2=A0=C2=A0 int need_check[BTRFS_MAX_LEVEL];
>> -=C2=A0=C2=A0=C2=A0 /* field for checking all trees */
>> -=C2=A0=C2=A0=C2=A0 int checked[BTRFS_MAX_LEVEL];
>> -=C2=A0=C2=A0=C2=A0 /* the corresponding extent should be marked as fu=
ll backref or
>> not */
>> -=C2=A0=C2=A0=C2=A0 int full_backref[BTRFS_MAX_LEVEL];
>> -};
>> -
>> =C2=A0 static int update_nodes_refs(struct btrfs_root *root, u64 byten=
r,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, struct nod=
e_refs *nrefs,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 level, int check_all);
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--BE53uEnv19AOfSbuuJIyjoCOq118SzspR--

--ZRfj9qQ5Tc3ZfXfLUI0umdCpAhGwCQnDM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlphh+0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjEcAf8C9qXeK6Us7MUaLg5c4raC2wa
67nm3XJL2AYrXEA8o3crMuMjbrmpLW+qxew+T8l+FQ3xa7Z2JR6izDMcVNrs0x/x
YmjXeaq7oRu8M6ahHkQhaANEWh+C07rKDXIP28+TMneGUSf28SVZXomlB5o0vOlz
58FLr52hw2G6KSybi6o1uPQLtRyBnohLfQ1w6vsoba6xDk4Qz4kznZcOSoJ8DbHn
1LE03SWKWLx/T09j9yLTQff+AzXw8NQgAMlBlg90G/Z6Fz0ZNu/1K13hVw5kDGEF
Ep+udSscLnvbPtCqId1beekZi5Nk/2T/yuGPzAtXCFJssD3F0jez38xx3vIVlA==
=ukRj
-----END PGP SIGNATURE-----

--ZRfj9qQ5Tc3ZfXfLUI0umdCpAhGwCQnDM--
