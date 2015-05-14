Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:32874 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbbENJlA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 05:41:00 -0400
Received: by igbpi8 with SMTP id pi8so9057890igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 02:40:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <554909A5.4030307@suse.com>
References: <554909A5.4030307@suse.com>
Date: Thu, 14 May 2015 10:40:59 +0100
Message-ID: <CAL3q7H6DY-6XVc28=ej6pqa=0dvuMaQ0rAKS5KVSBpDw1k5oaQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: iterate over unused chunk space in FITRIM
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 5, 2015 at 7:19 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> Since we now clean up block groups automatically as they become
> empty, iterating over block groups is no longer sufficient to discard
> unused space.
>
> This patch iterates over the unused chunk space and discards any regions
> that are unallocated, regardless of whether they were ever used.  This is
> a change for btrfs but is consistent with other file systems.
>
> We do this in a transactionless manner since the discard process can take
> a substantial amount of time and a transaction would need to be started
> before the acquisition of the device list lock.  That would mean a
> transaction would be held open across /all/ of the discards collectively.
> In order to prevent other threads from allocating or freeing chunks, we
> hold the chunks lock across the search and discard calls.  We release it
> between searches to allow the file system to perform more-or-less
> normally.  Since the running transaction can commit and disappear while
> we're using the transaction pointer, we take a reference to it and
> release it after the search.  This is safe since it would happen normally
> at the end of the transaction commit after any locks are released anyway.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Hi Jeff,

So I tested this and seems ok so far. Only one comment below.

