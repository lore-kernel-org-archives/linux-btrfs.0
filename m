From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: [PATCH] btrfs: fix printk format warnings
Date: Fri, 21 Nov 2008 01:18:02 +0000
Message-ID: <f058a9c30811201718l4fddea34ha9f4f0b0f153580b@mail.gmail.com>
References: <20081120223509.GF12456@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081120223509.GF12456@orion>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

On Thu, Nov 20, 2008 at 10:35 PM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> Is it reasonable to continue?
>
> ---
>
> Fix many warnings as
> warning: format '%Lu' expects type 'long long unsigned int', but argument 2 has type 'u64'
>

u64 is exactly that on any arch/gcc combination I know.

Shouldn't it be better to change the %Lu format to something that can
handle a simple typedef instead of all this
(unsigned long long) typecasting ?
I ask this ignorantly if such flag exists.

I simply find this kind of warnings (and fixes to respective warning)
frankly anyoing and counter productive.

Kind regads,


> Also add loglevel for printk().
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>
>  fs/btrfs/ctree.c       |   25 ++++++++++-------
>  fs/btrfs/extent-tree.c |   70 ++++++++++++++++++++++++++++-------------------
>  fs/btrfs/root-tree.c   |    8 +++--
>  fs/btrfs/super.c       |    6 ++--
>  4 files changed, 65 insertions(+), 44 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 71ef0a2..bc9328a 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -375,13 +375,15 @@ int noinline btrfs_cow_block(struct btrfs_trans_handle *trans,
>        int ret;
>
>        if (trans->transaction != root->fs_info->running_transaction) {
> -               printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
> +               printk(KERN_CRIT "trans %Lu running %Lu\n",
> +                      (unsigned long long)trans->transid, (unsigned long long)
>                       root->fs_info->running_transaction->transid);
>                WARN_ON(1);
>        }
>        if (trans->transid != root->fs_info->generation) {
> -               printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
> -                      root->fs_info->generation);
> +               printk(KERN_CRIT "trans %Lu running %Lu\n",
> +                      (unsigned long long)trans->transid,
> +                      (unsigned long long)root->fs_info->generation);
>                WARN_ON(1);
>        }
>
> @@ -490,13 +492,15 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
>                return 0;
>
>        if (trans->transaction != root->fs_info->running_transaction) {
> -               printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
> +               printk(KERN_CRIT "trans %Lu running %Lu\n",
> +                      (unsigned long long)trans->transid, (unsigned long long)
>                       root->fs_info->running_transaction->transid);
>                WARN_ON(1);
>        }
>        if (trans->transid != root->fs_info->generation) {
> -               printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
> -                      root->fs_info->generation);
> +               printk(KERN_CRIT "trans %Lu running %Lu\n",
> +                      (unsigned long long)trans->transid,
> +                      (unsigned long long)root->fs_info->generation);
>                WARN_ON(1);
>        }
>
> @@ -751,13 +755,14 @@ static int noinline check_block(struct btrfs_root *root,
>        u64 found_start;
>        return 0;
>        if (btrfs_header_level(path->nodes[level]) != level)
> -           printk("warning: bad level %Lu wanted %d found %d\n",
> -                  path->nodes[level]->start, level,
> +           printk(KERN_WARNING "warning: bad level %Lu wanted %d found %d\n",
> +                  (unsigned long long)path->nodes[level]->start, level,
>                   btrfs_header_level(path->nodes[level]));
>        found_start = btrfs_header_bytenr(path->nodes[level]);
>        if (found_start != path->nodes[level]->start) {
> -           printk("warning: bad bytentr %Lu found %Lu\n",
> -                  path->nodes[level]->start, found_start);
> +           printk(KERN_WARNING "warning: bad bytentr %Lu found %Lu\n",
> +                  (unsigned long long)path->nodes[level]->start,
> +                  (unsigned long long)found_start);
>        }
>  #if 0
>        struct extent_buffer *buf = path->nodes[level];
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a970472..efebe88 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -612,8 +612,9 @@ loop:
>            (ref_objectid != op->level &&
>             ref_objectid != BTRFS_MULTIPLE_OBJECTIDS)) {
>                printk(KERN_ERR "couldn't find %Lu, parent %Lu, root %Lu, "
> -                      "owner %u\n", op->bytenr, op->orig_parent,
> -                      ref_root, op->level);
> +                      "owner %u\n", (unsigned long long)op->bytenr,
> +                      (unsigned long long)op->orig_parent,
> +                      (unsigned long long)ref_root, op->level);
>                btrfs_print_leaf(extent_root, leaf);
>                BUG();
>        }
> @@ -943,10 +944,10 @@ search:
>                                    extent_root->root_key.objectid,
>                                    op->orig_generation, op->level, 1);
>        if (ret) {
> -               printk("Unable to find backref byte nr %Lu root %Lu gen %Lu "
> -                      "owner %u\n", op->bytenr,
> -                      extent_root->root_key.objectid, op->orig_generation,
> -                      op->level);
> +               printk(KERN_WARNING "Unable to find backref byte nr %Lu root "
> +                      "%Lu gen %Lu owner %u\n", (unsigned long long)op->bytenr,
> +                      (unsigned long long)extent_root->root_key.objectid,
> +                      (unsigned long long)op->orig_generation, op->level);
>                btrfs_print_leaf(extent_root, path->nodes[0]);
>                WARN_ON(1);
>                goto out;
> @@ -1314,7 +1315,9 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>        btrfs_item_key_to_cpu(l, &key, path->slots[0]);
>        if (key.objectid != bytenr) {
>                btrfs_print_leaf(root->fs_info->extent_root, path->nodes[0]);
> -               printk("wanted %Lu found %Lu\n", bytenr, key.objectid);
> +               printk(KERN_ERR "wanted %Lu found %Lu\n",
> +                      (unsigned long long)bytenr,
> +                      (unsigned long long)key.objectid);
>                BUG();
>        }
>        BUG_ON(key.type != BTRFS_EXTENT_ITEM_KEY);
> @@ -1385,7 +1388,8 @@ int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
>                goto out;
>        if (ret != 0) {
>                btrfs_print_leaf(root, path->nodes[0]);
> -               printk("failed to find block number %Lu\n", bytenr);
> +               printk(KERN_ERR "failed to find block number %Lu\n",
> +                      (unsigned long long)bytenr);
>                BUG();
>        }
>        l = path->nodes[0];
> @@ -1940,7 +1944,8 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>
>        ret = btrfs_alloc_chunk(trans, extent_root, flags);
>        if (ret) {
> -printk("space info full %Lu\n", flags);
> +               printk(KERN_INFO "space info full %Lu\n",
> +                      (unsigned long long)flags);
>                space_info->full = 1;
>        }
>  out:
> @@ -2418,7 +2423,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>                        if (ret) {
>                                printk(KERN_ERR "umm, got %d back from search"
>                                       ", was looking for %Lu\n", ret,
> -                                      bytenr);
> +                                      (unsigned long long)bytenr);
>                                btrfs_print_leaf(extent_root, path->nodes[0]);
>                        }
>                        BUG_ON(ret);
> @@ -2427,9 +2432,11 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>        } else {
>                btrfs_print_leaf(extent_root, path->nodes[0]);
>                WARN_ON(1);
> -               printk("Unable to find ref byte nr %Lu root %Lu "
> -                      "gen %Lu owner %Lu\n", bytenr,
> -                      root_objectid, ref_generation, owner_objectid);
> +               printk(KERN_WARNING "Unable to find ref byte nr %Lu root %Lu "
> +                      "gen %Lu owner %Lu\n", (unsigned long long)bytenr,
> +                      (unsigned long long)root_objectid,
> +                      (unsigned long long)ref_generation,
> +                      (unsigned long long)owner_objectid);
>        }
>
>        leaf = path->nodes[0];
> @@ -3005,7 +3012,9 @@ loop_check:
>                ret = 0;
>        } else if (!ret) {
>                printk(KERN_ERR "we were searching for %Lu bytes, num_bytes %Lu,"
> -                      " loop %d, allowed_alloc %d\n", total_needed, num_bytes,
> +                      " loop %d, allowed_alloc %d\n",
> +                      (unsigned long long)total_needed,
> +                      (unsigned long long)num_bytes,
>                       loop, allowed_chunk_alloc);
>                ret = -ENOSPC;
>        }
> @@ -3020,8 +3029,9 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
>        struct list_head *l;
>
>        printk(KERN_INFO "space_info has %Lu free, is %sfull\n",
> -              info->total_bytes - info->bytes_used - info->bytes_pinned -
> -              info->bytes_reserved, (info->full) ? "" : "not ");
> +              (unsigned long long)(info->total_bytes - info->bytes_used -
> +              info->bytes_pinned - info->bytes_reserved),
> +              (info->full) ? "" : "not ");
>
>        down_read(&info->groups_sem);
>        list_for_each(l, &info->block_groups) {
> @@ -3029,9 +3039,11 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
>                spin_lock(&cache->lock);
>                printk(KERN_INFO "block group %Lu has %Lu bytes, %Lu used "
>                       "%Lu pinned %Lu reserved\n",
> -                      cache->key.objectid, cache->key.offset,
> -                      btrfs_block_group_used(&cache->item),
> -                      cache->pinned, cache->reserved);
> +                      (unsigned long long)cache->key.objectid,
> +                      (unsigned long long)cache->key.offset,
> +                      (unsigned long long)btrfs_block_group_used(&cache->item),
> +                      (unsigned long long)cache->pinned,
> +                      (unsigned long long)cache->reserved);
>                btrfs_dump_free_space(cache, bytes);
>                spin_unlock(&cache->lock);
>        }
> @@ -3099,8 +3111,8 @@ again:
>                struct btrfs_space_info *sinfo;
>
>                sinfo = __find_space_info(root->fs_info, data);
> -               printk("allocation failed flags %Lu, wanted %Lu\n",
> -                      data, num_bytes);
> +               printk(KERN_ERR "allocation failed flags %Lu, wanted %Lu\n",
> +                      (unsigned long long)data, (unsigned long long)num_bytes);
>                dump_space_info(sinfo, num_bytes);
>                BUG();
>        }
> @@ -3114,7 +3126,8 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
>
>        cache = btrfs_lookup_block_group(root->fs_info, start);
>        if (!cache) {
> -               printk(KERN_ERR "Unable to find block group for %Lu\n", start);
> +               printk(KERN_ERR "Unable to find block group for %Lu\n",
> +                      (unsigned long long)start);
>                return -ENOSPC;
>        }
>        btrfs_add_free_space(cache, start, len);
> @@ -3238,8 +3251,9 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
>  update_block:
>        ret = update_block_group(trans, root, ins->objectid, ins->offset, 1, 0);
>        if (ret) {
> -               printk("update block group failed for %Lu %Lu\n",
> -                      ins->objectid, ins->offset);
> +               printk(KERN_ERR "update block group failed for %Lu %Lu\n",
> +                      (unsigned long long)ins->objectid,
> +                      (unsigned long long)ins->offset);
>                BUG();
>        }
>  out:
> @@ -3577,8 +3591,8 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
>                                break;
>                        }
>                        if (printk_ratelimit()) {
> -                               printk("leaf ref miss for bytenr %llu\n",
> -                                      (unsigned long long)bytenr);
> +                               printk(KERN_INFO "leaf ref miss for bytenr"
> +                                      " %llu\n", (unsigned long long)bytenr);
>                        }
>                }
>                next = btrfs_find_tree_block(root, bytenr, blocksize);
> @@ -5578,7 +5592,7 @@ int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start)
>        block_group = btrfs_lookup_block_group(info, group_start);
>        BUG_ON(!block_group);
>
> -       printk("btrfs relocating block group %llu flags %llu\n",
> +       printk(KERN_INFO "btrfs relocating block group %llu flags %llu\n",
>               (unsigned long long)block_group->key.objectid,
>               (unsigned long long)block_group->flags);
>
> @@ -5674,7 +5688,7 @@ next:
>        }
>
>        if (total_found > 0) {
> -               printk("btrfs found %llu extents in pass %d\n",
> +               printk(KERN_INFO "btrfs found %llu extents in pass %d\n",
>                       (unsigned long long)total_found, pass);
>                pass++;
>                if (total_found == skipped && pass > 2) {
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index dbe20d4..1eed223 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -132,8 +132,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>
>        if (ret != 0) {
>                btrfs_print_leaf(root, path->nodes[0]);
> -               printk("unable to update root key %Lu %u %Lu\n",
> -                      key->objectid, key->type, key->offset);
> +               printk(KERN_ERR "unable to update root key %Lu %u %Lu\n",
> +                      (unsigned long long)key->objectid, key->type,
> +                      (unsigned long long)key->offset);
>                BUG_ON(1);
>        }
>
> @@ -260,7 +261,8 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>                goto out;
>        if (ret) {
>  btrfs_print_leaf(root, path->nodes[0]);
> -printk("failed to del %Lu %u %Lu\n", key->objectid, key->type, key->offset);
> +printk(KER_ERR "failed to del %Lu %u %Lu\n", (unsigned long long)key->objectid, key->type,
> +(unsigned long long)key->offset);
>
>        }
>        BUG_ON(ret != 0);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 1975ea2..810e9a7 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -197,7 +197,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>                                info->max_extent = max_t(u64,
>                                        info->max_extent, root->sectorsize);
>                                printk(KERN_INFO "btrfs: max_extent at %llu\n",
> -                                      info->max_extent);
> +                                      (unsigned long long)info->max_extent);
>                        }
>                        break;
>                case Opt_max_inline:
> @@ -212,7 +212,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>                                                root->sectorsize);
>                                }
>                                printk(KERN_INFO "btrfs: max_inline at %llu\n",
> -                                       info->max_inline);
> +                                       (unsigned long long)info->max_inline);
>                        }
>                        break;
>                case Opt_alloc_start:
> @@ -222,7 +222,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>                                kfree(num);
>                                printk(KERN_INFO
>                                        "btrfs: allocations start at %llu\n",
> -                                       info->alloc_start);
> +                                       (unsigned long long)info->alloc_start);
>                        }
>                        break;
>                case Opt_noacl:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Miguel Sousa Filipe
