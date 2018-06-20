Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50735 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750821AbeFTFOE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 01:14:04 -0400
Subject: Re: [PATCH v3] btrfs: Don't remove block group still has pinned down
 bytes
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180615013523.2807-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5a2d761e-4d03-f92e-704b-7e86b149a4aa@gmx.com>
Date: Wed, 20 Jun 2018 13:13:49 +0800
MIME-Version: 1.0
In-Reply-To: <20180615013523.2807-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bfnHXl8z4C2StvvdkIp65BE1G5TFH2nA2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bfnHXl8z4C2StvvdkIp65BE1G5TFH2nA2
Content-Type: multipart/mixed; boundary="32H6h3pWx1JGjj4xpq5rI85D1mPyFp2yL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5a2d761e-4d03-f92e-704b-7e86b149a4aa@gmx.com>
Subject: Re: [PATCH v3] btrfs: Don't remove block group still has pinned down
 bytes
References: <20180615013523.2807-1-wqu@suse.com>
In-Reply-To: <20180615013523.2807-1-wqu@suse.com>

--32H6h3pWx1JGjj4xpq5rI85D1mPyFp2yL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping.

Since it's causing LTP tests failure, I'd like to backport it asap.

Thanks,
Qu

On 2018=E5=B9=B406=E6=9C=8815=E6=97=A5 09:35, Qu Wenruo wrote:
> [BUG]
> Under certain KVM load and LTP tests, we are possible to hit the
> following calltrace if quota is enabled:
> ------
> BTRFS critical (device vda2): unable to find logical 8820195328 length =
4096
> BTRFS critical (device vda2): unable to find logical 8820195328 length =
4096
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 49 at ../block/blk-core.c:172 blk_status_to_errno+=
0x1a/0x30
> CPU: 0 PID: 49 Comm: kworker/u2:1 Not tainted 4.12.14-15-default #1 SLE=
15 (unreleased)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebu=
ilt.qemu-project.org 04/01/2014
> Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> task: ffff9f827b340bc0 task.stack: ffffb4f8c0304000
> RIP: 0010:blk_status_to_errno+0x1a/0x30
> Call Trace:
>  submit_extent_page+0x191/0x270 [btrfs]
>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>  __do_readpage+0x2d2/0x810 [btrfs]
>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>  __extent_read_full_page+0xe7/0x100 [btrfs]
>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>  read_extent_buffer_pages+0x1ab/0x2d0 [btrfs]
>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>  btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
>  read_tree_block+0x31/0x60 [btrfs]
>  read_block_for_search.isra.35+0xf0/0x2e0 [btrfs]
>  btrfs_search_slot+0x46b/0xa00 [btrfs]
>  ? kmem_cache_alloc+0x1a8/0x510
>  ? btrfs_get_token_32+0x5b/0x120 [btrfs]
>  find_parent_nodes+0x11d/0xeb0 [btrfs]
>  ? leaf_space_used+0xb8/0xd0 [btrfs]
>  ? btrfs_leaf_free_space+0x49/0x90 [btrfs]
>  ? btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>  btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>  btrfs_find_all_roots+0x45/0x60 [btrfs]
>  btrfs_qgroup_trace_extent_post+0x20/0x40 [btrfs]
>  btrfs_add_delayed_data_ref+0x1a3/0x1d0 [btrfs]
>  btrfs_alloc_reserved_file_extent+0x38/0x40 [btrfs]
>  insert_reserved_file_extent.constprop.71+0x289/0x2e0 [btrfs]
>  btrfs_finish_ordered_io+0x2f4/0x7f0 [btrfs]
>  ? pick_next_task_fair+0x2cd/0x530
>  ? __switch_to+0x92/0x4b0
>  btrfs_worker_helper+0x81/0x300 [btrfs]
>  process_one_work+0x1da/0x3f0
>  worker_thread+0x2b/0x3f0
>  ? process_one_work+0x3f0/0x3f0
>  kthread+0x11a/0x130
>  ? kthread_create_on_node+0x40/0x40
>  ret_from_fork+0x35/0x40
> Code: 00 00 5b c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00=
 40 80 ff 0c 40 0f b6 c7 77 0b 48 c1 e0 04 8b 80 00 bf c8 bd c3 <0f> 0b b=
