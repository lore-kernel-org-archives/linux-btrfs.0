Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33200 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbbENJmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 05:42:47 -0400
Received: by iebgx4 with SMTP id gx4so55482356ieb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 02:42:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H5OFEybC+3HDvxFXQZyeE5edZ4oOhrcCQCqnv=75agDZA@mail.gmail.com>
References: <554909A7.6030100@suse.com>
	<CAL3q7H5OFEybC+3HDvxFXQZyeE5edZ4oOhrcCQCqnv=75agDZA@mail.gmail.com>
Date: Thu, 14 May 2015 10:42:46 +0100
Message-ID: <CAL3q7H4YWu7mx4tteoBH-mHaUWnuKvV52rnFAh9fYk-3dwzpBA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: add missing discards when unpinning extents
 with -o discard
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 8, 2015 at 10:10 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Tue, May 5, 2015 at 7:19 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> When we clear the dirty bits in btrfs_delete_unused_bgs for extents
>> in the empty block group, it results in btrfs_finish_extent_commit being
>> unable to discard the freed extents.
>>
>> The block group removal patch added an alternate path to forget extents
>> other than btrfs_finish_extent_commit. As a result, any extents that would
>> be freed when the block group is removed aren't discarded. In my
>> test run, with a large copy of mixed sized files followed by removal, it
>> left nearly 2/3 of extents undiscarded.
>>
>> To clean up the block groups, we add the removed block group onto a list
>> that will be discarded after transaction commit.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Hi Jeff,
Revising this after testing. Some more comments inlined below.

