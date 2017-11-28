Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57880 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdK1IZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 03:25:51 -0500
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
 <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
 <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>
 <3fc6c9b0-2c84-7bef-1775-bf3af708aa46@gmx.com>
 <d010dc5e-8770-c702-f13c-f61657f9c954@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d7bf2d14-a2e1-9d27-ac09-80933717d57c@gmx.com>
Date: Tue, 28 Nov 2017 16:25:32 +0800
MIME-Version: 1.0
In-Reply-To: <d010dc5e-8770-c702-f13c-f61657f9c954@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1BFF1JnkQcCpjOc9jgxaknm1e0GFqSMGQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1BFF1JnkQcCpjOc9jgxaknm1e0GFqSMGQ
Content-Type: multipart/mixed; boundary="BkSSwfpdIegFuouXiPF29jRXq39i8R3Ng";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <d7bf2d14-a2e1-9d27-ac09-80933717d57c@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
 <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
 <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>
 <3fc6c9b0-2c84-7bef-1775-bf3af708aa46@gmx.com>
 <d010dc5e-8770-c702-f13c-f61657f9c954@cn.fujitsu.com>
In-Reply-To: <d010dc5e-8770-c702-f13c-f61657f9c954@cn.fujitsu.com>

--BkSSwfpdIegFuouXiPF29jRXq39i8R3Ng
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 15:47, Su Yue wrote:
>=20
>=20
> On 11/28/2017 12:05 PM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 10:38, Su Yue wrote:
>>> Thanks for review.
>>>
>>> On 11/27/2017 06:37 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 11:13, Su Yue wrote:
>>>>> Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression whi=
ch
>>>>> screws up extent allocator") removes pin_metadata_blocks() from
>>>>> lowmem repair.
>>>>> So we have to find another way to exclude extents which should be
>>>>> occupied by tree blocks.
>>>>
>>>> First thing first, any tree block which is referred by will not be
>>>> freed.
>>>>
>>>> Unless some special case, like extent tree initialization which clea=
rs
>>>> the whole extent tree so we can't check if one tree block should be
>>>> freed using extent tree, there is no need to explicitly pin existing=

>>>> tree blocks.
>>>>
>>>> Their creation/freeing is already handled well.
>>>>
>>> If I understand the logic of extents correctly:
>>>
>>> The extents in free space cache are handled in the way like
>>> cache_block_group() in extent-tree.c.
>>> It traverses all extents items then marks all holes free in free spac=
e
>>> cache.
>>>
>>> Yes, in a normal situation, extents are already handled well.
>>> But original and lowmem check try to repair corrupted extent tree.
>>>
>>> Suppose a situation:
>>> 1) Let an extent item of one tree block is corrupted or missed.
>>> 2) The correct extent in free space cache will be marked as free.
>>> 3) Next CoW may allocate the "used" extents from free space
>>> =C2=A0=C2=A0=C2=A0 and insert an extent item.
>>> 4) Lowmem repair increases refs of the extent item and
>>> =C2=A0=C2=A0=C2=A0 causes a wrong extent item.
>>> OR
>>> 3) Lowmem repair inserts the extent item firstly.
>>> 4) CoW may allocate the "used" extents from free space.
>>> =C2=A0=C2=A0=C2=A0 BUG_ON failure of inserting the extent item.
>>
>> OK, this explains things, but still not optimal.
>>
>> Such behavior should not happen if nothing is exposed.
>> Pinning down all tree blocks is never a light operation and should be
>> avoided if possible.
>>
>=20
> Agreed.
>=20
>> It would be nice to do it when starting a new transaction to modify
>> the fs.
>>
>=20
> Now, there is only one transaction while checking chunks and extents
> because of previous wrong call of pin_metadata_blocks().
> It's meaningless to put it at start of new transaction now.

Because you start that transaction under all condition.

Normally, transaction should only be started if you're sure you will
modify the filesystem.

Start them unconditionally is not a preferred behavior.

>=20
> I will split the transaction into many minors. Then lowmem repair will
> speed up if no error in chunks and extents. But it is just a little
> optimization.

