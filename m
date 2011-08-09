From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: kill the durable block rsv stuff
Date: Tue, 9 Aug 2011 12:25:20 -0500
Message-ID: <CAKcLGm8AY86jpyi6Xw7OnKA_esrCT0hWf4hjfkiAO4_bs8SB2A@mail.gmail.com>
References: <1312827675-16190-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312827675-16190-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 8, 2011 at 1:21 PM, Josef Bacik <josef@redhat.com> wrote:
> This is confusing code and isn't used by anything anymore, so delete =
it.
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 | =A0 11 -----
> =A0fs/btrfs/disk-io.c =A0 =A0 | =A0 =A02 -
> =A0fs/btrfs/extent-tree.c | =A0100 ++++++++--------------------------=
-------------
> =A0fs/btrfs/inode.c =A0 =A0 =A0 | =A0 =A04 --
> =A0fs/btrfs/relocation.c =A0| =A0 =A01 -
> =A05 files changed, 17 insertions(+), 101 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9a2db9e..6071dab 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -772,13 +772,10 @@ struct btrfs_space_info {
> =A0struct btrfs_block_rsv {
> =A0 =A0 =A0 =A0u64 size;
> =A0 =A0 =A0 =A0u64 reserved;
> - =A0 =A0 =A0 u64 freed[2];
> =A0 =A0 =A0 =A0struct btrfs_space_info *space_info;
> - =A0 =A0 =A0 struct list_head list;
> =A0 =A0 =A0 =A0spinlock_t lock;
> =A0 =A0 =A0 =A0atomic_t usage;
> =A0 =A0 =A0 =A0unsigned int priority:8;
> - =A0 =A0 =A0 unsigned int durable:1;
> =A0 =A0 =A0 =A0unsigned int refill_used:1;
> =A0 =A0 =A0 =A0unsigned int full:1;
> =A0};
> @@ -840,7 +837,6 @@ struct btrfs_block_group_cache {
> =A0 =A0 =A0 =A0spinlock_t lock;
> =A0 =A0 =A0 =A0u64 pinned;
> =A0 =A0 =A0 =A0u64 reserved;
> - =A0 =A0 =A0 u64 reserved_pinned;
> =A0 =A0 =A0 =A0u64 bytes_super;
> =A0 =A0 =A0 =A0u64 flags;
> =A0 =A0 =A0 =A0u64 sectorsize;
> @@ -919,11 +915,6 @@ struct btrfs_fs_info {
>
> =A0 =A0 =A0 =A0struct btrfs_block_rsv empty_block_rsv;
>
> - =A0 =A0 =A0 /* list of block reservations that cross multiple trans=
actions */
> - =A0 =A0 =A0 struct list_head durable_block_rsv_list;
> -
> - =A0 =A0 =A0 struct mutex durable_block_rsv_mutex;
> -
> =A0 =A0 =A0 =A0u64 generation;
> =A0 =A0 =A0 =A0u64 last_trans_committed;
>
> @@ -2240,8 +2231,6 @@ void btrfs_init_block_rsv(struct btrfs_block_rs=
v *rsv);
> =A0struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *r=
oot);
> =A0void btrfs_free_block_rsv(struct btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_block=
_rsv *rsv);
> -void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct btrfs_block_rsv *rsv);
> =A0int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_block_rsv=
 *block_rsv,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 07b3ac6..0b5643a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1665,8 +1665,6 @@ struct btrfs_root *open_ctree(struct super_bloc=
k *sb,
> =A0 =A0 =A0 =A0btrfs_init_block_rsv(&fs_info->trans_block_rsv);
> =A0 =A0 =A0 =A0btrfs_init_block_rsv(&fs_info->chunk_block_rsv);
> =A0 =A0 =A0 =A0btrfs_init_block_rsv(&fs_info->empty_block_rsv);
> - =A0 =A0 =A0 INIT_LIST_HEAD(&fs_info->durable_block_rsv_list);
> - =A0 =A0 =A0 mutex_init(&fs_info->durable_block_rsv_mutex);
> =A0 =A0 =A0 =A0atomic_set(&fs_info->nr_async_submits, 0);
> =A0 =A0 =A0 =A0atomic_set(&fs_info->async_delalloc_pages, 0);
> =A0 =A0 =A0 =A0atomic_set(&fs_info->async_submit_draining, 0);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d30e0b4..fc2686c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -121,7 +121,6 @@ void btrfs_put_block_group(struct btrfs_block_gro=
up_cache *cache)
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&cache->count)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(cache->pinned > 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(cache->reserved > 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(cache->reserved_pinned > 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(cache->free_space_ctl);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(cache);
> =A0 =A0 =A0 =A0}
> @@ -3662,7 +3661,6 @@ void btrfs_init_block_rsv(struct btrfs_block_rs=
v *rsv)
> =A0 =A0 =A0 =A0spin_lock_init(&rsv->lock);
> =A0 =A0 =A0 =A0atomic_set(&rsv->usage, 1);
> =A0 =A0 =A0 =A0rsv->priority =3D 6;
> - =A0 =A0 =A0 INIT_LIST_HEAD(&rsv->list);
> =A0}
>
> =A0struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *r=
oot)
> @@ -3685,25 +3683,10 @@ void btrfs_free_block_rsv(struct btrfs_root *=
root,
> =A0{
> =A0 =A0 =A0 =A0if (rsv && atomic_dec_and_test(&rsv->usage)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_block_rsv_release(root, rsv, (u6=
4)-1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rsv->durable)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(rsv);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(rsv);
> =A0 =A0 =A0 =A0}
> =A0}
>
> -/*
> - * make the block_rsv struct be able to capture freed space.
> - * the captured space will re-add to the the block_rsv struct
> - * after transaction commit
> - */
> -void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct btrfs_block_rsv *block_rsv)
> -{
> - =A0 =A0 =A0 block_rsv->durable =3D 1;
> - =A0 =A0 =A0 mutex_lock(&fs_info->durable_block_rsv_mutex);
> - =A0 =A0 =A0 list_add_tail(&block_rsv->list, &fs_info->durable_block=
_rsv_list);
> - =A0 =A0 =A0 mutex_unlock(&fs_info->durable_block_rsv_mutex);
> -}
> -
> =A0int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_root *roo=
t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_block_rsv=
 *block_rsv,
> @@ -3745,9 +3728,7 @@ int btrfs_block_rsv_check(struct btrfs_trans_ha=
ndle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 0;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_bytes -=3D block_rsv->reserved;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block_rsv->durable &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv->freed[0] + block_rsv=
->freed[1] >=3D num_bytes)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 commit_trans =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 commit_trans =3D 1;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&block_rsv->lock);
> =A0 =A0 =A0 =A0if (!ret)
> @@ -3763,8 +3744,18 @@ int btrfs_block_rsv_check(struct btrfs_trans_h=
andle *trans,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (commit_trans) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct btrfs_space_info *sinfo =3D bloc=
k_rsv->space_info;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (trans)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EAGAIN;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&sinfo->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sinfo->bytes_pinned < num_bytes) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sinfo->loc=
k);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSPC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sinfo->lock);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0trans =3D btrfs_join_transaction(root)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(IS_ERR(trans));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_commit_transaction(trans=
, root);
> @@ -3885,10 +3876,6 @@ static void init_global_block_rsv(struct btrfs=
_fs_info *fs_info)
> =A0 =A0 =A0 =A0fs_info->tree_root->block_rsv =3D &fs_info->global_blo=
ck_rsv;
> =A0 =A0 =A0 =A0fs_info->chunk_root->block_rsv =3D &fs_info->chunk_blo=
ck_rsv;
>
> - =A0 =A0 =A0 btrfs_add_durable_block_rsv(fs_info, &fs_info->global_b=
lock_rsv);
> -
> - =A0 =A0 =A0 btrfs_add_durable_block_rsv(fs_info, &fs_info->delalloc=
_block_rsv);
> -
> =A0 =A0 =A0 =A0update_global_block_rsv(fs_info);
> =A0}
>
> @@ -4447,13 +4434,8 @@ static int unpin_extent_range(struct btrfs_roo=
t *root, u64 start, u64 end)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&cache->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->pinned -=3D len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->space_info->bytes_pinned -=3D l=
en;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cache->ro) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cache->ro)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->space_info->byt=
es_readonly +=3D len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (cache->reserved_pinned > 0) =
{
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D min(len, cache-=
>reserved_pinned);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cache->reserved_pinned =
-=3D len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cache->space_info->byte=
s_may_use +=3D len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&cache->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&cache->space_info->lock);
> =A0 =A0 =A0 =A0}
> @@ -4468,11 +4450,8 @@ int btrfs_finish_extent_commit(struct btrfs_tr=
ans_handle *trans,
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_fs_info *fs_info =3D root->fs_info;
> =A0 =A0 =A0 =A0struct extent_io_tree *unpin;
> - =A0 =A0 =A0 struct btrfs_block_rsv *block_rsv;
> - =A0 =A0 =A0 struct btrfs_block_rsv *next_rsv;
> =A0 =A0 =A0 =A0u64 start;
> =A0 =A0 =A0 =A0u64 end;
> - =A0 =A0 =A0 int idx;
> =A0 =A0 =A0 =A0int ret;
>
> =A0 =A0 =A0 =A0if (fs_info->pinned_extents =3D=3D &fs_info->freed_ext=
ents[0])
> @@ -4495,30 +4474,6 @@ int btrfs_finish_extent_commit(struct btrfs_tr=
ans_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cond_resched();
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 mutex_lock(&fs_info->durable_block_rsv_mutex);
> - =A0 =A0 =A0 list_for_each_entry_safe(block_rsv, next_rsv,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fs_=
info->durable_block_rsv_list, list) {
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D trans->transid & 0x1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block_rsv->freed[idx] > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv_add_bytes(blo=
ck_rsv,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 block_rsv->freed[idx], 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv->freed[idx] =3D=
 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&block_rsv->usage) =3D=3D=
 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_block_rsv_release=
(root, block_rsv, (u64)-1);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block_rsv->freed[0]=
 =3D=3D 0 &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv->free=
d[1] =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_de=
l_init(&block_rsv->list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(b=
lock_rsv);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_block_rsv_release=
(root, block_rsv, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 mutex_unlock(&fs_info->durable_block_rsv_mutex);
> -
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -4820,36 +4775,18 @@ void btrfs_free_tree_block(struct btrfs_trans=
_handle *trans,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (root->root_key.objectid !=3D BTRFS=
_TREE_LOG_OBJECTID) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D check_ref_clea=
nup(trans, root, buf->start);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto pi=
n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (btrfs_header_flag(buf, BTRFS_HEADE=
R_FLAG_WRITTEN)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pin_down_extent(root, =
cache, buf->start, buf->len, 1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto pin;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, =
&buf->bflags));
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_add_free_space(cache, buf->start=
, buf->len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_update_reserved_bytes(cache, buf=
->len, RESERVE_FREE);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> -pin:
> - =A0 =A0 =A0 if (block_rsv->durable && !cache->ro) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cache->lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cache->ro) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cache->reserved_pinned =
+=3D buf->len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cache->lock);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&block_rsv->l=
ock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_rsv->freed[trans-=
>transid & 0x1] +=3D buf->len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&block_rsv-=
>lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0}
> =A0out:
> =A0 =A0 =A0 =A0/*
> @@ -6699,12 +6636,9 @@ static int set_block_group_ro(struct btrfs_blo=
ck_group_cache *cache, int force)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->bytes_super - btrfs_blo=
ck_group_used(&cache->item);
>
> =A0 =A0 =A0 =A0if (sinfo->bytes_used + sinfo->bytes_reserved + sinfo-=
>bytes_pinned +
> - =A0 =A0 =A0 =A0 =A0 sinfo->bytes_may_use + sinfo->bytes_readonly +
> - =A0 =A0 =A0 =A0 =A0 cache->reserved_pinned + num_bytes + min_alloca=
ble_bytes <=3D
> - =A0 =A0 =A0 =A0 =A0 sinfo->total_bytes) {
> + =A0 =A0 =A0 =A0 =A0 sinfo->bytes_may_use + sinfo->bytes_readonly + =
num_bytes +
> + =A0 =A0 =A0 =A0 =A0 min_allocable_bytes <=3D sinfo->total_bytes) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sinfo->bytes_readonly +=3D num_bytes;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sinfo->bytes_may_use +=3D cache->reserv=
ed_pinned;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cache->reserved_pinned =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cache->ro =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 0;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 91d851c..54b11ad 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2164,9 +2164,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle =
*trans, struct inode *inode)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&root->orphan_lock);
>
> - =A0 =A0 =A0 if (block_rsv)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_add_durable_block_rsv(root->fs_in=
fo, block_rsv);
> -
> =A0 =A0 =A0 =A0/* grab metadata reservation from transaction handle *=
/
> =A0 =A0 =A0 =A0if (reserve) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_orphan_reserve_metadata(=
trans, inode);
> @@ -6495,7 +6492,6 @@ static int btrfs_truncate(struct inode *inode)
> =A0 =A0 =A0 =A0rsv =3D btrfs_alloc_block_rsv(root);
> =A0 =A0 =A0 =A0if (!rsv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> - =A0 =A0 =A0 btrfs_add_durable_block_rsv(root->fs_info, rsv);
>
> =A0 =A0 =A0 =A0trans =3D btrfs_start_transaction(root, 4);
> =A0 =A0 =A0 =A0if (IS_ERR(trans)) {
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 59bb176..545b043 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3651,7 +3651,6 @@ int prepare_to_relocate(struct reloc_control *r=
c)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
>
> =A0 =A0 =A0 =A0rc->block_rsv->refill_used =3D 1;
> - =A0 =A0 =A0 btrfs_add_durable_block_rsv(rc->extent_root->fs_info, r=
c->block_rsv);
>
> =A0 =A0 =A0 =A0memset(&rc->cluster, 0, sizeof(rc->cluster));
> =A0 =A0 =A0 =A0rc->search_start =3D rc->block_group->key.objectid;
> --
> 1.7.5.2
>
> --

Portions of this patch conflict with part of the sub transaction
patches submitted recently bu Lui Bo to the Mailing List.

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg11628.html

"[PATCH 02/12 v5] Btrfs: introduce sub transaction stuff" modifies
portions of the functions btrfs_finish_extent_commit() and
btrfs_free_tree_block() in fs/btrfs/extent-tree.c that are removed in
this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
