Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389217AbeHAPbP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:31:15 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EEAD5ADA1
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 13:45:20 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: locking: Allow btrfs_tree_lock() to return
 error to avoid deadlock
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180730061723.13290-2-wqu@suse.com>
 <20180731065223.12669-1-wqu@suse.com> <20180801132741.GG3218@twin.jikos.cz>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <6ab5a290-da83-7147-9341-1cd4ea011011@suse.de>
Date: Wed, 1 Aug 2018 21:45:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180801132741.GG3218@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gdoBendrn0Cl05nF18NZ49apQgECOkztg"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gdoBendrn0Cl05nF18NZ49apQgECOkztg
Content-Type: multipart/mixed; boundary="CWzWo4zrBJ8jZTVbUM9WgzN3WlfCi5Uz1";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <6ab5a290-da83-7147-9341-1cd4ea011011@suse.de>
Subject: Re: [PATCH v2] btrfs: locking: Allow btrfs_tree_lock() to return
 error to avoid deadlock
References: <20180730061723.13290-2-wqu@suse.com>
 <20180731065223.12669-1-wqu@suse.com> <20180801132741.GG3218@twin.jikos.cz>
In-Reply-To: <20180801132741.GG3218@twin.jikos.cz>

--CWzWo4zrBJ8jZTVbUM9WgzN3WlfCi5Uz1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8801=E6=97=A5 21:27, David Sterba wrote:
> On Tue, Jul 31, 2018 at 02:52:23PM +0800, Qu Wenruo wrote:
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
>=20
> I don't understand what exactly is the problem, can you please rephrase=

> that? Ie. what exactly is missing from where. If the problem is on the
> higher level, regarding the csum tree, this could be checked much
> earlier. I don't really like to see each and every callsite of tree
> locks to require the error handling, so I'm exploring the possibilities=

> if this is necessary at all.

This is a little complex.

I'll try to explain this using some asciiart:

Normal image                      |       This fuzzed image
----------------------------------+--------------------------------
BG 29360128                       | BG 29360128
 One empty slot                   |  One empty slot
29364224: backref to UUID tree    | 29364224: backref to UUID tree
 Two empty slots                  |  Two empty slots
29376512: backref to CSUM tree    |  One empty slot (bad type)
29380608: backref to D_RELOC tree | 29380608: backref to D_RELOC tree
=2E..                               | ...

Since bytenr 29376512 has no METADATA/EXTENT_ITEM, when btrfs try to
alloc tree block, it's an valid slot for btrfs.

And for finish_ordered_write, when we need to insert csum, we try to CoW
csum tree root.

Then extent allocator gives a new extent bytenr 29376512 length 4096.
However bytenr 29376512 is our current csum root, and already locked
during CoW.

So in btrfs_alloc_tree_block() which calls btrfs_tree_lock() to lock the
newly allocated tree block, we are trying to lock the tree block we have
already locked, thus triggering the WARN_ON() and deadlock.


In this particular fuzzed image, we can do key type check to detect
early corruption, but it has the following problem:

1) Won't really solve the problem
   I could easily craft a image with backref for csum tree missing, and
   everything else is OK. It will still cause the problem.

2) May break later RO_compat features
   If later RO_compat feature introduces new key type in extent tree, in
   theory it should be able to be mounted RO, but will be rejected by
   the type check.

So we have to go the way used in the patch.

Another solution would be do backref check each time we try to read out
a tree block, but that's too costly and may screw up locking.

Thanks,
Qu