8 fb ff ff ff c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
> ---[ end trace f079fb809e7a862b ]---
> BTRFS critical (device vda2): unable to find logical 8820195328 length =
16384
> BTRFS: error (device vda2) in btrfs_finish_ordered_io:3023: errno=3D-5 =
IO failure
> BTRFS info (device vda2): forced readonly
> BTRFS error (device vda2): pending csums is 2887680
> ------
>=20
> [CAUSE]
> It's caused by race with block group auto removal like the following
> case:
> - There is a meta block group X, which has only one tree block
>   The tree block belongs to fs tree 257.
> - In current transaction, some operation modified fs tree 257
>   The tree block get CoWed, so the block group X is empty, and marked a=
s
>   unused, queued to be deleted.
> - Some workload (like fsync) wakes up cleaner_kthread()
>   Which will call btrfs_deleted_unused_bgs() to remove unused block
>   groups.
>   So block group X along its chunk map get removed.
> - Some delalloc work finished for fs tree 257
>   Quota needs to get the original reference of the extent, which will
>   reads tree blocks of commit root of 257.
>   Then since the chunk map get removed, above warning get triggered.
>=20
> [FIX]
> Just teach btrfs_delete_unused_bgs() to skip block group who still has
> pinned bytes.
>=20
> However there is a minor side effect, since currently we only queue
> empty blocks at update_block_group(), and such empty block group with
> pinned bytes won't go through update_block_group() again, such block
> group won't be removed, until it get new extent allocated and removed.
>=20
> But please note that, there are more problems related to extent
> allocator with block group auto removal.
>=20
> Even a block group is marked unused, extent allocator can still allocat=
e
> new extents from unused block group.
> Thus delaying block group to next transaction won't work.
> (Extents get allocated in current transaction, and removed again in nex=
t
> transaction).
>=20
> So the root fix need to co-operate with extent allocator.
> But current fix should be enough for this particular bug.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Commit message update, to better indicate how pinned byte is used in
>   btrfs and why it's related to quota.
> v3:
>   Commit message update, further explaining the bug with an example.
>   And added the side effect of the fix, and possible further fix.
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f190023386a9..7d14c4ca8232 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10675,7 +10675,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_in=
fo *fs_info)
>  		/* Don't want to race with allocators so take the groups_sem */
>  		down_write(&space_info->groups_sem);
>  		spin_lock(&block_group->lock);
> -		if (block_group->reserved ||
> +		if (block_group->reserved || block_group->pinned ||
>  		    btrfs_block_group_used(&block_group->item) ||
>  		    block_group->ro ||
>  		    list_is_singular(&block_group->list)) {
>=20


--32H6h3pWx1JGjj4xpq5rI85D1mPyFp2yL--

--bfnHXl8z4C2StvvdkIp65BE1G5TFH2nA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsp4o0ACgkQwj2R86El
/qgi3gf/ft/5+9lNgchVfKKltuMR36vUft6QjJLLsIt49KFzthN86hiowmIxChvw
cPeTHqLXsQaxaoXdWDuHgwaY5ZkC4QmgV6Qx5rBjTq0G+MZvFUfPaHobN8F36YWm
5CSB5h2sVzupsgyLbgWkMKUKOmAWLnzz6XKR/hR8B0h28qVZWIgP8J5aaBGXoGD6
j22M+LLZjEiuXSWQAcNz0RcnDWFULhF+CbCYfktGN5keNJqxUb6qEY//pFsDiENa
PYEwOLi4/0MMDkW4GG+eK1HQOK5xBy9+2gqETipFuDIwC+t1HxSHwai+GsWS7VLA
iHtrFtvQ8eG8HMV56e8R/cCjtZjtjg==
=BTIP
-----END PGP SIGNATURE-----

--bfnHXl8z4C2StvvdkIp65BE1G5TFH2nA2--
