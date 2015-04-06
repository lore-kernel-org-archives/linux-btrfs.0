Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34970 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbDFJRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 05:17:41 -0400
Received: by igcau2 with SMTP id au2so16887848igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 02:17:41 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5519A011.8090501@suse.com>
References: <5519A011.8090501@suse.com>
Date: Mon, 6 Apr 2015 10:17:40 +0100
Message-ID: <CAL3q7H5hr2tjbRO1gj8DUT_=A4OjYGNXGOYxMLqPGk-CUaGC5w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: iterate over unused chunk space in FITRIM
From: Filipe David Manana <fdmanana@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 8:12 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> The combination of mkfs.btrfs discarding the entire block device and the
> old behavior of block groups being retained forever made iterating over
> the block groups on disk for FITRIM an easy optimization. If there wasn't
> a block group describing the space, btrfs had never written to it.
>
> Since we now clean up block groups automatically as they become empty,
> iterating over block groups is no longer sufficient to discard unused space.
>
> This patch iterates over the unused chunk space and discards it.  We
> block out device add/remove/replace operations for the duration, but
> relax the chunk lock in between discards to allow the file system
> to perform allocations and function normally.

Hi Jeff,

This last phrase isn't true. See comment below.

>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.c     | 45 +++++++++++++++++++------------
>  fs/btrfs/volumes.h     |  3 +++
>  3 files changed, 104 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8b353ad..0bf45b8 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9707,10 +9707,62 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
>         return unpin_extent_range(root, start, end, false);
>  }
>
> +/*
> + * It used to be that old block groups would be left around forever. so
> + * iterating over them would be enough to trim unused space.  Since we
> + * now automatically remove them, we also need to iterate over unallocated
> + * space.  We block out device add/removes while this is running but allow
> + * chunks to be allocated between discards to not hold up writes longer
> + * than necessary.

(same as in commit message, we are blocking chunk allocations)

> + */
> +static int btrfs_trim_free_extents(struct btrfs_trans_handle *trans,
> +                                  struct btrfs_device *device,
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
> +               ret = find_free_dev_extent_start(trans, device, minlen, start,
> +                                                &start, &len);
> +               if (ret) {
> +                       if (ret == -ENOSPC)
> +                               ret = 0;
> +                       break;
> +               }
> +
> +               ret = btrfs_issue_discard(device->bdev, start, len);
> +
> +               if (ret)
> +                       break;
> +
> +               start += len;
> +               *trimmed += len;
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
> +       struct btrfs_trans_handle *trans;
> +       struct btrfs_device *device;
> +       struct list_head *devices;
>         u64 group_trimmed;
>         u64 start;
>         u64 end;
> @@ -9765,6 +9817,27 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
>                 cache = next_block_group(fs_info->tree_root, cache);
>         }
>
> +       /*
> +        * Get a handle on the current transaction so we can
> +        * see pending extents.  We won't actually dirty anything.
> +        */
> +       trans = btrfs_start_transaction(root, 0);
> +       if (IS_ERR(trans))
> +               return PTR_ERR(trans);
> +
> +       lock_chunks(root);
> +       devices = &root->fs_info->fs_devices->alloc_list;
> +       list_for_each_entry(device, devices, dev_alloc_list) {
> +               ret = btrfs_trim_free_extents(trans, device, range->minlen,
> +                                             &group_trimmed);
> +               if (ret)
> +                       break;
> +
> +               trimmed += group_trimmed;
> +       }
> +       unlock_chunks(root);

So while doing discards against all un-allocated regions of all
devices we're holding the chunks mutex (lock_chunks).
This means that new chunk allocations are blocked while we hold that
mutex (extent-tree.c:do_chunk_alloc() locks chunks mutex and then
calls btrfs_alloc_chunk() while holding that mutex).

Thanks.

> +       btrfs_end_transaction(trans, root);
> +
>         range->len = trimmed;
>         return ret;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8222f6f..2f4ce7f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1089,12 +1089,13 @@ again:
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
> @@ -1108,9 +1109,9 @@ again:
>   * But if we don't find suitable free space, it is used to store the size of
>   * the max free space.
>   */
> -int find_free_dev_extent(struct btrfs_trans_handle *trans,
> -                        struct btrfs_device *device, u64 num_bytes,
> -                        u64 *start, u64 *len)
> +int find_free_dev_extent_start(struct btrfs_trans_handle *trans,
> +                              struct btrfs_device *device, u64 num_bytes,
> +                              u64 search_start, u64 *start, u64 *len)
>  {
>         struct btrfs_key key;
>         struct btrfs_root *root = device->dev_root;
> @@ -1120,19 +1121,11 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
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
> @@ -1260,6 +1253,24 @@ out:
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
> +       return find_free_dev_extent_start(trans, device, num_bytes,
> +                                         search_start, start, len);
> +}
> +
>  static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
>                           struct btrfs_device *device,
>                           u64 start, u64 *dev_extent_len)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 83069de..c9a7ea9 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -450,6 +450,9 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
>  int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info);
>  int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info);
>  int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
> +int find_free_dev_extent_start(struct btrfs_trans_handle *trans,
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
