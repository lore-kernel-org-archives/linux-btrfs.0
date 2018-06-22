Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932718AbeFVK4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 06:56:06 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2AE1CAC3B
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2018 10:56:05 +0000 (UTC)
Subject: Re: [PATCH v4] btrfs: Don't remove block group still has pinned down
 bytes
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180622043500.717-1-wqu@suse.com>
 <20180622095208.GX24375@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <67c49402-4031-f502-4ecf-ffc56af23137@suse.de>
Date: Fri, 22 Jun 2018 18:56:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180622095208.GX24375@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3TU75SD3u4QD25qsJ1BI4bOxhcn8MheRX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3TU75SD3u4QD25qsJ1BI4bOxhcn8MheRX
Content-Type: multipart/mixed; boundary="xxiRD9oSZ7lEPHCf7JqASYz2RJ78hMvDj";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <67c49402-4031-f502-4ecf-ffc56af23137@suse.de>
Subject: Re: [PATCH v4] btrfs: Don't remove block group still has pinned down
 bytes
References: <20180622043500.717-1-wqu@suse.com>
 <20180622095208.GX24375@twin.jikos.cz>
In-Reply-To: <20180622095208.GX24375@twin.jikos.cz>

--xxiRD9oSZ7lEPHCf7JqASYz2RJ78hMvDj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8822=E6=97=A5 17:52, David Sterba wrote:
> On Fri, Jun 22, 2018 at 12:35:00PM +0800, Qu Wenruo wrote:
>> [BUG]
>> Under certain KVM load and LTP tests, we are possible to hit the
>> following calltrace if quota is enabled:
>> ------
>> BTRFS critical (device vda2): unable to find logical 8820195328 length=
 4096
>> BTRFS critical (device vda2): unable to find logical 8820195328 length=
 4096
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 49 at ../block/blk-core.c:172 blk_status_to_errno=
+0x1a/0x30
>> CPU: 0 PID: 49 Comm: kworker/u2:1 Not tainted 4.12.14-15-default #1 SL=
E15 (unreleased)
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-preb=
uilt.qemu-project.org 04/01/2014
>> Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
>> task: ffff9f827b340bc0 task.stack: ffffb4f8c0304000
>> RIP: 0010:blk_status_to_errno+0x1a/0x30
>> Call Trace:
>>  submit_extent_page+0x191/0x270 [btrfs]
>>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>>  __do_readpage+0x2d2/0x810 [btrfs]
>>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>  __extent_read_full_page+0xe7/0x100 [btrfs]
>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>  read_extent_buffer_pages+0x1ab/0x2d0 [btrfs]
>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>  btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
>>  read_tree_block+0x31/0x60 [btrfs]
>>  read_block_for_search.isra.35+0xf0/0x2e0 [btrfs]
>>  btrfs_search_slot+0x46b/0xa00 [btrfs]
>>  ? kmem_cache_alloc+0x1a8/0x510
>>  ? btrfs_get_token_32+0x5b/0x120 [btrfs]
>>  find_parent_nodes+0x11d/0xeb0 [btrfs]
>>  ? leaf_space_used+0xb8/0xd0 [btrfs]
>>  ? btrfs_leaf_free_space+0x49/0x90 [btrfs]
>>  ? btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>>  btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>>  btrfs_find_all_roots+0x45/0x60 [btrfs]
>>  btrfs_qgroup_trace_extent_post+0x20/0x40 [btrfs]
>>  btrfs_add_delayed_data_ref+0x1a3/0x1d0 [btrfs]
>>  btrfs_alloc_reserved_file_extent+0x38/0x40 [btrfs]
>>  insert_reserved_file_extent.constprop.71+0x289/0x2e0 [btrfs]
>>  btrfs_finish_ordered_io+0x2f4/0x7f0 [btrfs]
>>  ? pick_next_task_fair+0x2cd/0x530
>>  ? __switch_to+0x92/0x4b0
>>  btrfs_worker_helper+0x81/0x300 [btrfs]
>>  process_one_work+0x1da/0x3f0
>>  worker_thread+0x2b/0x3f0
>>  ? process_one_work+0x3f0/0x3f0
>>  kthread+0x11a/0x130
>>  ? kthread_create_on_node+0x40/0x40
>>  ret_from_fork+0x35/0x40
>> Code: 00 00 5b c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 0=
0 40 80 ff 0c 40 0f b6 c7 77 0b 48 c1 e0 04 8b 80 00 bf c8 bd c3 <0f> 0b =
b8 fb ff ff ff c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
>> ---[ end trace f079fb809e7a862b ]---
>> BTRFS critical (device vda2): unable to find logical 8820195328 length=
 16384
