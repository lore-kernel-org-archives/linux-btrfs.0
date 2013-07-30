Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:32849 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G3PLl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 11:11:41 -0400
Received: by mail-wi0-f177.google.com with SMTP id hq12so3788917wib.10
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 08:11:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366741222-1825-1-git-send-email-jbacik@fusionio.com>
References: <1366741222-1825-1-git-send-email-jbacik@fusionio.com>
Date: Tue, 30 Jul 2013 18:11:39 +0300
Message-ID: <CAOcd+r1JhTKCTp4zmj9Yy-ASjKPjaRsGk8uhxGYM6zPOwbsA6w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix all callers of read_tree_block
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Tue, Apr 23, 2013 at 9:20 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> We kept leaking extent buffers when mounting a broken file system and it turns
> out it's because not everybody uses read_tree_block properly.  You need to check
> and make sure the extent_buffer is uptodate before you use it.  This patch fixes
> everybody who calls read_tree_block directly to make sure they check that it is
> uptodate and free it and return an error if it is not.  With this we no longer
> leak EB's when things go horribly wrong.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/backref.c     |   10 ++++++++--
>  fs/btrfs/ctree.c       |   21 ++++++++++++++++-----
>  fs/btrfs/disk-io.c     |   19 +++++++++++++++++--
>  fs/btrfs/extent-tree.c |    4 +++-
>  fs/btrfs/relocation.c  |   18 +++++++++++++++---
>  5 files changed, 59 insertions(+), 13 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 23e927b..04b5b30 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -423,7 +423,10 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
>                 BUG_ON(!ref->wanted_disk_byte);
>                 eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
>                                      fs_info->tree_root->leafsize, 0);
> -               BUG_ON(!eb);
> +               if (!eb || !extent_buffer_uptodate(eb)) {
> +                       free_extent_buffer(eb);
> +                       return -EIO;
> +               }
>                 btrfs_tree_read_lock(eb);
>                 if (btrfs_header_level(eb) == 0)
>                         btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0);
> @@ -913,7 +916,10 @@ again:
>                                                         info_level);
>                                 eb = read_tree_block(fs_info->extent_root,
>                                                            ref->parent, bsz, 0);
> -                               BUG_ON(!eb);
> +                               if (!eb || !extent_buffer_uptodate(eb)) {
> +                                       free_extent_buffer(eb);
> +                                       return -EIO;
> +                               }
>                                 ret = find_extent_in_eb(eb, bytenr,
>                                                         *extent_item_pos, &eie);
>                                 ref->inode_list = eie;
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 566d99b..2bc3440 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1281,7 +1281,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>                 free_extent_buffer(eb_root);
>                 blocksize = btrfs_level_size(root, old_root->level);
>                 old = read_tree_block(root, logical, blocksize, 0);
> -               if (!old) {
> +               if (!old || !extent_buffer_uptodate(old)) {
> +                       free_extent_buffer(old);
>                         pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
>                                 logical);
>                         WARN_ON(1);
> @@ -1526,8 +1527,10 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
>                         if (!cur) {
>                                 cur = read_tree_block(root, blocknr,
>                                                          blocksize, gen);
> -                               if (!cur)
> +                               if (!cur || !extent_buffer_uptodate(cur)) {
> +                                       free_extent_buffer(cur);
>                                         return -EIO;
> +                               }
>                         } else if (!uptodate) {
>                                 err = btrfs_read_buffer(cur, gen);
>                                 if (err) {
> @@ -1692,6 +1695,8 @@ static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
>                                    struct extent_buffer *parent, int slot)
>  {
>         int level = btrfs_header_level(parent);
> +       struct extent_buffer *eb;
> +
>         if (slot < 0)
>                 return NULL;
>         if (slot >= btrfs_header_nritems(parent))
> @@ -1699,9 +1704,15 @@ static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
>
>         BUG_ON(level == 0);
>
> -       return read_tree_block(root, btrfs_node_blockptr(parent, slot),
> -                      btrfs_level_size(root, level - 1),
> -                      btrfs_node_ptr_generation(parent, slot));
> +       eb = read_tree_block(root, btrfs_node_blockptr(parent, slot),
> +                            btrfs_level_size(root, level - 1),
> +                            btrfs_node_ptr_generation(parent, slot));
> +       if (eb && !extent_buffer_uptodate(eb)) {
> +               free_extent_buffer(eb);
> +               eb = NULL;
> +       }
> +
> +       return eb;
>  }
>
>  /*
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index fb0e5c2..4605cc7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1534,6 +1534,14 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
>         blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
>         root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
>                                      blocksize, generation);
> +       if (!root->node || !extent_buffer_uptodate(root->node)) {
> +               ret = (!root->node) ? -ENOMEM : -EIO;
> +
> +               free_extent_buffer(root->node);
> +               kfree(root);
> +               return ERR_PTR(ret);
> +       }
> +
>         root->commit_root = btrfs_root_node(root);
>         BUG_ON(!root->node); /* -ENOMEM */
>  out:
> @@ -2572,8 +2580,8 @@ int open_ctree(struct super_block *sb,
>         chunk_root->node = read_tree_block(chunk_root,
>                                            btrfs_super_chunk_root(disk_super),
>                                            blocksize, generation);
> -       BUG_ON(!chunk_root->node); /* -ENOMEM */
> -       if (!test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
> +       if (!chunk_root->node ||
> +           !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
>                 printk(KERN_WARNING "btrfs: failed to read chunk root on %s\n",
>                        sb->s_id);
>                 goto fail_tree_roots;
> @@ -2758,6 +2766,13 @@ retry_root_backup:
>                 log_tree_root->node = read_tree_block(tree_root, bytenr,
>                                                       blocksize,
>                                                       generation + 1);
> +               if (!log_tree_root->node ||
> +                   !extent_buffer_uptodate(log_tree_root->node)) {
> +                       printk(KERN_ERR "btrfs: failed to read log tree\n");
> +                       free_extent_buffer(log_tree_root->node);
> +                       kfree(log_tree_root);
> +                       goto fail_trans_kthread;
> +               }
>                 /* returns with log_tree_root freed on success */
>                 ret = btrfs_recover_log_trees(log_tree_root);
>                 if (ret) {
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 10a980c..ea92671 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7103,8 +7103,10 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>                 if (reada && level == 1)
>                         reada_walk_down(trans, root, wc, path);
>                 next = read_tree_block(root, bytenr, blocksize, generation);
> -               if (!next)
> +               if (!next || !extent_buffer_uptodate(next)) {
> +                       free_extent_buffer(next);
>                         return -EIO;
> +               }
>                 btrfs_tree_lock(next);
>                 btrfs_set_lock_blocking(next);
>         }
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index a5955e8..ed568e3 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1771,7 +1771,11 @@ again:
>
>                         eb = read_tree_block(dest, old_bytenr, blocksize,
>                                              old_ptr_gen);
> -                       BUG_ON(!eb);
> +                       if (!eb || !extent_buffer_uptodate(eb)) {
> +                               ret = (!eb) ? -ENOMEM : -EIO;
> +                               free_extent_buffer(eb);
> +                               return ret;
> +                       }
>                         btrfs_tree_lock(eb);
>                         if (cow) {
>                                 ret = btrfs_cow_block(trans, dest, eb, parent,
> @@ -1924,6 +1928,10 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
>                 bytenr = btrfs_node_blockptr(eb, path->slots[i]);
>                 blocksize = btrfs_level_size(root, i - 1);
>                 eb = read_tree_block(root, bytenr, blocksize, ptr_gen);
> +               if (!eb || !extent_buffer_uptodate(eb)) {
> +                       free_extent_buffer(eb);
> +                       return -EIO;
> +               }
>                 BUG_ON(btrfs_header_level(eb) != i - 1);
>                 path->nodes[i - 1] = eb;
>                 path->slots[i - 1] = 0;
> @@ -2601,7 +2609,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>                 blocksize = btrfs_level_size(root, node->level);
>                 generation = btrfs_node_ptr_generation(upper->eb, slot);
>                 eb = read_tree_block(root, bytenr, blocksize, generation);
> -               if (!eb) {
> +               if (!eb || !extent_buffer_uptodate(eb)) {
> +                       free_extent_buffer(eb);
>                         err = -EIO;
>                         goto next;
>                 }
> @@ -2762,7 +2771,10 @@ static int get_tree_block_key(struct reloc_control *rc,
>         BUG_ON(block->key_ready);
>         eb = read_tree_block(rc->extent_root, block->bytenr,
>                              block->key.objectid, block->key.offset);
> -       BUG_ON(!eb);
> +       if (!eb || !extent_buffer_uptodate(eb)) {
> +               free_extent_buffer(eb);
> +               return -EIO;
> +       }
>         WARN_ON(btrfs_header_level(eb) != block->level);
>         if (block->level == 0)
>                 btrfs_item_key_to_cpu(eb, &block->key, 0);
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Without this fix, we are seeing crashes when
btree_read_extent_buffer_pages() fails to read the page, because of IO
error. We see warnings like [1], [2], eventually leading to crash like
[3].

However, with this fix in place we can also crash; for example, in
btrfs_search_old_slot():
...
	b = get_old_root(root, time_seq);
	level = btrfs_header_level(b);

The fixed get_old_root() can experience an IO error in
read_tree_block(), and them "b" will be NULL, so we will crash,
correct? Then again, your patch was intended to fix only the callers
of read_tree_block, not the callers' callers:)

Thanks,
Alex.

[1]
WARNING: at /mnt/share/builds/3.8.13-030813-generic/2013-07-30_09-48-06/src/zadara-btrfs/fs/btrfs/extent_io.c:4765
map_private_extent_buffer+0xd4/0xe0 [btrfs]()
Hardware name: Bochs
btrfs bad mapping eb start 225941446656 len 4096, wanted 18446744041103806434 4
 rmd160 crypto_null af_key xfrm_algo kvm scst_vdisk(OF) iscsi_scst(OF)
scst(OF) libcrc32c microcode psmouse nls_iso8859_1 serio_raw
virtio_balloon cirrus ttm nfsd(OF) nfs_acl auth_rpcgss drm_kms_helper
nfs fscache lockd sunrpc drm sysimgblt sysfillrect syscopyarea
i2c_piix4 lp mac_hid parport floppy [last unloaded: ixgbevf]
Pid: 11027, comm: kworker/u:213 Tainted: GF          O
3.8.13-030813-generic #201305111843
Call Trace:
[<ffffffff8105990f>] warn_slowpath_common+0x7f/0xc0
[<ffffffff81059a06>] warn_slowpath_fmt+0x46/0x50
[<ffffffffa045fba4>] map_private_extent_buffer+0xd4/0xe0 [btrfs]
[<ffffffffa0455534>] btrfs_get_token_32+0x64/0xf0 [btrfs]
[<ffffffffa040f640>] leaf_space_used+0xe0/0x110 [btrfs]
[<ffffffffa04158f4>] btrfs_leaf_free_space+0x64/0xb0 [btrfs]
[<ffffffffa0416a22>] push_leaf_right+0xf2/0x1a0 [btrfs]
[<ffffffffa04171a1>] split_leaf+0x5e1/0x770 [btrfs]
[<ffffffffa0417e05>] btrfs_search_slot+0x785/0x820 [btrfs]
[<ffffffffa0419a8c>] btrfs_insert_empty_items+0x7c/0x120 [btrfs]
[<ffffffffa042fc7c>] btrfs_insert_bv_file_extent+0x7c/0x140 [btrfs]
[<ffffffffa04a86d6>] zbtrfs_blk_virt_chunk_migr_completed+0x4e6/0x8e0 [btrfs]
[<ffffffffa0535306>] dm_btrfs_chunk_migration_complete+0xc6/0x230 [dm_btrfs]
[<ffffffff81078b81>] process_one_work+0x141/0x490
[<ffffffff81079b48>] worker_thread+0x168/0x400
[<ffffffff8107f050>] kthread+0xc0/0xd0
[<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0

0x59ba4 is in map_private_extent_buffer
(/mnt/work/alex/zadara-btrfs-fixes/fs/btrfs/extent_io.c:4766).
4761
4762            if (start + min_len > eb->len) {
4763                    WARN(1, KERN_ERR "btrfs bad mapping eb start
%llu len %lu, "
4764                           "wanted %lu %lu\n", (unsigned long
long)eb->start,
4765                           eb->len, start, min_len);
4766                    return -EINVAL;
4767            }
4768
4769            p = extent_buffer_page(eb, i);
4770            kaddr = page_address(p);

The print was: btrfs bad mapping eb start 225941446656 len 4096,
wanted 18446744041103806434 4
BTW, I don't understand how "start" can be bad here?

This means that in
u32 btrfs_get_token_32(struct extent_buffer *eb, void *ptr, unsigned
long off, struct btrfs_map_token *token)
"ptr" or "off" are bad.
But "off" comes from offsetof expression, so "ptr" must be bad,
But in leaf_space_used() where it crashed we have:

start_item = btrfs_item_nr(l, start);
end_item = btrfs_item_nr(l, end);

data_len = btrfs_token_item_offset(l, start_item, &token) +
    btrfs_token_item_size(l, start_item, &token);

So "start_item" must be bad, but start_item depends only on "start"
(not on "l"). But in our case, btrfs_leaf_free_space() calls:
ret = BTRFS_LEAF_DATA_SIZE(root) - leaf_space_used(leaf, 0, nritems);
so "start" is 0...

[2]
WARNING: at /mnt/share/builds/3.8.13-030813-generic/2013-07-30_09-48-06/src/zadara-btrfs/fs/btrfs/extent_io.c:4719
read_extent_buffer+0xe5/0x120 [btrfs]()
Hardware name: Bochs
 rmd160 crypto_null af_key xfrm_algo kvm scst_vdisk(OF) iscsi_scst(OF)
scst(OF) libcrc32c microcode psmouse nls_iso8859_1 serio_raw
virtio_balloon cirrus ttm nfsd(OF) nfs_acl auth_rpcgss drm_kms_helper
nfs fscache lockd sunrpc drm sysimgblt sysfillrect syscopyarea
i2c_piix4 lp mac_hid parport floppy [last unloaded: ixgbevf]
Pid: 11027, comm: kworker/u:213 Tainted: GF       W  O
3.8.13-030813-generic #201305111843
Call Trace:
[<ffffffff8105990f>] warn_slowpath_common+0x7f/0xc0
[<ffffffff8105996a>] warn_slowpath_null+0x1a/0x20
[<ffffffffa045fa95>] read_extent_buffer+0xe5/0x120 [btrfs]
[<ffffffffa04555ac>] btrfs_get_token_32+0xdc/0xf0 [btrfs]
[<ffffffffa040f640>] leaf_space_used+0xe0/0x110 [btrfs]
[<ffffffffa04158f4>] btrfs_leaf_free_space+0x64/0xb0 [btrfs]
[<ffffffffa0416a22>] push_leaf_right+0xf2/0x1a0 [btrfs]
[<ffffffffa04171a1>] split_leaf+0x5e1/0x770 [btrfs]
[<ffffffffa0417e05>] btrfs_search_slot+0x785/0x820 [btrfs]
[<ffffffffa0419a8c>] btrfs_insert_empty_items+0x7c/0x120 [btrfs]
[<ffffffffa042fc7c>] btrfs_insert_bv_file_extent+0x7c/0x140 [btrfs]
[<ffffffffa04a86d6>] zbtrfs_blk_virt_chunk_migr_completed+0x4e6/0x8e0 [btrfs]
[<ffffffffa0535306>] dm_btrfs_chunk_migration_complete+0xc6/0x230 [dm_btrfs]
[<ffffffff81078b81>] process_one_work+0x141/0x490
[<ffffffff81079b48>] worker_thread+0x168/0x400
[<ffffffff8107f050>] kthread+0xc0/0xd0
[<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0

0x59a95 is in read_extent_buffer
(/mnt/work/alex/zadara-btrfs-fixes/fs/btrfs/extent_io.c:4719).
4714            char *kaddr;
4715            char *dst = (char *)dstv;
4716            size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
4717            unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
4718
4719            WARN_ON(start > eb->len);
4720            WARN_ON(start + len > eb->start + eb->len);
4721
4722            offset = (start_offset + start) & ((unsigned
long)PAGE_CACHE_SIZE - 1);
4723


[3]
[12163.397585] general protection fault: 0000 [#1] SMP
  rmd160 crypto_null af_key xfrm_algo kvm scst_vdisk(OF)
iscsi_scst(OF) scst(OF) libcrc32c microcode psmouse nls_iso8859_1
serio_raw virtio_balloon cirrus ttm nfsd(OF) nfs_acl auth_rpcgss
drm_kms_helper nfs fscache lockd sunrpc drm sysimgblt sysfillrect
syscopyarea i2c_piix4 lp mac_hid parport floppy [last unloaded:
ixgbevf]
 CPU 0
 Pid: 11027, comm: kworker/u:213 Tainted: GF       W  O
3.8.13-030813-generic #201305111843 Bochs Bochs
 read_extent_buffer+0x98/0x120 [btrfs]
 RSP: 0018:ffff8801a203f818  EFLAGS: 00010202
 RAX: ffff8801743574f8 RBX: ffff880174357428 RCX: 0000000000000fe2
 RDX: 0000160000000000 RSI: ffff880000000000 RDI: ffff8801a203f884
 RBP: ffff8801a203f858 R08: 000000000000000a R09: 0000000000000000
 R10: 0000000000008f32 R11: 0000000000008f31 R12: 0000000000000004
 R13: 0000000000000004 R14: ffff8801a203f884 R15: 007ffffffc3445e0
 FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 Successfully set up dm (252:18) iostats on top of /dev/ioerror
(252:0), flags=0x0
 CR2: 00007f7144001a48 CR3: 00000001df5e1000 CR4: 00000000000006f0
 Removing iostats (252:18) from 9:2
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kworker/u:213 (pid: 11027, threadinfo ffff8801a203e000, task
ffff8801a1922e80)
 Stack:
  0000000000001000 fffffff8688bcfe2 ffff8801a203f858 ffff8801a203f8e0
  ffff880174357428 0000000000000011 fffffff8688bcfd1 fffffff8688bcfe2
  ffff8801a203f8b8 ffffffffa04555ac ffff8800d188a000 fffffff8688bc000
[12163.434459] Call Trace:
[<ffffffffa04555ac>] btrfs_get_token_32+0xdc/0xf0 [btrfs]
[<ffffffffa040f640>] leaf_space_used+0xe0/0x110 [btrfs]
[<ffffffffa04158f4>] btrfs_leaf_free_space+0x64/0xb0 [btrfs]
[<ffffffffa0416a22>] push_leaf_right+0xf2/0x1a0 [btrfs]
[<ffffffffa04171a1>] split_leaf+0x5e1/0x770 [btrfs]
[<ffffffffa0417e05>] btrfs_search_slot+0x785/0x820 [btrfs]
[<ffffffffa0419a8c>] btrfs_insert_empty_items+0x7c/0x120 [btrfs]
[<ffffffffa042fc7c>] btrfs_insert_bv_file_extent+0x7c/0x140 [btrfs]
[<ffffffffa04a86d6>] zbtrfs_blk_virt_chunk_migr_completed+0x4e6/0x8e0 [btrfs]
[<ffffffffa0535306>] dm_btrfs_chunk_migration_complete+0xc6/0x230 [dm_btrfs]
[<ffffffff81078b81>] process_one_work+0x141/0x490
[<ffffffff81079b48>] worker_thread+0x168/0x400
[<ffffffff8107f050>] kthread+0xc0/0xd0
[<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
Code: 50 01 00 00 41 bd 00 10 00 00 48 ba 00 00 00 00 00 16 00 00 49
29 cd 48 be 00 00 00 00 00 88 ff ff 4c 89 f7 4d 39 e5 4d 0f 47 ec <4a>
03 14 38 49 83 c7 08 4d 01 ee 48 89 d0 4c 89 ea 48 c1 f8 06
RIP  [<ffffffffa045fa48>] read_extent_buffer+0x98/0x120 [btrfs]
 RSP <ffff8801a203f818>

(gdb) l *read_extent_buffer + 0x98
0x59a48 is in read_extent_buffer (include/linux/mm.h:772).
767      */
768     #include <linux/vmstat.h>
769
770     static __always_inline void *lowmem_page_address(const struct
page *page)
771     {
772             return __va(PFN_PHYS(page_to_pfn(page)));
773     }
774
775     #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
776     #define HASHED_PAGE_VIRTUAL
