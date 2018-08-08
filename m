Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51373 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbeHHHdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 03:33:35 -0400
Subject: Re: [PATCH v3] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533517699.git.misono.tomohiro@jp.fujitsu.com>
 <3ea480fc-46ad-4072-198d-1e8f49121be0@jp.fujitsu.com>
 <20180807162332.GB3288@fnst.localdomain>
 <bed3f2b7-1be3-130d-a0b6-7a4d3ba5db4e@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f4942d37-65a0-3a92-02d5-1162e2da8dab@gmx.com>
Date: Wed, 8 Aug 2018 13:15:27 +0800
MIME-Version: 1.0
In-Reply-To: <bed3f2b7-1be3-130d-a0b6-7a4d3ba5db4e@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MU70ooPLhMsngjHg6YmwdWBHxIskP6tSM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MU70ooPLhMsngjHg6YmwdWBHxIskP6tSM
Content-Type: multipart/mixed; boundary="rWq6fr5wn5zm7PGu7HnwQ0yZJU4cVXeZZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f4942d37-65a0-3a92-02d5-1162e2da8dab@gmx.com>
Subject: Re: [PATCH v3] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
References: <cover.1533517699.git.misono.tomohiro@jp.fujitsu.com>
 <3ea480fc-46ad-4072-198d-1e8f49121be0@jp.fujitsu.com>
 <20180807162332.GB3288@fnst.localdomain>
 <bed3f2b7-1be3-130d-a0b6-7a4d3ba5db4e@jp.fujitsu.com>
In-Reply-To: <bed3f2b7-1be3-130d-a0b6-7a4d3ba5db4e@jp.fujitsu.com>

--rWq6fr5wn5zm7PGu7HnwQ0yZJU4cVXeZZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8808=E6=97=A5 10:56, Misono Tomohiro wrote:
> On 2018/08/08 1:23, Lu Fengqi wrote:
>> On Mon, Aug 06, 2018 at 01:53:28PM +0900, Misono Tomohiro wrote:
>>> When qgroup is on, subvolume deletion does not remove qgroup items
>>> of the subvolume (qgroup info, limit, relation) from quota tree and
>>> they need to get removed manually by "btrfs qgroup destroy".
>>>
>>> Since level 0 qgroup cannot be used/inherited by any other subvolume,=