>> BTRFS: error (device vda2) in btrfs_finish_ordered_io:3023: errno=3D-5=
 IO failure
>> BTRFS info (device vda2): forced readonly
>> BTRFS error (device vda2): pending csums is 2887680
>> ------
>>
>> [CAUSE]
>> It's caused by race with block group auto removal like the following
>> case:
>> - There is a meta block group X, which has only one tree block
>>   The tree block belongs to fs tree 257.
>> - In current transaction, some operation modified fs tree 257
>>   The tree block get CoWed, so the block group X is empty, and marked =
as
>>   unused, queued to be deleted.
>> - Some workload (like fsync) wakes up cleaner_kthread()
>>   Which will call btrfs_deleted_unused_bgs() to remove unused block
>>   groups.
>>   So block group X along its chunk map get removed.
>> - Some delalloc work finished for fs tree 257
>>   Quota needs to get the original reference of the extent, which will
>>   reads tree blocks of commit root of 257.
>>   Then since the chunk map get removed, above warning get triggered.
>>
>> [FIX]
>> Just teach btrfs_delete_unused_bgs() to skip block group who still has=

>> pinned bytes.
>>
>> However there is a minor side effect, since currently we only queue
>> empty blocks at update_block_group(), and such empty block group with
>> pinned bytes won't go through update_block_group() again, such block
>> group won't be removed, until it get new extent allocated and removed.=

>=20
> So this cannot lead to free block groups that will not get cleaned for
> some longer period of time, right? After the bytes are unpinned and
> cleaner thread has a chance to run, the bg will not be blocked for
> deletion anymore.

Not exactly.

For this case, it's still possible we missed some empty block to cleanup:=


btrfs_update_block_group()
|- mark one block group as unused

<While that bg still has pinned bytes>

btrfs_delete_unused_bgs()
|- Find that block group has pinned bytes
|- Remove it from unused_bgs list (ignore it)

Now that empty bg with pinned bytes will not be deleted any more.
Even after the pinned bytes are freed. (since it's no longer traced by
unused_bgs list)

In short, empty block group (with or without pinned bytes) will either
1) Get reused (have reserved/used)
   And will not be traced.
2) Ignored (have pinned) <<< This is the new behavior
   Will not be traced just as 1)
3) Removed


Thanks,
Qu
>=20
> The visible effect of that is that the deletion might be slightly
> delayed.
>=20


--xxiRD9oSZ7lEPHCf7JqASYz2RJ78hMvDj--

--3TU75SD3u4QD25qsJ1BI4bOxhcn8MheRX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlss1cEACgkQwj2R86El
/qihSAf7BxubGwgUP3qUNwWvtfrnLb0Wx7G4SMG9X16uODVPeNGYh2XBnkurZRQz
YRIRD/PyyAlIee4YumS2JirbFH1YySmPL3YTabsBdXulQdQknzEHWs0bvbJZvx9U
tuyeP0ZzbYkxL8Lazj5synW8jUSTZlQqLZpAH5kJYOj0cz3EBbupU+lc6NA2Fn2J
BpBYH/DVXtp1cRFuxLPT7u6P37pcghpf8oBze3yotE3gx7VAVML6xJFUaPicDEwg
nzcL2twWY9qal1VzYRUQ+whkyNP4InCWivsOJ0CBi586yPaJZo/3r2OQ366bquyW
yygH4rKFUERHQt3v5E5p8yWSTMwy4g==
=iTEK
-----END PGP SIGNATURE-----

--3TU75SD3u4QD25qsJ1BI4bOxhcn8MheRX--