> ---
>  fs/btrfs/extent-tree.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.c     | 61 ++++++++++++++++++++------------
>  fs/btrfs/volumes.h     |  3 ++
>  3 files changed, 137 insertions(+), 23 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0ec8e22..6d1d74d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10031,10 +10031,94 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
>         return unpin_extent_range(root, start, end, false);
>  }
>
> +/*
> + * It used to be that old block groups would be left around forever.
> + * Iterating over them would be enough to trim unused space.  Since we
> + * now automatically remove them, we also need to iterate over unallocated
> + * space.
> + *
> + * We don't want a transaction for this since the discard may take a
> + * substantial amount of time.  We don't require that a transaction be
> + * running, but we do need to take a running transaction into account
> + * to ensure that we're not discarding chunks that were released in
> + * the current transaction.
> + *
> + * Holding the chunks lock will prevent other threads from allocating
> + * or releasing chunks, but it won't prevent a running transaction
> + * from committing and releasing the memory that the pending chunks
> + * list head uses.  For that, we need to take a reference to the
> + * transaction.
> + */
> +static int btrfs_trim_free_extents(struct btrfs_device *device,
> +                                  u64 minlen, u64 *trimmed)
> +{
> +       u64 start = 0, len = 0;
> +       int ret;
> +
> +       *trimmed = 0;
> +
> +       /* Not writeable = nothing to do. */
> +       if (!device->writeable)
> +               return 0;
> +
> +       /* No free space = nothing to do. */
> +       if (device->total_bytes <= device->bytes_used)
> +               return 0;
> +
> +       ret = 0;
> +
> +       while (1) {
> +               struct btrfs_fs_info *fs_info = device->dev_root->fs_info;
> +               struct btrfs_transaction *trans;
> +
> +               ret = mutex_lock_interruptible(&fs_info->chunk_mutex);
> +               if (ret)
> +                       return ret;
> +
> +               spin_lock(&fs_info->trans_lock);
> +               trans = fs_info->running_transaction;
> +               if (trans)
> +                       atomic_inc(&trans->use_count);
> +               spin_unlock(&fs_info->trans_lock);
> +
> +               ret = find_free_dev_extent_start(trans, device, minlen, start,
> +                                                &start, &len);

So we can't do this safely without holding a transaction open.
If we don't hold a transaction open, then we need to take the
commit_root_sem because find_free_dev_extent_start() uses the commit
root (and skips tree locking) of the device tree. We need to make sure
the commit root, or any of the nodes/leafs it leads to, doesn't
disappear or gets reused while we're doing the search(es) on the
device tree. Take a look a caching_thread() in extent-tree.c for
example.

Not holding the commit_root_sem while doing the search (calling
find_free_dev_extent_start) can lead to the following:

              CPU 0                                                  CPU 1

     starts transaction N

     at this point root R's
     root node (RN) == commit root node (CRN)

     RN and CRN point to child node eb X which
     has a logical address (X->start) LAX

                                                           (doesn't
join transaction N)

path->search_commit_root = 1

btrfs_search_slot(path)

                                                             get ref
on eb CRN (root->commit_root)

     eb X is deleted (or COWed)
     eb X's logical location is pinned

     btrfs_commit_transaction(N)
       btrfs_finish_extent_commit()
         eb X's range added back to free
         space cache

     transaction N commit finishes

     transaction N + 1 starts

       eb X's old range is allocated for
       some other new eb X' (or cowed eb),
       possibly for some other root

       new stuff written for eb X'

                                                             reads
node at logical address LAX
                                                               --> gets eb X'
                                                               -->
transid/generation check fails

(expected N gets N + 1)
                                                               --> returns -EIO



Otherwise the change looks good to me.
Thanks.

> +               if (trans)
> +                       btrfs_put_transaction(trans);
> +
> +               if (ret) {
> +                       mutex_unlock(&fs_info->chunk_mutex);
> +                       if (ret == -ENOSPC)
> +                               ret = 0;
> +                       break;
> +               }
> +
> +               ret = btrfs_issue_discard(device->bdev, start, len);
> +               mutex_unlock(&fs_info->chunk_mutex);
> +
> +               if (ret)
> +                       break;
> +
> +               start += len;
> +               *trimmed += len;
> +
> +               if (fatal_signal_pending(current)) {
> +                       ret = -ERESTARTSYS;
> +                       break;
> +               }
> +
> +               cond_resched();
> +       }
> +
> +       return ret;
> +}
> +
>  int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
>  {
>         struct btrfs_fs_info *fs_info = root->fs_info;
>         struct btrfs_block_group_cache *cache = NULL;
> +       struct btrfs_device *device;
> +       struct list_head *devices;
>         u64 group_trimmed;
>         u64 start;
>         u64 end;
> @@ -10089,6 +10173,18 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
>                 cache = next_block_group(fs_info->tree_root, cache);
>         }
>
> +       mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
> +       devices = &root->fs_info->fs_devices->alloc_list;
> +       list_for_each_entry(device, devices, dev_alloc_list) {
> +               ret = btrfs_trim_free_extents(device, range->minlen,
> +                                             &group_trimmed);
> +               if (ret)
> +                       break;
> +
> +               trimmed += group_trimmed;
> +       }
> +       mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> +
>         range->len = trimmed;
>         return ret;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 96aebf3..ada8965 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1051,15 +1051,19 @@ out:
>         return ret;
>  }
>
> -static int contains_pending_extent(struct btrfs_trans_handle *trans,
> +static int contains_pending_extent(struct btrfs_transaction *transaction,
>                                    struct btrfs_device *device,
>                                    u64 *start, u64 len)
>  {
> +       struct btrfs_fs_info *fs_info = device->dev_root->fs_info;
>         struct extent_map *em;
> -       struct list_head *search_list = &trans->transaction->pending_chunks;
> +       struct list_head *search_list = &transaction->pending_chunks;
>         int ret = 0;
>         u64 physical_start = *start;
>
> +       if (!transaction)
> +               search_list = &fs_info->pinned_chunks;
> +
>  again:
>         list_for_each_entry(em, search_list, list) {
>                 struct map_lookup *map;
> @@ -1078,8 +1082,8 @@ again:
>                         ret = 1;
>                 }
>         }
> -       if (search_list == &trans->transaction->pending_chunks) {
> -               search_list = &trans->root->fs_info->pinned_chunks;
> +       if (search_list == &transaction->pending_chunks) {
> +               search_list = &fs_info->pinned_chunks;
>                 goto again;
>         }
>
> @@ -1088,12 +1092,13 @@ again:
>
>
>  /*
> - * find_free_dev_extent - find free space in the specified device
> - * @device:    the device which we search the free space in
> - * @num_bytes: the size of the free space that we need
> - * @start:     store the start of the free space.
> - * @len:       the size of the free space. that we find, or the size of the max
> - *             free space if we don't find suitable free space
> + * find_free_dev_extent_start - find free space in the specified device
> + * @device:      the device which we search the free space in
> + * @num_bytes:   the size of the free space that we need
> + * @search_start: the position from which to begin the search
> + * @start:       store the start of the free space.
> + * @len:         the size of the free space. that we find, or the size
> + *               of the max free space if we don't find suitable free space
>   *
>   * this uses a pretty simple search, the expectation is that it is
>   * called very infrequently and that a given device has a small number
> @@ -1107,9 +1112,9 @@ again:
>   * But if we don't find suitable free space, it is used to store the size of
>   * the max free space.
>   */
> -int find_free_dev_extent(struct btrfs_trans_handle *trans,
> -                        struct btrfs_device *device, u64 num_bytes,
> -                        u64 *start, u64 *len)
> +int find_free_dev_extent_start(struct btrfs_transaction *transaction,
> +                              struct btrfs_device *device, u64 num_bytes,
> +                              u64 search_start, u64 *start, u64 *len)
>  {
>         struct btrfs_key key;
>         struct btrfs_root *root = device->dev_root;
> @@ -1119,19 +1124,11 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
>         u64 max_hole_start;
>         u64 max_hole_size;
>         u64 extent_end;
> -       u64 search_start;
>         u64 search_end = device->total_bytes;
>         int ret;
>         int slot;
>         struct extent_buffer *l;
>
> -       /* FIXME use last free of some kind */
> -
> -       /* we don't want to overwrite the superblock on the drive,
> -        * so we make sure to start at an offset of at least 1MB
> -        */
> -       search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
> -
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> @@ -1192,7 +1189,7 @@ again:
>                          * Have to check before we set max_hole_start, otherwise
>                          * we could end up sending back this offset anyway.
>                          */
> -                       if (contains_pending_extent(trans, device,
> +                       if (contains_pending_extent(transaction, device,
>                                                     &search_start,
>                                                     hole_size)) {
>                                 if (key.offset >= search_start) {
> @@ -1241,7 +1238,7 @@ next:
>         if (search_end > search_start) {
>                 hole_size = search_end - search_start;
>
> -               if (contains_pending_extent(trans, device, &search_start,
> +               if (contains_pending_extent(transaction, device, &search_start,
>                                             hole_size)) {
>                         btrfs_release_path(path);
>                         goto again;
> @@ -1267,6 +1264,24 @@ out:
>         return ret;
>  }
>
> +int find_free_dev_extent(struct btrfs_trans_handle *trans,
> +                        struct btrfs_device *device, u64 num_bytes,
> +                        u64 *start, u64 *len)
> +{
> +       struct btrfs_root *root = device->dev_root;
> +       u64 search_start;
> +
> +       /* FIXME use last free of some kind */
> +
> +       /*
> +        * we don't want to overwrite the superblock on the drive,
> +        * so we make sure to start at an offset of at least 1MB
> +        */
> +       search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
> +       return find_free_dev_extent_start(trans->transaction, device,
> +                                         num_bytes, search_start, start, len);
> +}
> +
>  static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
>                           struct btrfs_device *device,
>                           u64 start, u64 *dev_extent_len)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index ebc3133..30918a8 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -449,6 +449,9 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
>  int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
>  int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
>  int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
> +int find_free_dev_extent_start(struct btrfs_transaction *transaction,
> +                        struct btrfs_device *device, u64 num_bytes,
> +                        u64 search_start, u64 *start, u64 *max_avail);
>  int find_free_dev_extent(struct btrfs_trans_handle *trans,
>                          struct btrfs_device *device, u64 num_bytes,
>                          u64 *start, u64 *max_avail);
> --
> 1.8.5.6
>
>
> --
> Jeff Mahoney
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
