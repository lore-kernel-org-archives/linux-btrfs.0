Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52965 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbeHUDWe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 23:22:34 -0400
Subject: Re: [PATCH RFC] btrfs: locking: Add extra check in
 btrfs_init_new_buffer() to avoid deadlock
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180814055121.6077-1-wqu@suse.com>
 <20180820163801.GA24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7c3c350f-e89b-acca-1092-8edab1ea2348@gmx.com>
Date: Tue, 21 Aug 2018 08:04:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180820163801.GA24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i1JasbXqFJdNpjC8jC5YnREYCN8r22SQY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i1JasbXqFJdNpjC8jC5YnREYCN8r22SQY
Content-Type: multipart/mixed; boundary="6RjNM3tjV1Z68O739m4iHVdrZoOumAwfV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7c3c350f-e89b-acca-1092-8edab1ea2348@gmx.com>
Subject: Re: [PATCH RFC] btrfs: locking: Add extra check in
 btrfs_init_new_buffer() to avoid deadlock
References: <20180814055121.6077-1-wqu@suse.com>
 <20180820163801.GA24025@twin.jikos.cz>
In-Reply-To: <20180820163801.GA24025@twin.jikos.cz>

--6RjNM3tjV1Z68O739m4iHVdrZoOumAwfV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/21 =E4=B8=8A=E5=8D=8812:38, David Sterba wrote:
> On Tue, Aug 14, 2018 at 01:51:21PM +0800, Qu Wenruo wrote:
>> [BUG]
>> For certains crafted image, whose csum root leaf has missing backref, =
if
>> we try to trigger write with data csum, it could cause deadlock with t=
he
>> following kernel WARN_ON():
>> ------
>> WARNING: CPU: 1 PID: 41 at fs/btrfs/locking.c:230 btrfs_tree_lock+0x3e=
2/0x400
>> CPU: 1 PID: 41 Comm: kworker/u4:1 Not tainted 4.18.0-rc1+ #8
>> Workqueue: btrfs-endio-write btrfs_endio_write_helper
>> RIP: 0010:btrfs_tree_lock+0x3e2/0x400
>> Call Trace:
>>  btrfs_alloc_tree_block+0x39f/0x770
>>  __btrfs_cow_block+0x285/0x9e0
>>  btrfs_cow_block+0x191/0x2e0
>>  btrfs_search_slot+0x492/0x1160
>>  btrfs_lookup_csum+0xec/0x280
>>  btrfs_csum_file_blocks+0x2be/0xa60
>>  add_pending_csums+0xaf/0xf0
>>  btrfs_finish_ordered_io+0x74b/0xc90
>>  finish_ordered_fn+0x15/0x20
>>  normal_work_helper+0xf6/0x500
>>  btrfs_endio_write_helper+0x12/0x20
>>  process_one_work+0x302/0x770
>>  worker_thread+0x81/0x6d0
>>  kthread+0x180/0x1d0
>>  ret_from_fork+0x35/0x40
>> ---[ end trace 2e85051acb5f6dc1 ]---
>> ------
>>
>> [CAUSE]
>> That crafted image has missing backref for csum tree root leaf.
>> And when we try to allocate new tree block, since there is no
>> EXTENT/METADATA_ITEM for csum tree root, btrfs consider it's free slot=

>> and use it.
>>
>> The extent tree of the image looks like:
>> Normal image                      |       This fuzzed image
>> ----------------------------------+--------------------------------
>> BG 29360128                       | BG 29360128
>>  One empty slot                   |  One empty slot
>> 29364224: backref to UUID tree    | 29364224: backref to UUID tree
>>  Two empty slots                  |  Two empty slots
>> 29376512: backref to CSUM tree    |  One empty slot (bad type) <<<
>> 29380608: backref to D_RELOC tree | 29380608: backref to D_RELOC tree
>> ...                               | ...
>>
>> Since bytenr 29376512 has no METADATA/EXTENT_ITEM, when btrfs try to
>> alloc tree block, it's an valid slot for btrfs.
>>
>> And for finish_ordered_write, when we need to insert csum, we try to C=
oW
>> csum tree root.
>>
>> By *COINCIDENT*, empty slots at bytenr BG_OFFSET, BG_OFFSET + 8K,
>> BG_OFFSET + 12K is already used by tree block COW for other trees,
>> the next empty slot is BG_OFFSET + 16K, which should be the backref fo=
r
>> CSUM tree.
>>
>> But due to the bad type, btrfs can recognize it and still consider it =
as
>> an empty slot, and will try to use it for csum tree CoW.
>>
>> Then in the following call trace, we will try to lock the new tree
>> block, which turns out to be the old csum tree root which is already
>> locked:
>>
>> btrfs_search_slot() called on csum tree root, which is at 29376512
>> |- btrfs_cow_block()
>>    |- btrfs_set_lock_block()
>>    |  |- Now locks tree block 29376512 (old csum tree root)
>>    |- __btrfs_cow_block()
>>       |- btrfs_alloc_tree_block()
>>          |- btrfs_reserve_extent()
>>             | Now it returns tree block 29376512, which extent tree
>>             | shows its empty slot, but it's already hold by csum tree=