>>> let's remove them automatically when subvolume is deleted
>>> (to be precise, when the subvolume root is dropped).
>>>
>>> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>> ---
>>> v2 -> v3:
>>>  Use root->root_key.objectid instead of root->objectid
>>>  Add Reviewed-by tag
>>>
>>> v1 -> v2:
>>>  Move call of btrfs_remove_qgroup() from btrfs_delete_subvolume()
>>>  to btrfs_snapshot_destroy() so that it will be called after the
>>>  subvolume root is really dropped
>>>
>>> fs/btrfs/extent-tree.c | 16 ++++++++++++----
>>> 1 file changed, 12 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 9e7b237b9547..48edf839ed2c 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *ro=
ot,
>>> 	struct btrfs_root_item *root_item =3D &root->root_item;
>>> 	struct walk_control *wc;
>>> 	struct btrfs_key key;
>>> +	u64 objectid =3D root->root_key.objectid;
>>> 	int err =3D 0;
>>> 	int ret;
>>> 	int level;
>>> 	bool root_dropped =3D false;
>>>
>>> -	btrfs_debug(fs_info, "Drop subvolume %llu", root->objectid);
>>> +	btrfs_debug(fs_info, "Drop subvolume %llu", objectid);
>>>
>>> 	path =3D btrfs_alloc_path();
>>> 	if (!path) {
>>> @@ -9030,7 +9031,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>>> 		goto out_end_trans;
>>> 	}
>>>
>>> -	if (root->root_key.objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
>>> +	if (objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
>>> 		ret =3D btrfs_find_root(tree_root, &root->root_key, path,
>>> 				      NULL, NULL);
>>> 		if (ret < 0) {
>>> @@ -9043,8 +9044,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>>> 			 *
>>> 			 * The most common failure here is just -ENOENT.
>>> 			 */
>>> -			btrfs_del_orphan_item(trans, tree_root,
>>> -					      root->root_key.objectid);
>>> +			btrfs_del_orphan_item(trans, tree_root, objectid);
>>> 		}
>>> 	}
>>>
>>> @@ -9056,6 +9056,14 @@ int btrfs_drop_snapshot(struct btrfs_root *roo=
t,
>>> 		btrfs_put_fs_root(root);
>>> 	}
>>> 	root_dropped =3D true;
>>> +
>>> +	 /* Remove level-0 qgroup items since no other subvolume can use th=
em */
>>> +	ret =3D btrfs_remove_qgroup(trans, objectid);
>>> +	if (ret && ret !=3D -EINVAL && ret !=3D -ENOENT) {
>>
>> I'm sorry for missing the snapshot case. If it is a snapshot, then whe=
n
>> we remove the relevant qgroup, we will not be able to perform
>> quick_update_accounting(), and it will return 1. So we shouldn't abort=

>> the transaction when the return value =3D 1.
>>
>> btrfs_remove_qgroup
>> -> __del_qgroup_relation
>>    -> quick_update_accounting << if qgroup->excl !=3D qgroup->rfer; re=
turn 1
>>
>=20
> oh, thanks for pointing out, I missed that case...
> I wonder if there is a way to keep qgroup consistency without enforcing=
 rescan.=20

In theory, it's possible by just dirtying all extents of related level 0
qgroups.

In practical, not really possible.
As above method will hang current transaction almost forever.

>=20
> btw, I noticed that removing qgroup relation when excl !=3D rfer causes=

> some problem without this patch:
>=20
> (4.18-rc7)
> $ mkfs.btrfs -fq $DEV
> $ mount $DEV /mnt
>=20
> $ btrfs quota enable /mnt
> $ btrfs qgroup create 1/0 /mnt
> $ btrfs sub create /mnt/sub
> $ btrfs qgroup assign 0/257 1/0 /mnt
>=20
> $ dd if=3D/dev/urandom of=3D/mnt/sub/file bs=3D1k count=3D1000
> $ btrfs sub snap /mnt/sub /mnt/snap

In fact, at this point we should already mark btrfs quota inconsistent.

When creating qgroup 0/258 we're already doing quick hack for its
number, but since 0/257 is already belong to 1/0, the quick update
itself is already making quota inconsistent.

(Yes, snapshot creation under multi-level qgroups is the biggest
challenge for btrfs quota)

> $ dd if=3D/dev/urandom of=3D/mnt/sub/file2 bs=3D1k count=3D1000
>=20
> $ btrfs fi sync /mnt
> $ btrfs qgroup show -pcre /mnt

At this point, qgroups is already inconsistent.
I'll try to fix it.

Thanks,
Qu

> qgroupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5          16.00KiB     16.00KiB         none         none ---     --=
-
> 0/257         1.97MiB   1016.00KiB         none         none 1/0     --=
-
> 0/258      1016.00KiB     16.00KiB         none         none ---     --=
-
> 1/0           1.97MiB      1.97MiB         none         none ---     0/=
257
>                            ^^^^^^^ should be 1016Kib
>=20
> $ btrfs qgroup remove 0/257 1/0 /mnt
> WARNING: quotas may be inconsistent, rescan needed
> $ btrfs qgroup show -pcre  /mnt
> WARNING: qgroup data inconsistent, rescan recommended
> qgroupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5          16.00KiB     16.00KiB         none         none ---     --=
-
> 0/258      1016.00KiB   1016.00KiB         none         none ---     --=
-
> 1/0           1.97MiB      1.97MiB         none         none ---     --=
-
>=20
> $ btrfs quota rescan -w /mnt
> $ btrfs qgroup show -pcre /mnt
> qgroupid         rfer         excl     max_rfer     max_excl parent  ch=
ild
> --------         ----         ----     --------     -------- ------  --=
---
> 0/5          16.00KiB     16.00KiB         none         none ---     --=
-
> 0/258      1016.00KiB   1016.00KiB         none         none ---     --=
-
> 1/0           1.97MiB      1.97MiB         none         none ---     --=
-
>                ^^^^^^      ^^^^^^^ not changed, although inconsistency =
flag is cleared
>=20
> I will look at the case to better understand qgroup.
>=20
> Thanks,
> Misono
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--rWq6fr5wn5zm7PGu7HnwQ0yZJU4cVXeZZ--

--MU70ooPLhMsngjHg6YmwdWBHxIskP6tSM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltqfG8ACgkQwj2R86El
/qhTaAf/X3JVHnjQz/IYfAChJuY9r+U9FlWNgSZXS8BdchK+WD4zqBH5pxbsB2aI
OZFAIvSzK8hg5UtXiL/NMJQvaVDuPAm7Nod99QqCKiOi2BFeJIG+nyEcT6b0hhuy
I2cJbVnRuZ1hn1/gZ5hUGLs/VpOMojdMZ6Jb/0wHIM/GYHdwcsXosQ7k/9mHylzb
mBAY9dukpalY3ZDgbtREiNeOwQQDqj0b/ATWWNA+6sOCcUZgN0w4ExaTR6U8rl3L
SDH+mLe8uUd4GfFMlUG7a6UB7L5k729+CzfcsFxN5jirRofSJyXbusJyssypCtZY
SRXtScoZ1QSaRzpDhGZkiXlNiaMfmQ==
=DfWV
-----END PGP SIGNATURE-----

--MU70ooPLhMsngjHg6YmwdWBHxIskP6tSM--
