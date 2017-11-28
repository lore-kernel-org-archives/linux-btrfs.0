Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58706 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751619AbdK1EFd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 23:05:33 -0500
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
 <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
 <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3fc6c9b0-2c84-7bef-1775-bf3af708aa46@gmx.com>
Date: Tue, 28 Nov 2017 12:05:23 +0800
MIME-Version: 1.0
In-Reply-To: <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hKabFKBC06fFNBLJghdtdVXgQOVgHfah0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hKabFKBC06fFNBLJghdtdVXgQOVgHfah0
Content-Type: multipart/mixed; boundary="q115Ps1JvIDGXhwx0rOiHw9rblswMXUv0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <3fc6c9b0-2c84-7bef-1775-bf3af708aa46@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
 <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
 <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>
In-Reply-To: <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>

--q115Ps1JvIDGXhwx0rOiHw9rblswMXUv0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 10:38, Su Yue wrote:
> Thanks for review.
>=20
> On 11/27/2017 06:37 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 11:13, Su Yue wrote:
>>> Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression which=

>>> screws up extent allocator") removes pin_metadata_blocks() from
>>> lowmem repair.
>>> So we have to find another way to exclude extents which should be
>>> occupied by tree blocks.
>>
>> First thing first, any tree block which is referred by will not be fre=
ed.
>>
>> Unless some special case, like extent tree initialization which clears=

>> the whole extent tree so we can't check if one tree block should be
>> freed using extent tree, there is no need to explicitly pin existing
>> tree blocks.
>>
>> Their creation/freeing is already handled well.
>>
> If I understand the logic of extents correctly:
>=20
> The extents in free space cache are handled in the way like
> cache_block_group() in extent-tree.c.
> It traverses all extents items then marks all holes free in free space
> cache.
>=20
> Yes, in a normal situation, extents are already handled well.
> But original and lowmem check try to repair corrupted extent tree.
>=20
> Suppose a situation:
> 1) Let an extent item of one tree block is corrupted or missed.
> 2) The correct extent in free space cache will be marked as free.
> 3) Next CoW may allocate the "used" extents from free space
> =C2=A0=C2=A0 and insert an extent item.
> 4) Lowmem repair increases refs of the extent item and
> =C2=A0=C2=A0 causes a wrong extent item.
> OR
> 3) Lowmem repair inserts the extent item firstly.
> 4) CoW may allocate the "used" extents from free space.
> =C2=A0=C2=A0 BUG_ON failure of inserting the extent item.

OK, this explains things, but still not optimal.

Such behavior should not happen if nothing is exposed.
Pinning down all tree blocks is never a light operation and should be
avoided if possible.

It would be nice to do it when starting a new transaction to modify the f=
s.

>=20
>> Please explain the reason why you need to pin extents first.
>>
> What I do in the patch is like origin mode's.
> Pining extents first ensures every extents(corrupted and uncorrupted)
> will not be rellocated.

Only extent tree reinit will pin down all metadata block in original
mode while normal repair won't.

So you're still doing something which is not done in original mode,
which either needs to be explained in detail or fix original mode first.

>=20
> Thanks,
> Su
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Modify pin_down_tree_blocks() only for code reuse.
>>> So behavior of pin_metadata_blocks() which works with option
>>> 'init-extent-tree' is not influenced.
>>>
>>> Introduce exclude_blocks_and_extent_items() to mark extents of all tr=
ee
>>> blocks dirty in fs_info->excluded_extents. It also calls
>>> exclude_extent_items() to exclude extent_items in extent tree.
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> =C2=A0 cmds-check.c | 122
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>> =C2=A0 1 file changed, 112 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/cmds-check.c b/cmds-check.c
>>> index c7b570bef9c3..f39285c5a3c2 100644
>>> --- a/cmds-check.c
>>> +++ b/cmds-check.c
>>> @@ -13351,6 +13351,7 @@ out:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
>>> =C2=A0 }
>>> =C2=A0 +static int exclude_blocks_and_extent_items(struct btrfs_fs_in=
fo
>>> *fs_info);
>>> =C2=A0 /*
>>> =C2=A0=C2=A0 * Low memory usage version check_chunks_and_extents.
>>> =C2=A0=C2=A0 */
>>> @@ -13363,12 +13364,22 @@ static int
>>> check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *cur_root;
>>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree excluded_extents;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err =3D;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root =3Ds_info->fs_root;
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (repair) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_io_tree_init(&excl=
uded_extents);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->excluded_extents=
 =3Dexcluded_extents;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3Dxclude_blocks_and_=