>> ---
>>  fs/btrfs/ctree.h            |  2 ++
>>  fs/btrfs/extent-tree.c      | 58 +++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/free-space-cache.c | 45 +++++++++++++++++++----------------
>>  fs/btrfs/super.c            |  2 +-
>>  fs/btrfs/transaction.c      |  2 ++
>>  fs/btrfs/transaction.h      |  2 ++
>>  6 files changed, 90 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 6f364e1..3448a54 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3438,6 +3438,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>>                              struct btrfs_root *root, u64 group_start,
>>                              struct extent_map *em);
>>  void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info);
>> +void btrfs_cleanup_block_group_mapping(struct btrfs_block_group_cache *cache);
>>  void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
>>                                        struct btrfs_root *root);
>>  u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
>> @@ -4068,6 +4069,7 @@ __printf(5, 6)
>>  void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>>                      unsigned int line, int errno, const char *fmt, ...);
>>
>> +const char *btrfs_decode_error(int errno);
>>
>>  void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>>                                struct btrfs_root *root, const char *function,
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 6d1d74d..521a294 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -6011,6 +6011,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
>>                                struct btrfs_root *root)
>>  {
>>         struct btrfs_fs_info *fs_info = root->fs_info;
>> +       struct btrfs_block_group_cache *block_group, *tmp;
>> +       struct list_head *deleted_bgs;
>>         struct extent_io_tree *unpin;
>>         u64 start;
>>         u64 end;
>> @@ -6043,6 +6045,29 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
>>                 cond_resched();
>>         }
>>
>> +       /* Transaction is finished. We don't need the lock anymore. */
>> +       deleted_bgs = &trans->transaction->deleted_bgs;
>> +       list_for_each_entry_safe(block_group, tmp, deleted_bgs, bg_list) {
>> +               u64 start, end, trimmed = 0;
>> +               int ret;
>> +               list_del_init(&block_group->bg_list);
>> +
>> +               start = block_group->key.objectid;
>> +               end = start + block_group->key.offset - 1;
>> +
>> +               ret = btrfs_discard_extent(root, start, end, &trimmed);

The third argument for btrfs_discard_extent() is supposed to be the
number of bytes and not the end offset, that is, it should be:

ret = btrfs_discard_extent(root, block_group->key.objectid,
block_group->key.offset, &trimmed);

Fortunately this doesn't seem to cause problems as __btrfs_map_block()
will make sure we don't operate beyond the chunk's end offset.
Nevertheless it should be fixed to avoid confusion and breakage if
map_block() changes its behaviour in the future.

>> +
>> +               btrfs_cleanup_block_group_mapping(block_group);
>
> We can't do this unconditionally. Only if
> "atomic_dec_and_test(&block_group->trimming)" - we can have a
> concurrent trimmer that started before the bg deletion started (via
> the fitrim ioctl) - we don't want  the space to be possible to
> allocate while any other trimmers are still active.
>
>> +               btrfs_put_block_group(block_group);
>> +
>> +               if (ret) {
>> +                       const char *errstr = btrfs_decode_error(ret);
>> +                       btrfs_warn(fs_info,
>> +                                  "Discard failed while removing blockgroup: errno=%d %s\n",
>> +                                  ret, errstr);
>> +               }
>> +       }
>> +
>>         return 0;
>>  }
>>
>> @@ -9802,6 +9827,11 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>>          * currently running transaction might finish and a new one start,
>>          * allowing for new block groups to be created that can reuse the same
>>          * physical device locations unless we take this special care.
>> +        *
>> +        * There may also be an implicit trim operation if the file system
>> +        * is mounted with -odiscard. The same protections must remain
>> +        * in place until the extents have been discarded completely when
>> +        * the transaction commit has completed.
>>          */
>>         remove_em = (atomic_read(&block_group->trimming) == 0);
>>         /*
>> @@ -9876,6 +9906,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>>         spin_lock(&fs_info->unused_bgs_lock);
>>         while (!list_empty(&fs_info->unused_bgs)) {
>>                 u64 start, end;
>> +               int trimming;
>>
>>                 block_group = list_first_entry(&fs_info->unused_bgs,
>>                                                struct btrfs_block_group_cache,
>> @@ -9973,12 +10004,39 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>>                 spin_unlock(&block_group->lock);
>>                 spin_unlock(&space_info->lock);
>>
>> +               /* DISCARD can flip during remount */
>> +               trimming = btrfs_test_opt(root, DISCARD);
>> +
>> +               /* Implicit trim during transaction commit. */
>> +               if (trimming)
>> +                       atomic_inc(&block_group->trimming);
>> +
>>                 /*
>>                  * Btrfs_remove_chunk will abort the transaction if things go
>>                  * horribly wrong.
>>                  */
>>                 ret = btrfs_remove_chunk(trans, root,
>>                                          block_group->key.objectid);
>> +
>> +               if (ret) {
>> +                       if (trimming)
>> +                               atomic_dec(&block_group->trimming);
>
> And if the new value becomes 0 after decrementing we need to call
> btrfs_cleanup_block_group_mapping(), otherwise we leak the
> space/pinned chunk forever, extent maps, etc.

Well if the new value becomes 0 and block_group->removed == 1 too of
course. Even though failure in btrfs_remove_chunk() results in
transaction abortion, it's always better to not leak memory
(btrfs_free_space entries, see below) and do proper cleanup.

>
>> +                       goto end_trans;
>> +               }
>> +
>> +               /*
>> +                * If we're not mounted with -odiscard, we can just forget
>> +                * about this block group. Otherwise we'll need to wait
>> +                * until transaction commit to do the actual discard.
>> +                */
>> +               if (trimming) {
>> +                       WARN_ON(!list_empty(&block_group->bg_list));
>> +                       spin_lock(&trans->transaction->deleted_bgs_lock);
>> +                       list_add(&block_group->bg_list,
>> +                                &trans->transaction->deleted_bgs);
>
> I'd rather do this only if list_empty(&block_group->bg_list).
> Otherwise we risk getting the bg referenced multiple times in a list
> (or in different lists), resulting in dangling pointers even after the
> list_del() call.
>
>> +                       spin_unlock(&trans->transaction->deleted_bgs_lock);
>> +                       btrfs_get_block_group(block_group);
>> +               }
>>  end_trans:
>>                 btrfs_end_transaction(trans, root);
>>  next:
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index 41c510b..d33b146 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -3274,6 +3274,30 @@ next:
>>         return ret;
>>  }
>>
>> +void btrfs_cleanup_block_group_mapping(struct btrfs_block_group_cache *cache)
>> +{
>> +       struct extent_map_tree *em_tree;
>> +       struct extent_map *em;
>> +
>> +       lock_chunks(cache->fs_info->chunk_root);
>> +       em_tree = &cache->fs_info->mapping_tree.map_tree;
>> +       write_lock(&em_tree->lock);
>> +       em = lookup_extent_mapping(em_tree, cache->key.objectid, 1);
>> +       BUG_ON(!em); /* logic error, can't happen */
>> +
>> +       /*
>> +        * remove_extent_mapping() will delete us from the pinned_chunks
>> +        * list, which is protected by the chunk mutex.
>> +        */
>> +       remove_extent_mapping(em_tree, em);
>> +       write_unlock(&em_tree->lock);
>> +       unlock_chunks(cache->fs_info->chunk_root);
>> +
>> +       /* once for us and once for the tree */
>> +       free_extent_map(em);
>> +       free_extent_map(em);
>> +}
>> +
>>  int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>>                            u64 *trimmed, u64 start, u64 end, u64 minlen)
>>  {
>> @@ -3298,28 +3322,9 @@ out:
>>         spin_lock(&block_group->lock);
>>         if (atomic_dec_and_test(&block_group->trimming) &&
>>             block_group->removed) {
>> -               struct extent_map_tree *em_tree;
>> -               struct extent_map *em;
>> -
>>                 spin_unlock(&block_group->lock);
>>
>> -               lock_chunks(block_group->fs_info->chunk_root);
>> -               em_tree = &block_group->fs_info->mapping_tree.map_tree;
>> -               write_lock(&em_tree->lock);
>> -               em = lookup_extent_mapping(em_tree, block_group->key.objectid,
>> -                                          1);
>> -               BUG_ON(!em); /* logic error, can't happen */
>> -               /*
>> -                * remove_extent_mapping() will delete us from the pinned_chunks
>> -                * list, which is protected by the chunk mutex.
>> -                */
>> -               remove_extent_mapping(em_tree, em);
>> -               write_unlock(&em_tree->lock);
>> -               unlock_chunks(block_group->fs_info->chunk_root);
>> -
>> -               /* once for us and once for the tree */
>> -               free_extent_map(em);
>> -               free_extent_map(em);
>> +               btrfs_cleanup_block_group_mapping(block_group);
>>
>>                 /*
>>                  * We've left one free space entry and other tasks trimming

So this part here is important. We need either to move the call to
__btrfs_remove_free_space_cache(block_group->free_space_ctl) to the
new function btrfs_cleanup_block_group_mapping() or make sure
btrfs_finish_extent_commit() calls it when it calls
btrfs_cleanup_block_group_mapping(). Otherwise we have a leak of
btrfs_free_space entries, 1 for each trimmer that came from the fitrim
ioctl right before the block group was removed from the rbtree. This
is visible at rmmod time if you keep running generic/038:

[63529.346047] kmem_cache_destroy btrfs_free_space: Slab cache still has objects
(...)
[63529.362309] Call Trace:
[63529.362835]  [<ffffffff8142fa46>] dump_stack+0x4f/0x7b
[63529.363782]  [<ffffffff8108b6a2>] ? console_unlock+0x361/0x3ad
[63529.364878]  [<ffffffff8111e73d>] kmem_cache_destroy+0x6b/0xe9
[63529.366011]  [<ffffffffa0579ceb>] btrfs_destroy_cachep+0x63/0x76 [btrfs]
[63529.367230]  [<ffffffffa05d80c4>] exit_btrfs_fs+0x9/0xf45 [btrfs]
[63529.368367]  [<ffffffff810af90a>] SyS_delete_module+0x144/0x1d2
[63529.369451]  [<ffffffff8123960b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[63529.370610]  [<ffffffff81435b32>] system_call_fastpath+0x12/0x17



>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 9e66f5e..016e65a 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -69,7 +69,7 @@ static struct file_system_type btrfs_fs_type;
>>
>>  static int btrfs_remount(struct super_block *sb, int *flags, char *data);
>>
>> -static const char *btrfs_decode_error(int errno)
>> +const char *btrfs_decode_error(int errno)
>>  {
>>         char *errstr = "unknown";
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 5628e25..2005262 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -256,6 +256,8 @@ loop:
>>         mutex_init(&cur_trans->cache_write_mutex);
>>         cur_trans->num_dirty_bgs = 0;
>>         spin_lock_init(&cur_trans->dirty_bgs_lock);
>> +       INIT_LIST_HEAD(&cur_trans->deleted_bgs);
>> +       spin_lock_init(&cur_trans->deleted_bgs_lock);
>>         list_add_tail(&cur_trans->list, &fs_info->trans_list);
>>         extent_io_tree_init(&cur_trans->dirty_pages,
>>                              fs_info->btree_inode->i_mapping);
>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
>> index 0b24755..14325f2 100644
>> --- a/fs/btrfs/transaction.h
>> +++ b/fs/btrfs/transaction.h
>> @@ -74,6 +74,8 @@ struct btrfs_transaction {
>>          */
>>         struct mutex cache_write_mutex;
>>         spinlock_t dirty_bgs_lock;
>> +       struct list_head deleted_bgs;
>> +       spinlock_t deleted_bgs_lock;
>>         struct btrfs_delayed_ref_root delayed_refs;
>>         int aborted;
>>         int dirty_bg_run;
>> --
>> 1.8.5.6

While testing this I ran often into transaction abortions, with
-EEXISTS, due to getting the same physical device offsets assigned to
multiple new block groups:

[194737.659017] ------------[ cut here ]------------
[194737.660192] WARNING: CPU: 15 PID: 31111 at fs/btrfs/super.c:260
__btrfs_abort_transaction+0x52/0x106 [btrfs]()
[194737.662209] BTRFS: Transaction aborted (error -17)
[194737.663175] Modules linked in: btrfs dm_snapshot dm_bufio
dm_flakey dm_mod crc32c_generic xor raid6_pq nfsd auth_rpcgss
oid_registry nfs_acl nfs lockd grace fscache sunrpc loop fuse
acpi_cpufreq i2c_piix4 parport_pc processor psmouse i2c_core
thermal_sys pcspkr evdev parport button serio_raw microcode ext4 crc16
jbd2 mbcache sg sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix
floppy virtio_pci libata virtio_ring e1000 virtio scsi_mod [last
unloaded: btrfs]
[194737.674015] CPU: 15 PID: 31111 Comm: xfs_io Tainted: G        W
   4.0.0-rc5-btrfs-next-9+ #2
[194737.675986] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org
04/01/2014
[194737.682999]  0000000000000009 ffff8800564c7a98 ffffffff8142fa46
ffffffff8108b6a2
[194737.684540]  ffff8800564c7ae8 ffff8800564c7ad8 ffffffff81045ea5
ffff8800564c7b78
[194737.686017]  ffffffffa0383aa7 00000000ffffffef ffff88000c7ba000
ffff8801a1f66f40
[194737.687509] Call Trace:
[194737.688068]  [<ffffffff8142fa46>] dump_stack+0x4f/0x7b
[194737.689027]  [<ffffffff8108b6a2>] ? console_unlock+0x361/0x3ad
[194737.690095]  [<ffffffff81045ea5>] warn_slowpath_common+0xa1/0xbb
[194737.691198]  [<ffffffffa0383aa7>] ?
__btrfs_abort_transaction+0x52/0x106 [btrfs]
[194737.693789]  [<ffffffff81045f05>] warn_slowpath_fmt+0x46/0x48
[194737.695065]  [<ffffffffa0383aa7>]
__btrfs_abort_transaction+0x52/0x106 [btrfs]
[194737.696806]  [<ffffffffa039a3bd>]
btrfs_create_pending_block_groups+0x101/0x130 [btrfs]
[194737.698683]  [<ffffffffa03aa433>] __btrfs_end_transaction+0x84/0x366 [btrfs]
[194737.700329]  [<ffffffffa03aa725>] btrfs_end_transaction+0x10/0x12 [btrfs]
[194737.701924]  [<ffffffffa0394b51>]
btrfs_check_data_free_space+0x11f/0x27c [btrfs]
[194737.703675]  [<ffffffffa03b8ba4>] __btrfs_buffered_write+0x16a/0x4c8 [btrfs]
[194737.705417]  [<ffffffffa03bb502>] ?
btrfs_file_write_iter+0x19a/0x431 [btrfs]
[194737.707058]  [<ffffffffa03bb511>] ?
btrfs_file_write_iter+0x1a9/0x431 [btrfs]
[194737.708560]  [<ffffffffa03bb68d>] btrfs_file_write_iter+0x325/0x431 [btrfs]
[194737.710673]  [<ffffffff81067d85>] ? get_parent_ip+0xe/0x3e
[194737.712076]  [<ffffffff811534c3>] new_sync_write+0x7c/0xa0
[194737.713293]  [<ffffffff81153b58>] vfs_write+0xb2/0x117
[194737.714443]  [<ffffffff81154424>] SyS_pwrite64+0x64/0x82
[194737.715646]  [<ffffffff81435b32>] system_call_fastpath+0x12/0x17
[194737.717175] ---[ end trace f2d5dc04e56d7e48 ]---
[194737.718170] BTRFS: error (device sdc) in
btrfs_create_pending_block_groups:9524: errno=-17 Object already
exists


But this turned out to not be a problem in this nor your other
trim/discard patch. It's actually a regression from a change
introduced in 4.1 and this patch only makes that issue trigger more
often. I'll send a fix for it soon.

Everything else looks good.
Thanks.

>>
>>
>> --
>> Jeff Mahoney
>> SUSE Labs
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
