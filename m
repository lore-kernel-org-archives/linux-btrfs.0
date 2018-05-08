Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753525AbeEHCGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 22:06:11 -0400
Subject: Re: [PATCH v4 00/18] btrfs-progs: lowmem check: avoid extents
 overwrite
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
 <20180507181737.GE6649@twin.jikos.cz>
 <86ef8426-80b3-be41-2c95-d2d173d973ab@cn.fujitsu.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <f43e2d6d-4800-faae-6b81-99cd12f7ecda@suse.de>
Date: Tue, 8 May 2018 10:06:05 +0800
MIME-Version: 1.0
In-Reply-To: <86ef8426-80b3-be41-2c95-d2d173d973ab@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wQqqkvAqFjvzbn6dNPUTwZKbwB9C10j3V"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wQqqkvAqFjvzbn6dNPUTwZKbwB9C10j3V
Content-Type: multipart/mixed; boundary="5nlOIHldOqFXpleu1sucPUT7A54TXsudg";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 dsterba@suse.cz, linux-btrfs@vger.kernel.org
Message-ID: <f43e2d6d-4800-faae-6b81-99cd12f7ecda@suse.de>
Subject: Re: [PATCH v4 00/18] btrfs-progs: lowmem check: avoid extents
 overwrite
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
 <20180507181737.GE6649@twin.jikos.cz>
 <86ef8426-80b3-be41-2c95-d2d173d973ab@cn.fujitsu.com>
In-Reply-To: <86ef8426-80b3-be41-2c95-d2d173d973ab@cn.fujitsu.com>

--5nlOIHldOqFXpleu1sucPUT7A54TXsudg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8808=E6=97=A5 10:09, Su Yue wrote:
>=20
>=20
> On 05/08/2018 02:17 AM, David Sterba wrote:
>> On Thu, Feb 08, 2018 at 11:27:19AM +0800, Su Yue wrote:
>>> This patchset can be fetched from my github:
>>> https://github.com/Damenly/btrfs-progs/tree/lowmem
>>> based on unmerged patchset whose cover:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [PATCH 0/3] btrfs-progs: Split o=
riginal mode check to its own
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Author: Qu Wenruo <wqu@suse.com>=

>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I'm sorry to send patches based =
on unmerged patch if it let
>>> you feel
>>> uncomfortable.
>>> I think the three patches from Qu are good enough so I send it before=

>>> my vacation.
>>>
>>> Patch[1-3] fix minor problems of lowmem repair.
>>>
>>> Patch[4-8] introduce two ways to avoid extents overwrite:
>>> 1) Traverse trees and exclude all metadata blocks.
>>> =C2=A0=C2=A0=C2=A0 It's time-inefficient for large filesystems.
>>> 2) Mark all existed chunks full, allocate new chunk for CoW and
>>> =C2=A0=C2=A0=C2=A0 records chunk start.
>>> =C2=A0=C2=A0=C2=A0 If the last allocated chunk is almost full, alloca=
ted a new one.
>>> 2) is More efficient than 1). However, it can't handle situations
>>> like no space(fsck/004).
>>> Lowmem repair will try method 2 first and then method 1.
>>>
>>> Patch[9-17] remove parameters @trans in functions for lowmem repair.
>>> They try to avoid extents overwrite if necessary and start
>>> transactions by themselves.
>>>
>>> Patch[18] adds a test image.
>>> Those patches are mainly for lowmem repair. Original mode is not
>>> influenced.
>>>
>>> ---
>>> Changlog:
>>> v4->v3:
>>> =C2=A0 - Remove global enum extents_operation to simplify
>>> =C2=A0=C2=A0=C2=A0 avoid_extents_overwrite() and its cleanup.
>>> =C2=A0 - Rebase after work of check split.
>>> =C2=A0 v3->v2:
>>> =C2=A0 - check_btrfs_root() returns FATAL_ERROR if check_fs_first_ino=
de()
>>> =C2=A0=C2=A0=C2=A0 failed. Thanks Nikolay Borisov.
>>> =C2=A0 - Add function try_to_force_cow_in_new_chunk() and global u64
>>> =C2=A0=C2=A0=C2=A0 varaiable to record start of the last allocated ch=
unk.
>>> =C2=A0 - Remove unused EXTENTS_PIN in enum lowmem_extents_operation.
>>> =C2=A0 v2->v1:
>>> =C2=A0 - Let @err in check_btrfs_root() record err bits but excluded
>>> =C2=A0=C2=A0=C2=A0 negative values.
>>> =C2=A0 - Do not delete a line of code to release path after extent it=
em'
>>> =C2=A0=C2=A0=C2=A0 insertion in repair_extent_data_item().
>>> =C2=A0 - Add patch[3].
>>> =C2=A0 - Force CoW in new allocated chunk to avoid extents overwrite.=

