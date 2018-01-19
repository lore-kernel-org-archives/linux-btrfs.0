Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60056 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754090AbeASH1G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 02:27:06 -0500
Subject: Re: [PATCH 05/16] btrfs-progs: check: Export check global variables
 to check/common.h
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180119053731.10795-1-wqu@suse.com>
 <20180119053731.10795-6-wqu@suse.com>
 <3964e2a2-94fb-2ae9-4d3d-643b4befbc4b@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9c62a925-5135-0609-7e80-b02ca27a3a51@gmx.com>
Date: Fri, 19 Jan 2018 15:26:48 +0800
MIME-Version: 1.0
In-Reply-To: <3964e2a2-94fb-2ae9-4d3d-643b4befbc4b@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tP7jt3wbwl4JpG3Z2ZPYgbj5GDMIEvzEV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tP7jt3wbwl4JpG3Z2ZPYgbj5GDMIEvzEV
Content-Type: multipart/mixed; boundary="2MN0Yoxel1ib0hYqUJKd7JgOCcVlzCWQH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <9c62a925-5135-0609-7e80-b02ca27a3a51@gmx.com>
Subject: Re: [PATCH 05/16] btrfs-progs: check: Export check global variables
 to check/common.h
References: <20180119053731.10795-1-wqu@suse.com>
 <20180119053731.10795-6-wqu@suse.com>
 <3964e2a2-94fb-2ae9-4d3d-643b4befbc4b@cn.fujitsu.com>
In-Reply-To: <3964e2a2-94fb-2ae9-4d3d-643b4befbc4b@cn.fujitsu.com>

--2MN0Yoxel1ib0hYqUJKd7JgOCcVlzCWQH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8819=E6=97=A5 14:55, Su Yue wrote:
>=20
>=20
> On 01/19/2018 01:37 PM, Qu Wenruo wrote:
>> There are a dozen of variables which are used as "check global"
>> variables, like @total_csum_bytes or @no_holes.
>>
>> These variables are used freely across the check code, however since
>> we're splitting check code, they need to be exported so they can be us=
ed
>> in other files.
>>
>> This patch just export them and add declarations for them in
>> check/common.h.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 check/common.h | 17 +++++++++++++++++
>> =C2=A0 check/main.c=C2=A0=C2=A0 | 32 ++++++++++++++++----------------
>> =C2=A0 2 files changed, 33 insertions(+), 16 deletions(-)
>>
>> diff --git a/check/common.h b/check/common.h
>> index 25874aec597b..8d93ddbf4afb 100644
>> --- a/check/common.h
>> +++ b/check/common.h
>> @@ -36,4 +36,21 @@ struct node_refs {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int full_backref[BTRFS_MAX_LEVEL];
>> =C2=A0 };
>> =C2=A0 +extern u64 bytes_used;
>> +extern u64 total_csum_bytes;
>> +extern u64 total_btree_bytes;
>> +extern u64 total_fs_tree_bytes;
>> +extern u64 total_extent_tree_bytes;
>> +extern u64 btree_space_waste;
>> +extern u64 data_bytes_allocated;
>> +extern u64 data_bytes_referenced;
>> +extern struct list_head duplicate_extents;
>> +extern struct list_head delete_items;
>> +extern int no_holes;
>> +extern int init_extent_tree;
>> +extern int check_data_csum;
>> +extern struct btrfs_fs_info *global_info;
>> +extern struct task_ctx ctx;
>> +extern struct cache_tree *roots_info_cache;
>> +
>> =C2=A0 #endif
>> diff --git a/check/main.c b/check/main.c
>> index fbd73c42bee8..bb927ecc87ee 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -61,22 +61,22 @@ struct task_ctx {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct task_info *info;
>> =C2=A0 };
>> =C2=A0 -static u64 bytes_used =3D 0;
>> -static u64 total_csum_bytes =3D 0;
>> -static u64 total_btree_bytes =3D 0;
>> -static u64 total_fs_tree_bytes =3D 0;
>> -static u64 total_extent_tree_bytes =3D 0;
>> -static u64 btree_space_waste =3D 0;
>> -static u64 data_bytes_allocated =3D 0;
>> -static u64 data_bytes_referenced =3D 0;
>> -static LIST_HEAD(duplicate_extents);
>> -static LIST_HEAD(delete_items);
>> -static int no_holes =3D 0;
>> -static int init_extent_tree =3D 0;
>> -static int check_data_csum =3D 0;
>> -static struct btrfs_fs_info *global_info;
>> -static struct task_ctx ctx =3D { 0 };
>> -static struct cache_tree *roots_info_cache =3D NULL;
>> +u64 bytes_used =3D 0;
>> +u64 total_csum_bytes =3D 0;
>> +u64 total_btree_bytes =3D 0;
>> +u64 total_fs_tree_bytes =3D 0;
>> +u64 total_extent_tree_bytes =3D 0;
>> +u64 btree_space_waste =3D 0;
>> +u64 data_bytes_allocated =3D 0;
>> +u64 data_bytes_referenced =3D 0;
>> +LIST_HEAD(duplicate_extents);
>> +LIST_HEAD(delete_items);
>> +int no_holes =3D 0;
>> +int init_extent_tree =3D 0;
>> +int check_data_csum =3D 0;
>=20
> Just a small suggestion:
> Since the patchset only splits cmds-check.c without functional changes,=

> Maybe it's a good timing to adjust those lines of old code according by=

> errors and warnings which reported by checkpatch?

I'll do it in PART2, with new comment and format cleanup.

Right now I prefer this get merged first to provide the basis for later
cleanup.

Thanks,
Qu

>=20
> Thanks,
> Su
>=20
>> +struct btrfs_fs_info *global_info;
>> +struct task_ctx ctx =3D { 0 };
>> +struct cache_tree *roots_info_cache =3D NULL;
>> =C2=A0 =C2=A0 enum btrfs_check_mode {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CHECK_MODE_ORIGINAL,
>>
>=20
>=20


--2MN0Yoxel1ib0hYqUJKd7JgOCcVlzCWQH--

--tP7jt3wbwl4JpG3Z2ZPYgbj5GDMIEvzEV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlphnbgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qidtwf/Y6LEdEFE7BSokTIS6hx0ekH8
vO4uV69ACNeYKmD5blwrhVZLlxtfYQFhC24qWtvPfjS+YPHebmPCwzgMLQJ4CI7u
d2962u3bYGddF94ykEjiJRrwJfHMmEuA4wLosccn4x64Bo3tLdWdcJjEBjR7QARk
bM3Bb/+5n3oTIkDRz+aa2pxzZWW2DtEgVz1RYRErQYdlNqPlNEDpurl6r0kY2hzo
XLiJIEahHC4+6CKTXgTGqaW30VgYPdmChowyIMUmPJ0dpIM8kpIb/m1XhvQTfFdA
KhYiv3tmDfkz4PcTitKvWdAdCxz1mbyzTdh6q4b9kJHQUf4Ksz0tCwfrBKRqrQ==
=FbfO
-----END PGP SIGNATURE-----

--tP7jt3wbwl4JpG3Z2ZPYgbj5GDMIEvzEV--