extent_items(fs_info);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e=
rror("failed to exclude tree blocks and extent items");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
eturn ret;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reset_cached_block_groups=
(fs_info);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans =3Dtrfs_=
start_transaction(fs_info->extent_root, 1);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(tra=
ns)) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 error("failed to start transaction before check");
>>> @@ -13437,6 +13448,8 @@ out:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 err |=3Det;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 err &=3DBG_ACCOUNTING_ERROR;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_io_tree_cleanup(&e=
xcluded_extents);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->excluded_extents=
 =3DULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (trans)
>>> @@ -13534,40 +13547,106 @@ init:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0 }
>>> =C2=A0 -static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info=
,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root)
>>> +static int exclude_extent_items(struct btrfs_fs_info *fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct extent_io_tree *tree)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3Ds_info->extent_root;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path path;
>>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb;
>>> +=C2=A0=C2=A0=C2=A0 int slot;
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +=C2=A0=C2=A0=C2=A0 u64 start;
>>> +=C2=A0=C2=A0=C2=A0 u64 end;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ASSERT(tree);
>>> +=C2=A0=C2=A0=C2=A0 btrfs_init_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 key.objectid =3D;
>>> +=C2=A0=C2=A0=C2=A0 key.type =3D;
>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_search_slot(NULL, root, &key, &path, =
0, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 while (1) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 eb =3Dath.nodes[0];
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 slot =3Dath.slots[0];
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(eb,=
 &key, slot);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.type !=3DTRFS_EXT=
ENT_ITEM_KEY &&
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 k=
ey.type !=3DTRFS_METADATA_ITEM_KEY)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto next;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start =3Dey.objectid;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.type =3DBTRFS_EXT=
ENT_ITEM_KEY)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e=
nd =3Dtart + key.offset;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e=
nd =3Dtart + fs_info->nodesize;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_extent_dirty(tree, st=
art, end - 1);
>>> +next:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_next_item(roo=
t, &path);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret > 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3D;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto out;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto out;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +out:
>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("failed to exclude =
extent items");
>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path);
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> +static int traverse_tree_blocks(struct btrfs_fs_info *fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 int pin)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *tmp;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root_item *ri;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree *tree;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 bytenr;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int level =3Dtrfs_header_level(eb);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nritems;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i;
>>> +=C2=A0=C2=A0=C2=A0 u64 end =3Db->start + eb->len;
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 if (pin)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree =3Dfs_info->pinned_e=
xtents;
>>> +=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree =3Ds_info->excluded_=
extents;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * If we have pinned this block before, don'=
t pin it again.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If we have pinned/excluded this block bef=
ore, don't do it again.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * This can not only avoid foreve=
r loop with broken filesystem
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * but also give us some speedups=
=2E
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 if (test_range_bit(&fs_info->pinned_extents, eb->=
start,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 eb->start + eb->len - 1, EXTENT_DIRTY, 0))
>>> +=C2=A0=C2=A0=C2=A0 if (test_range_bit(tree, eb->start, end - 1, EXTE=
NT_DIRTY, 0))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_pin_extent(fs_info, eb->start, eb->l=
en);
>>> +=C2=A0=C2=A0=C2=A0 if (pin)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_pin_extent(fs_info,=
 eb->start, eb->len);