>>> =C2=A0 - Remove parameters @trans in check_chunks_and_extents_v2() an=
d
>>> =C2=A0=C2=A0=C2=A0 related callees.
>>> =C2=A0 - Repair functions for lowmem mode call try_avoid_extents_over=
write()
>>> =C2=A0=C2=A0=C2=A0 and start transactions.
>>> =C2=A0=C2=A0=C2=A0 Su Yue (18):
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: release path in repair_extent=
_data_item()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: record returned errors after
>>> =C2=A0=C2=A0=C2=A0=C2=A0 walk_down_tree_v2()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: assign @parent early in
>>> =C2=A0=C2=A0=C2=A0=C2=A0 repair_extent_data_item()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: exclude extents of metadata b=
locks
>>
>> Patch 1-4 added to devel.
>>
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: introduce mark/clear_block_gr=
oups_full()
>>
>> There were too many conflicts starting with this patch.
>>
>> Can you please refresh teh rest of the series and resend?
>>
> OK of cource. An small question below.
>=20
> Though this patchset is for lowmem mode, it also changes original mode
> for code reuse.
>=20
> This patch and remainings base on Qu's unmerged patchset:
> =C2=A0=C2=A0=C2=A0=C2=A0[PATCH 0/3] btrfs-progs: Split original mode ch=
eck to its own
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Author: Qu Wenruo <wqu@suse.=
com>
> New version is named
> =C2=A0=C2=A0=C2=A0=C2=A0[PATCH 0/3] btrfs-progs: Split mode-original co=
de
> =C2=A0=C2=A0=C2=A0=C2=A0Author: Qu Wenruo <wqu@suse.com>

Sorry, that patchset will not be updated until we get a relatively
stable check code base.
So I'm afraid you need to base them on current devel branch other than
my patchset.

Thanks,
Qu

>=20
> I just tried to rebase his brach named split_check_for_david to devel
> but failed with conflictions.
>=20
> Does V2 need to get rid of the precondition and just rebases to devel?
> Or to wait completion of split?
>=20
> Thanks,
> Su
>=20
>> For subject please use "btrfs-progs: check: lowmem: ..." and try to fi=
x
>> the typos in the changelogs. Thanks.
>>
>>
>>
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: introduce try_force_cow_in_ne=
w_chunk()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: introduce avoid_extents_overw=
rite()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: exclude extents if init-exten=
t-tree in
>>> =C2=A0=C2=A0=C2=A0=C2=A0 lowmem
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: start to remove parameters @t=
rans in
>>> lowmem
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: remove parameter @trans of
>>> =C2=A0=C2=A0=C2=A0=C2=A0 delete_extent_item()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: remove parameter @trans of
>>> =C2=A0=C2=A0=C2=A0=C2=A0 repair_chunk_item()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: remove parameter @trans of
>>> =C2=A0=C2=A0=C2=A0=C2=A0 repair_extent_item()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: remove parameter @trans of
>>> =C2=A0=C2=A0=C2=A0=C2=A0 check_leaf_items()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: remove parameter @trans of
>>> =C2=A0=C2=A0=C2=A0=C2=A0 repair_tree_back_ref()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: remove parameter @trans of
>>> =C2=A0=C2=A0=C2=A0=C2=A0 check_btrfs_root()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: introduce repair_block_accoun=
ting()
>>> =C2=A0=C2=A0 btrfs-progs: lowmem check: end of removing parameters @t=
rans in
>>> lowmem
>>> =C2=A0=C2=A0 btrfs-progs: fsck-tests: add image no extent with normal=
 device size
>>
>>
>>
>=20
>=20
>=20


--5nlOIHldOqFXpleu1sucPUT7A54TXsudg--

--wQqqkvAqFjvzbn6dNPUTwZKbwB9C10j3V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrxBg0ACgkQwj2R86El
/qjRjQf/T/u+gEz3Kzaa2uf5xF0Wh/89E6hsLwhXh8uJe6XJxnc7BFIehGyirLgi
MxNVSPJG8PeCuyh7tssKGmsYV35cN3bs8eSAlrHA2XkhCFaGibYZsR7583Pt6JOe
5yAVhurZirC6HGtWOr4kje7bB6WqJTHjohOExP368DRFFDkwr2qzT7QhpPAZXjJb
yD2MO+jQ3fstZ36DeLabOQUMMWUGP6ijLReLOyNtYS14YFjAHawzeM1Tp3j0ZOnf
r8ltOfA42J/fYJOep6sqgNfF3/GwFFWh0fqAXVwFgBsaJzu2kB7RUIkojawyYiFH
OExulrWbSq08r0AYBOgt1kPi9KdCdw==
=B/Dm
-----END PGP SIGNATURE-----

--wQqqkvAqFjvzbn6dNPUTwZKbwB9C10j3V--
