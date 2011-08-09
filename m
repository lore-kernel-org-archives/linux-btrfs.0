From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 02/12 v5] Btrfs: introduce sub transaction stuff
Date: Tue, 9 Aug 2011 12:25:35 -0500
Message-ID: <CAKcLGm_wtJpUrzGmOjjUCFkMC1JAFvV8TVmXxxEDMoHuwyVE-w@mail.gmail.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
	<1312623467-31487-3-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-3-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 6, 2011 at 4:37 AM, Liu Bo <liubo2009@cn.fujitsu.com> wrote=
:
> Introduce a new concept "sub transaction",
> the relation between transaction and sub transaction is
>
> transaction A =A0 =A0 =A0 ---> transid =3D x
> =A0 sub trans a(1) =A0 ---> sub_transid =3D x+1
> =A0 sub trans a(2) =A0 ---> sub_transid =3D x+2
> =A0 =A0 ... ...
> =A0 sub trans a(n-1) ---> sub_transid =3D x+n-1
> =A0 sub trans a(n) =A0 ---> sub_transid =3D x+n
> transaction B =A0 =A0 =A0 ---> transid =3D x+n+1
> =A0 =A0 ... ...
>
> And the most important is
> a) a trans handler's transid now gets value from sub transid instead =
of transid.
> b) when a transaction commits, transid may not added by 1, but depend=
 on the
