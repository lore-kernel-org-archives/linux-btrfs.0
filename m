Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754237AbeFTLDJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 07:03:09 -0400
Subject: Re: [PATCH v3] btrfs: Don't remove block group still has pinned down
 bytes
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180615013523.2807-1-wqu@suse.com>
 <CAL3q7H524L_JKupweEGxstHp4kZtVsmT4s7n6qwbZsQVhh39PA@mail.gmail.com>
 <aadc92ff-9455-8d1d-3828-805f2bd8cda2@suse.de>
 <CAL3q7H5O10eQtY122=Sm8ykN6Z1Z9NWrhztYHc528c7T8EYk1Q@mail.gmail.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <07d1c704-88b9-1e60-4ad4-531a9216d383@suse.de>
Date: Wed, 20 Jun 2018 19:03:04 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5O10eQtY122=Sm8ykN6Z1Z9NWrhztYHc528c7T8EYk1Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sHBln10VWGkPTqHj4ceDHu9PBz5AtZKs8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sHBln10VWGkPTqHj4ceDHu9PBz5AtZKs8
Content-Type: multipart/mixed; boundary="q9VfLAO62IM7aLnjmaIwHfukRHOT6hEYM";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <07d1c704-88b9-1e60-4ad4-531a9216d383@suse.de>
Subject: Re: [PATCH v3] btrfs: Don't remove block group still has pinned down
 bytes
References: <20180615013523.2807-1-wqu@suse.com>
 <CAL3q7H524L_JKupweEGxstHp4kZtVsmT4s7n6qwbZsQVhh39PA@mail.gmail.com>
 <aadc92ff-9455-8d1d-3828-805f2bd8cda2@suse.de>
 <CAL3q7H5O10eQtY122=Sm8ykN6Z1Z9NWrhztYHc528c7T8EYk1Q@mail.gmail.com>
In-Reply-To: <CAL3q7H5O10eQtY122=Sm8ykN6Z1Z9NWrhztYHc528c7T8EYk1Q@mail.gmail.com>

--q9VfLAO62IM7aLnjmaIwHfukRHOT6hEYM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8820=E6=97=A5 17:33, Filipe Manana wrote:
> On Wed, Jun 20, 2018 at 10:22 AM, Qu Wenruo <wqu@suse.de> wrote:
>>
>>
>> On 2018=E5=B9=B406=E6=9C=8820=E6=97=A5 17:13, Filipe Manana wrote:
>>> On Fri, Jun 15, 2018 at 2:35 AM, Qu Wenruo <wqu@suse.com> wrote:
>>>> [BUG]
>>>> Under certain KVM load and LTP tests, we are possible to hit the
>>>> following calltrace if quota is enabled:
>>>> ------
>>>> BTRFS critical (device vda2): unable to find logical 8820195328 leng=
th 4096
>>>> BTRFS critical (device vda2): unable to find logical 8820195328 leng=
th 4096
>>>> ------------[ cut here ]------------
>>>> WARNING: CPU: 0 PID: 49 at ../block/blk-core.c:172 blk_status_to_err=
no+0x1a/0x30
>>>> CPU: 0 PID: 49 Comm: kworker/u2:1 Not tainted 4.12.14-15-default #1 =
SLE15 (unreleased)
>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-pr=
ebuilt.qemu-project.org 04/01/2014
>>>> Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
>>>> task: ffff9f827b340bc0 task.stack: ffffb4f8c0304000
>>>> RIP: 0010:blk_status_to_errno+0x1a/0x30
>>>> Call Trace:
>>>>  submit_extent_page+0x191/0x270 [btrfs]
>>>>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>>>>  __do_readpage+0x2d2/0x810 [btrfs]
>>>>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>>>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>>>  __extent_read_full_page+0xe7/0x100 [btrfs]
>>>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>>>  read_extent_buffer_pages+0x1ab/0x2d0 [btrfs]
>>>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>>>  btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
>>>>  read_tree_block+0x31/0x60 [btrfs]
>>>>  read_block_for_search.isra.35+0xf0/0x2e0 [btrfs]
>>>>  btrfs_search_slot+0x46b/0xa00 [btrfs]
>>>>  ? kmem_cache_alloc+0x1a8/0x510
>>>>  ? btrfs_get_token_32+0x5b/0x120 [btrfs]
>>>>  find_parent_nodes+0x11d/0xeb0 [btrfs]
>>>>  ? leaf_space_used+0xb8/0xd0 [btrfs]
>>>>  ? btrfs_leaf_free_space+0x49/0x90 [btrfs]
>>>>  ? btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>>>>  btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>>>>  btrfs_find_all_roots+0x45/0x60 [btrfs]
>>>>  btrfs_qgroup_trace_extent_post+0x20/0x40 [btrfs]
>>>>  btrfs_add_delayed_data_ref+0x1a3/0x1d0 [btrfs]
>>>>  btrfs_alloc_reserved_file_extent+0x38/0x40 [btrfs]
>>>>  insert_reserved_file_extent.constprop.71+0x289/0x2e0 [btrfs]
>>>>  btrfs_finish_ordered_io+0x2f4/0x7f0 [btrfs]
>>>>  ? pick_next_task_fair+0x2cd/0x530
>>>>  ? __switch_to+0x92/0x4b0
>>>>  btrfs_worker_helper+0x81/0x300 [btrfs]
>>>>  process_one_work+0x1da/0x3f0
>>>>  worker_thread+0x2b/0x3f0
>>>>  ? process_one_work+0x3f0/0x3f0
>>>>  kthread+0x11a/0x130
>>>>  ? kthread_create_on_node+0x40/0x40
>>>>  ret_from_fork+0x35/0x40
>>>> Code: 00 00 5b c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00=
 00 40 80 ff 0c 40 0f b6 c7 77 0b 48 c1 e0 04 8b 80 00 bf c8 bd c3 <0f> 0=
