Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f41.google.com ([209.85.128.41]:48293 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3LOODg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 09:03:36 -0500
Received: by mail-qe0-f41.google.com with SMTP id gh4so3166886qeb.28
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 06:03:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131214095845.GA21618@pmhahn.de>
References: <20131214095845.GA21618@pmhahn.de>
Date: Sun, 15 Dec 2013 22:03:35 +0800
Message-ID: <CAP9B-Q=0wWxXH5usnOq6MGN-LQZfw5y8dxgLZYidu_oPsOxrjQ@mail.gmail.com>
Subject: Re: [BUG] open_ctree() failes after mounting BTRFS with 3.2 after 3.12
From: Shilong Wang <wangshilong1991@gmail.com>
To: Philipp Matthias Hahn <pmhahn@pmhahn.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Philipp,

In order to reproduce your problems.

I compile btrfs in kernel 3.2 and 3.12.

# mkfs.btrfs  -f /dev/sda2
# mount /dev/sda2  /mnt
# dd if=/dev/zero of=/mnt/data bs=1M count=1024
# umount /mnt

The above operations is in 3.2

and then i switch my system into 3.12, and try to mount /dev/sda2
it will output something like the following:

btrfs: mismatching generation and generation_v2 found in root item.
This root was probably mounted with an older kernel. Resetting all new
fields.

But it mounted successfully, then i do some similar operations in
3.12...and umount it.
and switch into kernel version 3.2...

but i failt to mount it in 3.2 and it output the following message.

BTRFS: couldn't mount because of unsupported optional features (20)

It seems that here the problem is because incompat features in newer
kernel and make older kernel
unmountable any more..

But in your problem is that you can still mount on older kernel? but
not new kernel?


Thanks,
Wang

2013/12/14 Philipp Matthias Hahn <pmhahn@pmhahn.de>:
> Hello,
>
> I'm not subscribed, so please cc: me.
>
> I've an extermal USB disk using BTRFS used for backups and data sharing
> between multiple systems using different kernels (3.2.xx, 3.12.5). The
> FS fails to mount with 3.12.x, but still works on 3.2.x with the
> following dmesg:
>
> btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
> btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
> btrfs: open_ctree failed
>
> Following
> <https://btrfs.wiki.kernel.org/index.php/Debugging_Btrfs_with_GDB#Building_UML_Kernel>
> here some more debug info. To me it looks like the call to
> btrfs_read_fs_root_no_name() fails.
>
> $ gdb --args ./linux ubd0=/dev/sdc2
> ...
> (gdb) handle SIGSEGV pass nostop noprint
> (gdb) handle SIGUSR1 pass nostop noprint
> (gdb) break open_ctree
> (gdb) r
> ...
> [    0.000000] Linux version 3.12.5 (pmhahn@scout) (gcc version 4.8.2 (Debian 4.8.2-10) ) #9 Sat Dec 14 09:40:10 CET 2013
> ...
> [    1.120000] Btrfs loaded, debug=on
> ...
> [    1.120000]  ubda: unknown partition table
> [    1.120000] btrfs: device label backup devid 1 transid 5478 /dev/root
>
> Breakpoint 1, open_ctree (sb=sb@entry=0x61d0e400, fs_devices=0x61d15c80, options=options@entry=0x0) at fs/btrfs/disk-io.c:2096
> 2096    {
> 2093    int open_ctree(struct super_block *sb,
> 2123            tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
> 2096    {
> 2123            tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
> 2096    {
> 2118            int num_backups_tried = 0;
> 2119            int backup_index = 0;
> 2123            tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info);
> 2124            chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
> 2125            if (!tree_root || !chunk_root) {
> 2124            chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info);
> 2125            if (!tree_root || !chunk_root) {
> 2130            ret = init_srcu_struct(&fs_info->subvol_srcu);
> 2131            if (ret) {
> 2130            ret = init_srcu_struct(&fs_info->subvol_srcu);
> 2131            if (ret) {
> 2136            ret = setup_bdi(fs_info, &fs_info->bdi);
> 2156            fs_info->btree_inode = new_inode(sb);
> 2136            ret = setup_bdi(fs_info, &fs_info->bdi);
> 2142            ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0);
> 2147            fs_info->dirty_metadata_batch = PAGE_CACHE_SIZE *
> 2150            ret = percpu_counter_init(&fs_info->delalloc_bytes, 0);
> 2136            ret = setup_bdi(fs_info, &fs_info->bdi);
> 2156            fs_info->btree_inode = new_inode(sb);
> 2157            if (!fs_info->btree_inode) {
> 2156            fs_info->btree_inode = new_inode(sb);
> 2157            if (!fs_info->btree_inode) {
> 2162            mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
> 2179            mutex_init(&fs_info->reloc_mutex);
> 2162            mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
> 2165            INIT_LIST_HEAD(&fs_info->trans_list);
> 2179            mutex_init(&fs_info->reloc_mutex);
> 2164            INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
> 2165            INIT_LIST_HEAD(&fs_info->trans_list);
> 2166            INIT_LIST_HEAD(&fs_info->dead_roots);
> 2164            INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
> 2166            INIT_LIST_HEAD(&fs_info->dead_roots);
> 2167            INIT_LIST_HEAD(&fs_info->delayed_iputs);
> 2168            INIT_LIST_HEAD(&fs_info->delalloc_roots);
> 2169            INIT_LIST_HEAD(&fs_info->caching_block_groups);
> 2179            mutex_init(&fs_info->reloc_mutex);
> 2182            init_completion(&fs_info->kobj_unregister);
> 2180            seqlock_init(&fs_info->profiles_lock);
> 2182            init_completion(&fs_info->kobj_unregister);
> 2183            INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
> 2186            btrfs_mapping_init(&fs_info->mapping_tree);
> 2183            INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
> 2184            INIT_LIST_HEAD(&fs_info->space_info);
> 2186            btrfs_mapping_init(&fs_info->mapping_tree);
> 2184            INIT_LIST_HEAD(&fs_info->space_info);
> 2185            INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
> 2186            btrfs_mapping_init(&fs_info->mapping_tree);
> 2187            btrfs_init_block_rsv(&fs_info->global_block_rsv,
> 2189            btrfs_init_block_rsv(&fs_info->delalloc_block_rsv,
> 2191            btrfs_init_block_rsv(&fs_info->trans_block_rsv, BTRFS_BLOCK_RSV_TRANS);
> 2192            btrfs_init_block_rsv(&fs_info->chunk_block_rsv, BTRFS_BLOCK_RSV_CHUNK);
> 2193            btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
> 2194            btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
> 2217            INIT_LIST_HEAD(&fs_info->ordered_roots);
> 2206            fs_info->free_chunk_space = 0;
> 2219            fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
> 2196            atomic_set(&fs_info->nr_async_submits, 0);
> 2219            fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
> 2198            atomic_set(&fs_info->async_submit_draining, 0);
> 2201            atomic64_set(&fs_info->tree_mod_seq, 0);
> 2202            fs_info->sb = sb;
> 2203            fs_info->max_inline = 8192 * 1024;
> 2204            fs_info->metadata_ratio = 0;
> 2205            fs_info->defrag_inodes = RB_ROOT;
> 2207            fs_info->tree_mod_log = RB_ROOT;
> 2208            fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
> 2211            INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
> 2214            fs_info->thread_pool_size = min_t(unsigned long,
> 2217            INIT_LIST_HEAD(&fs_info->ordered_roots);
> 2219            fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
> 2221            if (!fs_info->delayed_root) {
> 2219            fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
> 2221            if (!fs_info->delayed_root) {
> 2225            btrfs_init_delayed_root(fs_info->delayed_root);
> 2227            mutex_init(&fs_info->scrub_lock);
> 2225            btrfs_init_delayed_root(fs_info->delayed_root);
> 2227            mutex_init(&fs_info->scrub_lock);
> 2225            btrfs_init_delayed_root(fs_info->delayed_root);
> 2227            mutex_init(&fs_info->scrub_lock);
> 2232            init_waitqueue_head(&fs_info->scrub_pause_wait);
> 2228            atomic_set(&fs_info->scrubs_running, 0);
> 2232            init_waitqueue_head(&fs_info->scrub_pause_wait);
> 2233            init_rwsem(&fs_info->scrub_super_lock);
> 2240            mutex_init(&fs_info->balance_mutex);
> 2234            fs_info->scrub_workers_refcnt = 0;
> 2240            mutex_init(&fs_info->balance_mutex);
> 2245            init_waitqueue_head(&fs_info->balance_wait_q);
> 2241            atomic_set(&fs_info->balance_running, 0);
> 2245            init_waitqueue_head(&fs_info->balance_wait_q);
> 2244            fs_info->balance_ctl = NULL;
> 2245            init_waitqueue_head(&fs_info->balance_wait_q);
> 2249            sb->s_bdi = &fs_info->bdi;
> 2247            sb->s_blocksize = 4096;
> 2252            set_nlink(fs_info->btree_inode, 1);
> 2248            sb->s_blocksize_bits = blksize_bits(4096);
> 2249            sb->s_bdi = &fs_info->bdi;
> 2251            fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
> 2252            set_nlink(fs_info->btree_inode, 1);
> 2258            fs_info->btree_inode->i_size = OFFSET_MAX;
> 2259            fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
> 2260            fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
> 2262            RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
> 2264                                 fs_info->btree_inode->i_mapping);
> 2263            extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
> 2265            BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
> 2266            extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
> 2268            BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
> 2271            memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
> 2268            BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
> 2270            BTRFS_I(fs_info->btree_inode)->root = tree_root;
> 2271            memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
> 2273            set_bit(BTRFS_INODE_DUMMY,
> 2275            insert_inode_hash(fs_info->btree_inode);
> 2281            extent_io_tree_init(&fs_info->freed_extents[0],
> 2275            insert_inode_hash(fs_info->btree_inode);
> 2281            extent_io_tree_init(&fs_info->freed_extents[0],
> 2278            fs_info->block_group_cache_tree = RB_ROOT;
> 2281            extent_io_tree_init(&fs_info->freed_extents[0],
> 2279            fs_info->first_logical_byte = (u64)-1;
> 2281            extent_io_tree_init(&fs_info->freed_extents[0],
> 2283            extent_io_tree_init(&fs_info->freed_extents[1],
> 2289            mutex_init(&fs_info->ordered_operations_mutex);
> 2285            fs_info->pinned_extents = &fs_info->freed_extents[0];
> 2289            mutex_init(&fs_info->ordered_operations_mutex);
> 2286            fs_info->do_barriers = 1;
> 2289            mutex_init(&fs_info->ordered_operations_mutex);
> 2290            mutex_init(&fs_info->ordered_extent_flush_mutex);
> 2291            mutex_init(&fs_info->tree_log_mutex);
> 2292            mutex_init(&fs_info->chunk_mutex);
> 2293            mutex_init(&fs_info->transaction_kthread_mutex);
> 2294            mutex_init(&fs_info->cleaner_mutex);
> 2295            mutex_init(&fs_info->volume_mutex);
> 2296            init_rwsem(&fs_info->extent_commit_sem);
> 2297            init_rwsem(&fs_info->cleanup_work_sem);
> 2298            init_rwsem(&fs_info->subvol_sem);
> 2299            sema_init(&fs_info->uuid_tree_rescan_sem, 1);
> 2302            mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> 2299            sema_init(&fs_info->uuid_tree_rescan_sem, 1);
> 2302            mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> 2299            sema_init(&fs_info->uuid_tree_rescan_sem, 1);
> 2300            fs_info->dev_replace.lock_owner = 0;
> 2301            atomic_set(&fs_info->dev_replace.nesting_level, 0);
> 2302            mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
> 2303            mutex_init(&fs_info->dev_replace.lock_management_lock);
> 2304            mutex_init(&fs_info->dev_replace.lock);
> 2307            mutex_init(&fs_info->qgroup_ioctl_lock);
> 2312            fs_info->pending_quota_state = 0;
> 2309            INIT_LIST_HEAD(&fs_info->dirty_qgroups);
> 2314            mutex_init(&fs_info->qgroup_rescan_lock);
> 2308            fs_info->qgroup_tree = RB_ROOT;
> 2309            INIT_LIST_HEAD(&fs_info->dirty_qgroups);
> 2310            fs_info->qgroup_seq = 1;
> 2313            fs_info->qgroup_ulist = NULL;
> 2314            mutex_init(&fs_info->qgroup_rescan_lock);
> 2316            btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
> 2317            btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
> 2319            init_waitqueue_head(&fs_info->transaction_throttle);
> 2320            init_waitqueue_head(&fs_info->transaction_wait);
> 2321            init_waitqueue_head(&fs_info->transaction_blocked_wait);
> 2322            init_waitqueue_head(&fs_info->async_submit_wait);
> 2324            ret = btrfs_alloc_stripe_hash_table(fs_info);
> 2325            if (ret) {
> 2324            ret = btrfs_alloc_stripe_hash_table(fs_info);
> 2325            if (ret) {
> 2330            __setup_root(4096, 4096, 4096, 4096, tree_root,
> 2333            invalidate_bdev(fs_devices->latest_bdev);
> 2338            bh = btrfs_read_dev_super(fs_devices->latest_bdev);
> 2339            if (!bh) {
> 2338            bh = btrfs_read_dev_super(fs_devices->latest_bdev);
> 2339            if (!bh) {
> 2348            if (btrfs_check_super_csum(bh->b_data)) {
> 2359            memcpy(fs_info->super_copy, bh->b_data, sizeof(*fs_info->super_copy));
> 2360            memcpy(fs_info->super_for_commit, fs_info->super_copy,
> 2362            brelse(bh);
> 2364            memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
> 2373            disk_super = fs_info->super_copy;
> 2374            if (!btrfs_super_root(disk_super))
> 2373            disk_super = fs_info->super_copy;
> 2374            if (!btrfs_super_root(disk_super))
> 2378            if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
> 2385            generation = btrfs_super_generation(disk_super);
> 2386            find_oldest_super_backup(fs_info, generation);
> 2385            generation = btrfs_super_generation(disk_super);
> 2386            find_oldest_super_backup(fs_info, generation);
> 2392            fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
> 2394            ret = btrfs_parse_options(tree_root, options);
> 2392            fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
> 2394            ret = btrfs_parse_options(tree_root, options);
> 2395            if (ret) {
> 2394            ret = btrfs_parse_options(tree_root, options);
> 2395            if (ret) {
> 2400            features = btrfs_super_incompat_flags(disk_super) &
> 2402            if (features) {
> 2410            if (btrfs_super_leafsize(disk_super) !=
> 2411                btrfs_super_nodesize(disk_super)) {
> 2410            if (btrfs_super_leafsize(disk_super) !=
> 2419            if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
> 2429            if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
> 2428            features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
> 2429            if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
> 2428            features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
> 2432            if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
> 2439            if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
> 2445            nodesize = btrfs_super_nodesize(disk_super);
> 2447            sectorsize = btrfs_super_sectorsize(disk_super);
> 2448            stripesize = btrfs_super_stripesize(disk_super);
> 2447            sectorsize = btrfs_super_sectorsize(disk_super);
> 2448            stripesize = btrfs_super_stripesize(disk_super);
> 2449            fs_info->dirty_metadata_batch = leafsize * (1 + ilog2(nr_cpu_ids));
> 2450            fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
> 2456            if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
> 2450            fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
> 2456            if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
> 2468            btrfs_set_super_incompat_flags(disk_super, features);
> 2472            if (!(sb->s_flags & MS_RDONLY) && features) {
> 2470            features = btrfs_super_compat_ro_flags(disk_super) &
> 2472            if (!(sb->s_flags & MS_RDONLY) && features) {
> 2480            btrfs_init_workers(&fs_info->generic_worker,
> 2483            btrfs_init_workers(&fs_info->workers, "worker",
> 2487            btrfs_init_workers(&fs_info->delalloc_workers, "delalloc",
> 2490            btrfs_init_workers(&fs_info->flush_workers, "flush_delalloc",
> 2494                               min_t(u64, fs_devices->num_devices,
> 2493            btrfs_init_workers(&fs_info->submit_workers, "submit",
> 2494                               min_t(u64, fs_devices->num_devices,
> 2493            btrfs_init_workers(&fs_info->submit_workers, "submit",
> 2497            btrfs_init_workers(&fs_info->caching_workers, "cache",
> 2512            btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
> 2504            fs_info->submit_workers.idle_thresh = 64;
> 2506            fs_info->workers.idle_thresh = 16;
> 2512            btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
> 2507            fs_info->workers.ordered = 1;
> 2512            btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
> 2509            fs_info->delalloc_workers.idle_thresh = 2;
> 2510            fs_info->delalloc_workers.ordered = 1;
> 2512            btrfs_init_workers(&fs_info->fixup_workers, "fixup", 1,
> 2514            btrfs_init_workers(&fs_info->endio_workers, "endio",
> 2517            btrfs_init_workers(&fs_info->endio_meta_workers, "endio-meta",
> 2520            btrfs_init_workers(&fs_info->endio_meta_write_workers,
> 2523            btrfs_init_workers(&fs_info->endio_raid56_workers,
> 2526            btrfs_init_workers(&fs_info->rmw_workers,
> 2529            btrfs_init_workers(&fs_info->endio_write_workers, "endio-write",
> 2532            btrfs_init_workers(&fs_info->endio_freespace_worker, "freespace-write",
> 2534            btrfs_init_workers(&fs_info->delayed_workers, "delayed-meta",
> 2537            btrfs_init_workers(&fs_info->readahead_workers, "readahead",
> 2540            btrfs_init_workers(&fs_info->qgroup_rescan_workers, "qgroup-rescan", 1,
> 2560            ret = btrfs_start_workers(&fs_info->workers);
> 2547            fs_info->endio_workers.idle_thresh = 4;
> 2548            fs_info->endio_meta_workers.idle_thresh = 4;
> 2549            fs_info->endio_raid56_workers.idle_thresh = 4;
> 2550            fs_info->rmw_workers.idle_thresh = 2;
> 2552            fs_info->endio_write_workers.idle_thresh = 2;
> 2553            fs_info->endio_meta_write_workers.idle_thresh = 2;
> 2554            fs_info->readahead_workers.idle_thresh = 2;
> 2560            ret = btrfs_start_workers(&fs_info->workers);
> 2561            ret |= btrfs_start_workers(&fs_info->generic_worker);
> 2560            ret = btrfs_start_workers(&fs_info->workers);
> 2561            ret |= btrfs_start_workers(&fs_info->generic_worker);
> 2562            ret |= btrfs_start_workers(&fs_info->submit_workers);
> 2561            ret |= btrfs_start_workers(&fs_info->generic_worker);
> 2562            ret |= btrfs_start_workers(&fs_info->submit_workers);
> 2561            ret |= btrfs_start_workers(&fs_info->generic_worker);
> 2562            ret |= btrfs_start_workers(&fs_info->submit_workers);
> 2563            ret |= btrfs_start_workers(&fs_info->delalloc_workers);
> 2562            ret |= btrfs_start_workers(&fs_info->submit_workers);
> 2563            ret |= btrfs_start_workers(&fs_info->delalloc_workers);
> 2564            ret |= btrfs_start_workers(&fs_info->fixup_workers);
> 2563            ret |= btrfs_start_workers(&fs_info->delalloc_workers);
> 2564            ret |= btrfs_start_workers(&fs_info->fixup_workers);
> 2565            ret |= btrfs_start_workers(&fs_info->endio_workers);
> 2564            ret |= btrfs_start_workers(&fs_info->fixup_workers);
> 2565            ret |= btrfs_start_workers(&fs_info->endio_workers);
> 2566            ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
> 2565            ret |= btrfs_start_workers(&fs_info->endio_workers);
> 2566            ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
> 2567            ret |= btrfs_start_workers(&fs_info->rmw_workers);
> 2566            ret |= btrfs_start_workers(&fs_info->endio_meta_workers);
> 2567            ret |= btrfs_start_workers(&fs_info->rmw_workers);
> 2568            ret |= btrfs_start_workers(&fs_info->endio_raid56_workers);
> 2567            ret |= btrfs_start_workers(&fs_info->rmw_workers);
> 2568            ret |= btrfs_start_workers(&fs_info->endio_raid56_workers);
> 2569            ret |= btrfs_start_workers(&fs_info->endio_meta_write_workers);
> 2568            ret |= btrfs_start_workers(&fs_info->endio_raid56_workers);
> 2569            ret |= btrfs_start_workers(&fs_info->endio_meta_write_workers);
> 2570            ret |= btrfs_start_workers(&fs_info->endio_write_workers);
> 2569            ret |= btrfs_start_workers(&fs_info->endio_meta_write_workers);
> 2570            ret |= btrfs_start_workers(&fs_info->endio_write_workers);
> 2571            ret |= btrfs_start_workers(&fs_info->endio_freespace_worker);
> 2570            ret |= btrfs_start_workers(&fs_info->endio_write_workers);
> 2571            ret |= btrfs_start_workers(&fs_info->endio_freespace_worker);
> 2572            ret |= btrfs_start_workers(&fs_info->delayed_workers);
> 2571            ret |= btrfs_start_workers(&fs_info->endio_freespace_worker);
> 2572            ret |= btrfs_start_workers(&fs_info->delayed_workers);
> 2573            ret |= btrfs_start_workers(&fs_info->caching_workers);
> 2572            ret |= btrfs_start_workers(&fs_info->delayed_workers);
> 2573            ret |= btrfs_start_workers(&fs_info->caching_workers);
> 2574            ret |= btrfs_start_workers(&fs_info->readahead_workers);
> 2573            ret |= btrfs_start_workers(&fs_info->caching_workers);
> 2574            ret |= btrfs_start_workers(&fs_info->readahead_workers);
> 2575            ret |= btrfs_start_workers(&fs_info->flush_workers);
> 2574            ret |= btrfs_start_workers(&fs_info->readahead_workers);
> 2575            ret |= btrfs_start_workers(&fs_info->flush_workers);
> 2576            ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
> 2575            ret |= btrfs_start_workers(&fs_info->flush_workers);
> 2576            ret |= btrfs_start_workers(&fs_info->qgroup_rescan_workers);
> 2577            if (ret) {
> 2582            fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
> 2583            fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
> 2582            fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
> 2589            tree_root->stripesize = stripesize;
> 2583            fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
> 2586            tree_root->nodesize = nodesize;
> 2583            fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
> 2589            tree_root->stripesize = stripesize;
> 2592            sb->s_blocksize_bits = blksize_bits(sectorsize);
> 2586            tree_root->nodesize = nodesize;
> 2587            tree_root->leafsize = leafsize;
> 2588            tree_root->sectorsize = sectorsize;
> 2591            sb->s_blocksize = sectorsize;
> 2588            tree_root->sectorsize = sectorsize;
> 2591            sb->s_blocksize = sectorsize;
> 2592            sb->s_blocksize_bits = blksize_bits(sectorsize);
> 2594            if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
> 2592            sb->s_blocksize_bits = blksize_bits(sectorsize);
> 2594            if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
> 2599            if (sectorsize != PAGE_SIZE) {
> 2605            mutex_lock(&fs_info->chunk_mutex);
> 2606            ret = btrfs_read_sys_array(tree_root);
> 2607            mutex_unlock(&fs_info->chunk_mutex);
> 2606            ret = btrfs_read_sys_array(tree_root);
> 2607            mutex_unlock(&fs_info->chunk_mutex);
> 2608            if (ret) {
> 2614            blocksize = btrfs_level_size(tree_root,
> 2108            struct btrfs_root *tree_root;
> 2614            blocksize = btrfs_level_size(tree_root,
> 2616            generation = btrfs_super_chunk_root_generation(disk_super);
> 2618            __setup_root(nodesize, leafsize, sectorsize, stripesize,
> 2616            generation = btrfs_super_chunk_root_generation(disk_super);
> 2618            __setup_root(nodesize, leafsize, sectorsize, stripesize,
> 2621            chunk_root->node = read_tree_block(chunk_root,
> 2624            if (!chunk_root->node ||
> 2621            chunk_root->node = read_tree_block(chunk_root,
> 2624            if (!chunk_root->node ||
> 2625                !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
> 2624            if (!chunk_root->node ||
> 2630            btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
> 2631            chunk_root->commit_root = btrfs_root_node(chunk_root);
> 2633            read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
> 2631            chunk_root->commit_root = btrfs_root_node(chunk_root);
> 2633            read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
> 2636            ret = btrfs_read_chunk_tree(chunk_root);
> 2637            if (ret) {
> 2647            btrfs_close_extra_devices(fs_info, fs_devices, 0);
> 2649            if (!fs_devices->latest_bdev) {
> 2666                           sb->s_id);
> 2996            ret = next_root_backup(fs_info, fs_info->super_copy,
> 2666                           sb->s_id);
> 2656            blocksize = btrfs_level_size(tree_root,
> 2108            struct btrfs_root *tree_root;
> 2656            blocksize = btrfs_level_size(tree_root,
> 2658            generation = btrfs_super_generation(disk_super);
> 2660            tree_root->node = read_tree_block(tree_root,
> 2663            if (!tree_root->node ||
> 2660            tree_root->node = read_tree_block(tree_root,
> 2663            if (!tree_root->node ||
> 2664                !test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
> 2663            if (!tree_root->node ||
> 2671            btrfs_set_root_node(&tree_root->root_item, tree_root->node);
> 2672            tree_root->commit_root = btrfs_root_node(tree_root);
> 2678            extent_root = btrfs_read_tree_root(tree_root, &location);
> 2672            tree_root->commit_root = btrfs_root_node(tree_root);
> 2678            extent_root = btrfs_read_tree_root(tree_root, &location);
> 2674            location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
> 2675            location.type = BTRFS_ROOT_ITEM_KEY;
> 2676            location.offset = 0;
> 2678            extent_root = btrfs_read_tree_root(tree_root, &location);
> [    1.120000] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
> 2679            if (IS_ERR(extent_root)) {
> 2678            extent_root = btrfs_read_tree_root(tree_root, &location);
> 2679            if (IS_ERR(extent_root)) {
> 2687            dev_root = btrfs_read_tree_root(tree_root, &location);
> 2683            extent_root->track_dirty = 1;
> 2687            dev_root = btrfs_read_tree_root(tree_root, &location);
> 2684            fs_info->extent_root = extent_root;
> 2686            location.objectid = BTRFS_DEV_TREE_OBJECTID;
> 2687            dev_root = btrfs_read_tree_root(tree_root, &location);
> 2688            if (IS_ERR(dev_root)) {
> 2692            dev_root->track_dirty = 1;
> 2694            btrfs_init_devices_late(fs_info);
> 2693            fs_info->dev_root = dev_root;
> 2694            btrfs_init_devices_late(fs_info);
> 2697            csum_root = btrfs_read_tree_root(tree_root, &location);
> 2696            location.objectid = BTRFS_CSUM_TREE_OBJECTID;
> 2697            csum_root = btrfs_read_tree_root(tree_root, &location);
> [    1.120000] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
> 2698            if (IS_ERR(csum_root)) {
> 2706            quota_root = btrfs_read_tree_root(tree_root, &location);
> 2702            csum_root->track_dirty = 1;
> 2706            quota_root = btrfs_read_tree_root(tree_root, &location);
> 2703            fs_info->csum_root = csum_root;
> 2705            location.objectid = BTRFS_QUOTA_TREE_OBJECTID;
> 2706            quota_root = btrfs_read_tree_root(tree_root, &location);
> 2707            if (!IS_ERR(quota_root)) {
> 2715            uuid_root = btrfs_read_tree_root(tree_root, &location);
> 2714            location.objectid = BTRFS_UUID_TREE_OBJECTID;
> 2715            uuid_root = btrfs_read_tree_root(tree_root, &location);
> 2716            if (IS_ERR(uuid_root)) {
> 2718                    if (ret != -ENOENT)
> 2721                    check_uuid_tree = false;
> 2720                    create_uuid_tree = true;
> 2730            fs_info->generation = generation;
> 2731            fs_info->last_trans_committed = generation;
> 2733            ret = btrfs_recover_balance(fs_info);
> 2734            if (ret) {
> 2739            ret = btrfs_init_dev_stats(fs_info);
> 2740            if (ret) {
> 2746            ret = btrfs_init_dev_replace(fs_info);
> 2747            if (ret) {
> 2752            btrfs_close_extra_devices(fs_info, fs_devices, 1);
> 2754            ret = btrfs_init_space_info(fs_info);
> 2755            if (ret) {
> 2760            ret = btrfs_read_block_groups(extent_root);
> 2761            if (ret) {
> 2766                    btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
> 2767            if (fs_info->fs_devices->missing_devices >
> 2765            fs_info->num_tolerated_disk_barrier_failures =
> 2767            if (fs_info->fs_devices->missing_devices >
> 2775            fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
> 2780            fs_info->transaction_kthread = kthread_run(transaction_kthread,
> 2786            if (!btrfs_test_opt(tree_root, SSD) &&
> 2788                !fs_info->fs_devices->rotating) {
> 2787                !btrfs_test_opt(tree_root, NOSSD) &&
> 2806            ret = btrfs_read_qgroup_config(fs_info);
> 2807            if (ret)
> 2811            if (btrfs_super_log_root(disk_super) != 0) {
> 2860            ret = btrfs_find_orphan_roots(tree_root);
> 2861            if (ret)
> 2864            if (!(sb->s_flags & MS_RDONLY)) {
> 2882            fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
> 2878            location.objectid = BTRFS_FS_TREE_OBJECTID;
> 2879            location.type = BTRFS_ROOT_ITEM_KEY;
> 2880            location.offset = 0;
> 2882            fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
> 2883            if (IS_ERR(fs_info->fs_root)) {
> 2882            fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
> 2884                    err = PTR_ERR(fs_info->fs_root);
> 2883            if (IS_ERR(fs_info->fs_root)) {
>
> Error here?
>
> 2942            btrfs_free_qgroup_config(fs_info);
> 2944            kthread_stop(fs_info->transaction_kthread);
> 2945            btrfs_cleanup_transaction(fs_info->tree_root);
> 2946            del_fs_roots(fs_info);
> 2948            kthread_stop(fs_info->cleaner_kthread);
> 2954            filemap_write_and_wait(fs_info->btree_inode->i_mapping);
> 2957            btrfs_put_block_group_cache(fs_info);
> 2958            btrfs_free_block_groups(fs_info);
> 2961            free_root_pointers(fs_info, 1);
> 2962            invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> 2965            btrfs_stop_all_workers(fs_info);
> 2968            btrfs_mapping_tree_free(&fs_info->mapping_tree);
> 2970            iput(fs_info->btree_inode);
> 2976            bdi_destroy(&fs_info->bdi);
> 2978            cleanup_srcu_struct(&fs_info->subvol_srcu);
> 2980            btrfs_free_stripe_hash_table(fs_info);
> 2981            btrfs_close_devices(fs_info->fs_devices);
> 3001    }
> btrfs_fill_super (silent=1, data=0x0, fs_devices=<optimized out>, sb=0x61d0e400) at fs/btrfs/super.c:881
> 881             if (err) {
> 880             err = open_ctree(sb, fs_devices, (char *)data);
> 881             if (err) {
> btrfs_mount (fs_type=0x602de120 <btrfs_fs_type>, flags=<optimized out>, device_name=<optimized out>, data=0x0) at fs/btrfs/super.c:1213
> 1213                    error = btrfs_fill_super(s, fs_devices, data,
> [    1.120000] btrfs: open_ctree failed
> 1218            if (IS_ERR(root))
> 1219                    deactivate_locked_super(s);
> 1221            return root;
> 1219                    deactivate_locked_super(s);
> 1228    }
> mount_fs (type=type@entry=0x602de120 <btrfs_fs_type>, flags=flags@entry=32769, name=name@entry=0x61d0f380 "/dev/root", data=data@entry=0x0) at fs/super.c:1136
>
> If you need more, please ask.
>
> Sincerely
> Philipp
> --
>   / /  (_)__  __ ____  __ Philipp Hahn
>  / /__/ / _ \/ // /\ \/ /
> /____/_/_//_/\_,_/ /_/\_\ pmhahn@pmhahn.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