> =A0 biggest sub_transaction of the last neighbour transaction,
> =A0 i.e.
> =A0 =A0 =A0 =A0B->transid =3D a(n)->transid + 1,
> =A0 =A0 =A0 =A0(B->transid - A->transid) >=3D 1
> c) we start a new sub transaction after a fsync.
>
> We also ship some 'trans->transid' to 'trans->transaction->transid' t=
o
> ensure btrfs works well and to get rid of WARNings.
>
> These are used for the new log code.
>
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
> =A0fs/btrfs/ctree.c =A0 =A0 =A0 | =A0 35 ++++++++++++++++++----------=
-------
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 | =A0 =A01 +
> =A0fs/btrfs/disk-io.c =A0 =A0 | =A0 =A07 ++++---
> =A0fs/btrfs/extent-tree.c | =A0 10 ++++++----
> =A0fs/btrfs/inode.c =A0 =A0 =A0 | =A0 =A04 ++--
> =A0fs/btrfs/ioctl.c =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/btrfs/relocation.c =A0| =A0 =A06 +++---
> =A0fs/btrfs/transaction.c | =A0 13 ++++++++-----
> =A0fs/btrfs/transaction.h | =A0 =A01 +
> =A0fs/btrfs/tree-defrag.c | =A0 =A02 +-
> =A0fs/btrfs/tree-log.c =A0 =A0| =A0 16 ++++++++++++++--
> =A011 files changed, 59 insertions(+), 38 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 011cab3..41d1d17 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -228,9 +228,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *tr=
ans,
> =A0 =A0 =A0 =A0int level;
> =A0 =A0 =A0 =A0struct btrfs_disk_key disk_key;
>
> - =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transid !=3D
> + =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transaction->transid !=
=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root->fs_info->running_transaction->tr=
ansid);
> - =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transid !=3D root->las=
t_trans);
> + =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transid < root->last_t=
rans);
>
> =A0 =A0 =A0 =A0level =3D btrfs_header_level(buf);
> =A0 =A0 =A0 =A0if (level =3D=3D 0)
> @@ -425,9 +425,9 @@ static noinline int __btrfs_cow_block(struct btrf=
s_trans_handle *trans,
>
> =A0 =A0 =A0 =A0btrfs_assert_tree_locked(buf);
>
> - =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transid !=3D
> + =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transaction->transid !=
=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0root->fs_info->running_transaction->tr=
ansid);
> - =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transid !=3D root->las=
t_trans);
> + =A0 =A0 =A0 WARN_ON(root->ref_cows && trans->transid < root->last_t=
rans);
>
> =A0 =A0 =A0 =A0level =3D btrfs_header_level(buf);
>
> @@ -493,7 +493,8 @@ static noinline int __btrfs_cow_block(struct btrf=
s_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent_start =3D 0;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(trans->transid !=3D btrfs_heade=
r_generation(parent));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(btrfs_header_generation(parent)=
 <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 trans->transaction->transid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_node_blockptr(parent, parent=
_slot,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cow->start);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_node_ptr_generation(parent, =
parent_slot,
> @@ -514,7 +515,7 @@ static inline int should_cow_block(struct btrfs_t=
rans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
truct extent_buffer *buf)
> =A0{
> - =A0 =A0 =A0 if (btrfs_header_generation(buf) =3D=3D trans->transid =
&&
> + =A0 =A0 =A0 if (btrfs_header_generation(buf) >=3D trans->transactio=
n->transid &&
> =A0 =A0 =A0 =A0 =A0 =A0!btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRIT=
TEN) &&
> =A0 =A0 =A0 =A0 =A0 =A0!(root->root_key.objectid !=3D BTRFS_TREE_RELO=
C_OBJECTID &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_header_flag(buf, BTRFS_HEADER_FLAG_R=
ELOC)))
> @@ -542,7 +543,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_h=
andle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->fs_info->running_tr=
ansaction->transid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(1);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (trans->transid !=3D root->fs_info->generation) {
> + =A0 =A0 =A0 if (trans->transaction->transid !=3D root->fs_info->gen=
eration) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_CRIT "trans %llu running %=
llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)trans=
->transid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)root-=
>fs_info->generation);
> @@ -645,7 +646,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle =
*trans,
>
> =A0 =A0 =A0 =A0if (trans->transaction !=3D root->fs_info->running_tra=
nsaction)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(1);
> - =A0 =A0 =A0 if (trans->transid !=3D root->fs_info->generation)
> + =A0 =A0 =A0 if (trans->transaction->transid !=3D root->fs_info->gen=
eration)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(1);
>
> =A0 =A0 =A0 =A0parent_nritems =3D btrfs_header_nritems(parent);
> @@ -898,7 +899,7 @@ static noinline int balance_level(struct btrfs_tr=
ans_handle *trans,
>
> =A0 =A0 =A0 =A0WARN_ON(path->locks[level] !=3D BTRFS_WRITE_LOCK &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path->locks[level] !=3D BTRFS_WRITE_LO=
CK_BLOCKING);
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(mid) !=3D trans->transi=
d);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(mid) < trans->transacti=
on->transid);
>
> =A0 =A0 =A0 =A0orig_ptr =3D btrfs_node_blockptr(mid, orig_slot);
>
> @@ -1105,7 +1106,7 @@ static noinline int push_nodes_for_insert(struc=
t btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
>
> =A0 =A0 =A0 =A0mid =3D path->nodes[level];
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(mid) !=3D trans->transi=
d);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(mid) < trans->transacti=
on->transid);
>
> =A0 =A0 =A0 =A0if (level < BTRFS_MAX_LEVEL - 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent =3D path->nodes[level + 1];
> @@ -1942,8 +1943,8 @@ static int push_node_left(struct btrfs_trans_ha=
ndle *trans,
> =A0 =A0 =A0 =A0src_nritems =3D btrfs_header_nritems(src);
> =A0 =A0 =A0 =A0dst_nritems =3D btrfs_header_nritems(dst);
> =A0 =A0 =A0 =A0push_items =3D BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nr=
items;
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(src) !=3D trans->transi=
d);
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(dst) !=3D trans->transi=
d);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(src) < trans->transacti=
on->transid);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(dst) < trans->transacti=
on->transid);
>
> =A0 =A0 =A0 =A0if (!empty && src_nritems <=3D 8)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> @@ -2005,8 +2006,8 @@ static int balance_node_right(struct btrfs_tran=
s_handle *trans,
> =A0 =A0 =A0 =A0int dst_nritems;
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(src) !=3D trans->transi=
d);
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(dst) !=3D trans->transi=
d);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(src) < trans->transacti=
on->transid);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(dst) < trans->transacti=
on->transid);
>
> =A0 =A0 =A0 =A0src_nritems =3D btrfs_header_nritems(src);
> =A0 =A0 =A0 =A0dst_nritems =3D btrfs_header_nritems(dst);
> @@ -2097,7 +2098,7 @@ static noinline int insert_new_root(struct btrf=
s_trans_handle *trans,
> =A0 =A0 =A0 =A0btrfs_set_node_key(c, &lower_key, 0);
> =A0 =A0 =A0 =A0btrfs_set_node_blockptr(c, 0, lower->start);
> =A0 =A0 =A0 =A0lower_gen =3D btrfs_header_generation(lower);
> - =A0 =A0 =A0 WARN_ON(lower_gen !=3D trans->transid);
> + =A0 =A0 =A0 WARN_ON(lower_gen < trans->transaction->transid);
>
> =A0 =A0 =A0 =A0btrfs_set_node_ptr_generation(c, 0, lower_gen);
>
> @@ -2177,7 +2178,7 @@ static noinline int split_node(struct btrfs_tra=
ns_handle *trans,
> =A0 =A0 =A0 =A0u32 c_nritems;
>
> =A0 =A0 =A0 =A0c =3D path->nodes[level];
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(c) !=3D trans->transid)=
;
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(c) < trans->transaction=
->transid);
> =A0 =A0 =A0 =A0if (c =3D=3D root->node) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* trying to split the root, lets make=
 a new one */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D insert_new_root(trans, root, p=
ath, level + 1);
> @@ -3751,7 +3752,7 @@ static noinline int btrfs_del_leaf(struct btrfs=
_trans_handle *trans,
> =A0{
> =A0 =A0 =A0 =A0int ret;
>
> - =A0 =A0 =A0 WARN_ON(btrfs_header_generation(leaf) !=3D trans->trans=
id);
> + =A0 =A0 =A0 WARN_ON(btrfs_header_generation(leaf) < trans->transact=
ion->transid);
> =A0 =A0 =A0 =A0ret =3D del_ptr(trans, root, path, 1, path->slots[1]);
> =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a6263bd..310f586 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -925,6 +925,7 @@ struct btrfs_fs_info {
> =A0 =A0 =A0 =A0struct mutex durable_block_rsv_mutex;
>
> =A0 =A0 =A0 =A0u64 generation;
> + =A0 =A0 =A0 u64 sub_generation;
> =A0 =A0 =A0 =A0u64 last_trans_committed;
>
> =A0 =A0 =A0 =A0/*
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 94ecac3..50e74b1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1035,7 +1035,7 @@ int clean_tree_block(struct btrfs_trans_handle =
*trans, struct btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct extent_buffer *buf)
> =A0{
> =A0 =A0 =A0 =A0struct inode *btree_inode =3D root->fs_info->btree_ino=
de;
> - =A0 =A0 =A0 if (btrfs_header_generation(buf) =3D=3D
> + =A0 =A0 =A0 if (btrfs_header_generation(buf) >=3D
> =A0 =A0 =A0 =A0 =A0 =A0root->fs_info->running_transaction->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_assert_tree_locked(buf);
>
> @@ -1559,7 +1559,7 @@ static int transaction_kthread(void *arg)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0trans =3D btrfs_join_transaction(root)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(IS_ERR(trans));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (transid =3D=3D trans->transid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (transid =3D=3D trans->transaction->=
transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_commit_t=
ransaction(trans, root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> @@ -2001,6 +2001,7 @@ struct btrfs_root *open_ctree(struct super_bloc=
k *sb,
> =A0 =A0 =A0 =A0csum_root->track_dirty =3D 1;
>
> =A0 =A0 =A0 =A0fs_info->generation =3D generation;
> + =A0 =A0 =A0 fs_info->sub_generation =3D generation;
> =A0 =A0 =A0 =A0fs_info->last_trans_committed =3D generation;
> =A0 =A0 =A0 =A0fs_info->data_alloc_profile =3D (u64)-1;
> =A0 =A0 =A0 =A0fs_info->metadata_alloc_profile =3D (u64)-1;
> @@ -2671,7 +2672,7 @@ void btrfs_mark_buffer_dirty(struct extent_buff=
er *buf)
> =A0 =A0 =A0 =A0int was_dirty;
>
> =A0 =A0 =A0 =A0btrfs_assert_tree_locked(buf);
> - =A0 =A0 =A0 if (transid !=3D root->fs_info->generation) {
> + =A0 =A0 =A0 if (transid < root->fs_info->generation) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_CRIT "btrfs transid mismat=
ch buffer %llu, "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "found %llu running %llu\=
n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)bu=
f->start,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 66bac22..fa101ab 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4363,7 +4363,7 @@ int btrfs_finish_extent_commit(struct btrfs_tra=
ns_handle *trans,
> =A0 =A0 =A0 =A0list_for_each_entry_safe(block_rsv, next_rsv,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fs_i=
nfo->durable_block_rsv_list, list) {
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D trans->transid & 0x1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D trans->transaction->transid & 0=
x1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (block_rsv->freed[idx] > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_rsv_add_bytes(bl=
ock_rsv,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0block_rsv->freed[idx], 0);
> @@ -4680,7 +4680,7 @@ void btrfs_free_tree_block(struct btrfs_trans_h=
andle *trans,
> =A0 =A0 =A0 =A0if (block_rsv->space_info !=3D cache->space_info)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 if (btrfs_header_generation(buf) =3D=3D trans->transid)=
 {
> + =A0 =A0 =A0 if (btrfs_header_generation(buf) >=3D trans->transactio=
n->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (root->root_key.objectid !=3D BTRFS=
_TREE_LOG_OBJECTID) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D check_ref_clea=
nup(trans, root, buf->start);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ret)
> @@ -4730,7 +4730,8 @@ pin:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&block_rsv->=
lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv->freed[trans-=
>transid & 0x1] +=3D buf->len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv->freed[trans-=
>transaction->transid & 0x1] +=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
buf->len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&block_rsv=
->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> @@ -6164,7 +6165,8 @@ static noinline int walk_up_proc(struct btrfs_t=
rans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* make block locked assertion in clea=
n_tree_block happy */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!path->locks[level] &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_header_generation(eb) =3D=
=3D trans->transid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_header_generation(eb) >=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0trans->transaction->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_tree_lock(eb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_lock_blockin=
g(eb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path->locks[level] =3D=
 BTRFS_WRITE_LOCK_BLOCKING;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 34195f9..99eb0b3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2106,7 +2106,7 @@ void btrfs_orphan_pre_snapshot(struct btrfs_tra=
ns_handle *trans,
> =A0 =A0 =A0 =A0 * space than it frees. So we should make sure there i=
s enough
> =A0 =A0 =A0 =A0 * reserved space.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 index =3D trans->transid & 0x1;
> + =A0 =A0 =A0 index =3D trans->transaction->transid & 0x1;
> =A0 =A0 =A0 =A0if (block_rsv->reserved + block_rsv->freed[index] < bl=
ock_rsv->size) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_bytes +=3D block_rsv->size -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (block_rsv->r=
eserved + block_rsv->freed[index]);
> @@ -2130,7 +2130,7 @@ void btrfs_orphan_post_snapshot(struct btrfs_tr=
ans_handle *trans,
>
> =A0 =A0 =A0 =A0/* refill source subvolume's orphan block reservation =
*/
> =A0 =A0 =A0 =A0block_rsv =3D root->orphan_block_rsv;
> - =A0 =A0 =A0 index =3D trans->transid & 0x1;
> + =A0 =A0 =A0 index =3D trans->transaction->transid & 0x1;
> =A0 =A0 =A0 =A0if (block_rsv->reserved + block_rsv->freed[index] < bl=
ock_rsv->size) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_bytes =3D block_rsv->size -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(block_rsv->re=
served + block_rsv->freed[index]);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 2bb0886..bc9a2ad 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2758,7 +2758,7 @@ static noinline long btrfs_ioctl_start_sync(str=
uct file *file, void __user *argp
> =A0 =A0 =A0 =A0trans =3D btrfs_start_transaction(root, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(trans))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return PTR_ERR(trans);
> - =A0 =A0 =A0 transid =3D trans->transid;
> + =A0 =A0 =A0 transid =3D trans->transaction->transid;
> =A0 =A0 =A0 =A0ret =3D btrfs_commit_transaction_async(trans, root, 0)=
;
> =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_end_transaction(trans, root);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 59bb176..3063be1 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -469,7 +469,7 @@ static int update_backref_cache(struct btrfs_tran=
s_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (cache->last_trans =3D=3D trans->transid)
> + =A0 =A0 =A0 if (cache->last_trans >=3D trans->transaction->transid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0/*
> @@ -1281,7 +1281,7 @@ static struct btrfs_root *create_reloc_root(str=
uct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_root_last_snapshot(&root->ro=
ot_item,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0trans->transid - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0trans->transaction->transid - 1);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * called by btrfs_reloc_post_snapshot=
_hook.
> @@ -2271,7 +2271,7 @@ static int record_reloc_root_in_trans(struct bt=
rfs_trans_handle *trans,
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_root *root;
>
> - =A0 =A0 =A0 if (reloc_root->last_trans =3D=3D trans->transid)
> + =A0 =A0 =A0 if (reloc_root->last_trans >=3D trans->transaction->tra=
nsid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0root =3D read_fs_root(reloc_root->fs_info, reloc_root-=
>root_key.offset);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 7dc36fa..531b0dc 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -113,7 +113,9 @@ static noinline int join_transaction(struct btrfs=
_root *root, int nofail)
> =A0 =A0 =A0 =A0extent_io_tree_init(&cur_trans->dirty_pages,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->fs_info=
->btree_inode->i_mapping);
> =A0 =A0 =A0 =A0root->fs_info->generation++;
> + =A0 =A0 =A0 root->fs_info->sub_generation =3D root->fs_info->genera=
tion;
> =A0 =A0 =A0 =A0cur_trans->transid =3D root->fs_info->generation;
> + =A0 =A0 =A0 cur_trans->sub_transid =3D cur_trans->transid;
> =A0 =A0 =A0 =A0root->fs_info->running_transaction =3D cur_trans;
> =A0 =A0 =A0 =A0spin_unlock(&root->fs_info->trans_lock);
>
> @@ -129,7 +131,7 @@ static noinline int join_transaction(struct btrfs=
_root *root, int nofail)
> =A0static int record_root_in_trans(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct bt=
rfs_root *root)
> =A0{
> - =A0 =A0 =A0 if (root->ref_cows && root->last_trans < trans->transid=
) {
> + =A0 =A0 =A0 if (root->ref_cows && root->last_trans < trans->transac=
tion->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(root =3D=3D root->fs_info->ext=
ent_root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(root->commit_root !=3D root->n=
ode);
>
> @@ -146,7 +148,7 @@ static int record_root_in_trans(struct btrfs_tran=
s_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smp_wmb();
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&root->fs_info->fs_roots_rad=
ix_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (root->last_trans =3D=3D trans->tran=
sid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (root->last_trans >=3D trans->transa=
ction->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&root->fs_=
info->fs_roots_radix_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -194,7 +196,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans=
_handle *trans,
> =A0 =A0 =A0 =A0 * and barriers
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0smp_rmb();
> - =A0 =A0 =A0 if (root->last_trans =3D=3D trans->transid &&
> + =A0 =A0 =A0 if (root->last_trans >=3D trans->transaction->transid &=
&
> =A0 =A0 =A0 =A0 =A0 =A0!root->in_trans_setup)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> @@ -302,7 +304,7 @@ again:
>
> =A0 =A0 =A0 =A0cur_trans =3D root->fs_info->running_transaction;
>
> - =A0 =A0 =A0 h->transid =3D cur_trans->transid;
> + =A0 =A0 =A0 h->transid =3D cur_trans->sub_transid;
> =A0 =A0 =A0 =A0h->transaction =3D cur_trans;
> =A0 =A0 =A0 =A0h->blocks_used =3D 0;
> =A0 =A0 =A0 =A0h->bytes_reserved =3D 0;
> @@ -1346,6 +1348,7 @@ int btrfs_commit_transaction(struct btrfs_trans=
_handle *trans,
>
> =A0 =A0 =A0 =A0trans->transaction->blocked =3D 0;
> =A0 =A0 =A0 =A0spin_lock(&root->fs_info->trans_lock);
> + =A0 =A0 =A0 root->fs_info->generation =3D cur_trans->sub_transid;
> =A0 =A0 =A0 =A0root->fs_info->running_transaction =3D NULL;
> =A0 =A0 =A0 =A0root->fs_info->trans_no_join =3D 0;
> =A0 =A0 =A0 =A0spin_unlock(&root->fs_info->trans_lock);
> @@ -1367,7 +1370,7 @@ int btrfs_commit_transaction(struct btrfs_trans=
_handle *trans,
>
> =A0 =A0 =A0 =A0cur_trans->commit_done =3D 1;
>
> - =A0 =A0 =A0 root->fs_info->last_trans_committed =3D cur_trans->tran=
sid;
> + =A0 =A0 =A0 root->fs_info->last_trans_committed =3D cur_trans->sub_=
transid;
>
> =A0 =A0 =A0 =A0wake_up(&cur_trans->commit_wait);
>
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 02564e6..45876b0 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -23,6 +23,7 @@
>
> =A0struct btrfs_transaction {
> =A0 =A0 =A0 =A0u64 transid;
> + =A0 =A0 =A0 u64 sub_transid;
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * total writers in this transaction, it must be zero =
before the
> =A0 =A0 =A0 =A0 * transaction can end
> diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
> index 3b580ee..a2569af 100644
> --- a/fs/btrfs/tree-defrag.c
> +++ b/fs/btrfs/tree-defrag.c
> @@ -139,7 +139,7 @@ done:
> =A0 =A0 =A0 =A0if (ret !=3D -EAGAIN) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(&root->defrag_progress, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(root->defrag_progr=
ess));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->defrag_trans_start =3D trans->tra=
nsid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 root->defrag_trans_start =3D trans->tra=
nsaction->transid;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return ret;
> =A0}
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index f320641..5a026d2 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -134,9 +134,19 @@ static noinline int replay_dir_deletes(struct bt=
rfs_trans_handle *trans,
> =A0static int start_log_trans(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_root=
 *root)
> =A0{
> + =A0 =A0 =A0 struct btrfs_transaction *cur_trans;
> =A0 =A0 =A0 =A0int ret;
> =A0 =A0 =A0 =A0int err =3D 0;
>
> + =A0 =A0 =A0 /* start a new sub transaction */
> + =A0 =A0 =A0 spin_lock(&root->fs_info->trans_lock);
> +
> + =A0 =A0 =A0 cur_trans =3D root->fs_info->running_transaction;
> + =A0 =A0 =A0 cur_trans->sub_transid++;
> + =A0 =A0 =A0 root->fs_info->sub_generation =3D cur_trans->sub_transi=
d;
> +
> + =A0 =A0 =A0 spin_unlock(&root->fs_info->trans_lock);
> +
> =A0 =A0 =A0 =A0mutex_lock(&root->log_mutex);
> =A0 =A0 =A0 =A0if (root->log_root) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!root->log_start_pid) {
> @@ -2007,7 +2017,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *t=
rans,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* bail out if we need to do a full commit */
> - =A0 =A0 =A0 if (root->fs_info->last_trans_log_full_commit =3D=3D tr=
ans->transid) {
> + =A0 =A0 =A0 if (root->fs_info->last_trans_log_full_commit >=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 trans->transaction->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EAGAIN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&root->log_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> @@ -2084,7 +2095,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *t=
rans,
> =A0 =A0 =A0 =A0 * now that we've moved on to the tree of log tree roo=
ts,
> =A0 =A0 =A0 =A0 * check the full commit flag again
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (root->fs_info->last_trans_log_full_commit =3D=3D tr=
ans->transid) {
> + =A0 =A0 =A0 if (root->fs_info->last_trans_log_full_commit >=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 trans->transaction->transid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_wait_marked_extents(log, &log->d=
irty_log_pages, mark);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&log_root_tree->log_mutex=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EAGAIN;
> --
> 1.6.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Portions of this patch conflict with another patch recently posted to
the Mailing List by Josef.

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg11657.html

"[PATCH] Btrfs: kill the durable block rsv stuff" removes portions of
the functions btrfs_finish_extent_commit() and btrfs_free_tree_block()
in fs/btrfs/extent-tree.c that are modified in this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