b b8 fb ff ff ff c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
>>>> ---[ end trace f079fb809e7a862b ]---
>>>> BTRFS critical (device vda2): unable to find logical 8820195328 leng=
th 16384
>>>> BTRFS: error (device vda2) in btrfs_finish_ordered_io:3023: errno=3D=
-5 IO failure
>>>> BTRFS info (device vda2): forced readonly
>>>> BTRFS error (device vda2): pending csums is 2887680
>>>> ------
>>>>
>>>> [CAUSE]
>>>> It's caused by race with block group auto removal like the following=

>>>> case:
>>>> - There is a meta block group X, which has only one tree block
>>>>   The tree block belongs to fs tree 257.
>>>> - In current transaction, some operation modified fs tree 257
>>>>   The tree block get CoWed, so the block group X is empty, and marke=
d as
>>>>   unused, queued to be deleted.
>>>> - Some workload (like fsync) wakes up cleaner_kthread()
>>>>   Which will call btrfs_deleted_unused_bgs() to remove unused block
>>>>   groups.
>>>>   So block group X along its chunk map get removed.
>>>> - Some delalloc work finished for fs tree 257
>>>>   Quota needs to get the original reference of the extent, which wil=
l
>>>>   reads tree blocks of commit root of 257.
>>>>   Then since the chunk map get removed, above warning get triggered.=

>>>>
>>>> [FIX]
>>>> Just teach btrfs_delete_unused_bgs() to skip block group who still h=
as
>>>> pinned bytes.
>>>>
>>>> However there is a minor side effect, since currently we only queue
>>>> empty blocks at update_block_group(), and such empty block group wit=
h
>>>> pinned bytes won't go through update_block_group() again, such block=

>>>> group won't be removed, until it get new extent allocated and remove=
d.
>>>
>>> So that can be fixed in a separate patch, to add it back to the list
>>> of block groups to be deleted once everything is unpinned and passes
>>> all other necessary criteria.
>>
>> That's the plan.
>> Although still something more need to be considered.
>>
>>>
>>>>
>>>> But please note that, there are more problems related to extent
>>>> allocator with block group auto removal.
>>>
>>> The above isn't a problem of the allocator itself but rather in the
>>> way we manage COW, commit roots and unpinning.
>>>
>>>>
>>>> Even a block group is marked unused, extent allocator can still allo=
cate
>>>> new extents from unused block group.
>>>
>>> Why is that a problem?
>>> It's ok (with some good benefits), as long as the cleaner thread (or
>>> any thing that attempts to delete block groups in the unused list),
>>> doesn't delete it.
>>
>> It in fact could cause problem under certain case, e.g. btrfs needs to=

