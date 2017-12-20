Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54771 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932185AbdLTGAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 01:00:11 -0500
Subject: Re: [PATCH v2 00/17] btrfs-progs: lowmem check: avoid extents
 overwrite
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5971e0e8-42af-3044-71c4-7473f28b6e40@gmx.com>
Date: Wed, 20 Dec 2017 13:59:49 +0800
MIME-Version: 1.0
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sJqhtExWgalMtoajamSjMWmzvslrf3iLt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sJqhtExWgalMtoajamSjMWmzvslrf3iLt
Content-Type: multipart/mixed; boundary="fHWPMnnDpWLUlCpIT5FdMvI1yywvLHiOR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <5971e0e8-42af-3044-71c4-7473f28b6e40@gmx.com>
Subject: Re: [PATCH v2 00/17] btrfs-progs: lowmem check: avoid extents
 overwrite
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>

--fHWPMnnDpWLUlCpIT5FdMvI1yywvLHiOR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
> This patchset can be fetched from my github:
> https://github.com/Damenly/btrfs-progs/tree/lowmem_repair
> based on kdave/devel.
>=20
> Thanks to Qu Wenruo's ideas and suggestions first.
> Any suggestions about names of functions and variables are welcome.
>=20
> Patch[1-3] fix minor problems of lowmem repair.

Mostly fine for patch 1-3.

So Reviewed-by: Qu Wenruo <wqu@suse.com> for those patches.

Although for 2nd patch, I'm not sure if the naming or if the >0 for
error is good.


>=20
> Patch[4-8] introduce two ways to avoid extents overwrite:
> 1) Traverse trees and exclude all metadata blocks.
> It's time-inefficient for big filesystems.
> 2) Mark all existed chunks full, allocate new chunk for CoW.
> More efficient than method 1. However, it can't not handle situation
> like no space.
> Lowmem repair will try method 2 first and method 1 next now.

Commented in separate patches.

Thanks,
Qu

>=20
> Patch[9-17] remove parameters in lowmem repair functions. They
> will try to avoid extents overwrite if necessary and start=20
> transactions themselves.
>=20
> Those patches are mainly for lowmem repair. Original mode is not
> influenced.
> Since btrfs-progs v4.14, lowmem mode changed to check all tree blocks
> backrefs. There are many bugs about shared backref in lowmem mode now.
> If lowmem check can not work as expected, lowmem repair are useless.
> I will fix lowmem check in next.
>=20
> ---
> Changlog:
> v1->v2:
>  - Let @err in check_btrfs_root() record err bits but excluded
>    negative values.
>  - Do not delete a line of code to release path after extent item'
>    insertion in repair_extent_data_item().
>  - Add patch[3].
>  - Force CoW in new allocated chunk to avoid extents overwrite.
>  - Remove parameters @trans in check_chunks_and_extents_v2() and
>    related callees.
>  - Repair functions for lowmem mode call try_avoid_extents_overwrite()
>    and start transactions.
>=20
> Su Yue (17):
>   btrfs-progs: lowmem check: release path in repair_extent_data_item()
>   btrfs-progs: lowmem check: record returned errors after
>     walk_down_tree_v2()
>   btrfs-progs: lowmem check: assign @parent early in
>     repair_extent_data_item()
>   btrfs-progs: lowmem check: exclude extents of metadata blocks
>   btrfs-progs: lowmem check: introduce modify_block_groups_cache()
>   btrfs-progs: lowmem check: introduce force_cow_in_new_chunk()
>   btrfs-progs: lowmem check: introduce try_avoid_extents_overwrite()
>   btrfs-progs: lowmem check: exclude extents if init-extent-tree in
>     lowmem
>   btrfs-progs: lowmem check: start to remove parameters @trans in lowme=
m
>   btrfs-progs: lowmem check: remove parameter @trans of
>     delete_extent_item()
>   btrfs-progs: lowmem check: remove parameter @trans of
>     repair_chunk_item()
>   btrfs-progs: lowmem check: remove parameter @trans of
>     repair_extent_item()
>   btrfs-progs: lowmem check: remove parameter @trans of
>     check_leaf_items()
>   btrfs-progs: lowmem check: remove parameter @trans of
>     repair_tree_back_ref()
>   btrfs-progs: lowmem check: remove parameter @trans of
>     check_btrfs_root()
>   btrfs-progs: lowmem check: introduce repair_block_accounting()
>   btrfs-progs: lowmem check: end of removing parameters @trans in lowme=
m
>=20
>  cmds-check.c | 620 +++++++++++++++++++++++++++++++++++++++++++++++++--=
--------
>  1 file changed, 515 insertions(+), 105 deletions(-)
>=20


--fHWPMnnDpWLUlCpIT5FdMvI1yywvLHiOR--

--sJqhtExWgalMtoajamSjMWmzvslrf3iLt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo5/FUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjMXQf+Kkl3KGynF6rYtwykYfG0uyG9
tvqCkvU8JoHenb/uJsME0i9hIIoRSL5XZAU92f7QfYuIunccY+JU3NykDn/YErzF
gufavH3izzOzyS/txtTunP33BpW9FC9rJKQ0OK+iOeNrqY6cipy0VLk73IGLtjNW
wma+3jF29/34GsGeoJPP9qBL0Ben7YSV/1Q0TS9FpI2rU+EUcqaewiBGY9XNBVgl
oQBoozhtXteo3vCCuARr8GGXgZL1Ow/btlUr1owoJZCJEgOwfQJjdYPd8vrbx5gX
80AKZPAMUPlZAEHFLOf0+9C41ASrfPCptbxo6CT69pYVGeWKkG6E3JNg6nQkyA==
=tBQT
-----END PGP SIGNATURE-----

--sJqhtExWgalMtoajamSjMWmzvslrf3iLt--