>=20
>> However we have already locked csum tree root leaf by ourselves, thus =
we
>> will ourselves to release read/write lock, and causing deadlock.
>>
>> [FIX]
>> This patch will allow btrfs_tree_lock() to return error number, so
>> most callers can exit gracefully.
>> (Some caller doesn't really expect btrfs_tree_lock() to return error,
>> and in that case, we use BUG_ON())
>>
>> Since such problem can only happen in crafted image, we will still
>> trigger kernel warning, but with a little more meaningful warning
>> message.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D200405
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>> changelog:
>> v2:
>>   Fix pid_t output format from %llu to %d. Pointed by Su.
>>   Fix missing return 0 for btrfs_lock_tree().
>>   Update reviewed-by tags.
>> ---
>>  fs/btrfs/ctree.c           | 57 +++++++++++++++++++++++++++++++------=
-
>>  fs/btrfs/extent-tree.c     | 28 +++++++++++++++----
>>  fs/btrfs/extent_io.c       |  8 ++++--
>>  fs/btrfs/free-space-tree.c |  4 ++-
>>  fs/btrfs/locking.c         | 13 +++++++--
>>  fs/btrfs/locking.h         |  2 +-
>>  fs/btrfs/qgroup.c          |  4 ++-
>>  fs/btrfs/relocation.c      | 13 +++++++--
>>  fs/btrfs/tree-log.c        | 14 ++++++++--
>>  9 files changed, 115 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 4bc326df472e..6e695f4cd931 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -161,10 +161,12 @@ struct extent_buffer *btrfs_root_node(struct btr=
fs_root *root)
>>  struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root)
>>  {
>>  	struct extent_buffer *eb;
>> +	int ret;
>> =20
>>  	while (1) {
>>  		eb =3D btrfs_root_node(root);
>> -		btrfs_tree_lock(eb);
>> +		ret =3D btrfs_tree_lock(eb);
>> +		BUG_ON(ret < 0);
>>  		if (eb =3D=3D root->node)
>>  			break;
>>  		btrfs_tree_unlock(eb);
>> @@ -1584,6 +1586,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle=
 *trans,
>>  	for (i =3D start_slot; i <=3D end_slot; i++) {
>>  		struct btrfs_key first_key;
>>  		int close =3D 1;
>> +		int ret;
>> =20
>>  		btrfs_node_key(parent, &disk_key, i);
>>  		if (!progress_passed && comp_keys(&disk_key, progress) < 0)
>> @@ -1637,7 +1640,11 @@ int btrfs_realloc_node(struct btrfs_trans_handl=
e *trans,
>>  		if (search_start =3D=3D 0)
>>  			search_start =3D last_block;
>> =20
>> -		btrfs_tree_lock(cur);
>> +		ret =3D btrfs_tree_lock(cur);
>> +		if (ret < 0) {
>> +			free_extent_buffer(cur);
>> +			return ret;
>> +		}
>>  		btrfs_set_lock_blocking(cur);
>>  		err =3D __btrfs_cow_block(trans, root, cur, parent, i,
>>  					&cur, search_start,
>> @@ -1853,7 +1860,11 @@ static noinline int balance_level(struct btrfs_=
trans_handle *trans,
>>  			goto enospc;
>>  		}
>> =20
>> -		btrfs_tree_lock(child);
>> +		ret =3D btrfs_tree_lock(child);
>> +		if (ret < 0) {
>> +			free_extent_buffer(child);
>> +			goto enospc;
>> +		}
>>  		btrfs_set_lock_blocking(child);
>>  		ret =3D btrfs_cow_block(trans, root, child, mid, 0, &child);
>>  		if (ret) {
>> @@ -1891,7 +1902,12 @@ static noinline int balance_level(struct btrfs_=
trans_handle *trans,
>>  		left =3D NULL;
>> =20
>>  	if (left) {
>> -		btrfs_tree_lock(left);
>> +		ret =3D btrfs_tree_lock(left);
>> +		if (ret < 0) {
>> +			free_extent_buffer(left);
>> +			left =3D NULL;
>> +			goto enospc;
>> +		}
>>  		btrfs_set_lock_blocking(left);
>>  		wret =3D btrfs_cow_block(trans, root, left,
>>  				       parent, pslot - 1, &left);
>> @@ -1906,7 +1922,12 @@ static noinline int balance_level(struct btrfs_=
trans_handle *trans,
>>  		right =3D NULL;
>> =20
>>  	if (right) {
>> -		btrfs_tree_lock(right);
>> +		ret =3D btrfs_tree_lock(right);
>> +		if (ret < 0) {
>> +			free_extent_buffer(right);
>> +			right =3D NULL;
>> +			goto enospc;
>> +		}
>>  		btrfs_set_lock_blocking(right);
>>  		wret =3D btrfs_cow_block(trans, root, right,
>>  				       parent, pslot + 1, &right);
>> @@ -2069,7 +2090,11 @@ static noinline int push_nodes_for_insert(struc=
t btrfs_trans_handle *trans,
>>  	if (left) {
>>  		u32 left_nr;
>> =20
>> -		btrfs_tree_lock(left);
>> +		ret =3D btrfs_tree_lock(left);
>> +		if (ret < 0) {
>> +			free_extent_buffer(left);
>> +			return ret;
>> +		}
>>  		btrfs_set_lock_blocking(left);
>> =20
>>  		left_nr =3D btrfs_header_nritems(left);
>> @@ -2124,7 +2149,11 @@ static noinline int push_nodes_for_insert(struc=
t btrfs_trans_handle *trans,
>>  	if (right) {
>>  		u32 right_nr;
>> =20
>> -		btrfs_tree_lock(right);
>> +		ret =3D btrfs_tree_lock(right);
>> +		if (ret < 0) {
>> +			free_extent_buffer(right);
>> +			return ret;
>> +		}
>>  		btrfs_set_lock_blocking(right);
>> =20
>>  		right_nr =3D btrfs_header_nritems(right);
>> @@ -2874,7 +2903,9 @@ int btrfs_search_slot(struct btrfs_trans_handle =
*trans, struct btrfs_root *root,
>>  					err =3D btrfs_try_tree_write_lock(b);
>>  					if (!err) {
>>  						btrfs_set_path_blocking(p);
>> -						btrfs_tree_lock(b);
>> +						ret =3D btrfs_tree_lock(b);
>> +						if (ret < 0)
>> +							goto done;
>>  						btrfs_clear_path_blocking(p, b,
>>  								  BTRFS_WRITE_LOCK);
>>  					}
>> @@ -3773,7 +3804,9 @@ static int push_leaf_right(struct btrfs_trans_ha=
ndle *trans, struct btrfs_root
>>  	if (IS_ERR(right))
>>  		return 1;
>> =20
>> -	btrfs_tree_lock(right);
>> +	ret =3D btrfs_tree_lock(right);
>> +	if (ret < 0)
>> +		goto out_free;
>>  	btrfs_set_lock_blocking(right);
>> =20
>>  	free_space =3D btrfs_leaf_free_space(fs_info, right);
>> @@ -3811,6 +3844,7 @@ static int push_leaf_right(struct btrfs_trans_ha=
ndle *trans, struct btrfs_root
>>  				right, free_space, left_nritems, min_slot);
>>  out_unlock:
>>  	btrfs_tree_unlock(right);
>> +out_free:
>>  	free_extent_buffer(right);
>>  	return 1;
>>  }
>> @@ -4007,7 +4041,9 @@ static int push_leaf_left(struct btrfs_trans_han=
dle *trans, struct btrfs_root
>>  	if (IS_ERR(left))
>>  		return 1;
>> =20
>> -	btrfs_tree_lock(left);
>> +	ret =3D btrfs_tree_lock(left);
>> +	if (ret < 0)
>> +		goto out_free;
>>  	btrfs_set_lock_blocking(left);
>> =20
>>  	free_space =3D btrfs_leaf_free_space(fs_info, left);
>> @@ -4037,6 +4073,7 @@ static int push_leaf_left(struct btrfs_trans_han=
dle *trans, struct btrfs_root
>>  			       max_slot);
>>  out:
>>  	btrfs_tree_unlock(left);
>> +out_free:
>>  	free_extent_buffer(left);
>>  	return ret;
>>  }
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 3578fa5b30ef..da615ebc072e 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8297,14 +8297,19 @@ btrfs_init_new_buffer(struct btrfs_trans_handl=
e *trans, struct btrfs_root *root,
>>  {
>>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>>  	struct extent_buffer *buf;
>> +	int ret;
>> =20
>>  	buf =3D btrfs_find_create_tree_block(fs_info, bytenr);
>>  	if (IS_ERR(buf))
>>  		return buf;
>> +	ret =3D btrfs_tree_lock(buf);
>> +	if (ret < 0) {
>> +		free_extent_buffer(buf);
>> +		return ERR_PTR(ret);
>> +	}
>> =20
>>  	btrfs_set_header_generation(buf, trans->transid);
>>  	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);=

>> -	btrfs_tree_lock(buf);
>>  	clean_tree_block(fs_info, buf);
>>  	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
>> =20
>> @@ -8721,7 +8726,9 @@ static noinline int do_walk_down(struct btrfs_tr=
ans_handle *trans,
>>  					       level - 1);
>>  		reada =3D 1;
>>  	}
>> -	btrfs_tree_lock(next);
>> +	ret =3D btrfs_tree_lock(next);
>> +	if (ret < 0)
>> +		goto out_free;
>>  	btrfs_set_lock_blocking(next);
>> =20
>>  	ret =3D btrfs_lookup_extent_info(trans, fs_info, bytenr, level - 1, =
1,
>> @@ -8781,7 +8788,9 @@ static noinline int do_walk_down(struct btrfs_tr=
ans_handle *trans,
>>  			free_extent_buffer(next);
>>  			return -EIO;
>>  		}
>> -		btrfs_tree_lock(next);
>> +		ret =3D btrfs_tree_lock(next);
>> +		if (ret < 0)
>> +			goto out_free;
>>  		btrfs_set_lock_blocking(next);
>>  	}
>> =20
>> @@ -8839,6 +8848,7 @@ static noinline int do_walk_down(struct btrfs_tr=
ans_handle *trans,
>> =20
>>  out_unlock:
>>  	btrfs_tree_unlock(next);
>> +out_free:
>>  	free_extent_buffer(next);
>> =20
>>  	return ret;
>> @@ -8887,7 +8897,8 @@ static noinline int walk_up_proc(struct btrfs_tr=
ans_handle *trans,
>>  		 */
>>  		if (!path->locks[level]) {
>>  			BUG_ON(level =3D=3D 0);
>> -			btrfs_tree_lock(eb);
>> +			ret =3D btrfs_tree_lock(eb);
>> +			BUG_ON(ret < 0);
>>  			btrfs_set_lock_blocking(eb);
>>  			path->locks[level] =3D BTRFS_WRITE_LOCK_BLOCKING;
>> =20
>> @@ -8929,7 +8940,8 @@ static noinline int walk_up_proc(struct btrfs_tr=
ans_handle *trans,
>>  		/* make block locked assertion in clean_tree_block happy */
>>  		if (!path->locks[level] &&
>>  		    btrfs_header_generation(eb) =3D=3D trans->transid) {
>> -			btrfs_tree_lock(eb);
>> +			ret =3D btrfs_tree_lock(eb);
>> +			BUG_ON(ret < 0);
>>  			btrfs_set_lock_blocking(eb);
>>  			path->locks[level] =3D BTRFS_WRITE_LOCK_BLOCKING;
>>  		}
>> @@ -9107,7 +9119,11 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>> =20
>>  		level =3D btrfs_header_level(root->node);
>>  		while (1) {
>> -			btrfs_tree_lock(path->nodes[level]);
>> +			ret =3D btrfs_tree_lock(path->nodes[level]);
>> +			if (ret < 0) {
>> +				err =3D ret;
>> +				goto out_end_trans;
>> +			}
>>  			btrfs_set_lock_blocking(path->nodes[level]);
>>  			path->locks[level] =3D BTRFS_WRITE_LOCK_BLOCKING;
>> =20
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index cce6087d6880..3ba02aac6dd5 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3545,7 +3545,9 @@ lock_extent_buffer_for_io(struct extent_buffer *=
eb,
>>  	if (!btrfs_try_tree_write_lock(eb)) {
>>  		flush =3D 1;
>>  		flush_write_bio(epd);
>> -		btrfs_tree_lock(eb);
>> +		ret =3D btrfs_tree_lock(eb);
>> +		if (ret < 0)
>> +			return ret;
>>  	}
>> =20
>>  	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags)) {
>> @@ -3558,7 +3560,9 @@ lock_extent_buffer_for_io(struct extent_buffer *=
eb,
>>  		}
>>  		while (1) {
>>  			wait_on_extent_buffer_writeback(eb);
>> -			btrfs_tree_lock(eb);
>> +			ret =3D btrfs_tree_lock(eb);
>> +			if (ret < 0)
>> +				return ret;
>>  			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags))
>>  				break;
>>  			btrfs_tree_unlock(eb);
>> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
>> index b5950aacd697..948bbc45638a 100644
>> --- a/fs/btrfs/free-space-tree.c
>> +++ b/fs/btrfs/free-space-tree.c
>> @@ -1242,7 +1242,9 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_=
info *fs_info)
>> =20
>>  	list_del(&free_space_root->dirty_list);
>> =20
>> -	btrfs_tree_lock(free_space_root->node);
>> +	ret =3D btrfs_tree_lock(free_space_root->node);
>> +	if (ret < 0)
>> +		goto abort;
>>  	clean_tree_block(fs_info, free_space_root->node);
>>  	btrfs_tree_unlock(free_space_root->node);
>>  	btrfs_free_tree_block(trans, free_space_root, free_space_root->node,=

>> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
>> index 1da768e5ef75..ca151be026bf 100644
>> --- a/fs/btrfs/locking.c
>> +++ b/fs/btrfs/locking.c
>> @@ -224,10 +224,18 @@ void btrfs_tree_read_unlock_blocking(struct exte=
nt_buffer *eb)
>>  /*
>>   * take a spinning write lock.  This will wait for both
>>   * blocking readers or writers
>> + *
>> + * Return 0 if we successfully locked the tree block
>> + * Return <0 if some selftest failed (mostly due to extent tree corru=
ption)
>>   */
>> -void btrfs_tree_lock(struct extent_buffer *eb)
>> +int btrfs_tree_lock(struct extent_buffer *eb)
>>  {
>> -	WARN_ON(eb->lock_owner =3D=3D current->pid);
>> +	if (unlikely(eb->lock_owner =3D=3D current->pid)) {
>> +		WARN(1,
>> +"tree block %llu already locked by current (pid=3D%d), refuse to lock=
",
>> +		     eb->start, current->pid);
>> +		return -EUCLEAN;
>> +	}
>>  again:
>>  	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) =3D=3D=
 0);
>>  	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) =3D=
=3D 0);
>> @@ -248,6 +256,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
>>  	atomic_inc(&eb->spinning_writers);
>>  	atomic_inc(&eb->write_locks);
>>  	eb->lock_owner =3D current->pid;
>> +	return 0;
>>  }
>> =20
>>  /*
>> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
>> index 29135def468e..7394d7ba2ff9 100644
>> --- a/fs/btrfs/locking.h
>> +++ b/fs/btrfs/locking.h
>> @@ -11,7 +11,7 @@
>>  #define BTRFS_WRITE_LOCK_BLOCKING 3
>>  #define BTRFS_READ_LOCK_BLOCKING 4
>> =20
>> -void btrfs_tree_lock(struct extent_buffer *eb);
>> +int btrfs_tree_lock(struct extent_buffer *eb);
>>  void btrfs_tree_unlock(struct extent_buffer *eb);
>> =20
>>  void btrfs_tree_read_lock(struct extent_buffer *eb);
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 1874a6d2e6f5..ec4351fd7537 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1040,7 +1040,9 @@ int btrfs_quota_disable(struct btrfs_trans_handl=
e *trans,
>> =20
>>  	list_del(&quota_root->dirty_list);
>> =20
>> -	btrfs_tree_lock(quota_root->node);
>> +	ret =3D btrfs_tree_lock(quota_root->node);
>> +	if (ret < 0)
>> +		goto out;
>>  	clean_tree_block(fs_info, quota_root->node);
>>  	btrfs_tree_unlock(quota_root->node);
>>  	btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index be94c65bb4d2..a2fc0bd83a40 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -1877,7 +1877,11 @@ int replace_path(struct btrfs_trans_handle *tra=
ns,
>>  				free_extent_buffer(eb);
>>  				break;
>>  			}
>> -			btrfs_tree_lock(eb);
>> +			ret =3D btrfs_tree_lock(eb);
>> +			if (ret < 0) {
>> +				free_extent_buffer(eb);
>> +				break;
>> +			}
>>  			if (cow) {
>>  				ret =3D btrfs_cow_block(trans, dest, eb, parent,
>>  						      slot, &eb);
>> @@ -2788,7 +2792,12 @@ static int do_relocation(struct btrfs_trans_han=
dle *trans,
>>  			err =3D -EIO;
>>  			goto next;
>>  		}
>> -		btrfs_tree_lock(eb);
>> +		ret =3D btrfs_tree_lock(eb);
>> +		if (ret < 0) {
>> +			free_extent_buffer(eb);
>> +			err =3D ret;
>> +			goto next;
>> +		}
>>  		btrfs_set_lock_blocking(eb);
>> =20
>>  		if (!node->eb) {
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index f8220ec02036..173bc15a7cd1 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -2588,7 +2588,11 @@ static noinline int walk_down_log_tree(struct b=
trfs_trans_handle *trans,
>>  				}
>> =20
>>  				if (trans) {
>> -					btrfs_tree_lock(next);
>> +					ret =3D btrfs_tree_lock(next);
>> +					if (ret < 0) {
>> +						free_extent_buffer(next);
>> +						return ret;
>> +					}
>>  					btrfs_set_lock_blocking(next);
>>  					clean_tree_block(fs_info, next);
>>  					btrfs_wait_tree_block_writeback(next);
>> @@ -2672,7 +2676,9 @@ static noinline int walk_up_log_tree(struct btrf=
s_trans_handle *trans,
>>  				next =3D path->nodes[*level];
>> =20
>>  				if (trans) {
>> -					btrfs_tree_lock(next);
>> +					ret =3D btrfs_tree_lock(next);
>> +					if (ret < 0)
>> +						return ret;
>>  					btrfs_set_lock_blocking(next);
>>  					clean_tree_block(fs_info, next);
>>  					btrfs_wait_tree_block_writeback(next);
>> @@ -2754,7 +2760,9 @@ static int walk_log_tree(struct btrfs_trans_hand=
le *trans,
>>  			next =3D path->nodes[orig_level];
>> =20
>>  			if (trans) {
>> -				btrfs_tree_lock(next);
>> +				ret =3D btrfs_tree_lock(next);
>> +				if (ret < 0)
>> +					goto out;
>>  				btrfs_set_lock_blocking(next);
>>  				clean_tree_block(fs_info, next);
>>  				btrfs_wait_tree_block_writeback(next);
>> --=20
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--CWzWo4zrBJ8jZTVbUM9WgzN3WlfCi5Uz1--

--gdoBendrn0Cl05nF18NZ49apQgECOkztg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlthuWYACgkQwj2R86El
/qhhrQf+Ndi5CjkJsmwzKdQWyvyrAitZh/+eQKoSL80kA1NQ3W5Bz1rUrTtkxDiu
Vcr3ngvyijU7uqoyYOxTBHvxzLkvUjrtRDFiSDfrfD31LHAEZ4Qc3gskAepOwlXJ
x32rljGnBjj9u7dPI4tEMkne3cPrBnmx97ppsVUSWYI+GFCnJksaKylrh/r/K/g9
wmY3N6JpD9clCeFzdBL/FP4bDQeJ9cuwLYliPYuae/mOIeknN8Ww5idxoWIMqZ8I
htaB7KvIAnceC3CAAIpAIUonPCy70P0OzOBdKOpSWAZqMAkaEkPGBFTmLTh+aeBY
xb3us3EbAYVgIFZtpgj9YYD0xnkZfw==
=6zNe
-----END PGP SIGNATURE-----

--gdoBendrn0Cl05nF18NZ49apQgECOkztg--