>> allocate new data chunks, while all existing metadata are pretty spars=
e
>> with a lot of holes.
>> In that case, an empty block group which can be deleted will help.
>=20
> That doesn't answer my question.
> Let me rephrase it - If we need to allocate an extent and we allocate
> one from an empty block group, why is that a problem?
>=20
>>
>> Although balance should be the ultimate fix, if btrfs can be more
>> aggressive to avoid using empty block groups, it would definitely help=
=2E
>>
>>>
>>>> Thus delaying block group to next transaction won't work.
>>>> (Extents get allocated in current transaction, and removed again in =
next
>>>> transaction).
>>>>
>>>> So the root fix need to co-operate with extent allocator.
>>>
>>> What do you mean by co-operation with the extent allocator? I don't
>>> think the problem is there.
>>
>> The bug itself is not related to extent allocator.
>>
>> It's my later planned fix related to extent allocator.
>> It's about how aggressive we should try to claim empty block group.
>> Current behavior is pretty passive, mostly by luck to delete unused
>> block group.
>> My purposed fix is to claim empty block groups more aggressive.
>> If we find an empty block group (even with pinned bytes), we'll try ou=
r
>> best not to allocate from it, so in next transaction (with its pinned
>> bytes removed) we will definitely claim the space.
>=20
> Still doesn't answer my question. Why avoid allocation from an empty
> block group?

I have already answered your question: to ensure (or try to) this empty
block group will be deleted.

> By skipping it, you may end forcing allocation of a new block group
> which mail fail due to lack of unused space.
> What is your goal?

To make block group removal more aggressive.
For forced block group allocation, we can detect such case and fallback
to the empty block group.

>=20
> It would make sense to me to make it prefer to use non-empty block
> groups first and then only if none is available, to use an empty one.

Exactly.

This in fact introduced priority for block groups.
Empty block groups have the lowest priority.
And we can enhance it furthermore, by prefer near-full block groups
more, so we can reduce the need to do routine balance.

> But this is different from what you are saying, since you seem
> explicit about never using an empty one.

I mean, if we have other block group with enough space, we could ban
allocating from empty block group.
If we're forced to allocate new block group, then fallback to reuse
empty one, and remove it from unused_bgs_list.

Thanks,
Qu



>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>> But current fix should be enough for this particular bug.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> changelog:
>>>> v2:
>>>>   Commit message update, to better indicate how pinned byte is used =
in
>>>>   btrfs and why it's related to quota.
>>>> v3:
>>>>   Commit message update, further explaining the bug with an example.=

>>>>   And added the side effect of the fix, and possible further fix.
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index f190023386a9..7d14c4ca8232 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -10675,7 +10675,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs=
_info *fs_info)
>>>>                 /* Don't want to race with allocators so take the gr=
oups_sem */
>>>>                 down_write(&space_info->groups_sem);
>>>>                 spin_lock(&block_group->lock);
>>>> -               if (block_group->reserved ||
>>>> +               if (block_group->reserved || block_group->pinned ||
>>>>                     btrfs_block_group_used(&block_group->item) ||
>>>>                     block_group->ro ||
>>>>                     list_is_singular(&block_group->list)) {
>>>> --
>>>> 2.17.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>
>=20
>=20
>=20


--q9VfLAO62IM7aLnjmaIwHfukRHOT6hEYM--

--sHBln10VWGkPTqHj4ceDHu9PBz5AtZKs8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsqNGgACgkQwj2R86El
/qjsrQf/Y8QycK0ObODkij4Jo1bDOBhMdGH7kZuPRYp4uPoYs7lZKf5iK4zoVAoU
oRkXSeDaOSXH+n6UV0jf76Z/v6rEQLPA2b+JnGDVKWuqHE2dVE6r88Mq8UCCNAuV
kA2orG7vA/TjgESBN7zlVlrHYYR9BMQFTCm7Vh7BD66T5dKGm3KMtKEgDrNowY02
s3pHwPkxY7hgZ6e2Bf8bc/jWuwGmLLd9KJRLf0Gf378Vr2ugRcpHopOHxrc9VBLQ
Z5Rd+8RECyubc9MYE7YaqTEo8YeirylEZgeA8XIkpF8dYxfsDCM5Myj6+txarPtG
N0AxKngPAsNJrS6t2vrl0SCAD0z3Cg==
=Ssb0
-----END PGP SIGNATURE-----

--sHBln10VWGkPTqHj4ceDHu9PBz5AtZKs8--