>>             |- btrfs_init_new_buffer()
>>                |- btrfs_tree_lock()
>>                   | Triggers WARN_ON(eb->lock_owner =3D=3D current->pi=
d)
>>                   |- wait_event()
>>                      Wait lock owner to release the lock, but it's
>>                      locked by ourself, so it will deadlock
>>
>> [FIX]
>> This patch will do the lock_owner and current->pid check at
>> btrfs_init_new_buffer().
>> So above deadlock can be avoided.
>>
>> Since such problem can only happen in crafted image, we will still
>> trigger kernel warning, but with a little more meaningful warning
>> message.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D200405
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>>   Modify btrfs_tree_lock() to be able to return int to detect possible=

>>   deadlock and return.
>>   Titled as "btrfs: locking: Allow btrfs_tree_lock() to return error t=
o avoid deadlock"
>> v3:
>>   Instead of modify all btrfs_tree_lock() callers, only check possible=

>>   deadlock at btrfs_init_new_buffer(), as the bug only happens for new=
ly
>>   allocated tree block.
>>   With better commit message describing the on-disk extent tree
>>   corruption along with the call trace of how dead lock happens.
>>
>> Hi David,
>>
>> This v3 should explain the bug with more details and bring a minimal
>> impact to existing function callers.
>=20
> This is much better, thanks. I've checked the direct callers and a bit
> up the call chaing, all seem to be ready for errors.
>=20
>> Qu
>> ---
>>  fs/btrfs/extent-tree.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index e7559b89eaf7..c85ff8b7a95b 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8302,6 +8302,19 @@ btrfs_init_new_buffer(struct btrfs_trans_handle=
 *trans, struct btrfs_root *root,
>>  	if (IS_ERR(buf))
>>  		return buf;
>> =20
>> +	/*
>> +	 * Just extra safe net in case extent tree is corrupted and extent
>> +	 * allocator chooses to use a tree block which is already used and
>> +	 * locked.
>> +	 */
>> +	if (buf->lock_owner =3D=3D current->pid) {
>> +		WARN(1,
>=20
> A btrfs_warn or btrfs_err would be better, to identify the corrupted
> filesystem. Printing the stack trace might make sense in case we want t=
o
> know where exactly it failed as there are several paths that lead to
> btrfs_init_new_buffer.
>=20
> As every WARN, it needs to be considered because there are systems set
> up to panic on warn and warnings are frequently confused as hard errors=
=2E

Oh right, abusing WARN() would cause problem on such systems, especially
when such problem can be handled more or less gracefully.

>=20
> In this case I think it's worth to print the bytenr and root objectid
> and that the stacktrace is not that important.

Will add them of course.

Thanks,
Qu

>=20
>> +"tree block %llu already locked by pid=3D%d, extent tree corruption d=
etected",
>> +		     buf->start, current->pid);
>> +		free_extent_buffer(buf);
>> +		return ERR_PTR(-EUCLEAN);
>> +	}
>> +
>>  	btrfs_set_header_generation(buf, trans->transid);
>>  	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);=

>>  	btrfs_tree_lock(buf);
>> --=20
>> 2.18.0


--6RjNM3tjV1Z68O739m4iHVdrZoOumAwfV--

--i1JasbXqFJdNpjC8jC5YnREYCN8r22SQY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt7VxIACgkQwj2R86El
/qi5twgAkVzcj6hEwsQQ6JoHk39viXD1h/lGqWmZTOg0W0WqiDZTSw7wg4wH5Yo8
6PRgmVPotx51AQyjicihL29V6vYAbg5Plk1aFusBfmjfPedLoVMjJvw+9X6n4g/6
HsHxh/PNmy46K27DstKhjtbJaJXC4npz/hCDXpjBkIsBTOAoWpLxRlTpuFxioAD2
3xdc8LUNO2E8C+9oAa0amwnSkhyMcUE5/BljicYD4LEmOHNvEjrPEwsv+YA1Cn2/
xNqNJ1ZlJQoxvvl3WhwleYIrQ0kc95hgL4SkJkGRjZ6LrnS3PEIit0Uadv/WUnJd
52iyeI8SRvkEn5pOmnhU7qYSeY2nCA==
=auv6
-----END PGP SIGNATURE-----

--i1JasbXqFJdNpjC8jC5YnREYCN8r22SQY--
