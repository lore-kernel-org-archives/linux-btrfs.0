Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:56605 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753917AbeCVMQI (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 22 Mar 2018 08:16:08 -0400
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
References: <20180319091841.18603-1-wqu@suse.com>
 <3b720fac-68be-ab4f-c2fd-b86466010adb@gmail.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <e859b541-d4bb-37d3-bbe9-89eaefd62705@suse.com>
Date: Thu, 22 Mar 2018 20:15:52 +0800
MIME-Version: 1.0
In-Reply-To: <3b720fac-68be-ab4f-c2fd-b86466010adb@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aBRceFljHkjVAwWdkTt0INl2j6z6bZAxJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aBRceFljHkjVAwWdkTt0INl2j6z6bZAxJ
Content-Type: multipart/mixed; boundary="eQl2PZDKh1dWscKRDSrA9O7WuJAFBLmqh";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <e859b541-d4bb-37d3-bbe9-89eaefd62705@suse.com>
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
References: <20180319091841.18603-1-wqu@suse.com>
 <3b720fac-68be-ab4f-c2fd-b86466010adb@gmail.com>
In-Reply-To: <3b720fac-68be-ab4f-c2fd-b86466010adb@gmail.com>

--eQl2PZDKh1dWscKRDSrA9O7WuJAFBLmqh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 20:12, Nikolay Borisov wrote:
>=20
>=20
> On 19.03.2018 11:18, Qu Wenruo wrote:
>> We have several reports about node pointer points to incorrect child
>> tree blocks, which could have even wrong owner and level but still wit=
h
>> valid generation and checksum.
>>
>> Although btrfs check could handle it and print error message like:
>> leaf parent key incorrect 60670574592
>>
>> Kernel doesn't have enough check on this type of corruption correctly.=

>> At least add such check to read_tree_block() and btrfs_read_buffer(),
>> where we need two new parameters @first_key and @level to verify the
>> child tree block.
>>
>> For case where we don't have parent node to get @first_key and @level,=

>> just pass @first_key as NULL and kernel will skip such check.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
>=20
> This patch breaks the build, at the very least you should update the
> call to read_tree_block in ref-verify.c

Didn't notice the new ref-verify option.

I'll update this with CONFIG_BTRFS_FS_REF_VERIFY set.

Thanks,
Qu

>=20
>> ---
>>  fs/btrfs/backref.c     |  6 +++--
>>  fs/btrfs/ctree.c       | 25 +++++++++++++-----
>>  fs/btrfs/disk-io.c     | 69 ++++++++++++++++++++++++++++++++++++++++-=
---------
>>  fs/btrfs/disk-io.h     |  8 +++---
>>  fs/btrfs/extent-tree.c |  6 ++++-
>>  fs/btrfs/print-tree.c  | 10 +++++---
>>  fs/btrfs/qgroup.c      |  7 +++--
>>  fs/btrfs/relocation.c  | 21 ++++++++++++---
>>  fs/btrfs/tree-log.c    | 12 ++++++---
>>  9 files changed, 126 insertions(+), 38 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 26484648d090..3866b8ab20f1 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info *=
fs_info,
>>  		BUG_ON(ref->key_for_search.type);
>>  		BUG_ON(!ref->wanted_disk_byte);
>> =20
>> -		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0);
>> +		eb =3D read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,
>> +				     0);
>>  		if (IS_ERR(eb)) {
>>  			free_pref(ref);
>>  			return PTR_ERR(eb);
>> @@ -1291,7 +1292,8 @@ static int find_parent_nodes(struct btrfs_trans_=
handle *trans,
>>  			    ref->level =3D=3D 0) {
>>  				struct extent_buffer *eb;
>> =20
>> -				eb =3D read_tree_block(fs_info, ref->parent, 0);
>> +				eb =3D read_tree_block(fs_info, ref->parent, 0,
>> +						     NULL, 0);
>>  				if (IS_ERR(eb)) {
>>  					ret =3D PTR_ERR(eb);
>>  					goto out;
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index b88a79e69ddf..e49ca6d529e8 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -1436,7 +1436,7 @@ get_old_root(struct btrfs_root *root, u64 time_s=
eq)
>>  	if (old_root && tm && tm->op !=3D MOD_LOG_KEY_REMOVE_WHILE_FREEING) =
{
>>  		btrfs_tree_read_unlock(eb_root);
>>  		free_extent_buffer(eb_root);
>> -		old =3D read_tree_block(fs_info, logical, 0);
>> +		old =3D read_tree_block(fs_info, logical, 0, NULL, 0);
>>  		if (WARN_ON(IS_ERR(old) || !extent_buffer_uptodate(old))) {
>>  			if (!IS_ERR(old))
>>  				free_extent_buffer(old);
>> @@ -1656,6 +1656,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle=
 *trans,
>>  	btrfs_set_lock_blocking(parent);
>> =20
>>  	for (i =3D start_slot; i <=3D end_slot; i++) {
>> +		struct btrfs_key first_key;
>>  		int close =3D 1;
>> =20
>>  		btrfs_node_key(parent, &disk_key, i);
>> @@ -1665,6 +1666,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle=
 *trans,
>>  		progress_passed =3D 1;
>>  		blocknr =3D btrfs_node_blockptr(parent, i);
>>  		gen =3D btrfs_node_ptr_generation(parent, i);
>> +		btrfs_node_key_to_cpu(parent, &first_key, i);
>>  		if (last_block =3D=3D 0)
>>  			last_block =3D blocknr;
>> =20
>> @@ -1688,7 +1690,9 @@ int btrfs_realloc_node(struct btrfs_trans_handle=
 *trans,
>>  			uptodate =3D 0;
>>  		if (!cur || !uptodate) {
>>  			if (!cur) {
>> -				cur =3D read_tree_block(fs_info, blocknr, gen);
>> +				cur =3D read_tree_block(fs_info, blocknr, gen,
>> +						      &first_key,
>> +						      parent_level - 1);
>>  				if (IS_ERR(cur)) {
>>  					return PTR_ERR(cur);
>>  				} else if (!extent_buffer_uptodate(cur)) {
>> @@ -1696,7 +1700,8 @@ int btrfs_realloc_node(struct btrfs_trans_handle=
 *trans,
>>  					return -EIO;
>>  				}
>>  			} else if (!uptodate) {
>> -				err =3D btrfs_read_buffer(cur, gen);
>> +				err =3D btrfs_read_buffer(cur, gen, &first_key,
>> +							parent_level - 1);
>>  				if (err) {
>>  					free_extent_buffer(cur);
>>  					return err;
>> @@ -1849,14 +1854,17 @@ read_node_slot(struct btrfs_fs_info *fs_info, =
struct extent_buffer *parent,
>>  {
>>  	int level =3D btrfs_header_level(parent);
>>  	struct extent_buffer *eb;
>> +	struct btrfs_key first_key;
>> =20
>>  	if (slot < 0 || slot >=3D btrfs_header_nritems(parent))
>>  		return ERR_PTR(-ENOENT);
>> =20
>>  	BUG_ON(level =3D=3D 0);
>> =20
>> +	btrfs_node_key_to_cpu(parent, &first_key, slot);
>>  	eb =3D read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
>> -			     btrfs_node_ptr_generation(parent, slot));
>> +			     btrfs_node_ptr_generation(parent, slot),
>> +			     &first_key, level - 1);
>>  	if (!IS_ERR(eb) && !extent_buffer_uptodate(eb)) {
>>  		free_extent_buffer(eb);
>>  		eb =3D ERR_PTR(-EIO);
>> @@ -2445,10 +2453,14 @@ read_block_for_search(struct btrfs_root *root,=
 struct btrfs_path *p,
>>  	u64 gen;
>>  	struct extent_buffer *b =3D *eb_ret;
>>  	struct extent_buffer *tmp;
>> +	struct btrfs_key first_key;
>>  	int ret;
>> +	int parent_level;
>> =20
>>  	blocknr =3D btrfs_node_blockptr(b, slot);
>>  	gen =3D btrfs_node_ptr_generation(b, slot);
>> +	parent_level =3D btrfs_header_level(b);
>> +	btrfs_node_key_to_cpu(b, &first_key, slot);
>> =20
>>  	tmp =3D find_extent_buffer(fs_info, blocknr);
>>  	if (tmp) {
>> @@ -2467,7 +2479,7 @@ read_block_for_search(struct btrfs_root *root, s=
truct btrfs_path *p,
>>  		btrfs_set_path_blocking(p);
>> =20
>>  		/* now we're allowed to do a blocking uptodate check */
>> -		ret =3D btrfs_read_buffer(tmp, gen);
>> +		ret =3D btrfs_read_buffer(tmp, gen, &first_key, parent_level - 1);
>>  		if (!ret) {
>>  			*eb_ret =3D tmp;
>>  			return 0;
>> @@ -2494,7 +2506,8 @@ read_block_for_search(struct btrfs_root *root, s=
truct btrfs_path *p,
>>  	btrfs_release_path(p);
>> =20
>>  	ret =3D -EAGAIN;
>> -	tmp =3D read_tree_block(fs_info, blocknr, 0);
>> +	tmp =3D read_tree_block(fs_info, blocknr, 0, &first_key,
>> +			      parent_level - 1);
>>  	if (!IS_ERR(tmp)) {
>>  		/*
>>  		 * If the read above didn't mark this buffer up to date,
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 21f34ad0d411..46fbbbf34568 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -428,13 +428,40 @@ static int btrfs_check_super_csum(struct btrfs_f=
s_info *fs_info,
>>  	return ret;
>>  }
>> =20
>> +static int verify_parent_key(struct extent_buffer *eb,
>> +			     struct btrfs_key *first_key,
>> +			     int level)
>> +{
>> +	int found_level;
>> +	struct btrfs_key found_key;
>> +
>> +	if (!first_key)
>> +		return 0;
>> +
>> +	found_level =3D btrfs_header_level(eb);
>> +	if (found_level !=3D level)
>> +		return -EIO;
>> +
>> +	if (found_level)
>> +		btrfs_node_key_to_cpu(eb, &found_key, 0);
>> +	else
>> +		btrfs_item_key_to_cpu(eb, &found_key, 0);
>> +	return btrfs_comp_cpu_keys(first_key, &found_key);
>> +}
>> +
>>  /*
>>   * helper to read a given tree block, doing retries as required when
>>   * the checksums don't match and we have alternate mirrors to try.
>> + *
>> + * @parent_transid:	expected transid, skip check if 0
>> + * @first_key:		expected key of first slot, skip check if NULL
>> + * @level:		expected level, skip check if @first_key is NULL
>>   */
>>  static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_in=
fo,
>>  					  struct extent_buffer *eb,
>> -					  u64 parent_transid)
>> +					  u64 parent_transid,
>> +					  struct btrfs_key *first_key,
>> +					  int level)
>>  {
>>  	struct extent_io_tree *io_tree;
>>  	int failed =3D 0;
>> @@ -449,11 +476,13 @@ static int btree_read_extent_buffer_pages(struct=
 btrfs_fs_info *fs_info,
>>  		ret =3D read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
>>  					       mirror_num);
>>  		if (!ret) {
>> -			if (!verify_parent_transid(io_tree, eb,
>> +			if (verify_parent_transid(io_tree, eb,
>>  						   parent_transid, 0))
>> -				break;
>> -			else
>>  				ret =3D -EIO;
>> +			else if (verify_parent_key(eb, first_key, level))
>> +				ret =3D -EUCLEAN;
>> +			else
>> +				break;
>>  		}
>> =20
>>  		/*
>> @@ -461,7 +490,8 @@ static int btree_read_extent_buffer_pages(struct b=
trfs_fs_info *fs_info,
>>  		 * there is no reason to read the other copies, they won't be
>>  		 * any less wrong.
>>  		 */
>> -		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
>> +		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags) ||
>> +		    ret =3D=3D -EUCLEAN)
>>  			break;
>> =20
>>  		num_copies =3D btrfs_num_copies(fs_info,
>> @@ -1062,8 +1092,17 @@ void btrfs_wait_tree_block_writeback(struct ext=
ent_buffer *buf)
>>  			        buf->start, buf->start + buf->len - 1);
>>  }
>> =20
>> +/*
>> + * Read tree block at logical address @bytenr and do variant basic bu=
t critical
>> + * verfication.
>> + *
>> + * @parent_transid:	expected transid of this tree block, skip check i=
f 0
>> + * @first_key:		expected key in slot 0, skip check if NULL
>> + * @level:		eppected level, skip check if @first_key is NULL
>> + */
>>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, =
u64 bytenr,
>> -				      u64 parent_transid)
>> +				      u64 parent_transid,
>> +				      struct btrfs_key *first_key, int level)
>>  {
>>  	struct extent_buffer *buf =3D NULL;
>>  	int ret;
>> @@ -1072,7 +1111,8 @@ struct extent_buffer *read_tree_block(struct btr=
fs_fs_info *fs_info, u64 bytenr,
>>  	if (IS_ERR(buf))
>>  		return buf;
>> =20
>> -	ret =3D btree_read_extent_buffer_pages(fs_info, buf, parent_transid)=
;
>> +	ret =3D btree_read_extent_buffer_pages(fs_info, buf, parent_transid,=

>> +					     first_key, level);
>>  	if (ret) {
>>  		free_extent_buffer(buf);
>>  		return ERR_PTR(ret);
>> @@ -1425,7 +1465,7 @@ static struct btrfs_root *btrfs_read_tree_root(s=
truct btrfs_root *tree_root,
>>  	generation =3D btrfs_root_generation(&root->root_item);
>>  	root->node =3D read_tree_block(fs_info,
>>  				     btrfs_root_bytenr(&root->root_item),
>> -				     generation);
>> +				     generation, NULL, 0);
>>  	if (IS_ERR(root->node)) {
>>  		ret =3D PTR_ERR(root->node);
>>  		goto find_fail;
>> @@ -2289,7 +2329,8 @@ static int btrfs_replay_log(struct btrfs_fs_info=
 *fs_info,
>>  	__setup_root(log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
>> =20
>>  	log_tree_root->node =3D read_tree_block(fs_info, bytenr,
>> -					      fs_info->generation + 1);
>> +					      fs_info->generation + 1,
>> +					      NULL, 0);
>>  	if (IS_ERR(log_tree_root->node)) {
>>  		btrfs_warn(fs_info, "failed to read log tree");
>>  		ret =3D PTR_ERR(log_tree_root->node);
>> @@ -2746,7 +2787,7 @@ int open_ctree(struct super_block *sb,
>> =20
>>  	chunk_root->node =3D read_tree_block(fs_info,
>>  					   btrfs_super_chunk_root(disk_super),
>> -					   generation);
>> +					   generation, NULL, 0);
>>  	if (IS_ERR(chunk_root->node) ||
>>  	    !extent_buffer_uptodate(chunk_root->node)) {
>>  		btrfs_err(fs_info, "failed to read chunk root");
>> @@ -2783,7 +2824,7 @@ int open_ctree(struct super_block *sb,
>> =20
>>  	tree_root->node =3D read_tree_block(fs_info,
>>  					  btrfs_super_root(disk_super),
>> -					  generation);
>> +					  generation, NULL, 0);
>>  	if (IS_ERR(tree_root->node) ||
>>  	    !extent_buffer_uptodate(tree_root->node)) {
>>  		btrfs_warn(fs_info, "failed to read tree root");
>> @@ -3890,12 +3931,14 @@ void btrfs_btree_balance_dirty_nodelay(struct =
btrfs_fs_info *fs_info)
>>  	__btrfs_btree_balance_dirty(fs_info, 0);
>>  }
>> =20
>> -int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
>> +int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid,
>> +		      struct btrfs_key *first_key, int level)
>>  {
>>  	struct btrfs_root *root =3D BTRFS_I(buf->pages[0]->mapping->host)->r=
oot;
>>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>> =20
>> -	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid);=

>> +	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
>> +					      first_key, level);
>>  }
>> =20
>>  static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>> index 301151a50ac1..3a1f4b2fa6ff 100644
>> --- a/fs/btrfs/disk-io.h
>> +++ b/fs/btrfs/disk-io.h
>> @@ -52,8 +52,9 @@ static inline u64 btrfs_sb_offset(int mirror)
>>  struct btrfs_device;
>>  struct btrfs_fs_devices;
>> =20
>> -struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info,
>> -				      u64 bytenr, u64 parent_transid);
>> +struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, =
u64 bytenr,
>> +				      u64 parent_transid,
>> +				      struct btrfs_key *first_key, int level);
>>  void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr);=

>>  int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 byten=
r,
>>  			 int mirror_num, struct extent_buffer **eb);
>> @@ -123,7 +124,8 @@ static inline void btrfs_put_fs_root(struct btrfs_=
root *root)
>>  void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
>>  int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_trans=
id,
>>  			  int atomic);
>> -int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);=

>> +int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid,
>> +		      struct btrfs_key *first_key, int level);
>>  u32 btrfs_csum_data(const char *data, u32 seed, size_t len);
>>  void btrfs_csum_final(u32 crc, u8 *result);
>>  blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct b=
io *bio,
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index c1618ab9fecf..156ac8e4ff62 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8701,6 +8701,7 @@ static noinline int do_walk_down(struct btrfs_tr=
ans_handle *trans,
>>  	u64 parent;
>>  	u32 blocksize;
>>  	struct btrfs_key key;
>> +	struct btrfs_key first_key;
>>  	struct extent_buffer *next;
>>  	int level =3D wc->level;
>>  	int reada =3D 0;
>> @@ -8721,6 +8722,8 @@ static noinline int do_walk_down(struct btrfs_tr=
ans_handle *trans,
>>  	}
>> =20
>>  	bytenr =3D btrfs_node_blockptr(path->nodes[level], path->slots[level=
]);
>> +	btrfs_node_key_to_cpu(path->nodes[level], &first_key,
>> +			      path->slots[level]);
>>  	blocksize =3D fs_info->nodesize;
>> =20
>>  	next =3D find_extent_buffer(fs_info, bytenr);
>> @@ -8785,7 +8788,8 @@ static noinline int do_walk_down(struct btrfs_tr=
ans_handle *trans,
>>  	if (!next) {
>>  		if (reada && level =3D=3D 1)
>>  			reada_walk_down(trans, root, wc, path);
>> -		next =3D read_tree_block(fs_info, bytenr, generation);
>> +		next =3D read_tree_block(fs_info, bytenr, generation, &first_key,
>> +				       level - 1);
>>  		if (IS_ERR(next)) {
>>  			return PTR_ERR(next);
>>  		} else if (!extent_buffer_uptodate(next)) {
>> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
>> index 569205e651c7..b00d88291085 100644
>> --- a/fs/btrfs/print-tree.c
>> +++ b/fs/btrfs/print-tree.c
>> @@ -365,9 +365,13 @@ void btrfs_print_tree(struct extent_buffer *c)
>>  		       btrfs_node_blockptr(c, i));
>>  	}
>>  	for (i =3D 0; i < nr; i++) {
>> -		struct extent_buffer *next =3D read_tree_block(fs_info,
>> -					btrfs_node_blockptr(c, i),
>> -					btrfs_node_ptr_generation(c, i));
>> +		struct btrfs_key first_key;
>> +		struct extent_buffer *next;
>> +
>> +		btrfs_node_key_to_cpu(c, &first_key, i);
>> +		next =3D read_tree_block(fs_info, btrfs_node_blockptr(c, i),
>> +				       btrfs_node_ptr_generation(c, i),
>> +				       &first_key, level - 1);
>>  		if (IS_ERR(next)) {
>>  			continue;
>>  		} else if (!extent_buffer_uptodate(next)) {
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index aa259d6986e1..86698702d08c 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1614,7 +1614,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_tran=
s_handle *trans,
>>  		return 0;
>> =20
>>  	if (!extent_buffer_uptodate(root_eb)) {
>> -		ret =3D btrfs_read_buffer(root_eb, root_gen);
>> +		ret =3D btrfs_read_buffer(root_eb, root_gen, NULL, 0);
>>  		if (ret)
>>  			goto out;
>>  	}
>> @@ -1645,6 +1645,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_tran=
s_handle *trans,
>>  	level =3D root_level;
>>  	while (level >=3D 0) {
>>  		if (path->nodes[level] =3D=3D NULL) {
>> +			struct btrfs_key first_key;
>>  			int parent_slot;
>>  			u64 child_gen;
>>  			u64 child_bytenr;
>> @@ -1657,8 +1658,10 @@ int btrfs_qgroup_trace_subtree(struct btrfs_tra=
ns_handle *trans,
>>  			parent_slot =3D path->slots[level + 1];
>>  			child_bytenr =3D btrfs_node_blockptr(eb, parent_slot);
>>  			child_gen =3D btrfs_node_ptr_generation(eb, parent_slot);
>> +			btrfs_node_key_to_cpu(eb, &first_key, parent_slot);
>> =20
>> -			eb =3D read_tree_block(fs_info, child_bytenr, child_gen);
>> +			eb =3D read_tree_block(fs_info, child_bytenr, child_gen,
>> +					     &first_key, level);
>>  			if (IS_ERR(eb)) {
>>  				ret =3D PTR_ERR(eb);
>>  				goto out;
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index cd2298d185dd..4a309f8c9535 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -1839,6 +1839,8 @@ int replace_path(struct btrfs_trans_handle *tran=
s,
>> =20
>>  	parent =3D eb;
>>  	while (1) {
>> +		struct btrfs_key first_key;
>> +
>>  		level =3D btrfs_header_level(parent);
>>  		BUG_ON(level < lowest_level);
>> =20
>> @@ -1852,6 +1854,7 @@ int replace_path(struct btrfs_trans_handle *tran=
s,
>>  		old_bytenr =3D btrfs_node_blockptr(parent, slot);
>>  		blocksize =3D fs_info->nodesize;
>>  		old_ptr_gen =3D btrfs_node_ptr_generation(parent, slot);
>> +		btrfs_node_key_to_cpu(parent, &key, slot);
>> =20
>>  		if (level <=3D max_level) {
>>  			eb =3D path->nodes[level];
>> @@ -1876,7 +1879,8 @@ int replace_path(struct btrfs_trans_handle *tran=
s,
>>  				break;
>>  			}
>> =20
>> -			eb =3D read_tree_block(fs_info, old_bytenr, old_ptr_gen);
>> +			eb =3D read_tree_block(fs_info, old_bytenr, old_ptr_gen,
>> +					     &first_key, level - 1);
>>  			if (IS_ERR(eb)) {
>>  				ret =3D PTR_ERR(eb);
>>  				break;
>> @@ -2036,6 +2040,8 @@ int walk_down_reloc_tree(struct btrfs_root *root=
, struct btrfs_path *path,
>>  	last_snapshot =3D btrfs_root_last_snapshot(&root->root_item);
>> =20
>>  	for (i =3D *level; i > 0; i--) {
>> +		struct btrfs_key first_key;
>> +
>>  		eb =3D path->nodes[i];
>>  		nritems =3D btrfs_header_nritems(eb);
>>  		while (path->slots[i] < nritems) {
>> @@ -2056,7 +2062,9 @@ int walk_down_reloc_tree(struct btrfs_root *root=
, struct btrfs_path *path,
>>  		}
>> =20
>>  		bytenr =3D btrfs_node_blockptr(eb, path->slots[i]);
>> -		eb =3D read_tree_block(fs_info, bytenr, ptr_gen);
>> +		btrfs_node_key_to_cpu(eb, &first_key, path->slots[i]);
>> +		eb =3D read_tree_block(fs_info, bytenr, ptr_gen, &first_key,
>> +				     i - 1);
>>  		if (IS_ERR(eb)) {
>>  			return PTR_ERR(eb);
>>  		} else if (!extent_buffer_uptodate(eb)) {
>> @@ -2714,6 +2722,8 @@ static int do_relocation(struct btrfs_trans_hand=
le *trans,
>>  	path->lowest_level =3D node->level + 1;
>>  	rc->backref_cache.path[node->level] =3D node;
>>  	list_for_each_entry(edge, &node->upper, list[LOWER]) {
>> +		struct btrfs_key first_key;
>> +
>>  		cond_resched();
>> =20
>>  		upper =3D edge->node[UPPER];
>> @@ -2779,7 +2789,9 @@ static int do_relocation(struct btrfs_trans_hand=
le *trans,
>> =20
>>  		blocksize =3D root->fs_info->nodesize;
>>  		generation =3D btrfs_node_ptr_generation(upper->eb, slot);
>> -		eb =3D read_tree_block(fs_info, bytenr, generation);
>> +		btrfs_node_key_to_cpu(upper->eb, &first_key, slot);
>> +		eb =3D read_tree_block(fs_info, bytenr, generation, &first_key,
>> +				     upper->level - 1);
>>  		if (IS_ERR(eb)) {
>>  			err =3D PTR_ERR(eb);
>>  			goto next;
>> @@ -2944,7 +2956,8 @@ static int get_tree_block_key(struct btrfs_fs_in=
fo *fs_info,
>>  	struct extent_buffer *eb;
>> =20
>>  	BUG_ON(block->key_ready);
>> -	eb =3D read_tree_block(fs_info, block->bytenr, block->key.offset);
>> +	eb =3D read_tree_block(fs_info, block->bytenr, block->key.offset, NU=
LL,
>> +			     0);
>>  	if (IS_ERR(eb)) {
>>  		return PTR_ERR(eb);
>>  	} else if (!extent_buffer_uptodate(eb)) {
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 434457794c27..b98a1801b406 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -304,7 +304,7 @@ static int process_one_buffer(struct btrfs_root *l=
og,
>>  	 * pin down any logged extents, so we have to read the block.
>>  	 */
>>  	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS)) {
>> -		ret =3D btrfs_read_buffer(eb, gen);
>> +		ret =3D btrfs_read_buffer(eb, gen, NULL, 0);
>>  		if (ret)
>>  			return ret;
>>  	}
>> @@ -2420,7 +2420,7 @@ static int replay_one_buffer(struct btrfs_root *=
log, struct extent_buffer *eb,
>>  	int i;
>>  	int ret;
>> =20
>> -	ret =3D btrfs_read_buffer(eb, gen);
>> +	ret =3D btrfs_read_buffer(eb, gen, NULL, 0);
>>  	if (ret)
>>  		return ret;
>> =20
>> @@ -2537,6 +2537,8 @@ static noinline int walk_down_log_tree(struct bt=
rfs_trans_handle *trans,
>>  	WARN_ON(*level >=3D BTRFS_MAX_LEVEL);
>> =20
>>  	while (*level > 0) {
>> +		struct btrfs_key first_key;
>> +
>>  		WARN_ON(*level < 0);
>>  		WARN_ON(*level >=3D BTRFS_MAX_LEVEL);
>>  		cur =3D path->nodes[*level];
>> @@ -2549,6 +2551,7 @@ static noinline int walk_down_log_tree(struct bt=
rfs_trans_handle *trans,
>> =20
>>  		bytenr =3D btrfs_node_blockptr(cur, path->slots[*level]);
>>  		ptr_gen =3D btrfs_node_ptr_generation(cur, path->slots[*level]);
>> +		btrfs_node_key_to_cpu(cur, &first_key, path->slots[*level]);
>>  		blocksize =3D fs_info->nodesize;
>> =20
>>  		parent =3D path->nodes[*level];
>> @@ -2567,7 +2570,8 @@ static noinline int walk_down_log_tree(struct bt=
rfs_trans_handle *trans,
>> =20
>>  			path->slots[*level]++;
>>  			if (wc->free) {
>> -				ret =3D btrfs_read_buffer(next, ptr_gen);
>> +				ret =3D btrfs_read_buffer(next, ptr_gen,
>> +							&first_key, *level - 1);
>>  				if (ret) {
>>  					free_extent_buffer(next);
>>  					return ret;
>> @@ -2597,7 +2601,7 @@ static noinline int walk_down_log_tree(struct bt=
rfs_trans_handle *trans,
>>  			free_extent_buffer(next);
>>  			continue;
>>  		}
>> -		ret =3D btrfs_read_buffer(next, ptr_gen);
>> +		ret =3D btrfs_read_buffer(next, ptr_gen, &first_key, *level - 1);
>>  		if (ret) {
>>  			free_extent_buffer(next);
>>  			return ret;
>>
>=20


--eQl2PZDKh1dWscKRDSrA9O7WuJAFBLmqh--

--aBRceFljHkjVAwWdkTt0INl2j6z6bZAxJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqznngNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qAoKB/9XOFAMa7gfsbDETHSVZH973Wo6bNAkik0o4H2g
ij5KC3ifFdMtlmDpNoB8Nj36SuP2QV6FGDzmBwFj3znhHeMyqXHTver01H7stu9u
5DGaoPnm/rTLSBr4Dw2FoAbtpvH/K24ecjtmakGZAWHkJPCLJsv3Sqc63lS+oPhW
pg+WGC34QwHgkE77gltmlcNwUW/xwoIw54ywS7CFOH+GoHA8mpkUt/j69pLo/KM8
ysjM3mw8Fa8ChaswKr+PLLH1VQcMgMlWs9hRR10wsjiN4SV11kSgAfJQM+/H4pxu
0zK89SRQy9Df3ev56Pk2AsyFpeiF/7WKyoGwCigkn6luOdsn
=OlwE
-----END PGP SIGNATURE-----

--aBRceFljHkjVAwWdkTt0INl2j6z6bZAxJ--