>>> +=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_extent_dirty(tree, eb=
->start, end - 1);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nritems =3Dtrfs_header_nritems(=
eb);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D; i < nritems; i++) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (level =3D0=
) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
ool is_extent_root;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_item_key_to_cpu(eb, &key, i);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (key.type !=3DTRFS_ROOT_ITEM_KEY)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 /* Skip the extent root and reloc roots */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (key.objectid =3DBTRFS_EXTENT_TREE_OBJECTID ||
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 key.objectid =3DBTRFS_TREE_RELOC_OBJECTID ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (key.objectid =3DBTRFS_TREE_RELOC_OBJECTID ||
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3DBTRFS_DATA_RELOC_TREE_O=
BJECTID)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
s_extent_root >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3D=3D
>>> BTRFS_EXTENT_TREE_OBJECTID;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /=
* If pin, skip the extent root */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (pin && is_extent_root)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 continue;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ri =3Dtrfs_item_ptr(eb, i, struct btrfs_root_item);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 bytenr =3Dtrfs_disk_root_bytenr(eb, ri);
>>> =C2=A0 @@ -13582,7 +13661,7 @@ static int pin_down_tree_blocks(struct=

>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "Error reading root blo=
ck\n");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3Din_down_tree_blocks(fs_info, tmp, 0);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3Draverse_tree_blocks(fs_info, tmp, 0, pin);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 free_extent_buffer(tmp);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> @@ -13601,7 +13680,8 @@ static int pin_down_tree_blocks(struct
>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "Error reading tree blo=
ck\n");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3Din_down_tree_blocks(fs_info, tmp, tree_root);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3Draverse_tree_blocks(fs_info, tmp, tree_root,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pin);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 free_extent_buffer(tmp);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> @@ -13611,6 +13691,12 @@ static int pin_down_tree_blocks(struct
>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0 }
>>> =C2=A0 +static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return traverse_tree_blocks(fs_info, eb, tree_roo=
t, 1);
>>> +}
>>> +
>>> =C2=A0 static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> @@ -13622,6 +13708,22 @@ static int pin_metadata_blocks(struct
>>> btrfs_fs_info *fs_info)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return pin_down_tree_blocks(fs_info, f=
s_info->tree_root->node, 1);
>>> =C2=A0 }
>>> =C2=A0 +static int exclude_tree_blocks(struct btrfs_fs_info *fs_info,=

>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 return traverse_tree_blocks(fs_info, fs_info->tre=
e_root->node,
>>> 1, 0);
>>> +}
>>> +
>>> +static int exclude_blocks_and_extent_items(struct btrfs_fs_info
>>> *fs_info)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3Dxclude_extent_items(fs_info, fs_info->excl=
uded_extents);
>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0 return exclude_tree_blocks(fs_info, fs_info->tree=
_root->node, 1);
>>> +}
>>> +
>>> =C2=A0 static int reset_block_groups(struct btrfs_fs_info *fs_info)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_block_group_cache *cache;=

>>>
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--q115Ps1JvIDGXhwx0rOiHw9rblswMXUv0--

--hKabFKBC06fFNBLJghdtdVXgQOVgHfah0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloc4IMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgH7wf6AyRIKeChFDmxtLTISrrTgXTN
gd2y5wnv69ubUglT/1HdhZkP4cplJqar6Q8po0eyCUcP4iXlN/1tvExb1PSKZUJq
duNmcBofSUFcPMEp2TJGcPq7Sf7ociArt3OwcDdNIQqZeKn8Dw18RQhsNAy+8rIs
LkqVy8S3NBTV+6VwnD1NeTXZYjQGPopyBTVx39HbndHiz+9xJ6bkR4E2vvPvIILf
cOxSZpVfPrj+SwWF+xEUZhHHNmnVFdWa/NDMKlFHJwfi4Y5ygwAHguxonCPxKr9l
DHA9C4Jge7mVmajLv9B06R+rMWUYDzNxuN5JLaoBvbbmkBkvtHYuPZYr8govqQ==
=TmTw
-----END PGP SIGNATURE-----

--hKabFKBC06fFNBLJghdtdVXgQOVgHfah0--