Compared to iterating all tree blocks, it's a big optimization.

Just think of filesystem with several TB metadata.

>=20
>>>
>>>> Please explain the reason why you need to pin extents first.
>>>>
>>> What I do in the patch is like origin mode's.
>>> Pining extents first ensures every extents(corrupted and uncorrupted)=

>>> will not be rellocated.
>>
>> Only extent tree reinit will pin down all metadata block in original
>> mode while normal repair won't.
>>
>> So you're still doing something which is not done in original mode,
>> which either needs to be explained in detail or fix original mode firs=
t.
>>
>=20
> You are right. I did miss details of how original mode frees extent
> records.
>=20
> After come thinking, pining extents is still necessary in lowmem
> repair.
>=20
> Original mode has extent cache to record all extents and free normal
> extents while traversing tree blocks.
> After traversal, only corrupted extent records exist in the cache.
> At this moment, it pins them and start transactions to repair.
>=20
> Lowmem mode does not store anything like extent records. It begins
> transactions(in further patch) in traversal. We can not guarantee
> extents allocated from free space is occupied by one tree block which
> has not been traversed.
>=20
> Although pining extents is heavy and painfully work, it seems
> inevitable. Otherwise, I have no better idea than pining all
> extents.

Firstly, only missing backref in extent tree will cause problem.

Even we have corrupted backref or extra backref which doesn't have any
tree block/data referring it, it won't cause a big problem.

So for lowmem mode, we can do it in a different way, just like seed
device, we allocate new meta chunks, and only use new meta chunks for
our tree operations.

This will avoid any extra tree iteration, and easier to implement AFAIK.
(Just mark all existing block groups full, to force chunk allocation)

Thanks,
Qu

>=20
> Thanks,
> Su
>=20
>>>
>>> Thanks,
>>> Su
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Modify pin_down_tree_blocks() only for code reuse.
>>>>> So behavior of pin_metadata_blocks() which works with option
>>>>> 'init-extent-tree' is not influenced.
>>>>>
>>>>> Introduce exclude_blocks_and_extent_items() to mark extents of all
>>>>> tree
>>>>> blocks dirty in fs_info->excluded_extents. It also calls
>>>>> exclude_extent_items() to exclude extent_items in extent tree.
>>>>>
>>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>>> ---
>>>>> =C2=A0=C2=A0 cmds-check.c | 122
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>>>> =C2=A0=C2=A0 1 file changed, 112 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>>> index c7b570bef9c3..f39285c5a3c2 100644
>>>>> --- a/cmds-check.c
>>>>> +++ b/cmds-check.c
>>>>> @@ -13351,6 +13351,7 @@ out:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +static int exclude_blocks_and_extent_items(struct btr=
fs_fs_info
>>>>> *fs_info);
>>>>> =C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0 * Low memory usage version check_chunks_and_exte=
nts.
>>>>> =C2=A0=C2=A0=C2=A0 */
>>>>> @@ -13363,12 +13364,22 @@ static int
>>>>> check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *cur_root;
>>>>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree excluded_extents;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err =3D;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root =3Ds_info->fs_root=
;
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (repair) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_io_tree_init(&ex=
cluded_extents);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->excluded_exten=
ts =3Dexcluded_extents;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3Dxclude_blocks_an=
d_extent_items(fs_info);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 error("failed to exclude tree blocks and extent items");
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return ret;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reset_cached_block_grou=
ps(fs_info);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans =
=3Dtrfs_start_transaction(fs_info->extent_root, 1);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS=
_ERR(trans)) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 error("failed to start transaction before check");
>>>>> @@ -13437,6 +13448,8 @@ out:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 err |=3Det;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 err &=3DBG_ACCOUNTING_ERROR;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_io_tree_cleanup(=
&excluded_extents);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->excluded_exten=
ts =3DULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (trans)
>>>>> @@ -13534,40 +13547,106 @@ init:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 -static int pin_down_tree_blocks(struct btrfs_fs_info =
*fs_info,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root)
>>>>> +static int exclude_extent_items(struct btrfs_fs_info *fs_info,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_io_tree *tree)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3Ds_info->extent_root;=

>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_path path;
>>>>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb;
>>>>> +=C2=A0=C2=A0=C2=A0 int slot;
>>>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>>>> +=C2=A0=C2=A0=C2=A0 u64 start;
>>>>> +=C2=A0=C2=A0=C2=A0 u64 end;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 ASSERT(tree);
>>>>> +=C2=A0=C2=A0=C2=A0 btrfs_init_path(&path);
>>>>> +=C2=A0=C2=A0=C2=A0 key.objectid =3D;
>>>>> +=C2=A0=C2=A0=C2=A0 key.type =3D;
>>>>> +=C2=A0=C2=A0=C2=A0 key.offset =3D;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_search_slot(NULL, root, &key, &path=
, 0, 0);
>>>>> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 while (1) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 eb =3Dath.nodes[0];
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 slot =3Dath.slots[0];
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(e=
b, &key, slot);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.type !=3DTRFS_E=
XTENT_ITEM_KEY &&
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 key.type !=3DTRFS_METADATA_ITEM_KEY)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto next;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start =3Dey.objectid;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.type =3DBTRFS_E=
XTENT_ITEM_KEY)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 end =3Dtart + key.offset;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 end =3Dtart + fs_info->nodesize;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_extent_dirty(tree, =
start, end - 1);
>>>>> +next:
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3Dtrfs_next_item(r=
oot, &path);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret > 0) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3D;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto out;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 goto out;
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> +out:
>>>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("failed to exclud=
e extent items");
>>>>> +=C2=A0=C2=A0=C2=A0 btrfs_release_path(&path);
>>>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>>>> +}
>>>>> +
>>>>> +static int traverse_tree_blocks(struct btrfs_fs_info *fs_info,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int pin)
>>>>> =C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *tmp;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root_item *ri;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>>>>> +=C2=A0=C2=A0=C2=A0 struct extent_io_tree *tree;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 bytenr;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int level =3Dtrfs_header_level=
(eb);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nritems;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i;
>>>>> +=C2=A0=C2=A0=C2=A0 u64 end =3Db->start + eb->len;
>>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 if (pin)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree =3Dfs_info->pinned=
_extents;
>>>>> +=C2=A0=C2=A0=C2=A0 else
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tree =3Ds_info->exclude=
d_extents;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * If we have pinned this block before, do=
n't pin it again.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If we have pinned/excluded this block b=
efore, don't do it
>>>>> again.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * This can not only avoi=
d forever loop with broken filesystem
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * but also give us some =
speedups.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> -=C2=A0=C2=A0=C2=A0 if (test_range_bit(&fs_info->pinned_extents, eb=
->start,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 eb->start + eb->len - 1, EXTENT_DIRTY, 0))
>>>>> +=C2=A0=C2=A0=C2=A0 if (test_range_bit(tree, eb->start, end - 1, EX=
TENT_DIRTY, 0))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 0;
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 btrfs_pin_extent(fs_info, eb->star=
t, eb->len);
>>>>> +=C2=A0=C2=A0=C2=A0 if (pin)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_pin_extent(fs_inf=
o, eb->start, eb->len);
>>>>> +=C2=A0=C2=A0=C2=A0 else
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_extent_dirty(tree, =
eb->start, end - 1);
>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nritems =3Dtrfs_header_=
nritems(eb);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D; i < nritems; i++) =
{
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (le=
vel =3D0) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 bool is_extent_root;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(eb, &key, i);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (key.type !=3DTRFS_ROOT_ITEM_KEY)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 /* Skip the extent root and reloc roots */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (key.objectid =3DBTRFS_EXTENT_TREE_OBJECTID ||
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3DBTRFS_TREE_RELOC_OBJECTID ||
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (key.objectid =3DBTRFS_TREE_RELOC_OBJECTID ||
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3DBTRFS_DATA_RELOC_=
TREE_OBJECTID)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 is_extent_root >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3D=3D
>>>>> BTRFS_EXTENT_TREE_OBJECTID;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 /* If pin, skip the extent root */
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (pin && is_extent_root)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 continue;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ri =3Dtrfs_item_ptr(eb, i, struct btrfs_root_item);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 bytenr =3Dtrfs_disk_root_bytenr(eb, ri);
>>>>> =C2=A0=C2=A0 @@ -13582,7 +13661,7 @@ static int pin_down_tree_block=
s(struct
>>>>> btrfs_fs_info *fs_info,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "Error reading ro=
ot block\n");
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Din_down_tree_blocks(fs_info, tmp, 0);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Draverse_tree_blocks(fs_info, tmp, 0, pin);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 free_extent_buffer(tmp);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>> @@ -13601,7 +13680,8 @@ static int pin_down_tree_blocks(struct
>>>>> btrfs_fs_info *fs_info,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fprintf(stderr, "Error reading tr=
ee block\n");
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Din_down_tree_blocks(fs_info, tmp, tree_root);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ret =3Draverse_tree_blocks(fs_info, tmp, tree_root,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 pin);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 free_extent_buffer(tmp);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>> @@ -13611,6 +13691,12 @@ static int pin_down_tree_blocks(struct
>>>>> btrfs_fs_info *fs_info,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +static int pin_down_tree_blocks(struct btrfs_fs_info =
*fs_info,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 return traverse_tree_blocks(fs_info, eb, tree_r=
oot, 1);
>>>>> +}
>>>>> +
>>>>> =C2=A0=C2=A0 static int pin_metadata_blocks(struct btrfs_fs_info *f=
s_info)
>>>>> =C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> @@ -13622,6 +13708,22 @@ static int pin_metadata_blocks(struct
>>>>> btrfs_fs_info *fs_info)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return pin_down_tree_blocks(fs=
_info,
>>>>> fs_info->tree_root->node, 1);
>>>>> =C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 +static int exclude_tree_blocks(struct btrfs_fs_info *=
fs_info,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *eb, int tree_root)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 return traverse_tree_blocks(fs_info, fs_info->t=
ree_root->node,
>>>>> 1, 0);
>>>>> +}
>>>>> +
>>>>> +static int exclude_blocks_and_extent_items(struct btrfs_fs_info
>>>>> *fs_info)
>>>>> +{
>>>>> +=C2=A0=C2=A0=C2=A0 int ret;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 ret =3Dxclude_extent_items(fs_info, fs_info->ex=
cluded_extents);
>>>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>> +=C2=A0=C2=A0=C2=A0 return exclude_tree_blocks(fs_info, fs_info->tr=
ee_root->node, 1);
>>>>> +}
>>>>> +
>>>>> =C2=A0=C2=A0 static int reset_block_groups(struct btrfs_fs_info *fs=
_info)
>>>>> =C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_block_group_cache=
 *cache;
>>>>>
>>>>
>>>
>>>
>>> --=C2=A0
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>
>=20
>=20
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--BkSSwfpdIegFuouXiPF29jRXq39i8R3Ng--

--1BFF1JnkQcCpjOc9jgxaknm1e0GFqSMGQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlodHX0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhn0Af/eaRxVcqCcb3l9RE+IId1u3yB
56zVtebu9WhJ4//SOfewoTo0QpZzOZknIVtRAHkoZMwD1au8Nd3SZXXlEAj1PDp5
ikSt51mP/CmOMx8mGTERrZUFYGUcCQgONpf2xt2UFMCctpU+4w20lTKQVQPTTJWI
I8McFhV5yBa9NeZJ5kXg2TXbgH0wapBTvT3jzAj3bF0hBmJTTwD8n81hm+m+1E3S
nqLEL3zXyHVQ+zIh5KSvWGpU73ehm46lX83wUwGnzfX8Bz2ahJXgzH0pTu6iHvja
4CijC1xe18jYvf3LTGF2Bf+zx1bwipJIwdkfenSlJ4vuDdSAgun1H8zxiSHB9w==
=FEc4
-----END PGP SIGNATURE-----

--1BFF1JnkQcCpjOc9jgxaknm1e0GFqSMGQ--
